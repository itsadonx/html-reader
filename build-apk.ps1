# Build APK without Android Studio
# Requires: Java JDK 17+, Android SDK (command-line tools)
# Run in PowerShell from this project folder: .\build-apk.ps1

$ErrorActionPreference = "Stop"
$ProjectDir = $PSScriptRoot

Write-Host "=== HTML Reader - Build APK (no Android Studio) ===" -ForegroundColor Cyan
Write-Host ""

# 1. Check Java
Write-Host "[1/4] Checking for Java..." -ForegroundColor Yellow
$javaCmd = Get-Command java -ErrorAction SilentlyContinue
if (-not $javaCmd) {
    Write-Host "ERROR: Java not found. Install JDK 17 or later and add it to PATH." -ForegroundColor Red
    Write-Host "Download: https://adoptium.net/temurin/releases/" -ForegroundColor Gray
    exit 1
}
try { $null = & java -version 2>&1 } catch { }
Write-Host "OK" -ForegroundColor Green
Write-Host ""

# 2. Ensure Gradle wrapper exists (create it if missing)
$wrapperJar = Join-Path $ProjectDir "gradle\wrapper\gradle-wrapper.jar"
$gradlewBat = Join-Path $ProjectDir "gradlew.bat"

if (-not (Test-Path $wrapperJar)) {
    Write-Host "[2/4] Gradle wrapper missing. Downloading Gradle to create it..." -ForegroundColor Yellow
    $gradleZipUrl = "https://services.gradle.org/distributions/gradle-8.2-bin.zip"
    $gradleZip = Join-Path $env:TEMP "gradle-8.2-bin.zip"
    $gradleDir = Join-Path $env:TEMP "gradle-8.2"
    try {
        Invoke-WebRequest -Uri $gradleZipUrl -OutFile $gradleZip -UseBasicParsing
        Expand-Archive -Path $gradleZip -DestinationPath $env:TEMP -Force
        $extractPath = Join-Path $env:TEMP "gradle-8.2"
        $gradleBat = Join-Path $extractPath "bin\gradle.bat"
        if (Test-Path $gradleBat) {
            Push-Location $ProjectDir
            & $gradleBat wrapper --no-daemon
            Pop-Location
            Write-Host "Wrapper created." -ForegroundColor Green
        } else {
            throw "Could not find gradle.bat after extract"
        }
    } catch {
        Write-Host "Failed to create wrapper: $_" -ForegroundColor Red
        Write-Host "Install Gradle from https://gradle.org/install/ and run: gradle wrapper" -ForegroundColor Gray
        exit 1
    }
} else {
    Write-Host "[2/4] Gradle wrapper found." -ForegroundColor Green
}
Write-Host ""

# 3. Android SDK
Write-Host "[3/4] Checking Android SDK..." -ForegroundColor Yellow
$sdkDir = $env:ANDROID_HOME
if (-not $sdkDir) { $sdkDir = $env:ANDROID_SDK_ROOT }
if (-not $sdkDir -and (Test-Path "$env:LOCALAPPDATA\Android\Sdk")) {
    $sdkDir = "$env:LOCALAPPDATA\Android\Sdk"
}
if ($sdkDir -and (Test-Path $sdkDir)) {
    $localProps = Join-Path $ProjectDir "local.properties"
    $sdkDirEscaped = $sdkDir -replace '\\', '/'
    Set-Content -Path $localProps -Value "sdk.dir=$sdkDirEscaped" -Encoding UTF8
    Write-Host "SDK at: $sdkDir" -ForegroundColor Green
} else {
    Write-Host "WARNING: ANDROID_HOME not set. Build may fail." -ForegroundColor Yellow
    Write-Host "To install SDK without Android Studio:" -ForegroundColor Gray
    Write-Host "  1. Download: https://developer.android.com/studio#command-line-tools-only" -ForegroundColor Gray
    Write-Host "  2. Extract to e.g. D:\android-sdk" -ForegroundColor Gray
    Write-Host "  3. Run: D:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat ""platforms;android-34"" ""build-tools;34.0.0""" -ForegroundColor Gray
    Write-Host "  4. Set ANDROID_HOME=D:\android-sdk" -ForegroundColor Gray
}
Write-Host ""

# 4. Build
Write-Host "[4/4] Building APK..." -ForegroundColor Yellow
Push-Location $ProjectDir
try {
    & $gradlewBat assembleDebug --no-daemon
    if ($LASTEXITCODE -eq 0) {
        $apkPath = Join-Path $ProjectDir "app\build\outputs\apk\debug\app-debug.apk"
        Write-Host ""
        Write-Host "BUILD SUCCESSFUL" -ForegroundColor Green
        Write-Host "APK: $apkPath" -ForegroundColor Cyan
        if (Test-Path $apkPath) {
            explorer "/select,$(($apkPath -replace '/','\'))"
        }
    } else {
        Write-Host "Build failed. See errors above." -ForegroundColor Red
        exit $LASTEXITCODE
    }
} finally {
    Pop-Location
}
