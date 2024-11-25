# Steps - Development Environment Setup.md
- This document details how this nextjs-dashboard Application Development Environment was setup.

## 1. Setup required tools
To install required tools, in PowerShell terminal, run:

```
    Start-Process "cmd.exe" -ArgumentList "/k cd $($PWD.Path) && setup.bat" -Verb runAs
```

    or

```
    Start-Process "powershell.exe" -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-Command", "Set-Location -Path $($PWD.Path); .\setup.ps1" -Verb RunAs
```

    or

```
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    .\setup.ps1
```

    In Windows Explorer, Right-click setup.bat file and Run as administrator

## 2. Check versions
Run the following commands in the terminal to check the versions:

```
    choco -v
    openssl -v
    gcc -v
    node -v
    nvm -v
    pnpm -v
```

## 3. This application was created using npx

```
    npx create-next-app@latest
```

Note: Enable everything.

## 4. Install yarn. It prefers to use yarn.

```
    npm i -g yarn
```

## 5. Install modules    

```
    yarn install
    yarn add @reduxjs/toolkit react-redux
    yarn add reactstrap 
    yarn add install @apollo/client graphql 
    yarn add react@latest react-dom@latest react-router-dom@latest
```