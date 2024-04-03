@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\EaseUSDataRecoveryWizard\EASEUSDataRecoveryWizard.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\EaseUSDataRecoveryWizard" -y files\EASEUSDataRecoveryWizard.7z
start "" /D"%temp%\DLC1Temp\EaseUSDataRecoveryWizard" "EASEUSDataRecoveryWizard.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\EaseUSDataRecoveryWizard" "EASEUSDataRecoveryWizard.exe"