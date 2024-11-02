# Setup pnpm Global folder in Windows
## 1. Install pnpm package:

```powershell
yarn global add react-devtools
```
or
```powershell
pnpm add -g react-devtools --global-bin "C:\Users\User\.local\bin"

```
## 2. Find the global binary path used by Yarn

```powershell
$globalBinPath = yarn global bin
or
$globalBinPath = pnpm config get global-bin

$globalBinPath
```

### 2.1. If you encounter the local/bin error, set the path manually
![image](https://github.com/xmione/nextjs-dashboard/blob/master/Docs/images/error.png)

```powershell
# Set the path manually
$globalBinPath = "$env:UserProfile\.local\bin";

# Check if path exists in Windows directory
Test-Path -Path $globalBinPath

# If does not exist, create it
New-Item -ItemType Directory -Path $globalBinPath

pnpm config set global-bin $globalBinPath
pnpm config get global-bin
```
## 3. Add this path to your User-level PATH and current session/process environment variable

```powershell
# Get both Machine-Level and User-Level Path Env Vars
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

# Add Yarn Global Bin Path to User Path
[System.Environment]::SetEnvironmentVariable("Path", "$userPath;$globalBinPath", [System.EnvironmentVariableTarget]::User)

#You need to update the userPath variable
$userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

# Split the paths into arrays
$machinePathArray = $machinePath -split ';'
$userPathArray = $userPath -split ';'

# Combine them and remove duplicates by selecting unique paths
$combinedPaths = ($machinePathArray + $userPathArray | Select-Object -Unique) -join ';'
$combinedPaths

# Update current session/process Path Env Var
$env:Path = $combinedPaths
```

## 3. Open the developer tools from the terminal

```powershell
react-devtools
```
