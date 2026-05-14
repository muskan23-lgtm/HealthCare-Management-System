@echo off
setlocal

set "GIT_DIR=C:\Program Files\Git\cmd"
set "GIT_EXE=%GIT_DIR%\git.exe"

if not exist "%GIT_EXE%" (
  echo Git was not found at "%GIT_EXE%".
  echo Install Git for Windows, then run this command again.
  exit /b 1
)

set "PATH=%GIT_DIR%;C:\Program Files\Git\bin;%PATH%"
"%GIT_EXE%" %*
