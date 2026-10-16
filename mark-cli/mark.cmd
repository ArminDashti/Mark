@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0mark.ps1" %*
exit /b %ERRORLEVEL%
