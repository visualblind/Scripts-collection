:: =============================================================================
::                       MWin v1.0 www.github.com/wrrulos
::                      Script to change menu in Windows 11
::                               Made by wRRulos
::                                  @wrrulos
:: =============================================================================

:: Any error report it to my discord please, thank you.

@echo off
title MWin
mode con cols=70 lines=21

net session >nul 2>&1

if %errorlevel% == 0 (

    goto MWin

) else (

    echo.
    echo.
    echo                888b     d888 888       888 d8b          
    echo                8888b   d8888 888   o   888 Y8P          
    echo                88888b.d88888 888  d8b  888              
    echo                888Y88888P888 888 d888b 888 888 88888b.  
    echo                888 Y888P 888 888d88888b888 888 888  88b 
    echo                888  Y8P  888 88888P Y88888 888 888  888 
    echo                888   8   888 8888P   Y8888 888 888  888 
    echo                888       888 888P     Y888 888 888  888
    echo.
    echo                [#] MWin needs administrator permissions
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.

    pause >nul
    exit /b
    
)

:MWin
cls
echo.
echo.
echo                888b     d888 888       888 d8b          
echo                8888b   d8888 888   o   888 Y8P          
echo                88888b.d88888 888  d8b  888              
echo                888Y88888P888 888 d888b 888 888 88888b.  
echo                888 Y888P 888 888d88888b888 888 888  88b 
echo                888  Y8P  888 88888P Y88888 888 888  888 
echo                888   8   888 8888P   Y8888 888 888  888 
echo                888       888 888P     Y888 888 888  888
echo.
echo                  [0] Activate        [1] Deactivate
echo.
set /p option=".                         Choose an option: "

if %option% == 0 ( goto Activate )
if %option% == 1 ( goto Deactivate ) else (
    goto MWin
)


:Activate
reg add "HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f >nul 2>&1

echo.
echo.
echo  [#] If the changes do not appear, restart your computer.
echo.
echo.
echo.

pause >nul
exit /b

:Deactivate
reg delete "HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

echo.
echo.
echo  [#] If the changes do not appear, restart your computer.
echo.
echo.
echo.

pause >nul
exit /b