---
title: 4610(S) An authentication package has been loaded by the Local Security Authority. (Windows 10)
description: Describes security event 4610(S) An authentication package has been loaded by the Local Security Authority.
ms.pagetype: security
ms.prod: w10
ms.mktglfcycl: deploy
ms.sitesec: library
ms.localizationpriority: none
author: dansimp
ms.date: 04/19/2017
ms.reviewer: 
manager: dansimp
ms.author: dansimp
---

# 4610(S): An authentication package has been loaded by the Local Security Authority.

**Applies to**
-   Windows 10
-   Windows Server 2016


<img src="images/event-4610.png" alt="Event 4610 illustration" width="656" height="317" hspace="10" align="left" />

***Subcategory:***&nbsp;[Audit Security System Extension](audit-security-system-extension.md)

***Event Description:***

This event generates every time [Authentication Package](https://msdn.microsoft.com/library/windows/desktop/aa374733(v=vs.85).aspx) has been loaded by the Local Security Authority ([LSA](https://msdn.microsoft.com/library/windows/desktop/aa378326(v=vs.85).aspx)).

Each time the system starts, the LSA loads the Authentication Package DLLs from **HKEY\_LOCAL\_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\Authentication Packages** registry value and performs the initialization sequence for every package located in these DLLs.

> **Note**&nbsp;&nbsp;For recommendations, see [Security Monitoring Recommendations](#security-monitoring-recommendations) for this event.

<br clear="all">

***Event XML:***
```
- <Event xmlns="http://schemas.microsoft.com/win/2004/08/events/event">
- <System>
 <Provider Name="Microsoft-Windows-Security-Auditing" Guid="{54849625-5478-4994-A5BA-3E3B0328C30D}" /> 
 <EventID>4610</EventID> 
 <Version>0</Version> 
 <Level>0</Level> 
 <Task>12289</Task> 
 <Opcode>0</Opcode> 
 <Keywords>0x8020000000000000</Keywords> 
 <TimeCreated SystemTime="2015-10-14T03:36:41.391489300Z" /> 
 <EventRecordID>1048138</EventRecordID> 
 <Correlation /> 
 <Execution ProcessID="516" ThreadID="520" /> 
 <Channel>Security</Channel> 
 <Computer>DC01.contoso.local</Computer> 
 <Security /> 
 </System>
- <EventData>
 <Data Name="AuthenticationPackageName">C:\\Windows\\system32\\msv1\_0.DLL : MICROSOFT\_AUTHENTICATION\_PACKAGE\_V1\_0</Data> 
 </EventData>
 </Event>

```

***Required Server Roles:*** None.

***Minimum OS Version:*** Windows Server 2008, Windows Vista.

***Event Versions:*** 0.

***Field Descriptions:***

**Authentication Package Name** \[Type = UnicodeString\]**:** the name of loaded [Authentication Package](https://msdn.microsoft.com/library/windows/desktop/aa374733(v=vs.85).aspx). The format is: DLL\_PATH\_AND\_NAME: AUTHENTICATION\_PACKAGE\_NAME.

By default the only one Authentication Package loaded by Windows 10 is “[MICROSOFT\_AUTHENTICATION\_PACKAGE\_V1\_0](https://msdn.microsoft.com/library/windows/desktop/aa378753(v=vs.85).aspx)”.

## Security Monitoring Recommendations

For 4610(S): An authentication package has been loaded by the Local Security Authority.

-   Report all “**Authentication Package Name**” not equals “C:\\Windows\\system32\\msv1\_0.DLL : MICROSOFT\_AUTHENTICATION\_PACKAGE\_V1\_0”, because by default this is the only Authentication Package loaded by Windows 10.

-   Typically this event has an informational purpose. If you have a pre-defined list of allowed Authentication Packages in the system, then you can check whether “**Authentication Package Name”** is in your defined list.

