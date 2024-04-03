---
title: Deploying, managing, and servicing Surface Pro X
description: This article provides an overview of key considerations for deploying, managing, and servicing Surface Pro X.
ms.prod: w10
ms.mktglfcycl: manage
ms.localizationpriority: high
ms.sitesec: library
author: dansimp
ms.author: dansimp
ms.topic: article
ms.date: 10/03/2019
ms.reviewer: jessko
manager: dansimp
ms.audience: itpro
---
# Deploying, managing, and servicing Surface Pro X

## Introduction

Built to handle high performance commercial requirements, Surface Pro X breaks new ground by incorporating the most powerful processor ever released on an ARM device, the Microsoft SQ1 ARM chipset.

Powered by a 3GHz CPU and a 2.1 teraflop GPU, Surface Pro X provides a full Windows experience. Its 13-hour battery life and built-in 4G LTE make it ideally suited for mobile first-line workers and professionals across the financial, legal, and medical fields or any role demanding extended battery life and continuous connectivity capabilities.

Surface Pro X is designed almost exclusively for a modern, cloud-based environment centered around Microsoft 365, Intune and Windows Autopilot. This article highlights what that looks like and outlines key considerations for deploying, managing, and servicing Surface Pro X.

## Deploying Surface Pro X

For the best experience, deploy Surface Pro X using Windows Autopilot either with the assistance of a Microsoft Cloud Solution Provider or self-provisioned using Autopilot deployment profiles and related features. For more information, refer to:

- [Windows Autopilot and Surface devices](windows-autopilot-and-surface-devices.md)

Autopilot deployment has several advantages: It allows you to use the factory provisioned operating system, streamlined for zero-touch deployment, to include pre-installation of Office Pro Plus.

Organizations already using modern management, security, and productivity solutions are well positioned to take advantage of the unique performance features in Surface Pro X. Customers using modernized line of business apps, Microsoft store (UWP) apps, or remote desktop solutions also stand to benefit.

## Image-based deployment considerations

Surface Pro X will be released without a standard Windows .ISO deployment image, which means it’s not supported on the Microsoft Deployment Toolkit (MDT) or operating system deployment methods using System Center Configuration Manager (SCCM) aka ConfiMgr. Customers relying on image-based deployment should consider Surface Pro 7 while they continue to evaluate the right time to transition to the cloud.

## Managing Surface Pro X devices

### Intune

A component of Microsoft Enterprise Mobility + Security, Intune integrates with Azure Active Directory for identity and access control and provides granular management of enrolled Surface Pro X devices. Intune mobile device management (MDM) policies have a number of advantages over older on-premises tools such as Windows Group Policy. This includes faster device login times and a more streamlined catalog of policies enabling full device management from the cloud. For example, you can manage LTE using eSIM profiles to configure data plans and deploy activation codes to multiple devices.<br> 

