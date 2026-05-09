param(
    [ValidateSet("install", "build", "dev", "all")]
    [string]$Task = "all"
)

$ErrorActionPreference = "Stop"

$NodeDir = "C:\Program Files\nodejs"
$NpmCmd = Join-Path $NodeDir "npm.cmd"
$FrontendDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Test-Path $NpmCmd)) {
    throw "npm was not found at $NpmCmd. Install Node.js LTS, then rerun this script."
}

$env:Path = "$NodeDir;$env:Path"
Set-Location $FrontendDir

Write-Host "Node: $(& "$NodeDir\node.exe" --version)"
Write-Host "npm:  $(& $NpmCmd --version)"

if ($Task -in @("install", "all")) {
    & $NpmCmd install
}

if ($Task -in @("build", "all")) {
    & $NpmCmd run build
}

if ($Task -in @("dev", "all")) {
    & $NpmCmd run dev
}
