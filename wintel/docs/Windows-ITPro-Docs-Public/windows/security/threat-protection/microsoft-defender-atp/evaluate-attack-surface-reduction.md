---
title: Use a demo to see how ASR rules can help protect your devices
description: The custom demo tool lets you create sample malware infection scenarios so you can see how ASR would block and prevent attacks
keywords: Attack surface reduction, hips, host intrusion prevention system, protection rules, anti-exploit, antiexploit, exploit, infection prevention, evaluate, test, demo
search.product: eADQiWindows 10XVcnh
ms.pagetype: security
ms.prod: w10
ms.mktglfcycl: manage
ms.sitesec: library
ms.pagetype: security
ms.localizationpriority: medium
audience: ITPro
author: levinec
ms.author: ellevin
ms.date: 04/02/2019
ms.reviewer: 
manager: dansimp
---

# Evaluate attack surface reduction rules

**Applies to:**

* [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

Attack surface reduction rules help prevent actions and apps that are typically used by exploit-seeking malware to infect machines. Attack surface reduction rules are supported on Windows Server 2019 as well as Windows 10 clients.

This topic helps you evaluate attack surface reduction rules. It explains how to enable audit mode so you can test the feature directly in your organization.

> [!TIP]
> You can also visit the Windows Defender Testground website at [demo.wd.microsoft.com](https://demo.wd.microsoft.com?ocid=cx-wddocs-testground) to confirm the feature is working and see how it works.

## Use audit mode to measure impact

You can enable attack surface reduction rules in audit mode. This lets you see a record of what apps would have been blocked if you had enabled attack surface reduction rules.

You might want to do this when testing how the feature will work in your organization, to ensure it doesn't affect your line-of-business apps, and to get an idea of how often the rules will fire during normal use.

To enable audit mode, use the following PowerShell cmdlet:

```PowerShell
Set-MpPreference -AttackSurfaceReductionRules_Actions AuditMode
```

This enables all attack surface reduction rules in audit mode.

> [!TIP]
> If you want to fully audit how attack surface reduction rules will work in your organization, you'll need to use a management tool to deploy this setting to machines in your network(s).
You can also use Group Policy, Intune, or MDM CSPs to configure and deploy the setting, as described in the main [Attack surface reduction rules topic](attack-surface-reduction.md).

## Review attack surface reduction events in Windows Event Viewer

To review apps that would have been blocked, open Event Viewer and filter for Event ID 1121 in the Microsoft-Windows-Windows-Defender/Operational log. The following table lists all network protection events.

 Event ID | Description
-|-
 5007 | Event when settings are changed
 1121 | Event when an attack surface reduction rule fires in block mode
 1122 | Event when an attack surface reduction rule fires in audit mode

## Customize attack surface reduction rules

During your evaluation, you may wish to configure each rule individually or exclude certain files and processes from being evaluated by the feature.

See the [Customize attack surface reduction rules](customize-attack-surface-reduction.md) topic for information on configuring the feature with management tools, including Group Policy and MDM CSP policies.

## Related topics

* [Reduce attack surfaces with attack surface reduction rules](attack-surface-reduction.md)
* [Use audit mode to evaluate Windows Defender](audit-windows-defender.md)
