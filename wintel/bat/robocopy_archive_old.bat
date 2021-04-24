::: Generate reproducable new line variable
set nl=^&echo.

for /f "tokens=1-4 delims=/-. " %%i in ('date /t') do (call :set_date %%i %%j %%k %%l)
goto :end_set_date

:set_date
if "%1:~0,1%" gtr "9" shift
for /f "skip=1 tokens=2-4 delims=(-)" %%m in ('echo,^|date') do (set %%m=%1&set %%n=%2&set %%o=%3)
goto :eof
:end_set_date
::: End set date

start /B robocopy %userprofile%\Documents \\travisrunyard.me\root\dfs\visualblind\Documents /MIR /ZB /R:5 /W:5 /NP /NDL /LOG+:%userprofile%\Documents\Temp\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\Desktop \\travisrunyard.me\root\dfs\visualblind\Desktop /MIR /ZB /R:5 /W:5 /NP /NDL /LOG+:%userprofile%\Documents\Temp\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\Downloads \\travisrunyard.me\root\dfs\visualblind\Downloads /MIR /ZB /R:5 /W:5 /NP /NDL /LOG+:%userprofile%\Documents\Temp\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\Pictures \\travisrunyard.me\root\dfs\visualblind\Pictures /MIR /ZB /R:5 /W:5 /NP /NDL /LOG+:%userprofile%\Documents\Temp\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\AppData\Local\TslGame\Saved\Demos \\travisrunyard.me\root\dfs\visualblind\AppData\Local\TslGame\Saved\Demos /MIR /ZB /R:5 /W:5 /NP /NDL /LOG+:%userprofile%\Documents\Temp\robocopy_%mm%_%dd%_%yy%.txt
echo Robocopy Done%nl%"%username%\Desktop,%username%\Documents,%username%\Downloads,%username%\Pictures,%username%\AppData\Local\TslGame\Saved\Demos > \\travisrunyard.me\root\dfs\%username%" >> %userprofile%\Documents\Temp\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\Documents F:\%username%\Documents /MIR /ZB /R:2 /W:55 /NP /NDL /LOG+:%userprofile%\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\Desktop F:\%username%\Desktop /MIR /ZB /R:2 /W:55 /NP /NDL /LOG+:%userprofile%\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\Downloads F:\%username%\Downloads /MIR /ZB /R:2 /W:55 /NP /NDL /LOG+:%userprofile%\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\Pictures F:\%username%\Pictures /MIR /ZB /R:2 /W:55 /NP /NDL /LOG+:%userprofile%\robocopy_%mm%_%dd%_%yy%.txt
start /B robocopy %userprofile%\AppData\Local\TslGame\Saved\Demos F:\%username%\AppData\Local\TslGame\Saved\Demos /MIR /ZB /R:5 /W:5 /NP /NDL /LOG+:%userprofile%\Documents\Temp\robocopy_%mm%_%dd%_%yy%.txt
echo Robocopy Done%nl%"%username%\Desktop,%username%\Documents,%username%\Downloads,%username%\Pictures,%username%\AppData\Local\TslGame\Saved\Demos > F:\%username%" >> %userprofile%\Documents\Temp\robocopy_%mm%_%dd%_%yy%.txt

goto skipcomment

echo "Stopping unnecessary services..."
net stop OneSyncSvc_52a81
net stop BthAvctpSvc
net stop PhoneSvc

echo "Disabling unnecessary services..."
REM Windows Search
sc config WSearch start=disabled
REM SSDP Discovery
sc config SSDPSRV start=disabled
REM Geolocation Service
sc config lfsvc start=disabled
REM ActiveX Installer
sc config AXInstSV start=disabled
REM AllJoyn Router Service
sc config AJRouter start=disabled
REM App Readiness
sc config AppReadiness start=disabled
REM HomeGroup Listener
sc config HomeGroupListener start=disabled
REM HomeGroup Provider
sc config HomeGroupProvider start=disabled
REM Internet Connetion Sharing
sc config SharedAccess start=disabled
REM Link-Layer Topology Discovery Mapper
sc config lltdsvc start=disabled
REM Microsoft Diagnostics Hub Standard Collector Service
sc config diagnosticshub.standardcollector.service start=disabled
REM Microsoft Account Sign-in Assistant
REM sc config wlidsvc start=disabled
REM Microsoft Windows SMS Router Service.
sc config SmsRouter start=disabled
REM Network Connected Devices Auto-Setup
sc config NcdAutoSetup start=disabled
REM Peer Name Resolution Protocol
sc config PNRPsvc start=disabled
REM Peer Networking Group
sc config p2psvc start=disabled
REM Peer Networking Identity Manager
sc config p2pimsvc start=disabled
REM PNRP Machine Name Publication Service
sc config PNRPAutoReg start=disabled
REM WalletService
sc config WalletService start=disabled
REM Windows Media Player Network Sharing Service
sc config WMPNetworkSvc start=disabled
REM Windows Mobile Hotspot Service
sc config icssvc start=disabled
REM Xbox Live Auth Manager
sc config XblAuthManager start=disabled
REM Xbox Live Game Save
sc config XblGameSave start=disabled
REM Xbox Live Networking Service
sc config XboxNetApiSvc start=disabled
REM Device Management Enrollment Service
sc config DmEnrollmentSvc start=disabled
REM Retail Demo Service
sc config RetailDemo start=disabled

:skipcomment

exit
