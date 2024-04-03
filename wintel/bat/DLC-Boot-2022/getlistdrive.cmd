@echo off
mode con lines=25 cols=90

pushd "%~dp0"

cls & color 3F
"%~dp0\partassist.exe" /list
rem del /Q log