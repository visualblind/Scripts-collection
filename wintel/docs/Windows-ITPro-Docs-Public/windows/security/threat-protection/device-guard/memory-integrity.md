---
title: Memory integrity
keywords: mitigations, vulnerabilities, vulnerability, mitigation, exploit, exploits, emet
description: Memory integrity.
search.product: eADQiWindows 10XVcnh
ms.pagetype: security
ms.prod: w10
ms.mktglfcycl: manage
ms.sitesec: library
ms.pagetype: security
ms.localizationpriority: medium
author: levinec
ms.author: ellevin
ms.date: 08/09/2018
ms.reviewer: 
manager: dansimp
---

# Memory integrity

**Applies to:**

- [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

Memory integrity is a powerful system mitigation that leverages hardware virtualization and the Windows Hyper-V hypervisor to protect Windows kernel-mode processes against the injection and execution of malicious or unverified code. Code integrity validation is performed in a secure environment that is resistant to attack from malicious software, and page permissions for kernel mode are set and maintained by the Hyper-V hypervisor. Memory integrity helps block many types of malware from running on computers that run Windows 10 and Windows Server 2016.

> [!NOTE]
> For more information, see [Device protection in Windows Defender Security Center](https://support.microsoft.com/help/4096339/windows-10-device-protection-in-windows-defender-security-center).

