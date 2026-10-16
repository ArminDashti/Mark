#Requires -Version 5.1
<#
.SYNOPSIS
    mark: lifecycle CLI for mark-api and mark-ui (Docker mode).

.EXAMPLE
    mark run --app=all
    mark port --app=ui --port=8300
    mark rebuild --remove-data=yes -y
#>
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Rest
)

$ErrorActionPreference = 'Continue'

$CliVersion = '1.0.0'
$ProjectName = 'mark'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$DataRoot = Join-Path $env:LOCALAPPDATA 'mark'
$ConfigPath = Join-Path $DataRoot 'config.json'
$LogDir = Join-Path $DataRoot 'logs'
$LogPath = Join-Path $LogDir 'mark.log'
$LogMaxBytes = 10MB
$WaitSeconds = 30
$AppOrder = @('api', 'ui')
$Apps = @{
    api = @{
        Container   = 'mark-api'
        Image       = 'mark-api:latest'
        Volume      = 'mark-api-vol'
        Dir         = (Join-Path $RepoRoot 'mark-api')
        DefaultPort = 8230
    }
    ui  = @{
        Container   = 'mark-ui'
        Image       = 'mark-ui:latest'
        Volume      = $null
        Dir         = (Join-Path $RepoRoot 'mark-ui')
        DefaultPort = 8231
    }
}
$Network = if ($env:DOCKER_NETWORK) { $env:DOCKER_NETWORK } else { 'mark-net' }

# ---------- logging and errors ----------

function Write-Log {
    param([string]$Level, [string]$Message)
    if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }
    if ((Test-Path $LogPath) -and (Get-Item $LogPath).Length -gt $LogMaxBytes) {
        Move-Item -Force -Path $LogPath -Destination "$LogPath.1"
    }
    $line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    Add-Content -Path $LogPath -Value $line -Encoding UTF8
    switch ($Level) {
        'ERROR' { Write-Host $Message -ForegroundColor Red }
        'WARN'  { Write-Host $Message -ForegroundColor Yellow }
        default { Write-Host $Message }
    }
}

function Write-Step([string]$Message) { Write-Log 'INFO' "==> $Message" }

function Stop-Mark {
    param([string]$Message, [int]$Code = 1)
    Write-Log 'ERROR' $Message
    exit $Code
}

# ---------- config ----------

function Get-Config {
    $cfg = [ordered]@{
        ports = [ordered]@{ api = $Apps.api.DefaultPort; ui = $Apps.ui.DefaultPort }
        built = [ordered]@{ api = $null; ui = $null }
    }
    if (Test-Path $ConfigPath) {
        try {
            $raw = Get-Content $ConfigPath -Raw | ConvertFrom-Json
            foreach ($app in $AppOrder) {
                if ($raw.ports.$app) { $cfg.ports[$app] = [int]$raw.ports.$app }
                if ($raw.built.$app) { $cfg.built[$app] = [string]$raw.built.$app }
            }
        }
        catch {
            Write-Log 'WARN' "Config unreadable, using defaults: $ConfigPath"
        }
    }
    return $cfg
}

function Save-Config($cfg) {
    New-Item -ItemType Directory -Path $DataRoot -Force | Out-Null
    $cfg | ConvertTo-Json -Depth 4 | Set-Content -Path $ConfigPath -Encoding UTF8
}

function Get-AppUrl([string]$app, $cfg) {
    return "http://localhost:$($cfg.ports[$app])/"
}

# ---------- docker helpers ----------

function Assert-Docker {
    & docker info *> $null
    if ($LASTEXITCODE -ne 0) { Stop-Mark 'Docker is not running or not installed.' 1 }
}

function Test-Installed([string]$app) {
    $image = $Apps[$app].Image
    & docker image inspect $image *> $null
    return ($LASTEXITCODE -eq 0)
}

function Get-AppState([string]$app) {
    $name = $Apps[$app].Container
    $status = & docker container inspect -f '{{.State.Status}}' $name 2>$null
    if ($LASTEXITCODE -ne 0) { return 'missing' }
    if ("$status".Trim() -eq 'running') { return 'running' }
    return 'stopped'
}

function Initialize-Network {
    & docker network inspect $Network *> $null
    if ($LASTEXITCODE -eq 0) { return }
    Write-Step "Creating network $Network"
    & docker network create $Network | Out-Null
    if ($LASTEXITCODE -ne 0) { Stop-Mark "Could not create network $Network." 1 }
}

