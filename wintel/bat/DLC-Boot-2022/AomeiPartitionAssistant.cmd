@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\AomeiPartitionAssistant\AomeiPartitionAssistant.exe" goto exit
7z.exe x -o"%temp%\DLC1Temp\AomeiPartitionAssistant" -y files\AomeiPartitionAssistant.7z

:exit
start "" /D"%temp%\DLC1Temp\AomeiPartitionAssistant" "AomeiPartitionAssistant.exe"
exit