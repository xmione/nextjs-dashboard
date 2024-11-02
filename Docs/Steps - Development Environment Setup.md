# Steps - Development Environment Setup.md
- This document details how this nextjs-dashboard Application Development Environment was setup.

## 1. Setup required tools
To install required tools, in PowerShell terminal, run:

    Start-Process "cmd.exe" -WorkingDirectory $PWD.Path -ArgumentList "/k setup.bat" -Verb runAs

    or

    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    .\setup.ps1

    or 

    In Windows Explorer, Right-click setup.bat file and Run as administrator

## 2. Check versions
Run the following commands in the terminal to check the versions:

    choco -v
    openssl -v
    gcc -v
    node -v
    nvm -v

## 3. This application was created using npx

    npx create-next-app@latest

Note: Enable everything.

## 4. Install yarn. It prefers to use yarn.

    npm i -g yarn

## 5. Install modules    
    yarn install
    yarn add @reduxjs/toolkit react-redux
    yarn add reactstrap 
    yarn add install @apollo/client graphql 
    yarn add react@latest react-dom@latest react-router-dom@latest
