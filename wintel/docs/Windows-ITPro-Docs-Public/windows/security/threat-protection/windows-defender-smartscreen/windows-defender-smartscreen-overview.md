---
title: Windows Defender SmartScreen overview (Windows 10)
description: Conceptual info about Windows Defender SmartScreen.
keywords: SmartScreen Filter, Windows SmartScreen
ms.prod: w10
ms.mktglfcycl: explore
ms.sitesec: library
ms.pagetype: security
author: mjcaparas
ms.localizationpriority: medium
ms.date: 07/27/2017
ms.reviewer: 
manager: dansimp
ms.author: macapara
---

# Windows Defender SmartScreen
**Applies to:**

- Windows 10
- Windows 10 Mobile

Windows Defender SmartScreen helps to protect your employees if they try to visit sites previously reported as phishing or malware websites, or if an employee tries to download potentially malicious files.

**SmartScreen determines whether a site is potentially malicious by:**

- Analyzing visited webpages looking for indications of suspicious behavior. If it finds suspicious pages, SmartScreen shows a warning page, advising caution.

- Checking the visited sites against a dynamic list of reported phishing sites and malicious software sites. If it finds a match, SmartScreen shows a warning to let the user know that the site might be malicious.

**SmartScreen determines whether a downloaded app or app installer is potentially malicious by:**

- Checking downloaded files against a list of reported malicious software sites and programs known to be unsafe. If it finds a match, SmartScreen shows a warning to let the user know that the site might be malicious. 

- Checking downloaded files against a list of files that are well known and downloaded by many Windows users. If the file isn't on that list, SmartScreen shows a warning, advising caution.

    >[!NOTE]
    >Before Windows 10, version 1703 this feature was called the SmartScreen Filter when used within the browser and Windows SmartScreen when used outside of the browser.

## Benefits of Windows Defender SmartScreen
Windows Defender SmartScreen helps to provide an early warning system against websites that might engage in phishing attacks or attempt to distribute malware through a socially-engineered attack. The primary benefits are:

- **Anti-phishing and anti-malware support.** SmartScreen helps to protect your employees from sites that are reported to host phishing attacks or attempt to distribute malicious software. It can also help protect against deceptive advertisements, scam sites, and drive-by attacks. Drive-by attacks are web-based attacks that tend to start on a trusted site, targeting security vulnerabilities in commonly-used software. Because drive-by attacks can happen even if the user does not click or download anything on the page, the danger often goes unnoticed. For more info about drive-by attacks, see [Evolving Microsoft SmartScreen to protect you from drive-by attacks](https://blogs.windows.com/msedgedev/2015/12/16/SmartScreen-drive-by-improvements/#3B7Bb8bzeAPq8hXE.97)

- **Reputation-based URL and app protection.** SmartScreen evaluates a website's URLs to determine if they're known to distribute or host unsafe content. It also provides reputation checks for apps, checking downloaded programs and the digital signature used to sign a file. If a URL, a file, an app, or a certificate has an established reputation, your employees won't see any warnings. If however there's no reputation, the item is marked as a higher risk and presents a warning to the employee.

- **Operating system integration.** SmartScreen is integrated into the Windows 10 operating system, meaning that it checks any files an app (including 3rd-party browsers and email clients) attempts to download and run.

- **Improved heuristics and diagnostic data.** SmartScreen is constantly learning and endeavoring to stay up-to-date, so it can help to protect you against potentially malicious sites and files.

- **Management through Group Policy and Microsoft Intune.** SmartScreen supports using both Group Policy and Microsoft Intune settings. For more info about all available settings, see [Available Windows Defender SmartScreen Group Policy and mobile device management (MDM) settings](windows-defender-smartscreen-available-settings.md).

## Viewing Windows Defender SmartScreen anti-phishing events
When Windows Defender SmartScreen warns or blocks an employee from a website, it's logged as [Event 1035 - Anti-Phishing](https://technet.microsoft.com/scriptcenter/dd565657(v=msdn.10).aspx).


## Viewing Windows event logs for SmartScreen
SmartScreen events appear in the Microsoft-Windows-SmartScreen/Debug log in Event Viewer.

> [!NOTE]
> For information on how to use the Event Viewer, see [Windows Event Viewer](https://docs.microsoft.com/host-integration-server/core/windows-event-viewer1).

|EventID | Description |
| :---:         |     :---:      |
|1000 | Application SmartScreen Event|
|1001 | Uri SmartScreen Event|
|1002 | User Decision SmartScreen Event|

## Related topics
- [SmartScreen Frequently Asked Questions (FAQ)](https://feedback.smartscreen.microsoft.com/smartscreenfaq.aspx)

- [Threat protection](../index.md)

- [Available Windows Defender SmartScreen Group Policy and mobile device management (MDM) settings](https://docs.microsoft.com/windows/security/threat-protection/windows-defender-smartscreen/windows-defender-smartscreen-available-settings)

>[!NOTE]
>Help to make this topic better by providing us with edits, additions, and feedback. For info about how to contribute to this topic, see [Contributing to TechNet content](https://github.com/Microsoft/windows-itpro-docs/blob/master/CONTRIBUTING.md).
