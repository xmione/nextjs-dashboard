<#
    File Name    : uninstall.ps1
    Purpose      : To uninstall ReactJS-Tools Development Environment components 
    Author       : Solomio S. Sisante
    Created      : October 27, 2024    

    To run:
    
    Start-Process "cmd.exe" -WorkingDirectory $PWD.Path -ArgumentList "/k uninstall.bat" -Verb runAs
    
    or

    Start-Process "powershell.exe" -WorkingDirectory $PWD.Path -ArgumentList "-ExecutionPolicy Bypass -File .\uninstall.ps1" -Verb RunAs

    or

    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    .\uninstall.ps1

#>

# Log file name with timestamp
$logFileName = "uninstall_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFileName

# Function to uninstall OpenSSL
function Uninstall-OpenSSL {
    try {
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Host "Uninstalling OpenSSL via Chocolatey..."
            choco uninstall openssl -y
        } else {
            Write-Host "Chocolatey is not installed, attempting manual removal."
            
            # Check if OpenSSL is installed manually and remove it
            $openSSLPath = "C:\Program Files\OpenSSL-Win64"
            if (Test-Path $openSSLPath) {
                Remove-Item -Recurse -Force $openSSLPath
                Write-Host "OpenSSL manually removed."
            } else {
                Write-Host "OpenSSL is not installed manually."
            }
        }
    } catch {
        Write-Host "Failed to uninstall OpenSSL. Error: $_"
    }
}

# Function to remove OpenSSL from PATH
function Remove-OpenSSLFromPath {
    Write-Host "Removing OpenSSL from system PATH..."
    $openSSLPath = "C:\Program Files\OpenSSL-Win64\bin"
    $envPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

    if ($envPath -like "*$openSSLPath*") {
        $newEnvPath = $envPath -replace [regex]::Escape(";$openSSLPath"), ""
        [System.Environment]::SetEnvironmentVariable('Path', $newEnvPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "OpenSSL removed from system PATH."
    } else {
        Write-Host "OpenSSL is not in the system PATH."
    }
}

# Function to uninstall MinGW
function Uninstall-Mingw {
    try {
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Host "Uninstalling MinGW via Chocolatey..."
            choco uninstall mingw -y
        } else {
            Write-Host "Chocolatey is not installed, attempting manual removal."
            
            # Check if MinGW is installed manually and remove it
            $mingwPath = "C:\ProgramData\mingw64"
            if (Test-Path $mingwPath) {
                Remove-Item -Recurse -Force $mingwPath
                Write-Host "MinGW manually removed."
            } else {
                Write-Host "MinGW is not installed manually."
            }
        }
    } catch {
        Write-Host "Failed to uninstall MinGW. Error: $_"
    }
}

# Function to remove MinGW from PATH
function Remove-MingwFromPath {
    Write-Host "Removing MinGW from system PATH..."
    $mingwPath = "C:\ProgramData\mingw64\mingw64\bin"
    $envPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

    if ($envPath -like "*$mingwPath*") {
        $newEnvPath = $envPath -replace [regex]::Escape(";$mingwPath"), ""
        [System.Environment]::SetEnvironmentVariable('Path', $newEnvPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "MinGW removed from system PATH."
    } else {
        Write-Host "MinGW is not in the system PATH."
    }
}

# Function to uninstall Node.js
function Uninstall-NodeJs {
    try {
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Host "Uninstalling Node.js via Chocolatey..."
            choco uninstall nodejs -y
        } else {
            Write-Host "Chocolatey is not installed, attempting manual removal."
            
            # Check if Node.js is installed and remove it
            $nodeJsPath = "C:\Program Files\nodejs"
            if (Test-Path $nodeJsPath) {
                Remove-Item -Recurse -Force $nodeJsPath
                Write-Host "Node.js manually removed."
            } else {
                Write-Host "Node.js is not installed manually."
            }
        }
    } catch {
        Write-Host "Failed to uninstall Node.js. Error: $_"
    }
}

# Function to remove Node.js from PATH
function Remove-NodeJsFromPath {
    Write-Host "Removing Node.js from system PATH..."
    $nodeJsPath = "C:\Program Files\nodejs"
    $envPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

    if ($envPath -like "*$nodeJsPath*") {
        $newEnvPath = $envPath -replace [regex]::Escape(";$nodeJsPath"), ""
        [System.Environment]::SetEnvironmentVariable('Path', $newEnvPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Node.js removed from system PATH."
    } else {
        Write-Host "Node.js is not in the system PATH."
    }
}

# Uninstall Chocolatey
function Uninstall-Chocolatey {
    try {
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Host "Uninstalling Chocolatey..."
            # Remove Chocolatey and all associated directories
            choco uninstall chocolatey -y
            Remove-Item -Recurse -Force "C:\ProgramData\chocolatey"
            Write-Host "Chocolatey uninstalled."
        } else {
            Write-Host "Chocolatey is not installed."
        }
    } catch {
        Write-Host "Failed to uninstall Chocolatey. Error: $_"
    }
}

# Main script logic
Write-Host "Starting ReactJS-Tools Environment Uninstall..."

# Uninstall OpenSSL
Uninstall-OpenSSL

# Remove OpenSSL from system PATH
Remove-OpenSSLFromPath

# Uninstall MinGW
Uninstall-Mingw

# Remove MinGW from system PATH
Remove-MingwFromPath

# Uninstall Node.js
Uninstall-NodeJs

# Remove Node.js from system PATH
Remove-NodeJsFromPath

# Uninstall Chocolatey
Uninstall-Chocolatey

Write-Host "ReactJS-Tools Environment Uninstall Complete."
Stop-Transcript