function Invoke-Compose([string]$app, [string[]]$ComposeArgs) {
    $cfg = Get-Config
    $env:PUBLISH_PORT = [string]$cfg.ports[$app]
    $file = Join-Path $Apps[$app].Dir 'docker-compose.yml'
    & docker compose -p $ProjectName -f $file @ComposeArgs
    if ($LASTEXITCODE -ne 0) {
        Stop-Mark "docker compose $($ComposeArgs -join ' ') failed for $app (exit $LASTEXITCODE)." 1
    }
}

function Invoke-Build([string]$app) {
    if ($app -eq 'api') {
        $dir = $Apps.api.Dir
        $image = $Apps.api.Image
        Push-Location $dir
        try {
            & docker build --no-cache --pull -f dockerfile -t $image .
            $code = $LASTEXITCODE
        }
        finally { Pop-Location }
        if ($code -ne 0) { Stop-Mark "Build failed for mark-api (exit $code). Previous image is kept." 1 }
    }
    else {
        Invoke-Compose $app @('build', '--no-cache', '--pull')
    }
}

# ---------- network and http ----------

function Test-PortFree([int]$port) {
    $listener = $null
    try {
        $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $port)
        $listener.Start()
        return $true
    }
    catch { return $false }
    finally { if ($listener) { $listener.Stop() } }
}

function Test-Url([string]$url) {
    try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
        return $true
    }
    catch {
        # Any HTTP answer (even 404) means the server is up.
        if ($_.Exception.Response) { return $true }
        return $false
    }
}

function Wait-Url([string]$url, [int]$seconds) {
    $deadline = (Get-Date).AddSeconds($seconds)
    while ((Get-Date) -lt $deadline) {
        if (Test-Url $url) { return $true }
        Start-Sleep -Seconds 1
    }
    return $false
}

function Get-SourceRevision {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { return 'unknown' }
    $rev = & git -C $RepoRoot describe --tags --always --dirty 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $rev) { return 'unknown' }
    return ($rev | Select-Object -First 1).Trim()
}

function Confirm-Action([string]$prompt) {
    $answer = Read-Host $prompt
    return ($answer -eq 'yes')
}

# ---------- app operations ----------

function Start-App([string]$app) {
    $cfg = Get-Config
    $url = Get-AppUrl $app $cfg
    Write-Step "Starting $($Apps[$app].Container) on $url"
    Initialize-Network
    Invoke-Compose $app @('up', '-d')
    if (Wait-Url $url $WaitSeconds) {
        Write-Log 'INFO' "$app is up: $url"
    }
    else {
        Stop-Mark "$app did not answer at $url within $WaitSeconds s. Check: docker logs $($Apps[$app].Container)" 1
    }
}

function Stop-App([string]$app) {
    if ((Get-AppState $app) -eq 'missing') {
        Write-Log 'INFO' "$app is already stopped"
        return
    }
    Write-Step "Stopping $app"
    Invoke-Compose $app @('down')
    if ((Get-AppState $app) -ne 'missing') { Stop-Mark "$app container still present after stop." 1 }
    $port = (Get-Config).ports[$app]
    if (-not (Test-PortFree $port)) { Write-Log 'WARN' "Port $port is still in use by another process." }
}

function Get-Targets($opts) {
    $value = if ($opts.ContainsKey('app')) { [string]$opts['app'] } else { 'all' }
    if ($value -eq 'all') { return $AppOrder }
    if ($AppOrder -contains $value) { return @($value) }
    Stop-Mark "Unknown app '$value'. Use api, ui, or all." 2
}

# ---------- commands ----------

function Show-Usage {
    @(
        'mark: lifecycle CLI for mark-api and mark-ui (Docker mode)'
        ''
        'Usage: mark <command> [options]'
        ''
        'Commands:'
        '  status   [--app=api|ui|all]          Show install, state, port and URL. Exit 0 running, 3 stopped, 4 not installed'
        '  version                              CLI version, source revision, built revision per app'
        '  run      [--app=api|ui|all]          Start app(s) and wait for the URL (30 s)'
        '  stop     [--app=api|ui|all]          Stop and remove containers (data kept)'
        '  port     --app=api|ui [--port=N]     Show or change the published port (restarts if running)'
        '  update                               git pull --ff-only, then rebuild keeping data'
        '  rebuild  [--remove-data=no|yes] [-y] Rebuild images. yes wipes data, config and images'
        '  uninstall [-y]                       Remove containers, data, config and the PATH entry'
        '  help                                 Show this message'
        ''
        'Options accept --name=value or --name value. Exit 2 on usage errors.'
    ) | ForEach-Object { Write-Host $_ }
}

