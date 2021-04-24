@echo off
title IMAGE HEALTH - Version 08.07.2015
color 17
%windir%\system32\reg.exe query "HKU\S-1-5-19" >nul 2>&1 || (
echo.
echo ===============================================================================
echo.                     ADMINISTRATOR PRIVILEGES NOT DETECTED
echo.
echo.        RIGHT CLICK ON THIS SCRIPT AND SELECT 'RUN AS AN ADMINISTRATOR'
echo ===============================================================================
echo. Press Any Key To Exit..
pause >nul
goto :eof
)

:menu
set userinp=
cls
echo.
echo.   IMAGEHEALTH PROGRAM OPTIONS
echo ===============================================================================
echo.   Press 0 - Quit and Exit program 
echo.   Press 1 - Run Dism /ScanHealth
echo.   Press 2 - Run Dism /RestoreHealth
echo.   Press 3 - Run Dism /RestoreHealth /Source            
echo.   Press 4 - Run Dism /AnalyzeComponentStore
echo.   Press 5 - Run Dism /StartComponentCleanup
echo.   Press 6 - Run Dism /StartComponentCleanup /ResetBase
echo.   Press 7 - Run Dism /revertpendingactions
echo.   Press 8 - Run SFC /Scannow
echo ===============================================================================
set /p userinp= ^> Enter Your Option: 
set userinp=%userinp:~0,3%
if %userinp%==0 goto :done
if %userinp%==1 goto :scan1
if %userinp%==2 goto :scan2
if %userinp%==3 goto :scan3
if %userinp%==4 goto :scan4
if %userinp%==5 goto :scan5
if %userinp%==6 goto :scan6
if %userinp%==7 goto :scan7
if %userinp%==8 goto :scan8

:scan1
cls
echo.
echo ===============================================================================
echo.   Dism is scanning the online image for health.
echo.   Dism will report whether the image is healthy or repairable
echo.   This will take several minutes..
echo ===============================================================================
Dism /Online /Cleanup-Image /ScanHealth
pause
goto :menu

:scan2
cls
echo.
echo ===============================================================================
echo.   Dism is restoring the online image health.
echo.   This will take several minutes..
echo ===============================================================================
Dism /Online /Cleanup-Image /RestoreHealth
pause
goto :menu

:scan3
cls
for %%i in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%i:\\sources\install.wim" set setupdrv=%%i
if defined setupdrv (
echo.
echo ===============================================================================
echo.   Found Source Install.wim on Drive %setupdrv%:
echo ===============================================================================
goto :restorewim
)
for %%i in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%i:\\sources\install.esd" set setupdrv=%%i
if defined setupdrv (
echo.
echo ===============================================================================
echo.   Found Source Install.esd on Drive %setupdrv%:
echo ===============================================================================
goto :restoreesd
)
if not defined setupdrv (
cls
echo.
echo ===============================================================================
echo.   No Installation Media Found!
echo.
echo.   Insert DVD or USB flash drive and run this option again. 
echo ===============================================================================
pause
goto :menu
)
:restorewim
if not exist "%~dp0Temp\install.wim" (
echo.
echo ===============================================================================
echo.   MOUNTING THE SOURCE INSTALL.WIM AS THE REPAIR SOURCE
echo ===============================================================================
md "%~dp0Temp\Mount"
copy %setupdrv%:\sources\install.wim "%~dp0Temp\install.wim"
)
Dism /Mount-Image /ImageFile:"%~dp0Temp\install.wim" /Index:1 /MountDir:"%~dp0Temp\Mount"
cls
echo.
echo ===============================================================================
echo.   Dism is restoring the online image health.
echo.   This will take several minutes..
echo ===============================================================================
Dism /Online /Cleanup-Image /RestoreHealth /Source:"%~dp0Temp\Mount\windows" /LimitAccess
Dism /Unmount-Image /MountDir:"%~dp0Temp\Mount" /discard
pause
goto :menu
:restoreesd
set wimlib=%~dp0bin\wimlib-imagex.exe
%windir%\system32\reg.exe query "hklm\software\microsoft\Windows NT\currentversion" /v buildlabex | find /i "amd64" 1>nul && set wimlib=%~dp0bin\bin64\wimlib-imagex.exe
if not exist "%~dp0bin\wimlib-imagex.exe" (echo.&echo ERROR: Required Bin Files Not Found.&PAUSE&GOTO :EOF)
if not exist "%~dp0Temp\install.wim" (
echo.
echo ===============================================================================
echo.   MOUNTING THE SOURCE INSTALL.ESD AS THE REPAIR SOURCE
echo ===============================================================================
md "%~dp0Temp\Mount"
REM "%wimlib%" export "%setupdrv%:\sources\install.esd" 4 "%~dp0Temp\install.wim" --compress=maximum
"%wimlib%" export "%setupdrv%:\sources\install.esd" 1 "%~dp0Temp\install.wim" --compress=maximum
)
Dism /Mount-Image /ImageFile:"%~dp0Temp\install.wim" /Index:1 /MountDir:"%~dp0Temp\Mount"
cls
echo.
echo ===============================================================================
echo.   Dism is restoring the online image health.
echo.   This will take several minutes..
echo ===============================================================================
Dism /Online /Cleanup-Image /RestoreHealth /Source:"%~dp0Temp\Mount\windows" /LimitAccess
Dism /Unmount-Image /MountDir:"%~dp0Temp\Mount" /discard
pause
goto :menu

:scan4
cls
echo.
echo ===============================================================================
echo.   Dism is Analyzing the Component Store.
echo.   This will take several minutes..
echo ===============================================================================
Dism /Online /Cleanup-Image /AnalyzeComponentStore
pause
goto :menu

:scan5
cls
echo.
echo ===============================================================================
echo.   Dism is Cleaning Up the Component Store.
echo.   This will take several minutes..
echo ===============================================================================
Dism /Online /Cleanup-Image /StartComponentCleanup
pause
goto :menu

:scan6
cls
echo.
echo ===============================================================================
echo.   Dism is Resetting the Component Store.
echo.   This will take several minutes..
echo ===============================================================================
Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase
pause
goto :menu

:scan7
cls
echo.
echo ===============================================================================
echo.   Dism is Reverting any Pending Dism Actions.
echo.   This will take several minutes.. 
echo ===============================================================================
Dism /online /Cleanup-Image /revertpendingactions
pause
goto :menu

:scan8
cls
echo.
echo ===============================================================================
echo.   System File Checker is scanning the online image for corruption. 
echo.   This will take several minutes
echo ===============================================================================
sfc.exe /scannow
pause
goto :menu

:offlinemenu
cls
echo.
echo ===============================================================================
echo.
echo.   No Off-Line Menu at this time
echo.
echo ===============================================================================
pause
goto :menu

:done
cls
if exist "%~dp0Temp\Mount" rmdir /s /q "%~dp0Temp\Mount"
if exist "%~dp0Temp" rmdir /s /q "%~dp0Temp"
echo.
echo.   IMAGE_HEALTH.CMD
echo.   WRITTEN BY KYHI
echo.   AUGUST 07,2015
echo.
echo.   ENJOY!!
echo.
timeout /t 6 >nul
goto :eof