$ErrorActionPreference = 'Stop'
$Repo = 'RandomGuy908/time-zone'
$Base = "https://github.com/$Repo/releases/latest/download"
$InstallDir = if ($env:TIMEZONE_INSTALL_DIR) { $env:TIMEZONE_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'TimeZoneConverter' }
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("timezone-" + [guid]::NewGuid())

try {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        throw 'Docker was not found. Install and start Docker Desktop, then run this command again.'
    }
    docker info *> $null
    if ($LASTEXITCODE -ne 0) { throw 'Docker is installed but is not running. Start Docker Desktop and try again.' }
    docker compose version *> $null
    if ($LASTEXITCODE -ne 0) { throw 'Docker Compose v2 is required.' }

    New-Item -ItemType Directory -Force -Path $Tmp | Out-Null
    $Zip = Join-Path $Tmp 'time-zone-app.zip'
    $Checksums = Join-Path $Tmp 'checksums.txt'
    Invoke-WebRequest "$Base/time-zone-app.zip" -OutFile $Zip
    Invoke-WebRequest "$Base/checksums.txt" -OutFile $Checksums

    $ExpectedLine = Get-Content $Checksums | Where-Object { $_ -match 'time-zone-app\.zip$' } | Select-Object -First 1
    if (-not $ExpectedLine) { throw 'Checksum for time-zone-app.zip was not found.' }
    $Expected = ($ExpectedLine -split '\s+')[0].ToLowerInvariant()
    $Actual = (Get-FileHash -Algorithm SHA256 $Zip).Hash.ToLowerInvariant()
    if ($Expected -ne $Actual) { throw 'Checksum verification failed.' }

    $Extract = Join-Path $Tmp 'app'
    Expand-Archive -Path $Zip -DestinationPath $Extract -Force
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Get-ChildItem -Force $InstallDir | Where-Object Name -ne '.git' | Remove-Item -Recurse -Force
    Copy-Item -Path (Join-Path $Extract '*') -Destination $InstallDir -Recurse -Force

    Push-Location $InstallDir
    try { docker compose up -d --build --remove-orphans } finally { Pop-Location }

    Write-Host ''
    Write-Host 'Time Zone Converter is installed and running.' -ForegroundColor Green
    Write-Host "Install directory: $InstallDir"
    Write-Host 'URL: http://localhost:6030'
    Write-Host "To update later, run $InstallDir\scripts\update.ps1"
}
finally {
    if (Test-Path $Tmp) { Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue }
}
