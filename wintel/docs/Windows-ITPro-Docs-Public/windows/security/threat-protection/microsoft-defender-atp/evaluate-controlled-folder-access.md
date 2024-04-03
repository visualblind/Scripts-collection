---
title: See how controlled folder access can help protect files from being changed by malicious apps
description: Use a custom tool to see how Controlled folder access works in Windows 10.
keywords: Exploit protection, windows 10, windows defender, ransomware, protect, evaluate, test, demo, try
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
ms.date: 11/16/2018
ms.reviewer: 
manager: dansimp
---

# Evaluate controlled folder access

**Applies to:**

* [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

[Controlled folder access](controlled-folders.md) is a feature that helps protect your documents and files from modification by suspicious or malicious apps. Controlled folder access is supported on Windows Server 2019 as well as Windows 10 clients.

It is especially useful in helping to protect your documents and information from [ransomware](https://www.microsoft.com/wdsi/threats/ransomware) that can attempt to encrypt your files and hold them hostage.

This topic helps you evaluate controlled folder access. It explains how to enable audit mode so you can test the feature directly in your organization.

> [!TIP]
> You can also visit the Windows Defender Testground website at [demo.wd.microsoft.com](https://demo.wd.microsoft.com?ocid=cx-wddocs-testground) to confirm the feature is working and see how it works.

## Use audit mode to measure impact

You can enable the controlled folder access feature in audit mode. This lets you see a record of what *would* have happened if you had enabled the setting.

You might want to do this when testing how the feature will work in your organization, to ensure it doesn't affect your line-of-business apps, and to get an idea of how many suspicious file modification attempts generally occur over a certain period.

To enable audit mode, use the following PowerShell cmdlet:

```PowerShell
Set-MpPreference -EnableControlledFolderAccess AuditMode
```

> [!TIP]
> If you want to fully audit how controlled folder access will work in your organization, you'll need to use a management tool to deploy this setting to machines in your network(s).
You can also use Group Policy, Intune, MDM, or System Center Configuration Manager to configure and deploy the setting, as described in the main [controlled folder access topic](controlled-folders.md).

## Review controlled folder access events in Windows Event Viewer

The following controlled folder access events appear in Windows Event Viewer under Microsoft/Windows/Windows Defender/Operational folder.

Event ID | Description
-|-
 5007 | Event when settings are changed
 1124 | Audited controlled folder access event
 1123 | Blocked controlled folder access event

## Customize protected folders and apps

During your evaluation, you may wish to add to the list of protected folders, or allow certain apps to modify files.

See [Protect important folders with controlled folder access](controlled-folders.md) for configuring the feature with management tools, including Group Policy, PowerShell, and MDM CSP.

## Related topics

* [Protect important folders with controlled folder access](controlled-folders.md)
* [Evaluate Microsoft Defender ATP]../(microsoft-defender-atp/evaluate-atp.md)
* [Use audit mode](audit-windows-defender.md)
