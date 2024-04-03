@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\DnsJumper\DnsJumper.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\DnsJumper" -y files\DnsJumper.7z
start "" /D"%temp%\DLC1Temp\DnsJumper" "DnsJumper.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\DnsJumper" "DnsJumper.exe"
exit