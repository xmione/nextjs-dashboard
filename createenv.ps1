#=================================================================================
# File Name : createenv.ps1
# Created By: Solomio S. Sisante
# Created On: November 5, 2024
# Created To: Automatically create the Windows environment variables for the application.
#
# How to run:
#             .\createenv.ps1 -vercelToken your-vercel-token `
#                              -postgresUrl postgres-url `
#                              -postgresPrismaUrl postgres-prisma-url `
#                              -postgresUrlNoSsl postgres-url-no-ssl `
#                              -postgresUrlNonPooling postgres-url-non-pooling `
#                              -postgresUser postgres-user `
#                              -postgresHost postgres-host `
#                              -postgresPassword postgres-password `
#                              -postgresDatabase postgres-database
#
#=================================================================================

param (
    [string]$vercelToken,
    [string]$postgresUrl,
    [string]$postgresPrismaUrl,
    [string]$postgresUrlNoSsl,
    [string]$postgresUrlNonPooling,
    [string]$postgresUser,
    [string]$postgresHost,
    [string]$postgresPassword,
    [string]$postgresDatabase
)

$logFile = "C:\path\to\createenv.log"

function Write-Log {
    param (
        [string]$message
    )
    $message | Tee-Object -FilePath $logFile -Append
}

Write-Log "Starting createenv.ps1"

# Set environment variables
$env:VERCEL_TOKEN = $vercelToken
$env:POSTGRES_URL = $postgresUrl
$env:POSTGRES_PRISMA_URL = $postgresPrismaUrl
$env:POSTGRES_URL_NO_SSL = $postgresUrlNoSsl
$env:POSTGRES_URL_NON_POOLING = $postgresUrlNonPooling
$env:POSTGRES_USER = $postgresUser
$env:POSTGRES_HOST = $postgresHost
$env:POSTGRES_PASSWORD = $postgresPassword
$env:POSTGRES_DATABASE = $postgresDatabase
$env:AUTH_SECRET = [System.Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))

if ($env:ASPNET_DEVELOPMENT -eq "Codespace") {
    $env:AUTH_URL = "CODESPACE_NAME/api/auth"
} else {
    $env:AUTH_URL = "http://localhost:3000/api/auth"
}

$env:NEXTAUTH_URL=$env:AUTH_URL

Write-Log "VERCEL_TOKEN=$env:VERCEL_TOKEN"
Write-Log "POSTGRES_URL=$env:POSTGRES_URL"
Write-Log "POSTGRES_PRISMA_URL=$env:POSTGRES_PRISMA_URL"
Write-Log "POSTGRES_URL_NO_SSL=$env:POSTGRES_URL_NO_SSL"
Write-Log "POSTGRES_URL_NON_POOLING=$env:POSTGRES_URL_NON_POOLING"
Write-Log "POSTGRES_USER=$env:POSTGRES_USER"
Write-Log "POSTGRES_HOST=$env:POSTGRES_HOST"
Write-Log "POSTGRES_PASSWORD=$env:POSTGRES_PASSWORD"
Write-Log "POSTGRES_DATABASE=$env:POSTGRES_DATABASE"
Write-Log "AUTH_SECRET=$env:AUTH_SECRET"
Write-Log "AUTH_URL=$env:AUTH_URL"
Write-Log "NEXTAUTH_URL=$env:NEXTAUTH_URL"

Write-Log "createenv.ps1 completed successfully."
