@pushd "%~dp0"
@7z.exe x -o"%TEMP%" -y Files\AutoMountDrives.7z
@start "" /D"%TEMP%" "AutoMountDrives.exe"