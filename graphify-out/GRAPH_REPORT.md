# Graph Report - mark  (2026-10-16)

## Corpus Check
- 104 files · ~164,860 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 832 nodes · 1050 edges · 66 communities (58 shown, 8 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 30 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `89b83eb3`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- MarksView.vue
- armin-dev-policies/SKILL.md
- mark.ps1
- Disk
- Skill authoring spec
- utils.ts
- main
- devDependencies
- speckit-analyze/SKILL.md
- compilerOptions
- Code Removal (Dead / Orphan Only)
- Code Removal (Dead / Orphan Only)
- Mark
- compilerOptions
- Workflow
- App.vue
- GitNexus — Code Intelligence
- Detect Anti-Pattern
- Reuse task procedures
- auth.ts
- Redeploy and open a PR
- Execution Steps
- Store
- AboutMeView.vue
- GitNexus — Code Intelligence
- tsconfig.json
- mark-api
- mark-ui
- vite-env.d.ts
- INDEX.md
- Caveman Help
- vite.config.ts
- github.com/ArminDashti/mark-api
- How
- Manage project docs
- caveman/SKILL.md
- Darou Pakhsh Distribution Company
- Template
- Template
- Manage Ubuntu
- speckit-plan/SKILL.md
- speckit-specify/SKILL.md
- speckit-tasks/SKILL.md
- Template
- LoginView.vue
- How
- apiFetch
- How
- How
- app-lifecycle-cli/SKILL.md
- Review Caveman evidence
- lean-ctx — Local Context SDK for AI Agents
- speckit-checklist/SKILL.md
- Suggest Improvements
- speckit-clarify/SKILL.md
- speckit-implement/SKILL.md
- speckit-constitution/SKILL.md
- speckit-tasks-to-issues/SKILL.md
- speckit-taskstoissues/SKILL.md
- Dialog.vue
- Irancell Ubuntu T3
- loopx-global-risks/SKILL.md
- Loopx/SKILL.md

## God Nodes (most connected - your core abstractions)
1. `compilerOptions` - 17 edges
2. `Invoke-Rebuild()` - 15 edges
3. `Disk` - 14 edges
4. `Stop-Mark()` - 14 edges
5. `main()` - 13 edges
6. `Handler` - 12 edges
7. `Service` - 12 edges
8. `Mark` - 12 edges
9. `Write-Log()` - 12 edges
10. `Start-App()` - 12 edges

## Surprising Connections (you probably didn't know these)
- `main()` --calls--> `HashPassword()`  [INFERRED]
  mark-api/cmd/server/main.go → mark-api/internal/auth/password.go
- `main()` --calls--> `NewService()`  [INFERRED]
  mark-api/cmd/server/main.go → mark-api/internal/marks/service.go
- `main()` --calls--> `EnsureRoot()`  [INFERRED]
  mark-api/cmd/server/main.go → mark-api/internal/storage/disk.go
- `main()` --calls--> `NewDisk()`  [INFERRED]
  mark-api/cmd/server/main.go → mark-api/internal/storage/disk.go
- `PNGSquare()` --calls--> `New()`  [INFERRED]
  mark-api/internal/render/render.go → mark-api/internal/handlers/handlers.go

## Import Cycles
- None detected.

## Communities (66 total, 8 thin omitted)

### Community 0 - "MarksView.vue"
Cohesion: 0.08
Nodes (21): markImageUrl(), copiedId, copyUrl(), dialogOpen, editing, emptyLabel, errorMessage, file (+13 more)

### Community 1 - "armin-dev-policies/SKILL.md"
Cohesion: 0.05
Nodes (37): Anti-pattern reference, Coupling & cohesion, Data & concurrency, Distribution, False positives (usually skip), Layering (typical clean/onion/n-tier), Structure, Architecture (+29 more)

### Community 2 - "mark.ps1"
Cohesion: 0.22
Nodes (29): Assert-Docker(), Confirm-Action(), Get-AppState(), Get-AppUrl(), Get-Config(), Get-SourceRevision(), Get-Targets(), Initialize-Network() (+21 more)

### Community 3 - "Disk"
Cohesion: 0.10
Nodes (24): Image, detectMIME(), extForMIME(), Context, Store, NewService(), normalizeInput(), optionalKind() (+16 more)

### Community 4 - "Skill authoring spec"
Cohesion: 0.07
Nodes (25): Example, Gotchas, Procedure, REPLACE — title of the golden path, What didn't work, When to use this, Add what the agent lacks, omit what it knows, Body content (+17 more)

### Community 5 - "utils.ts"
Cohesion: 0.20
Nodes (7): buttonVariants, classes, props, classes, emit, props, cn()

### Community 6 - "main"
Cohesion: 0.08
Nodes (33): Claims, Config, HandlerFunc, Handler, loginRequest, updateJSON, main(), IssueToken() (+25 more)

### Community 7 - "devDependencies"
Cohesion: 0.04
Nodes (46): autoprefixer, class-variance-authority, clsx, @fontsource/inter, dependencies, class-variance-authority, clsx, @fontsource/inter (+38 more)

### Community 8 - "speckit-analyze/SKILL.md"
Cohesion: 0.08
Nodes (25): 1. Initialize Analysis Context, 2. Load Artifacts (Progressive Disclosure), 3. Build Semantic Models, 4. Detection Passes (Token-Efficient Analysis), 5. Severity Assignment, 6. Produce Compact Analysis Report, 7. Provide Next Actions, 8. Offer Remediation (+17 more)

### Community 9 - "compilerOptions"
Cohesion: 0.09
Nodes (21): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+13 more)

