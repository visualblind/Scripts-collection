---
title: Detect and block potentially unwanted applications
ms.reviewer:
description: Describes how to detect and block Potentially Unwanted Applications (PUA) using Microsoft Defender ATP for Mac.
keywords: microsoft, defender, atp, mac, pua, pus
search.product: eADQiWindows 10XVcnh
search.appverid: met150
ms.prod: w10
ms.mktglfcycl: deploy
ms.sitesec: library
ms.pagetype: security
ms.author: dansimp
author: dansimp
ms.localizationpriority: medium
manager: dansimp
audience: ITPro
ms.collection: M365-security-compliance
ms.topic: conceptual
---

# Detect and block potentially unwanted applications

**Applies to:**

- [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP) for Mac](microsoft-defender-atp-mac.md)

The potentially unwanted application (PUA) protection feature in Microsoft Defender ATP for Mac can detect and block PUA files on endpoints in your network.

These applications are not considered viruses, malware, or other types of threats, but might perform actions on endpoints that adversely affect their performance or use. PUA can also refer to applications that are considered to have poor reputation.

These applications can increase the risk of your network being infected with malware, cause malware infections to be harder to identify, and can waste IT resources in cleaning up the applications.

## How it works

Microsoft Defender ATP for Mac can detect and report PUA files. When configured in blocking mode, PUA files are moved to the quarantine.

When a PUA is detected on an endpoint, Microsoft Defender ATP for Mac presents a notification to the user, unless notifications have been disabled. The threat name will contain the word "Application".

## Configure PUA protection

PUA protection in Microsoft Defender ATP for Mac can be configured in one of the following ways:

- **Off**: PUA protection is disabled.
- **Audit**: PUA files are reported in the product logs, but not in Microsoft Defender Security Center. No notification is presented to the user and no action is taken by the product.
- **Block**: PUA files are reported in the product logs and in Microsoft Defender Security Center. The user is presented with a notification and action is taken by the product.

>[!WARNING]
>By default, PUA protection is configured in **Audit** mode.

You can configure how PUA files are handled from the command line or from the management console.

### Use the command-line tool to configure PUA protection:

In Terminal, execute the following command to configure PUA protection:

```bash
$ mdatp --threat --type-handling potentially_unwanted_application [off|audit|block]
```

### Use the management console to configure PUA protection:

In your enterprise, you can configure PUA protection from a management console, such as JAMF or Intune, similarly to how other product settings are configured. For more information, see the [Threat type settings](microsoft-defender-atp-mac-preferences.md#threat-type-settings) section of the [Set preferences for Microsoft Defender ATP for Mac](microsoft-defender-atp-mac-preferences.md) topic.

## Related topics

- [Set preferences for Microsoft Defender ATP for Mac](microsoft-defender-atp-mac-preferences.md)