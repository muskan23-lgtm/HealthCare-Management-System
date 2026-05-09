@echo off
setlocal

set "NODE_DIR=C:\Program Files\nodejs"
set "NPM_CMD=%NODE_DIR%\npm.cmd"

if not exist "%NPM_CMD%" (
  echo npm was not found at "%NPM_CMD%".
  echo Install Node.js LTS, then run this file again.
  exit /b 1
)

set "PATH=%NODE_DIR%;%PATH%"
cd /d "%~dp0"

echo Node:
"%NODE_DIR%\node.exe" --version
echo npm:
call "%NPM_CMD%" --version

set "TASK=%~1"
if "%TASK%"=="" set "TASK=all"

if /i "%TASK%"=="install" (
  call "%NPM_CMD%" install
  exit /b %ERRORLEVEL%
)

if /i "%TASK%"=="build" (
  call "%NPM_CMD%" run build
  exit /b %ERRORLEVEL%
)

if /i "%TASK%"=="dev" (
  call "%NPM_CMD%" run dev
  exit /b %ERRORLEVEL%
)

if /i "%TASK%"=="all" (
  call "%NPM_CMD%" install || exit /b %ERRORLEVEL%
  call "%NPM_CMD%" run build || exit /b %ERRORLEVEL%
  call "%NPM_CMD%" run dev
  exit /b %ERRORLEVEL%
)

echo Unknown task: %TASK%
echo Use: run-frontend.cmd [install^|build^|dev^|all]
exit /b 1
