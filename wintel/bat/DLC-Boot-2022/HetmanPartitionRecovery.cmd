@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\HetmanPartitionRecovery\HetmanPartitionRecovery.cmd" goto a
7z.exe x -o"%temp%\DLC1Temp\HetmanPartitionRecovery" -y files\HetmanPartitionRecovery.7z
start "" /D"%temp%\DLC1Temp\HetmanPartitionRecovery" "HetmanPartitionRecovery.cmd"
rem start "" /D"%temp%\DLC1Temp\HetmanPartitionRecovery" "Keygen.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\HetmanPartitionRecovery" "HetmanPartitionRecovery.cmd"
rem start "" /D"%temp%\DLC1Temp\HetmanPartitionRecovery" "Keygen.exe"
exit