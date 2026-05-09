@echo off
setlocal

set "ROOT=%~dp0"
set "NODE_DIR=C:\Program Files\nodejs"

if exist "%NODE_DIR%\npm.cmd" (
  set "PATH=%NODE_DIR%;%PATH%"
)

"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -File "%ROOT%start-local.ps1"
