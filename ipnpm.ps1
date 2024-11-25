#=================================================================================
# File Name : ipnpm.ps1
# Created By: Solomio S. Sisante
# Created On: November 25, 2024
# Created To: Install pnpm.
#
# How to run:
#             .\ipnpm.ps1 
#
#=================================================================================

# Set up pnpm Global Folder on Windows

# Step 1: Install pnpm using yarn
Write-Host "Installing pnpm using yarn..." -ForegroundColor Cyan
yarn global add pnpm

# Step 2: Configure Global Bin Directory
Write-Host "Configuring Global Bin Directory..." -ForegroundColor Cyan

# Set global bin directory path
$pnpmGlobalHomePath = [System.IO.Path]::Combine($env:USERPROFILE, 'AppData\Local\pnpm')

# Check if the directory exists, and create it if not
if (-not (Test-Path -Path $pnpmGlobalHomePath)) {
    Write-Host "Creating Global Bin Directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $pnpmGlobalHomePath -Force
} else {
    Write-Host "Global Bin Directory already exists." -ForegroundColor Green
}

# Update User-Level PATH to include Global Bin Directory
$userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

if ($userPath -split ";" -notcontains $pnpmGlobalHomePath) {
    Write-Host "Adding pnpm Global Bin Directory to User-Level PATH..." -ForegroundColor Yellow
    [System.Environment]::SetEnvironmentVariable("Path", "$userPath;$pnpmGlobalHomePath", [System.EnvironmentVariableTarget]::User)
} else {
    Write-Host "pnpm Global Bin Directory already in PATH." -ForegroundColor Green
}

# Set PNPM_HOME environment variable
if (-not [System.Environment]::GetEnvironmentVariable("PNPM_HOME", [System.EnvironmentVariableTarget]::User)) {
    Write-Host "Setting PNPM_HOME environment variable..." -ForegroundColor Yellow
    [System.Environment]::SetEnvironmentVariable("PNPM_HOME", $pnpmGlobalHomePath, [System.EnvironmentVariableTarget]::User)
}

# Step 3: Update Current Session PATH
Write-Host "Updating current session PATH..." -ForegroundColor Cyan
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

# Step 4: Troubleshooting chcp.com availability
Write-Host "Checking chcp.com availability..." -ForegroundColor Cyan
if (-not (Test-Path "C:\Windows\System32\chcp.com")) {
    Write-Host "chcp.com is missing. Attempting to repair..." -ForegroundColor Red
    DISM /Online /Cleanup-Image /RestoreHealth
    Write-Host "Restart your computer if chcp.com remains unavailable." -ForegroundColor Yellow
} else {
    Write-Host "chcp.com is available." -ForegroundColor Green
}

# Step 5: Finalize pnpm setup
Write-Host "Running pnpm setup..." -ForegroundColor Cyan
pnpm setup

Write-Host "pnpm setup complete! Please restart PowerShell to apply changes." -ForegroundColor Green
