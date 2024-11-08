<#
    File Name    : setup.ps1
    Purpose      : To setup ReactJS-Tools Application Development Environment
    Author       : Solomio S. Sisante
    Created      : October 27, 2024    

    To run:

    Start-Process "cmd.exe" -WorkingDirectory $PWD.Path -ArgumentList "/k setup.bat" -Verb runAs

    or

    Start-Process "powershell.exe" -WorkingDirectory $PWD.Path -ArgumentList "-ExecutionPolicy Bypass -File .\setup.ps1" -Verb RunAs

    or

    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    .\setup.ps1

#>

# Enable TLS12 for secure downloads
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 

# Log file path
$logFileName = "install_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# Redirect all output to the log file
Start-Transcript -Path $logFileName -Append

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "$timestamp - $message"   
}

Log-Message "Starting installation of ReactJS-Tools Application Development Environment."

# Function to install an application
function Install-Application {
    param (
        [string]$appName,
        [scriptblock]$installCommand,
        [scriptblock]$checkCommand,
        [string]$envPath,
        [string]$manualInstallUrl = $null,
        [string]$manualInstallPath = $null
    ) 
    $message = @" 

====================================================================================================================    
appName: $appName 
installCommand: $installCommand 
checkCommand: $checkCommand 
envPath: $envPath 
manualInstallUrl: $manualInstallUrl 
manualInstallPath: $manualInstallPath 
====================================================================================================================
"@ 

    Log-Message $message

    if (-not (& $checkCommand -ErrorAction SilentlyContinue)) {
        Log-Message "Installing $appName..."
    
        try {
            # Check if Chocolatey exists, if not, install it
            if (-not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
                iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
                Log-Message "Chocolatey installed successfully."
            }
    
            # Install the application with Chocolatey, using -y for automatic confirmation
            Start-Process -NoNewWindow -Wait "choco" -ArgumentList "install $appName -y"
            Log-Message "$appName installed successfully."
    
        } catch {
            if ($manualInstallUrl -and $manualInstallPath) {
                Log-Message "Failed to install $appName via Chocolatey, attempting manual installation."
                Download-WithProgress -url $manualInstallUrl -outputFile $manualInstallPath
                Start-Process -FilePath $manualInstallPath -ArgumentList '/silent' -Wait
                Log-Message "$appName manual installation completed."
            } else {
                Log-Message "No manual installation method available for $appName."
            }
        }
    } else {
        Log-Message "$appName is already installed."
    }
    

    if (& $checkCommand -ErrorAction SilentlyContinue) {
        Log-Message "$appName installation verified."
    } else {
        Log-Message "$appName installation failed verification."
    }

    $currentPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)

    Log-Message "currentPath = $currentPath"
    if (-not ($currentPath -like "*$envPath*")) {
        $newPath = $currentPath + ";$envPath"
        [System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::User)
        $env:Path = $newPath
        Log-Message "Added $appName to the system PATH."
    } else {
        Log-Message "$appName is already in the system PATH."
    }
}

# Function to download a file with progress tracking
function Download-WithProgress {
    param (
        [string]$url,
        [string]$outputFile
    )

    Log-Message "Starting download of $url..."

    # Use Invoke-WebRequest with the -OutFile parameter
    try {
        Invoke-WebRequest -Uri $url -OutFile $outputFile -UseBasicP
    } catch {
        Log-Message "Error downloading file: $_"
    }
    
    Log-Message "Download completed: $outputFile"
}


function RestartPC {
    # Restart with 10 seconds delay, or immediate on key press
    Log-Message "`nSystem will automatically restart in 10 seconds to apply PATH changes."
    Log-Message "Press any key to restart immediately, or press Ctrl+C to cancel."

    $counter = 10
    $waitForRestart = $true

    # Start countdown
    while ($counter -gt 0 -and $waitForRestart) {
        if ($host.UI.RawUI.KeyAvailable) {
            Log-Message "`nRestarting immediately..."
            Restart-Computer -Force
            $waitForRestart = $false
        } else {
            Log-Message "$counter seconds remaining..."
            Start-Sleep -Seconds 1
            $counter--
        }
    }

    # Restart if no key pressed
    if ($waitForRestart) {
        Restart-Computer -Force
    }
}

# Execute installation functions

Install-Application -appName "Chocolatey" `
                    -installCommand { choco install chocolatey -y } `
                    -checkCommand { Get-Command choco -ErrorAction SilentlyContinue } `
                    -envPath "C:\ProgramData\chocolatey\bin"

Install-Application -appName "OpenSSL" `
                    -installCommand { choco install openssl -y } `
                    -checkCommand { Test-Path "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" } `
                    -envPath "C:\Program Files\OpenSSL-Win64\bin" `
                    -manualInstallUrl "https://slproweb.com/download/Win64OpenSSL-3_3_2.exe" `
                    -manualInstallPath "C:\Temp\Win64OpenSSL-3_3_2.exe"

Install-Application -appName "MinGW" `
                    -installCommand { choco install mingw -y } `
                    -checkCommand { Test-Path "C:\ProgramData\mingw64\mingw64\bin\gcc.exe" } `
                    -envPath "C:\ProgramData\mingw64\mingw64\bin"

Install-Application -appName "nodejs" `
                    -installCommand { choco install nodejs --version=22.9.0 -y } `
                    -checkCommand { Get-Command node -ErrorAction SilentlyContinue } `
                    -envPath "C:\Program Files\nodejs"

# Install-Application -appName "Docker Desktop" `
#                     -installCommand { choco install docker-desktop --version=4.34.2 -y } `
#                     -checkCommand { Get-Command docker -ErrorAction SilentlyContinue } `
#                     -envPath "C:\Program Files\Docker\Docker"

                    choco install docker-desktop --version=4.34.2 -y
                
                           
<#
Install-Application -appName "nodejs" `
                    -installCommand { choco install nodejs -y } `
                    -checkCommand { Get-Command node -ErrorAction SilentlyContinue } `
                    -envPath "C:\Program Files\nodejs"

<#

[System.Environment]::SetEnvironmentVariable("NODE_PATH", "C:\Program Files\nodejs\node_modules", "Machine")
[System.Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Program Files\nodejs\node_modules\npm\bin", "Machine")
[System.Environment]::SetEnvironmentVariable("NPM_CONFIG_PREFIX", "C:\Program Files\nodejs\node_modules\npm\bin", "Machine")

#>                    
                                        

# Log the completion of the installation process
Log-Message "Installation process completed."

# Stop logging
Stop-Transcript

Read-Host -Prompt "Press Enter to Restart Computer"

RestartPC
