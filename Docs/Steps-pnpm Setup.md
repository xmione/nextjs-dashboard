# Setup pnpm Global folder in Windows
1. Setting Up Global Bin Directory:
To set up the global bin directory for pnpm, try running these commands in your PowerShell:

```
$pnpmHome = [System.IO.Path]::Combine($env:USERPROFILE, '.pnpm-global')
pnpm config set global-bin-dir $pnpmHome
```
![alt text](image-1.png)

2. Adding Global Bin Directory to PATH:
Add the global bin directory to your PATH:
```
[System.Environment]::SetEnvironmentVariable("PNPM_HOME", $pnpmHome, [System.EnvironmentVariableTarget]::User)
$path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("Path", "$path;$pnpmHome", [System.EnvironmentVariableTarget]::User)
```
![alt text](image-2.png)

3. Restart PowerShell:
Close and reopen PowerShell to apply the changes.

4. Run Pnpm Setup:
Now, you should be able to run pnpm setup without issues:
```
pnpm setup
```
![alt text](image-3.png)

These steps should resolve the chcp and global bin directory issues. After this, you should be set to use pnpm for global installs seamlessly in your VM environment.

# Setup pnpm Global folder in Linux
1. Set the Global Bin Directory: Configure pnpm to use a global bin directory:
```
pnpm config set global-bin-dir ~/.local/bin
```
![alt text](image-6.png)

2. Add the Directory to PATH: Update your PATH to include this directory:
```
export PNPM_HOME="$HOME/.local/bin"
export PATH="$PNPM_HOME:$PATH"
```
![alt text](image-7.png)

3. Persist the Changes: Add these lines to your .bashrc, .zshrc, or equivalent shell config file to make the change permanent:
```
echo 'export PNPM_HOME="$HOME/.local/bin"' >> ~/.bashrc
echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
![alt text](image-8.png)

For zsh, replace ~/.bashrc with ~/.zshrc.

4. Run Pnpm Setup: Now, run the setup command to finalize the configuration:
```
pnpm setup
```
![alt text](image-9.png)

These steps will set up pnpm for global use in your Linux environment, allowing you to install and manage global packages seamlessly.
Happy coding! 🐧✨