---
title: Help prevent ransomware and threats from encrypting and changing files
description: Files in default folders can be protected from being changed by malicious apps. This can help prevent ransomware from encrypting your files.
keywords: controlled folder access, windows 10, windows defender, ransomware, protect, files, folders
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
audience: ITPro
ms.date: 08/05/2019
ms.reviewer: v-maave
manager: dansimp
---

# Protect important folders with controlled folder access

**Applies to:**

* [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

Controlled folder access helps you protect valuable data from malicious apps and threats, such as ransomware. It protects your data by checking against a list of known, trusted apps. Controlled folder access is supported on Windows Server 2019 as well as Windows 10 clients. It can be turned on via the Windows Security App, or from the System Center Configuration Manager (SCCM) and Intune, for managed devices. Controlled folder access works best with [Microsoft Defender Advanced Threat Protection](../microsoft-defender-atp/microsoft-defender-advanced-threat-protection.md), which gives you detailed reporting into controlled folder access events and blocks as part of the usual [alert investigation scenarios](../microsoft-defender-atp/investigate-alerts.md).

Controlled folder access works by only allowing apps to access protected folders if the app is included on a list of trusted software. If an app isn't on the list, Controlled folder access will block it from making changes to files inside protected folders.

Apps are added to the trusted list based upon their prevalence and reputation. Apps that are highly prevalent throughout your organization, and that have never displayed any malicious behavior, are deemed trustworthy and automatically added to the list.

Apps can also be manually added to the trusted list via SCCM and Intune. Additional actions, such as [adding a file indicator](../microsoft-defender-atp/respond-file-alerts.md#add-indicator-to-block-or-allow-a-file) for the app, can be performed from the Security Center Console.

Controlled folder access is especially useful in helping to protect your documents and information from [ransomware](https://www.microsoft.com/wdsi/threats/ransomware) that can attempt to encrypt your files and hold them hostage.

With Controlled folder access in place, a notification will appear on the computer where the app attempted to make changes to a protected folder. You can [customize the notification](customize-attack-surface-reduction.md#customize-the-notification) with your company details and contact information. You can also enable the rules individually to customize what techniques the feature monitors.

The protected folders include common system folders, and you can [add additional folders](customize-controlled-folders.md#protect-additional-folders). You can also [allow or whitelist apps](customize-controlled-folders.md#allow-specific-apps-to-make-changes-to-controlled-folders) to give them access to the protected folders.

You can use [audit mode](audit-windows-defender.md) to evaluate how controlled folder access would impact your organization if it were enabled. You can also visit the Windows Defender Testground website at [demo.wd.microsoft.com](https://demo.wd.microsoft.com?ocid=cx-wddocs-testground) to confirm the feature is working and see how it works.

Controlled folder access is supported on Windows 10, version 1709 and later and Windows Server 2019.

## Requirements

Controlled folder access requires enabling [Windows Defender Antivirus real-time protection](../windows-defender-antivirus/configure-real-time-protection-windows-defender-antivirus.md).

## Review controlled folder access events in the Microsoft Defender ATP Security Center

Microsoft Defender ATP provides detailed reporting into events and blocks as part of its [alert investigation scenarios](../microsoft-defender-atp/investigate-alerts.md).

You can query Microsoft Defender ATP data by using [Advanced hunting](https://docs.microsoft.com/windows/security/threat-protection/microsoft-defender-atp/advanced-hunting-windows-defender-advanced-threat-protection). If you're using [audit mode](audit-windows-defender.md), you can use Advanced hunting to see how controlled folder access settings would affect your environment if they were enabled.

Here is an example query

```PowerShell
MiscEvents
| where ActionType in ('ControlledFolderAccessViolationAudited','ControlledFolderAccessViolationBlocked')
```

## Review controlled folder access events in Windows Event Viewer

You can review the Windows event log to see events that are created when controlled folder access blocks (or audits) an app:

1. Download the [Evaluation Package](https://aka.ms/mp7z2w) and extract the file *cfa-events.xml* to an easily accessible location on the machine.

1. Type **Event viewer** in the Start menu to open the Windows Event Viewer.

1. On the left panel, under **Actions**, click **Import custom view...**.

1. Navigate to where you extracted *cfa-events.xml* and select it. Alternatively, [copy the XML directly](event-views.md).

1. Click **OK**.

1. This will create a custom view that filters to only show the following events related to controlled folder access:

Event ID | Description
-|-
5007 | Event when settings are changed
1124 | Audited controlled folder access event
1123 | Blocked controlled folder access event

## In this section

Topic | Description
-|-
[Evaluate controlled folder access](evaluate-controlled-folder-access.md) | Use a dedicated demo tool to see how controlled folder access works, and what events would typically be created.
[Enable controlled folder access](enable-controlled-folders.md) | Use Group Policy, PowerShell, or MDM CSPs to enable and manage controlled folder access in your network
[Customize controlled folder access](customize-controlled-folders.md) | Add additional protected folders, and allow specified apps to access protected folders.