### Community 10 - "Code Removal (Dead / Orphan Only)"
Cohesion: 0.10
Nodes (19): 1. Identify candidate targets, 2. Prove dead/orphan status (required), 3. Confirm no hidden connections, 4. Execute removal, 5. Validate and report, Code Removal (Dead / Orphan Only), Edge cases, Eligibility (all must pass) (+11 more)

### Community 11 - "Code Removal (Dead / Orphan Only)"
Cohesion: 0.10
Nodes (19): 1. Identify candidate targets, 2. Prove dead/orphan status (required), 3. Confirm no hidden connections, 4. Execute removal, 5. Validate and report, Code Removal (Dead / Orphan Only), Edge cases, Eligibility (all must pass) (+11 more)

### Community 12 - "Mark"
Cohesion: 0.25
Nodes (10): Context, DB, likeContains(), NewStore(), scanMark(), wrapConflict(), Store, Mark (+2 more)

### Community 13 - "compilerOptions"
Cohesion: 0.12
Nodes (15): compilerOptions, baseUrl, noFallthroughCasesInSwitch, noUncheckedSideEffectImports, noUnusedLocals, noUnusedParameters, paths, strict (+7 more)

### Community 14 - "Workflow"
Cohesion: 0.14
Nodes (13): About Me Section, Examples, Objective, Safety rules, Step 1: Place the page, Step 2: Layout (match helix), Step 3: Write the bio (eloquent, unique), Step 4: Contact email (anti-crawl) (+5 more)

### Community 15 - "App.vue"
Cohesion: 0.24
Nodes (10): { isAuthenticated, logout }, onToggleTheme(), router, syncTheme(), theme, applyTheme(), getTheme(), initTheme() (+2 more)

### Community 16 - "GitNexus — Code Intelligence"
Cohesion: 0.17
Nodes (11): Always Do, CLI, GitNexus — Code Intelligence, lean-ctx, Learned, Never Do, Promotion rule, Resources (+3 more)

### Community 17 - "Detect Anti-Pattern"
Cohesion: 0.17
Nodes (12): Additional resources, Detect Anti-Pattern, Examples, Objective, Safety rules, Step 1: Scope, Step 2: Map structure, Step 3: Hunt by category (+4 more)

### Community 18 - "Reuse task procedures"
Cohesion: 0.17
Nodes (11): Layout, Never, Reuse task procedures, Script rules, Step 1: Search the index, Step 2: Decide whether to save it, and how, Step 3: Do the task, the way you will save it, Step 4: Follow a saved guide (+3 more)

### Community 19 - "auth.ts"
Cohesion: 0.19
Nodes (13): API_BASE, AuthResponse, clearSession(), getStoredUser(), getToken(), MarkKind, MarkRow, setSession() (+5 more)

### Community 20 - "Redeploy and open a PR"
Cohesion: 0.22
Nodes (8): 1. Detect Docker, 2. Rebuild + re-run (keep data), 2b. Non-Docker: close, reinstall, run, 3. Pull Request, 4. Final report, Cheat-sheet, Never, Redeploy and open a PR

