@echo off
pushd %~dp0
SET CurDir=%CD%\
"%CurDir%RMPARTUSB.exe" list ALLDRIVES>"%temp%\AllDriveList.txt"