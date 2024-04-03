@echo off
rem This script will enable the command prompt to save the command history to disk
rem 4kib.com / nixscripts.com

if "%AUTOEXEC%" EQU "1" goto :eof
SET AUTOEXEC=1

IF NOT EXIST "%USERPROFILE%\commands.log" ( type nul > "%USERPROFILE%\commands.log" || exit /b %ERRORLEVEL% ) ELSE ( goto :cmdhist )

:cmdhist
@echo Persistent command history is now enabled in %USERPROFILE%\commands.log for this command prompt.
@echo Loading macros.

rem  remap exit command to save a copy of the command line history to a log before exiting.
DOSKEY exit=(echo/ ^& echo **** %date% %time% ****) $g$g %USERPROFILE%\commands.log ^& doskey /history $g$g %USERPROFILE%\commands.log ^& ECHO Command history saved, exiting ^& exit $*

rem  review previous command line entries:
DOSKEY history=notepad %USERPROFILE%\commands.log

rem  copy the current directory to the clipboard
DOSKEY cc=cd^|clip ^& echo %%CD%% copied to clipboard
