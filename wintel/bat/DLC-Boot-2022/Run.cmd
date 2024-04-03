@echo off
mode con lines=25 cols=90
pushd "%cd%"
cd /d "%~dp0"


cls& color 3F
%~dp0bin\partassist.exe /list