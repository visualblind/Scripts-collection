---
title: Troubleshoot problems with Network protection
description: Check pre-requisites, use audit mode, add exclusions, or collect diagnostic data to help troubleshoot issues
keywords: troubleshoot, error, fix, windows defender eg, asr, rules, hips, troubleshoot, audit, exclusion, false positive, broken, blocking
search.product: eADQiWindows 10XVcnh
ms.pagetype: security
ms.prod: w10
ms.mktglfcycl: manage
ms.sitesec: library
ms.pagetype: security
ms.localizationpriority: medium
audience: ITPro
author: dansimp
ms.author: dansimp
ms.date: 03/27/2019
ms.reviewer: 
manager: dansimp
---

# Troubleshoot network protection

**Applies to:**

* [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

* IT administrators

When you use [Network protection](network-protection.md) you may encounter issues, such as:

* Network protection blocks a website that is safe (false positive)
* Network protection fails to block a suspicious or known malicious website (false negative)

There are four steps to troubleshooting these problems:

1. Confirm prerequisites
2. Use audit mode to test the rule
3. Add exclusions for the specified rule (for false positives)
4. Submit support logs

## Confirm prerequisites

Network protection will only work on devices with the following conditions:

>[!div class="checklist"]
> * Endpoints are running Windows 10 Enterprise edition, version 1709 or higher (also known as the Fall Creators Update).
> * Endpoints are using Windows Defender Antivirus as the sole antivirus protection app. [Using any other antivirus app will cause Windows Defender AV to disable itself](../windows-defender-antivirus/windows-defender-antivirus-compatibility.md).
> * [Real-time protection](../windows-defender-antivirus/configure-real-time-protection-windows-defender-antivirus.md) is enabled.
> * [Cloud-delivered protection](../windows-defender-antivirus/enable-cloud-protection-windows-defender-antivirus.md) is enabled.
> * Audit mode is not enabled. Use [Group Policy](enable-network-protection.md#group-policy) to set the rule to **Disabled** (value: **0**).

## Use audit mode

You can enable network protection in audit mode and then visit a website that we've created to demo the feature. All website connections will be allowed by network protection but an event will be logged to indicate any connection that would have been blocked if network protection was enabled.

1. Set network protection to **Audit mode**.

   ```PowerShell
   Set-MpPreference -EnableNetworkProtection AuditMode
   ```

1. Perform the connection activity that is causing an issue (for example, attempt to visit the site, or connect to the IP address you do or don't want to block).

1. [Review the network protection event logs](network-protection.md#review-network-protection-events-in-windows-event-viewer) to see if the feature would have blocked the connection if it had been set to **Enabled**.
   >
   >If network protection is not blocking a connection that you are expecting it should block, enable the feature.

```PowerShell
Set-MpPreference -EnableNetworkProtection Enabled
```

## Report a false positive or false negative

If you've tested the feature with the demo site and with audit mode, and network protection is working on pre-configured scenarios, but is not working as expected for a specific connection, use the [Windows Defender Security Intelligence web-based submission form](https://www.microsoft.com/wdsi/filesubmission) to report a false negative or false positive for network protection. With an E5 subscription, you can also [provide a link to any associated alert](../microsoft-defender-atp/alerts-queue.md).

## Exclude website from network protection scope

To whitelist the website that is being blocked (false positive), add its URL to the [list of trusted sites](https://blogs.msdn.microsoft.com/asiatech/2014/08/19/how-to-add-web-sites-to-trusted-sites-via-gpo-from-dc-installed-ie10-or-higher-ie-version/). Web resources from this list bypass the network protection check.

## Collect diagnostic data for file submissions

When you report a problem with network protection, you are asked to collect and submit diagnostic data that can be used by Microsoft support and engineering teams to help troubleshoot issues.

1. Open an elevated command prompt and change to the Windows Defender directory:

   ```PowerShell
   cd c:\program files\windows defender
   ```

1. Run this command to generate the diagnostic logs:

   ```PowerShell
   mpcmdrun -getfiles
   ```

1. By default, they are saved to C:\ProgramData\Microsoft\Windows Defender\Support\MpSupportFiles.cab. Attach the file to the submission form.

## Related topics

* [Network protection](network-protection.md)
* [Evaluate network protection](evaluate-network-protection.md)
* [Enable network protection](enable-network-protection.md)