For more information about setting up Intune, refer to the [Intune documentation](https://docs.microsoft.com/intune/).

### Co-management

Once deployed in Autopilot, you can join Surface Pro X devices to Azure AD or Active Directory (Hybrid Azure AD Join) where you will be able to manage the devices with Intune or co-manage them with SCCM, which will install the 32-bit x86 ConfigMgr client.

### Third party MDM solutions

You may be able to use third-party MDM tools to manage Surface Pro X devices. For details, contact your MDM provider.

### Antivirus software

Windows Defender will help protect Windows 10 on ARM-based PCs for the supported lifetime of the Windows 10 device. 

Some third-party antivirus software cannot be installed on a Windows 10 PC running on an ARM-based processor. Collaboration with third-party antivirus software providers is continuing for AV app readiness on ARM-based PCs. Contact your antivirus software provider to understand when their apps will be available.

## Servicing Surface Pro X

Outside of personal devices that rely on Windows Update, servicing devices in most corporate environments requires downloading and managing the deployment of .MSI files to update target devices. Refer to the following documentation, which will be updated later to include guidance for servicing Surface Pro X:

- [Deploy the latest firmware and drivers for Surface devices](deploy-the-latest-firmware-and-drivers-for-surface-devices.md).  

> [!NOTE]
> Surface Pro X supports Windows 10, version 1903 and later.

## Running apps on Surface Pro X

Most apps run on ARM-based Windows 10 PCs with limited exclusions.

### Supported apps

- Most x86 Win32 apps run on Surface Pro X.
- Native ARM64 and Microsoft Store UWP apps provide an excellent user experience utilizing the full native speed of the ARM-based processor while optimizing battery life.
- Apps that use drivers designed for a Windows 10 PC running on an ARM-based processor.

### Not supported

- x64 apps won't run on a Windows 10 PC on an ARM-based processor.

For more information about running apps on Surface Pro X, refer to:

- [Windows 10 ARM-based PCs Support FAQ](https://support.microsoft.com/help/4521606)
- [Windows 10 on ARM documentation](https://docs.microsoft.com/windows/arm)

## Virtual Desktops (VDI)

Windows Virtual Desktop enables access to Windows desktops,applications, and data on any computing device or platform, from any location. To learn more, refer to the [Windows Virtual Desktop site](https://aka.ms/wvd). 

## Browsing with Surface Pro X

Popular browsers run on Surface Pro X:

- In-box Edge, Firefox, Chrome, and Internet Explorer all run on Surface Pro X.
- In-box Edge and Firefox run natively and therefore have enhanced performance on a Windows 10 PC on an ARM-based processor.

## Installing and using Microsoft Office

- Use Office 365 for the best experience on a Windows 10 PC on an ARM-based processor.
- Office 365 “click-to-run” installs Outlook, Word, Excel, and PowerPoint, optimized to run on a Windows 10 PC on an ARM-based processor.
- Microsoft Teams runs great on Surface Pro X.
- For “perpetual versions” of Office such as Office 2019, install the 32-bit version.

## VPN

To confirm if a specific third-party VPN supports a Windows 10 PC on an ARM-based processor, contact the VPN provider.

## Comparing key features

The following tables show the availability of selected key features on Surface Pro X with Windows 10 on ARM compared to Intel-based Surface Pro 7.

| Deployment                              | Surface Pro 7 | Surface Pro X | Notes                                                                                                                           |
| --------------------------------------- | ------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| Windows Autopilot                       | Yes           | Yes           |                                                                                                                                 |
| Support for Network Boot (PXE)          | Yes           | Yes           |                                                                                                                                 |
| Windows Configuration Designer          | Yes           | No            | Not recommended for Surface Pro X.                                                                                              |
| WinPE                                   | Yes           | Yes           | Not recommended for Surface Pro X. Microsoft does not provide the necessary .ISO and drivers to support WinPE with Surface Pro X. |
| SCCM: Operating System Deployment (OSD) | Yes           | No            | Not supported on Surface Pro X.                                                                                              |
| MDT                                     | Yes           | No            | Not supported on Surface Pro X.                                                                                              |


| Management                                    | Surface Pro 7       | Surface Pro X | Notes                                                                                 |
| --------------------------------------------- | ------------------- | ------------- | ------------------------------------------------------------------------------------- |
| Intune                                        | Yes                 | Yes           | Manage LTE with eSIM profiles.                                                        |
| Windows Autopilot                             | Yes                 | Yes           |                                                                                       |
| Azure AD (co-management)                      | Yes                 | Yes           | Ability to join Surface Pro X to Azure AD or Active Directory (Hybrid Azure AD Join). |
| SCCM                                          | Yes               | Yes           |                                                                                       |
| Power on When AC Restore                      | Yes                 | Yes           |                                                                                   |
| Surface Diagnostic Toolkit (SDT) for Business | Yes                 | Yes           |                                                                                   |
| Surface Dock Firmware Update                  | Yes                 | Yes           |                                                                                   |
| Asset Tag Utility                             | Yes                 | Yes           |                                                                                   |
| Surface Enterprise management Mode (SEMM)     | Yes | Partial       | No option to disable hardware on Surface Pro X at the firmware level.                 |
| Surface UEFI Configurator                     | Yes |               | No option to disable hardware. on Surface Pro X at the firmware level.                |
| Surface UEFI Manager                          | Yes | Partial       | No option to disable hardware on Surface Pro X at the firmware level.                 |


| Security                          | Surface Pro 7 | Surface Pro X | Notes                                                                                                                                                                                                                                                                                                                                                |
| --------------------------------- | ------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BitLocker                         | Yes           | Yes           |                                                                                                                                                                                                                                                                                                                                                      |
| Windows Defender                  | Yes           | Yes           |                                                                                                                                                                                                                                                                                                                                                      |
| Support for third-party antivirus | Yes           | See note      |Some third-party antivirus software cannot be installed on a Windows 10 PC running on an ARM-based processor. Collaboration with third-party antivirus software providers is continuing for AV app readiness on ARM-based PCs. Contact your antivirus software provider to understand when their apps will be available. |
| Conditional Access                | Yes           | Yes           |                                                                                                                                                                                                                                                                                                                                                      |
| Secure Boot                       | Yes           | Yes           |                                                                                                                                                                                                                                                                                                                                                      |
| Windows Information Protection    | Yes           | Yes           |                                                                                                                                                                                                                                                                                                                                                      |
| Surface Data Eraser (SDE)         | Yes           | Yes           |                                                                                                                                                                                                                                                                                                                                                      |

## FAQ

### Will an OS image be available at launch?

No. Surface Pro X will be released without a standard Windows .ISO deployment image, which means it’s not supported on the Microsoft Deployment Toolkit (MDT) or operating system deployment methods using System Center Configuration Manager (SCCM) aka ConfiMgr. Customers relying on image-based deployment should consider Surface Pro 7 while they continue to evaluate the right time to transition to the cloud.

### How can I deploy Surface Pro X?

Deploy Surface Pro X using Windows Autopilot.

### Will a BMR be available?

Yes.

### Is Intune required to manage Surface Pro X?

Intune is recommended but not required. Once deployed in Autopilot, you can join Surface Pro X devices to Azure AD or Active Directory (Hybrid Azure AD Join) where you will be able to manage the devices with Intune or co-manage them with SCCM, which will install the 32-bit x86 ConfigMgr client.
