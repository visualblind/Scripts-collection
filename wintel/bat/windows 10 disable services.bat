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
sc config wlidsvc start=disabled
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