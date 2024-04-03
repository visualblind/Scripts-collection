@echo off
pushd %~dp0
if exist "C:\Windows\Temp\dlcversion.txt" (
del /a /f /q "C:\Windows\Temp\dlcversion.txt"
)
ping -n 1 125.234.53.108 | find "TTL=" >nul 
if errorlevel 1 ( 
	exit
) else (
    bitsadmin.exe /transfer replica /priority FOREGROUND http://dlcboot.com/dlcversion.txt C:\Windows\Temp\dlcversion.txt
	exit
)