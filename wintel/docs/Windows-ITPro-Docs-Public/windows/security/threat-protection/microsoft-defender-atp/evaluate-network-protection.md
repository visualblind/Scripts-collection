---
title: Conduct a demo to see how network protection works
description: Quickly see how Network protection works by performing common scenarios that it protects against
keywords: Network protection, exploits, malicious website, ip, domain, domains, evaluate, test, demo
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
ms.date: 05/10/2019
ms.reviewer: 
manager: dansimp
---

# Evaluate network protection

**Applies to:**

* [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

[Network protection](network-protection.md) helps prevent employees from using any application to access dangerous domains that may host phishing scams, exploits, and other malicious content on the Internet.

This topic helps you evaluate Network protection by enabling the feature and guiding you to a testing site. The site in this evaluation topic are not malicious, they are specially created websites that pretend to be malicious. The site will replicate the behavior that would happen if a user visited a malicious site or domain.

> [!TIP]
> You can also visit the Windows Defender Testground website at [demo.wd.microsoft.com](https://demo.wd.microsoft.com?ocid=cx-wddocs-testground) to see how other protection features work.

## Enable network protection in audit mode

You can enable network protection in audit mode to see which IP addresses and domains would have been blocked if it was enabled.

You might want to do this to make sure it doesn't affect line-of-business apps or to get an idea of how often blocks occur.

1. Type **powershell** in the Start menu, right-click **Windows PowerShell** and click **Run as administrator**
2. Enter the following cmdlet:

    ```PowerShell
    Set-MpPreference -EnableNetworkProtection AuditMode
    ```

### Visit a (fake) malicious domain

1. Open Internet Explorer, Google Chrome, or any other browser of your choice.

1. Go to [https://smartscreentestratings2.net](https://smartscreentestratings2.net).

The network connection will be allowed and a test message will be displayed.

![Example notification that says Connection blocked: Your IT administrator caused Windows Security to block this network connection. Contact your IT help desk.](../images/np-notif.png)

## Review network protection events in Windows Event Viewer

To review apps that would have been blocked, open Event Viewer and filter for Event ID 1125 in the Microsoft-Windows-Windows-Defender/Operational log. The following table lists all network protection events.

| Event ID | Provide/Source | Description |
|-|-|-|
|5007 | Windows Defender (Operational) | Event when settings are changed |
|1125 | Windows Defender (Operational) | Event when a network connection is audited |
|1126 | Windows Defender (Operational) | Event when a network connection is blocked |

## Related topics

* [Network protection](network-protection.md)
* [Enable network protection](enable-network-protection.md)
* [Troubleshoot network protection](troubleshoot-np.md)
