@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto x64

:x86
if exist "%temp%\DLC1Temp\PartitionWizard\PartitionWizard.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\PartitionWizard" -y files\PartitionWizardx86.7z
start "" /B /D"%temp%\DLC1Temp\PartitionWizard" "PartitionWizard.exe"
exit

:x64
if exist "%temp%\DLC1Temp\PartitionWizard\PartitionWizard.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\PartitionWizard" -y files\PartitionWizardx64.7z
start "" /B /D"%temp%\DLC1Temp\PartitionWizard" "PartitionWizard.exe"
exit

:a
start "" /B /D"%temp%\DLC1Temp\PartitionWizard" "PartitionWizard.exe"