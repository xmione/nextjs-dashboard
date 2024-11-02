@ECHO OFF
ECHO =========================================================================================
ECHO File Name  : setup.bat
ECHO Purpose    : Installs the necessary tools for the ReactJS-Tools application.
ECHO Author     : Solomio S. Sisante
ECHO Created    : October 27, 2024
ECHO. 
ECHO How to run : Start-Process "cmd.exe" $PWD.Path -ArgumentList "/k setup.bat" -Verb runAs
ECHO.
ECHO =========================================================================================
ECHO %~dp0  
 
:: powershell.exe -WindowStyle Hidden -ExecutionPolicy Unrestricted -File %~dp0\setup.ps1
powershell.exe -ExecutionPolicy Unrestricted -File %~dp0\setup.ps1
pause