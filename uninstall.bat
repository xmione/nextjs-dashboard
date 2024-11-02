@ECHO OFF
ECHO =========================================================================================
ECHO File Name  : uninstall.bat
ECHO Author     : Solomio S. Sisante
ECHO Created    : October 27, 2024
ECHO =========================================================================================
ECHO %~dp0  
 
:: powershell.exe -WindowStyle Hidden -ExecutionPolicy Unrestricted -File %~dp0\uninstall.ps1
powershell.exe -ExecutionPolicy Unrestricted -File %~dp0\uninstall.ps1
pause