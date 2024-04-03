@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\NuclearCoffeeRecoverKeys\RecoverKeys (x86).exe" goto a
7z.exe x -o"%temp%\DLC1Temp\NuclearCoffeeRecoverKeys" -y files\NuclearCoffeeRecoverKeys.7z
rem CHDIR /D "%temp%\DLC1Temp\NuclearCoffeeRecoverKeys"
rem REG IMPORT Register.reg
start "" /D"%temp%\DLC1Temp\NuclearCoffeeRecoverKeys" "RecoverKeys (x86).exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "NuclearCoffeeRecoverKeys\RecoverKeys (x86).exe"
exit