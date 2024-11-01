# Setup pnpm Global folder
1. Setting Up Global Bin Directory:
To set up the global bin directory for pnpm, try running these commands in your PowerShell:

$pnpmHome = [System.IO.Path]::Combine($env:USERPROFILE, '.pnpm-global')
pnpm config set global-bin-dir $pnpmHome

2. Adding Global Bin Directory to PATH:
Add the global bin directory to your PATH:

[System.Environment]::SetEnvironmentVariable("PNPM_HOME", $pnpmHome, [System.EnvironmentVariableTarget]::User)
$path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("Path", "$path;$pnpmHome", [System.EnvironmentVariableTarget]::User)

3. Restart PowerShell:
Close and reopen PowerShell to apply the changes.

4. Run Pnpm Setup:
Now, you should be able to run pnpm setup without issues:
pnpm setup
These steps should resolve the chcp and global bin directory issues. After this, you should be set to use pnpm for global installs seamlessly in your VM environment.
