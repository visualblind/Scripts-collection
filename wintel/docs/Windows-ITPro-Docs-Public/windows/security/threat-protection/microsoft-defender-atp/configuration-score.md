---
title: Overview of Configuration score in Microsoft Defender Security Center
description: Expand your visibility into the overall security configuration posture of your organization
keywords: configuration score, mdatp configuration score, secure score, security controls, improvement opportunities, security configuration score over time, security posture, baseline
search.product: eADQiWindows 10XVcnh
search.appverid: met150
ms.prod: w10
ms.mktglfcycl: deploy
ms.sitesec: library
ms.pagetype: security
ms.author: dolmont
author: DulceMontemayor
ms.localizationpriority: medium
manager: dansimp
audience: ITPro
ms.collection: M365-security-compliance 
ms.topic: conceptual
ms.date: 04/11/2019
---
# Configuration score
**Applies to:**
- [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

>[!NOTE]
>  Secure score is now part of Threat & Vulnerability Management as Configuration score. The secure score page will be available for a few weeks. 

The Microsoft Defender Advanced Threat Protection Configuration score gives you visibility and control over the security posture of your organization based on security best practices. High configuration score means your endpoints are more resilient from cybersecurity threat attacks.

Your configuration score widget shows the collective security configuration state of your machines across the following categories:
- Application
- Operating system
- Network
- Accounts
- Security controls

## How it works
>[!NOTE]
>  Configuration score currently supports configurations set via Group Policy. Due to the current partial Intune support, configurations which might have been set through Intune might show up as misconfigured. Contact your IT Administrator to verify the actual configuration status in case your organization is using Intune for secure configuration management.

The data in the configuration score widget is the product of meticulous and ongoing vulnerability discovery process aggregated with configuration discovery assessments that continuously:
- Compare collected configurations to the collected benchmarks to discover misconfigured assets
- Map configurations to vulnerabilities that can be remediated or partially remediated (risk reduction) by remediating the misconfiguration
- Collect and maintain best practice configuration benchmarks (vendors, security feeds, internal research teams)
- Collect and monitor changes of security control configuration state from all assets

From the widget, you'd be able to see which security aspect requires attention. You can click the configuration score categories and it will take you to the **Security recommendations** page to see more details and understand the context of the issue. From there, you can act on them based on security benchmarks. 

## Improve your configuration score
The goal is to remediate the issues in the security recommendations list to improve your configuration score. You can filter the view based on:
- **Related component** — **Accounts**, **Application**, **Network**, **OS**, or **Security controls** 
- **Remediation type** — **Configuration change** or **Software update**

See how you can [improve your security configuration](https://docs.microsoft.com/windows/security/threat-protection/microsoft-defender-atp/threat-and-vuln-mgt-scenarios#improve-your-security-configuration), for details.

>[!IMPORTANT]
>To boost your vulnerability assessment detection rates, download the following mandatory security updates and deploy them in your network:
>- 19H1 customers | [KB 4512941](https://support.microsoft.com/help/4512941/windows-10-update-kb4512941)
>- RS5 customers | [KB 4516077](https://support.microsoft.com/help/4516077/windows-10-update-kb4516077)
>- RS4 customers | [KB 4516045](https://support.microsoft.com/help/4516045/windows-10-update-kb4516045)
>- RS3 customers | [KB 4516071](https://support.microsoft.com/help/4516071/windows-10-update-kb4516071)
>
>To download the security updates:
>1. Go to [Microsoft Update Catalog](http://www.catalog.update.microsoft.com/home.aspx).
>2. Key-in the security update KB number that you need to download, then click **Search**.  

## Related topics
- [Risk-based Threat & Vulnerability Management](next-gen-threat-and-vuln-mgt.md) 
- [Threat & Vulnerability Management dashboard overview](tvm-dashboard-insights.md)
- [Exposure score](tvm-exposure-score.md)
- [Security recommendations](tvm-security-recommendation.md)
- [Remediation](tvm-remediation.md)
- [Software inventory](tvm-software-inventory.md)
- [Weaknesses](tvm-weaknesses.md)
- [Scenarios](threat-and-vuln-mgt-scenarios.md)
