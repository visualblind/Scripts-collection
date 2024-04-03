@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\FindAndMount\PartitionFindandMount.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\FindAndMount" -y files\PartitionFindandMount.7z
CHDIR /D "%temp%\DLC1Temp\FindAndMount"
REG IMPORT Register.reg
start "" /D"%temp%\DLC1Temp\FindAndMount" "PartitionFindandMount.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\FindAndMount" "PartitionFindandMount.exe"