### Community 21 - "Execution Steps"
Cohesion: 0.12
Nodes (15): 1. Initialize Convergence Context, 2. Load Artifacts (Progressive Disclosure), 3. Build the Intent Inventory, 4. Assess the Codebase and Classify Findings, 5. Assign Severity, 6. Present the In-Session Findings Summary, 7. Append Convergence Tasks (or report converged), 8. Provide Next Actions (Handoff) (+7 more)

### Community 22 - "Store"
Cohesion: 0.38
Nodes (5): Context, DB, NewStore(), User, Store

### Community 23 - "AboutMeView.vue"
Cohesion: 0.29
Nodes (6): domainParts, localPart, mailtoHref, photoOk, photoSrc, visibleEmail

### Community 24 - "GitNexus — Code Intelligence"
Cohesion: 0.33
Nodes (5): Always Do, CLI, GitNexus — Code Intelligence, Never Do, Resources

### Community 25 - "tsconfig.json"
Cohesion: 0.33
Nodes (5): compilerOptions, baseUrl, paths, files, references

### Community 26 - "mark-api"
Cohesion: 0.40
Nodes (4): Admin API, Local run, mark-api, Public URL

### Community 27 - "mark-ui"
Cohesion: 0.50
Nodes (3): Local run, mark-ui, Pages

### Community 30 - "Caveman Help"
Cohesion: 0.14
Nodes (12): caveman-help, Example output, How to invoke, See also, What it does, Caveman Help, Configure Default Mode, Deactivate (+4 more)

### Community 36 - "How"
Cohesion: 0.14
Nodes (13): 1 — Host identity (name → IP), 2 — Connect (strict), 3 — Downloads and installs, 4 — Iran egress, 5 — Risky commands, 6 — Firewall discipline (SSH), 7 — Cleanup, Always (+5 more)

### Community 37 - "Manage project docs"
Cohesion: 0.14
Nodes (13): 1. Resolve target files, 2. Gather ground truth (bounded), 3. Write or edit, 4. Confirm (short), Examples, Goals, Manage project docs, Modes (run only what is needed) (+5 more)

### Community 38 - "caveman/SKILL.md"
Cohesion: 0.17
Nodes (10): caveman, Example output, How to invoke, See also, What it does, Auto-Clarity, Boundaries, Intensity (+2 more)

### Community 39 - "Darou Pakhsh Distribution Company"
Cohesion: 0.17
Nodes (10): Safety Rules (Required), Company Context, Darou Pakhsh Distribution Company, Database Safety Rules (Required), Key Repositories, Programming Stack, SQL Server Database, SQL Server Reporting Services (+2 more)

### Community 40 - "Template"
Cohesion: 0.18
Nodes (10): 🛠️ Changed, 🧠 Learning, Objective, Overview, ⚠️ Risks, Rules, 💡 Suggestions, Template (+2 more)

### Community 41 - "Template"
Cohesion: 0.18
Nodes (10): 🛠️ Changed, 🧠 Learning, Objective, Overview, ⚠️ Risks, Rules, 💡 Suggestions, Template (+2 more)

### Community 42 - "Manage Ubuntu"
Cohesion: 0.18
Nodes (10): Examples, Manage Ubuntu, Objective, Safety rules, Step 1: Resolve target and connect, Step 2: Verify connectivity (read-only), Step 3: Inspect before changing config, network, or services, Step 4: Operate (+2 more)

### Community 43 - "speckit-plan/SKILL.md"
Cohesion: 0.18
Nodes (10): Completion Report, Done When, Key rules, Mandatory Post-Execution Hooks, Outline, Phase 0: Outline & Research, Phase 1: Design & Contracts, Phases (+2 more)

### Community 44 - "speckit-specify/SKILL.md"
Cohesion: 0.18
Nodes (10): Completion Report, Done When, For AI Generation, Mandatory Post-Execution Hooks, Outline, Pre-Execution Checks, Quick Guidelines, Section Requirements (+2 more)

### Community 45 - "speckit-tasks/SKILL.md"
Cohesion: 0.18
Nodes (10): Checklist Format (REQUIRED), Completion Report, Done When, Mandatory Post-Execution Hooks, Outline, Phase Structure, Pre-Execution Checks, Task Generation Rules (+2 more)

### Community 46 - "Template"
Cohesion: 0.18
Nodes (10): 🛠️ Changed, 🧠 Learning, Objective, Overview, ⚠️ Risks, Rules, 💡 Suggestions, Template (+2 more)

### Community 47 - "LoginView.vue"
Cohesion: 0.20
Nodes (9): login(), { applySession }, errorMessage, onSubmit(), password, route, router, submitting (+1 more)

