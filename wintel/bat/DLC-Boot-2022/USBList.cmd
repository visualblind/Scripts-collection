@echo off
pushd %~dp0
SET CurDir=%CD%\
"%CurDir%RMPARTUSB.exe" list >"%temp%\USBList.txt"