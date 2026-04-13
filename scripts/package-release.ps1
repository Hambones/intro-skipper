param(
    [string]$Version = "0.0.0",
    [string]$OutputDir = "releases",
    [string]$BuildDir = "IntroSkipper/bin/Release/net9.0"
)

if(-not (Test-Path $BuildDir)){
    Write-Host "Build output not found: $BuildDir" -ForegroundColor Yellow
    Write-Host "Run: dotnet publish -c Release IntroSkipper/IntroSkipper.csproj" -ForegroundColor Yellow
    exit 1
}

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$zipName = "intro-skipper-$Version.zip"
$zipPath = Join-Path $OutputDir $zipName

if(Test-Path $zipPath){ Remove-Item $zipPath -Force }

# Collect files: DLL(s) and Configuration web UI
$tempDir = Join-Path $env:TEMP "intro-skipper-package-$Version"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tempDir
New-Item -ItemType Directory -Path $tempDir | Out-Null

Copy-Item -Path (Join-Path $BuildDir "*.dll") -Destination $tempDir -Recurse -Force

# Copy web UI (Configuration) if present
if(Test-Path "IntroSkipper/Configuration/index.js"){
    $webDir = Join-Path $tempDir "web"
    New-Item -ItemType Directory -Path $webDir | Out-Null
    Copy-Item -Path "IntroSkipper/Configuration/*" -Destination $webDir -Recurse -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $zipPath)

Remove-Item -Recurse -Force $tempDir

Write-Host "Created package: $zipPath"
