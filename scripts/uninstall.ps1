$ErrorActionPreference = 'Stop'
$InstallDir = if ($env:TIMEZONE_INSTALL_DIR) { $env:TIMEZONE_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'TimeZoneConverter' }
if (Test-Path (Join-Path $InstallDir 'docker-compose.yml')) {
    Push-Location $InstallDir
    try { docker compose down --remove-orphans } finally { Pop-Location }
}
if (Test-Path $InstallDir) { Remove-Item $InstallDir -Recurse -Force }
Write-Host 'Time Zone Converter has been removed. Docker Desktop was left installed.' -ForegroundColor Green
