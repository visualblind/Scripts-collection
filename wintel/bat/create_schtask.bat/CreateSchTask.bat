@ECHO OFF
SET UPDATEDIR=%~dp0
CHDIR %UPDATEDIR%
Start /Wait /B schtasks.exe /create /TN "ACC" /XML "ts.xml" /F
Start /Wait /B schtasks.exe /create /TN "ACCAgent" /XML "agentts.xml"
EXIT /B 