function Invoke-Status($targets) {
    $cfg = Get-Config
    $installedCount = 0
    $runningCount = 0
    foreach ($app in $targets) {
        $installed = Test-Installed $app
        $state = Get-AppState $app
        $url = Get-AppUrl $app $cfg
        $http = '-'
        if ($installed) { $installedCount++ }
        if ($state -eq 'running') {
            $runningCount++
            $http = if (Test-Url $url) { 'ok' } else { 'no response' }
        }
        Write-Log 'INFO' ('{0,-4} installed={1} state={2} mode=docker port={3} url={4} http={5} container={6}' -f `
            $app, $installed, $state, $cfg.ports[$app], $url, $http, $Apps[$app].Container)
    }
    if ($installedCount -eq 0) { return 4 }
    if ($runningCount -eq $targets.Count) { return 0 }
    return 3
}

function Invoke-Version {
    $cfg = Get-Config
    $rev = Get-SourceRevision
    Write-Log 'INFO' "mark CLI $CliVersion"
    Write-Log 'INFO' "source revision: $rev"
    foreach ($app in $AppOrder) {
        if (-not (Test-Installed $app)) {
            Write-Log 'INFO' "${app}: not installed"
        }
        elseif ($cfg.built[$app] -eq $rev) {
            Write-Log 'INFO' "${app}: built=$($cfg.built[$app]) (up to date)"
        }
        else {
            Write-Log 'WARN' "${app}: built=$($cfg.built[$app]) source=$rev. Run: mark rebuild"
        }
    }
    return 0
}

function Invoke-Run($targets) {
    foreach ($app in $targets) {
        if (-not (Test-Installed $app)) { Stop-Mark "$app is not installed. Run: mark rebuild" 4 }
    }
    foreach ($app in $targets) {
        if ((Get-AppState $app) -eq 'running') {
            Write-Log 'INFO' "$app already running: $(Get-AppUrl $app (Get-Config))"
            continue
        }
        Start-App $app
    }
    return 0
}

function Invoke-Stop($targets) {
    foreach ($app in $targets) { Stop-App $app }
    return 0
}

function Invoke-Port($opts) {
    if (-not $opts.ContainsKey('app') -or -not ($AppOrder -contains [string]$opts['app'])) {
        Stop-Mark 'port requires --app=api or --app=ui' 2
    }
    $app = [string]$opts['app']
    $cfg = Get-Config
    if (-not $opts.ContainsKey('port')) {
        Write-Log 'INFO' "$app port: $($cfg.ports[$app])"
        return 0
    }
    $port = 0
    if (-not [int]::TryParse([string]$opts['port'], [ref]$port) -or $port -lt 1 -or $port -gt 65535) {
        Stop-Mark "Invalid port '$($opts['port'])'. Use 1-65535." 2
    }
    if ($port -eq $cfg.ports[$app]) {
        Write-Log 'INFO' "$app already uses port $port"
        return 0
    }
    $other = if ($app -eq 'api') { 'ui' } else { 'api' }
    if ($cfg.ports[$other] -eq $port) { Stop-Mark "Port $port is already used by $other." 1 }
    if (-not (Test-PortFree $port)) { Stop-Mark "Port $port is in use by another process." 1 }

    $wasRunning = (Get-AppState $app) -eq 'running'
    $cfg.ports[$app] = $port
    Save-Config $cfg
    Write-Log 'INFO' "$app port set to $port"
    if ($wasRunning) {
        Stop-App $app
        Start-App $app
    }
    else {
        Write-Log 'INFO' "Start with: mark run --app=$app"
    }
    return 0
}

function Invoke-Rebuild($opts) {
    $removeData = if ($opts.ContainsKey('remove-data')) { [string]$opts['remove-data'] } else { 'no' }
    if ($removeData -notin @('no', 'yes')) { Stop-Mark "Invalid --remove-data '$removeData'. Use no or yes." 2 }
    $yes = $opts.ContainsKey('yes')

    $wasRunning = @{}
    foreach ($app in $AppOrder) { $wasRunning[$app] = (Get-AppState $app) -eq 'running' }

    if ($removeData -eq 'yes') {
        Write-Log 'WARN' 'This deletes ALL data, config and images for mark:'
        foreach ($app in $AppOrder) {
            Write-Log 'WARN' "  container: $($Apps[$app].Container)"
            Write-Log 'WARN' "  image:     $($Apps[$app].Image)"
        }
        Write-Log 'WARN' '  volume:    mark-api-vol'
        Write-Log 'WARN' "  config:    $ConfigPath"
        if (-not $yes -and -not (Confirm-Action 'Type "yes" to continue: ')) { Stop-Mark 'Aborted.' 1 }

        foreach ($app in $AppOrder) { Invoke-Compose $app @('down', '-v') }
        & docker volume rm mark-api-vol *> $null
        foreach ($app in $AppOrder) { & docker image rm -f $Apps[$app].Image *> $null }
        if (Test-Path $ConfigPath) { Remove-Item $ConfigPath -Force }
        Write-Log 'INFO' 'Data, config and images removed.'
    }
    else {
        foreach ($app in $AppOrder) { Stop-App $app }
    }

    $cfg = Get-Config
    foreach ($app in $AppOrder) {
        Write-Step "Building $app (no cache)"
        Invoke-Build $app
    }
    $rev = Get-SourceRevision
    foreach ($app in $AppOrder) { $cfg.built[$app] = $rev }
    Save-Config $cfg

    foreach ($app in $AppOrder) {
        if ($removeData -eq 'yes' -or $wasRunning[$app]) { Start-App $app }
    }
    return (Invoke-Status $AppOrder)
}

function Invoke-Update($opts) {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Stop-Mark 'git is required for update.' 1 }
    Write-Step 'git pull --ff-only'
    & git -C $RepoRoot pull --ff-only
    if ($LASTEXITCODE -ne 0) { Stop-Mark 'git pull failed. Nothing was rebuilt.' 1 }
    return (Invoke-Rebuild @{ 'remove-data' = 'no' })
}

function Remove-FromUserPath([string]$dir) {
    $current = [Environment]::GetEnvironmentVariable('Path', 'User')
    $target = $dir.TrimEnd('\')
    $parts = @($current -split ';' | Where-Object { $_ -and ($_.TrimEnd('\') -ine $target) })
    [Environment]::SetEnvironmentVariable('Path', ($parts -join ';'), 'User')
}

function Invoke-Uninstall($opts) {
    $yes = $opts.ContainsKey('yes')
    Write-Log 'WARN' 'This removes mark containers, images, the volume mark-api-vol, config, logs and the PATH entry.'
    Write-Log 'WARN' "  folder kept: $RepoRoot"
    if (-not $yes -and -not (Confirm-Action 'Type "yes" to continue: ')) { Stop-Mark 'Aborted.' 1 }

    foreach ($app in $AppOrder) { Invoke-Compose $app @('down', '-v') }
    & docker volume rm mark-api-vol *> $null
    foreach ($app in $AppOrder) { & docker image rm -f $Apps[$app].Image *> $null }
    if (Test-Path $DataRoot) { Remove-Item $DataRoot -Recurse -Force }
    Remove-FromUserPath $PSScriptRoot
    Write-Log 'INFO' 'mark uninstalled. Open a new shell for the PATH change to apply.'
    return 0
}

# ---------- parse and dispatch ----------

$command = if ($Rest -and $Rest.Count -gt 0) { $Rest[0].ToLowerInvariant() } else { 'help' }
if ($command -in @('-h', '--help')) { $command = 'help' }

$opts = @{}
if ($Rest -and $Rest.Count -gt 1) {
    for ($i = 1; $i -lt $Rest.Count; $i++) {
        $token = $Rest[$i]
        if ($token -match '^--([a-z-]+)=(.*)$') {
            $opts[$matches[1]] = $matches[2]
        }
        elseif ($token -match '^--([a-z-]+)$') {
            $name = $matches[1]
            if (($i + 1) -lt $Rest.Count -and -not $Rest[$i + 1].StartsWith('-')) {
                $opts[$name] = $Rest[$i + 1]
                $i++
            }
            else {
                $opts[$name] = $true
            }
        }
        elseif ($token -eq '-y') {
            $opts['yes'] = $true
        }
        else {
            Stop-Mark "Unknown option '$token'. Run: mark help" 2
        }
    }
}

try {
    switch ($command) {
        'help'      { Show-Usage; exit 0 }
        'version'   { exit (Invoke-Version) }
        'status'    { Assert-Docker; exit (Invoke-Status (Get-Targets $opts)) }
        'run'       { Assert-Docker; exit (Invoke-Run (Get-Targets $opts)) }
        'stop'      { Assert-Docker; exit (Invoke-Stop (Get-Targets $opts)) }
        'port'      { Assert-Docker; exit (Invoke-Port $opts) }
        'update'    { Assert-Docker; exit (Invoke-Update $opts) }
        'rebuild'   { Assert-Docker; exit (Invoke-Rebuild $opts) }
        'uninstall' { Assert-Docker; exit (Invoke-Uninstall $opts) }
        default     { Stop-Mark "Unknown command '$command'. Run: mark help" 2 }
    }
}
catch {
    Stop-Mark "Unexpected error: $($_.Exception.Message)" 1
}