### Community 48 - "How"
Cohesion: 0.20
Nodes (9): How, Manage Windows Processes, Modes, Safety, Step 1 — Snapshot, Step 2 — Score (any strong hit → suspect), Step 3 — Report, Step 4 — Contain (only if asked) (+1 more)

### Community 49 - "apiFetch"
Cohesion: 0.27
Nodes (10): apiFetch(), createMark(), deleteMark(), fetchMarks(), parseError(), updateMark(), load(), onDelete() (+2 more)

### Community 50 - "How"
Cohesion: 0.22
Nodes (8): How, Managing Firewall, Modes, Safety, Step 1 — List, Step 2 — Change (Admin; only if asked), Step 3 — Verify, When

### Community 51 - "How"
Cohesion: 0.22
Nodes (8): How, Modes, Resource Managing, Safety, Step 1 — Diagnose, Step 2 — Ease (only if asked), Step 3 — Verify, When

### Community 52 - "app-lifecycle-cli/SKILL.md"
Cohesion: 0.25
Nodes (7): Commands, Docker mode (no service, no AppData install), Inputs (infer, don't ask unless unknowable), Native mode, Registration, Rules, Verify, then report alias, mode, paths, port, uninstall

### Community 53 - "Review Caveman evidence"
Cohesion: 0.25
Nodes (7): Hard rules, Review Caveman evidence, Step 1 — Load context, Step 2 — Establish baseline, Step 3 — Test the leading explanation with traces, Step 4 — Inspect representative traces, Step 5 — Report

### Community 54 - "lean-ctx — Local Context SDK for AI Agents"
Cohesion: 0.25
Nodes (7): ctx_read Modes, File Editing, lean-ctx — Local Context SDK for AI Agents, More Tools (via ctx_call or ctx_load_tools), Setup, Shell Hook (use instead of raw exec), Tool Visibility Profiles

### Community 55 - "speckit-checklist/SKILL.md"
Cohesion: 0.25
Nodes (7): Anti-Examples: What NOT To Do, Checklist Purpose: "Unit Tests for English", Example Checklist Types & Sample Items, Execution Steps, Post-Execution Checks, Pre-Execution Checks, User Input

### Community 56 - "Suggest Improvements"
Cohesion: 0.25
Nodes (7): Always, Example, Format of response, How, Never, Suggest Improvements, When

### Community 57 - "speckit-clarify/SKILL.md"
Cohesion: 0.29
Nodes (6): Completion Report, Done When, Mandatory Post-Execution Hooks, Outline, Pre-Execution Checks, User Input

### Community 58 - "speckit-implement/SKILL.md"
Cohesion: 0.29
Nodes (6): Completion Report, Done When, Mandatory Post-Execution Hooks, Outline, Pre-Execution Checks, User Input

### Community 59 - "speckit-constitution/SKILL.md"
Cohesion: 0.40
Nodes (4): Outline, Post-Execution Checks, Pre-Execution Checks, User Input

### Community 60 - "speckit-tasks-to-issues/SKILL.md"
Cohesion: 0.40
Nodes (4): Outline, Post-Execution Checks, Pre-Execution Checks, User Input

### Community 61 - "speckit-taskstoissues/SKILL.md"
Cohesion: 0.40
Nodes (4): Outline, Post-Execution Checks, Pre-Execution Checks, User Input

## Knowledge Gaps
- **464 isolated node(s):** `github.com/ArminDashti/mark-api`, `loginRequest`, `updateJSON`, `name`, `private` (+459 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Service` connect `Disk` to `main`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Why does `Mark` connect `Mark` to `Disk`?**
  _High betweenness centrality (0.005) - this node is a cross-community bridge._
- **Why does `main()` connect `main` to `Disk`?**
  _High betweenness centrality (0.004) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `main()` (e.g. with `Middleware()` and `HashPassword()`) actually correct?**
  _`main()` has 12 INFERRED edges - model-reasoned connections that need verification._
- **What connects `github.com/ArminDashti/mark-api`, `loginRequest`, `updateJSON` to the rest of the system?**
  _464 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MarksView.vue` be split into smaller, more focused modules?**
  _Cohesion score 0.07671957671957672 - nodes in this community are weakly interconnected._
- **Should `armin-dev-policies/SKILL.md` be split into smaller, more focused modules?**
  _Cohesion score 0.045454545454545456 - nodes in this community are weakly interconnected._