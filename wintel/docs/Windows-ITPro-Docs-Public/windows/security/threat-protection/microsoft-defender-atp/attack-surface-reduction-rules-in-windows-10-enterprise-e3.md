---
title: Use attack surface reduction rules in Windows 10 Enterprise E3
description: ASR rules can help prevent exploits from using apps and scripts to infect machines with malware
keywords: Attack surface reduction, hips, host intrusion prevention system, protection rules, anti-exploit, antiexploit, exploit, infection prevention
search.product: eADQiWindows 10XVcnh
ms.pagetype: security
ms.prod: w10
ms.mktglfcycl: manage
ms.sitesec: library
ms.pagetype: security
ms.localizationpriority: medium
author: levinec
ms.author: ellevin
ms.date: 10/15/2018
ms.reviewer: 
manager: dansimp
---

# Use attack surface reduction rules in Windows 10 Enterprise E3

**Applies to:**

- Windows 10 Enterprise E3

Attack surface reduction rules help prevent actions and apps that are typically used by exploit-seeking malware to infect machines. This feature area includes the rules, monitoring, reporting, and analytics necessary for deployment that are included in [Microsoft Defender Advanced Threat Protection](../microsoft-defender-atp/microsoft-defender-advanced-threat-protection.md), and require the Windows 10 Enterprise E5 license. 

A limited subset of basic attack surface reduction rules can technically be used with Windows 10 Enterprise E3. They can be used without the benefits of reporting, monitoring, and analytics, which provide the ease of deployment and management capabilities necessary for enterprises. 

Attack surface reduction rules are supported on Windows Server 2019 as well as Windows 10 clients.

The limited subset of rules that can be used in Windows 10 Enterprise E3 include:

- Block executable content from email client and webmail
- Block all Office applications from creating child processes
- Block Office applications from creating executable content
- Block Office applications from injecting code into other processes
- Block JavaScript or VBScript from launching downloaded executable content
- Block execution of potentially obfuscated scripts
- Block Win32 API calls from Office macro
- Use advanced protection against ransomware
- Block credential stealing from the Windows local security authority subsystem (lsass.exe)
- Block process creations originating from PSExec and WMI commands
- Block untrusted and unsigned processes that run from USB

For more information about these rules, see [Reduce attack surfaces with attack surface reduction rules](https://docs.microsoft.com/windows/security/threat-protection/windows-defender-exploit-guard/attack-surface-reduction-exploit-guard).

 ## Related topics

Topic | Description 
---|---
[Evaluate attack surface reduction rules](evaluate-attack-surface-reduction.md) | Use a tool to see a number of scenarios that demonstrate how attack surface reduction rules work, and what events would typically be created.
[Enable attack surface reduction rules](enable-attack-surface-reduction.md) | Use Group Policy, PowerShell, or MDM CSPs to enable and manage attack surface reduction rules in your network.
[Customize attack surface reduction rules](customize-attack-surface-reduction.md) | Exclude specified files and folders from being evaluated by attack surface reduction rules and customize the notification that appears on a user's machine when a rule blocks an app or file. 
