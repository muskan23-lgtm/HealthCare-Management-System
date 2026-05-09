$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$BackendDir = Join-Path $Root "backend"
$FrontendDir = Join-Path $Root "frontend"
$VenvDir = Join-Path $BackendDir ".venv"
$VenvPython = Join-Path $VenvDir "Scripts\python.exe"

function Invoke-SystemPython {
    param([string[]]$Arguments)

    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 @Arguments
        return
    }

    if (Get-Command python -ErrorAction SilentlyContinue) {
        & python @Arguments
        return
    }

    throw "Python was not found. Install Python 3 and rerun this script."
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "npm was not found. Install Node.js LTS and rerun this script."
}

Write-Host "Preparing backend..."
Set-Location $BackendDir

if (-not (Test-Path $VenvPython)) {
    Invoke-SystemPython -Arguments @("-m", "venv", $VenvDir)
}

& $VenvPython -m pip install --upgrade pip
& $VenvPython -m pip install -r requirements.txt
& $VenvPython manage.py migrate

Write-Host "Preparing frontend..."
Set-Location $FrontendDir

if (-not (Test-Path (Join-Path $FrontendDir "node_modules"))) {
    npm install
}

Write-Host "Starting backend at http://127.0.0.1:8000"
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-ExecutionPolicy", "Bypass",
    "-Command",
    "Set-Location '$BackendDir'; & '$VenvPython' manage.py runserver 127.0.0.1:8000"
)

Write-Host "Starting frontend at http://127.0.0.1:5173"
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-ExecutionPolicy", "Bypass",
    "-Command",
    "Set-Location '$FrontendDir'; `$env:VITE_API_BASE_URL='http://127.0.0.1:8000/api'; npm run dev -- --host 127.0.0.1"
)

Set-Location $Root
Write-Host ""
Write-Host "Local app is starting:"
Write-Host "  Frontend: http://127.0.0.1:5173"
Write-Host "  Backend:  http://127.0.0.1:8000"
