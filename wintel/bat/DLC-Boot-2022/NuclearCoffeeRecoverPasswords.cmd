@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\NuclearCoffeeRecoverPasswords\NuclearCoffeeRecoverPasswords.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\NuclearCoffeeRecoverPasswords" -y files\NuclearCoffeeRecoverPasswords.7z
start "" /B /D"%temp%\DLC1Temp\NuclearCoffeeRecoverPasswords" "NuclearCoffeeRecoverPasswords.exe"
exit
:a
start "" /B /D"%temp%\DLC1Temp\NuclearCoffeeRecoverPasswords" "NuclearCoffeeRecoverPasswords.exe"