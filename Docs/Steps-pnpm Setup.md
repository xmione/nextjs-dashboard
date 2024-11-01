# Setup pnpm Global folder in Windows
1. Install pnpm package:

```powershell
yarn global add pnpm
```
2. Setting Up Global Bin Directory:

You can check Machine-Level and User-Level Path environment variables by running these commands in PowerShell:

## Getting Machine-Level Path Environment Variable
```powershell
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$machinePath
```

## Getting User-Level Path Environment Variable
```powershell
$userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
$userPath
```
## Setting Machine-Level

```powershell
$machinePath = "C:\Windows\System32;C:\Windows\System32\WindowsPowerShell\v1.0"

[System.Environment]::SetEnvironmentVariable("Path", $machinePath, [System.EnvironmentVariableTarget]::Machine)

```
## Setting User-Level

```powershell
$userPath = "C:\Users\User\AppData\Local\pnpm;C:\ProgramData\chocolatey\bin;C:\Program Files\OpenSSL-Win64\bin;C:\ProgramData\mingw64\mingw64\bin;C:\Users\User\AppData\Local\Microsoft\WindowsApps;C:\Users\User\.dotnet\tools;C:\Users\User\AppData\Local\GitHubDesktop\bin;C:\Users\User\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\User\AppData\Roaming\npm;C:\Program Files\nodejs;C:\Program Files\Git\cmd"

[System.Environment]::SetEnvironmentVariable("Path", $userPath, [System.EnvironmentVariableTarget]::User)
```

## Setting Current Session/Process-Level
You can set the current session/process-level path variable in two (2) ways:

### 1. Restarting the Computer

```powershell
Restart-Computer -Force
```

### 2. Getting the Machine-Level and User-Level path variables, combining them and then saving them to the $env:Path variable

```powershell
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

# Split the paths into arrays
$machinePathArray = $machinePath -split ';'
$userPathArray = $userPath -split ';'

# Combine them and remove duplicates by selecting unique paths
$combinedPaths = ($machinePathArray + $userPathArray | Select-Object -Unique) -join ';'
$combinedPaths
$env:Path = $combinedPaths
```
## Setup the Global bin directory
To set up the global bin directory for pnpm, try running these commands in your PowerShell:

### 1. Set the default Global Bin Folder
```powershell
$pnpmGlobalHomePath = [System.IO.Path]::Combine($env:USERPROFILE, 'AppData\Local\pnpm')
```

### 2. Check if path exists in the directory
```powershell
Test-Path -Path $pnpmGlobalHomePath
```

### 3. Create Path if it does not exist
```powershell
New-Item -ItemType Directory -Path $pnpmGlobalHomePath
```

### 4. Add to User-Level Path if it does not exist
#### 4.1. Check User Path
```powershell
$userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
$existInUserPath = suserPath -split ";" -contains $pnpmGlobalHomePath
$existInUserPath
```
#### 4.2. Add if it does not exist
```powershell
[System.Environment]::SetEnvironmentVariable("Path", "$userPath;$pnpmGlobalHomePath", [System.EnvironmentVariableTarget]::User)
```

### 5. Set the Global folder
```powershell
pnpm config set global-bin-dir $pnpmGlobalHomePath
```

### 6. Add the Global Bin Directory to PNPM_HOME variable:
#### 6.1. Check first if it exist

```powershell
[System.Environment]::GetEnvironmentVariable("PNPM_HOME", [System.EnvironmentVariableTarget]::User)
```

#### 6.2. Set PNPM_HOME value
```powershell
[System.Environment]::SetEnvironmentVariable("PNPM_HOME", $pnpmGlobalHomePath, [System.EnvironmentVariableTarget]::User)
```
4. Restart PowerShell: Close and reopen PowerShell to apply the changes.

```powershell
Restart-Computer -Force
```

If you don't want to restart the computer and want it to take effect immediately, run this command:

```powershell
$userPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
$pnpmGlobalHomePath = [System.Environment]::GetEnvironmentVariable("PNPM_HOME", [System.EnvironmentVariableTarget]::User)
$env:Path = $userPath
$env:PHPM_HOME = $pnpmGlobalHomePath
```

5. Run Pnpm Setup:
Now, you should be able to run pnpm setup without issues:
```powershell
pnpm setup
```

These steps should resolve the chcp and global bin directory issues. After this, you should be set to use pnpm for global installs seamlessly in your VM environment.

# Setup pnpm Global folder in Linux
1. Set the Global Bin Directory: Configure pnpm to use a global bin directory:
```powershell
pnpm config set global-bin-dir ~/.local/bin
```

2. Add the Directory to PATH: Update your PATH to include this directory:
```powershell
export PNPM_HOME="$HOME/.local/bin"
export PATH="$PNPM_HOME:$PATH"
```

3. Persist the Changes: Add these lines to your .bashrc, .zshrc, or equivalent shell config file to make the change permanent:
```powershell
echo 'export PNPM_HOME="$HOME/.local/bin"' >> ~/.bashrc
echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

For zsh, replace ~/.bashrc with ~/.zshrc.

4. Run Pnpm Setup: Now, run the setup command to finalize the configuration:
```powershell
pnpm setup
```

These steps will set up pnpm for global use in your Linux environment, allowing you to install and manage global packages seamlessly.
Happy coding! 🐧✨

# Trouble-Shooting

## Check chcp.com 

### 1. Check if chcp.com exists in C:\Windows\System32 and path is in environment variable

```powershell
ls C:\Windows\System32\chcp.com
```

### 1.1. If it exists, check current session Process-Level Path environment if it has C:\Windows\System32

```powershell
$processPath = $env:Path -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ -eq 'C:\Windows\System32' }
$processPath
```

### 1.1.1. If path C:\Windows\System32 is not found, check first if it exists in the User-Level variable

```powershell
$userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
$userPath
```

### 1.1.1.1 If it does not exist, add it to the User and Process level environment variable Path

```powershell
[System.Environment]::SetEnvironmentVariable("Path", "$userPath;C:\Windows\System32", [System.EnvironmentVariableTarget]::User)

$env:Path = $userPath
```

### 1.1.1.2 If it exists in the User level variable, just add it to the Process level environment variable Path

```powershell
$env:Path = $userPath
```
Note: If you open a new terminal in VS you got to repeat from 1.1.1. again but if you open a new VS Code IDE, you wouldn't have to.

### 1.1.2 If `C:\Windows\System32` is missing in the User-Level Path, add it
```powershell
[System.Environment]::SetEnvironmentVariable("Path", "$userPath;C:\Windows\System32", [System.EnvironmentVariableTarget]::User)
$env:Path = "$env:Path;C:\Windows\System32"  # Add to current session Path

### 1.2. If chcp.com does not exists, reinstall it
### 1.2.1. Repair Windows Image using DISM

```powershell
DISM /Online /Cleanup-Image /RestoreHealth
```

### 1.2.2. Restart the computer and check again
### 1.3. Manually Restore chcp.com (if still missing)
### 1.3.1. Copy chcp.com from another working Windows machine:

```powershell
Copy-Item -Path "C:\Windows\System32\chcp.com" -Destination "C:\Windows\System32\chcp.com"

```
### 1.3.2. Verify it is now accessible

```powershell
ls C:\Windows\System32\chcp.com
```

This should ensure you’ve got everything detailed and clear for troubleshooting! 🎀✨