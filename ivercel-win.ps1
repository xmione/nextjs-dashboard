#=================================================================================
# File Name : install-vercel.ps1
# Created By: Solomio S. Sisante
# Created On: November 12, 2024
# Created To: Install Vercel CLI in Windows.
#
# How to run:
#             .\ivercel-win.ps1
#
#=================================================================================

# Log function to write messages to a log file and console
function Write-Log {
    param (
        [string]$message
    )
    $message | Tee-Object -FilePath "$PSScriptRoot\ivercel-win.log" -Append
}

Write-Log "Installing vercel cli version 37.14.0..."

# Install vercel using yarn
yarn global add vercel@37.14.0

# Add Vercel to the PATH
$env:Path += ";$($env:USERPROFILE)\.yarn\bin"
[System.Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::User)

# Refresh the environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Process)

Write-Log "Vercel CLI installed and PATH updated successfully."
