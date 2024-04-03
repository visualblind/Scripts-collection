---
title: Microsoft Application Virtualization Management System Release Notes
description: Microsoft Application Virtualization Management System Release Notes
author: dansimp
ms.assetid: e1a4d5ee-53c7-4b48-814c-a34ce0e698dc
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.pagetype: mdop, appcompat, virtualization
ms.mktglfcycl: deploy
ms.sitesec: library
ms.prod: w10
ms.date: 08/30/2016
---


# Microsoft Application Virtualization Management System Release Notes


To search these Release Notes, press CTRL+F.

**Important**  
Read these Release Notes thoroughly before you install the Application Virtualization Management System. These Release Notes contain information that you need to successfully install the Application Virtualization Management System. This document contains information that is not available in the product documentation. If there is a discrepancy between these Release Notes and other Application Virtualization Management System documentation, the latest change should be considered authoritative. These Release Notes supersede the content included with this product.

 

For updated information about known issues, please visit the Microsoft TechNet Library at <https://go.microsoft.com/fwlink/?LinkId=122918>.

## About Microsoft Application Virtualization 4.5 Cumulative Update 1


These Release Notes have been updated to reflect the changes introduced with Microsoft Application Virtualization 4.5 Cumulative Update 1 (App-V 4.5 CU1), which provides the latest updates to Application Virtualization (App-V) 4.5. This cumulative update contains the following changes:

-   Support for Windows 7 Beta and Windows Server 2008 R2 Beta: App-V 4.5 CU1 addresses compatibility issues with Windows 7 Beta and Windows Server 2008 R2 Beta. Support will be provided for blocking issues that prevent App-V 4.5 CU1 running in a test environment on pre-RTM versions of Windows 7. This will help ensure that your virtual applications can run successfully in a test environment where compatibility between App-V 4.5 Client and Windows 7 Beta is required.

    **Important**  
    Running App-V 4.5 CU1 on any version of Windows 7 or Windows Server 2008 R2 in a live operating environment is not supported.

     

-   Improved support for sequencing the .NET Framework: App-V 4.5 CU1 addresses previous issues with sequencing the .NET Framework 3.5 and earlier on Windows XP (SP2 or later). For more information about the new capabilities, see the TechNet article at <https://go.microsoft.com/fwlink/?LinkId=123412>.

-   Customer Feedback and Hotfix Rollup: App-V 4.5 CU1 also includes a rollup up of fixes to address issues found since the App-V 4.5 RTM release. This includes a combination of known issues and customer feedback from our internal teams, partners, and customers who are using App-V 4.5. For a full list of the included updates, see the KB article at <https://go.microsoft.com/fwlink/?LinkId=141258>.

## About the Product Documentation


Comprehensive documentation for Application Virtualization (App-V) is available on Microsoft TechNet in the Application Virtualization (App-V) TechCenter at <https://go.microsoft.com/fwlink/?LinkId=122939>. The TechNet documentation includes the online Help for the Application Virtualization Sequencer, the Application Virtualization Client, and the Application Virtualization Server. It also includes the Application Virtualization Planning and Deployment Guide and the Application Virtualization Operations Guide.

## Protect Against Security Vulnerabilities and Viruses


To help protect against security vulnerabilities and viruses, it is important to install the latest available security updates for any new software being installed. For more information, see the Microsoft Security Web site at <https://go.microsoft.com/fwlink/?LinkId=3482>.

## Providing Feedback


You can provide feedback, make a suggestion, or report an issue with the Microsoft Application Virtualization (App-V) Management System via a community forum on the Microsoft Application Virtualization TechCenter (<https://go.microsoft.com/fwlink/?LinkId=122917>).

You can also provide your feedback on the documentation directly to the App-V documentation team. Send your documentation feedback to appvdocs@microsoft.com.

## Known Issues with Application Virtualization 4.5 CU1


This section provides the most up-to-date information about issues with Microsoft Application Virtualization (App-V) 4.5 CU1. These issues do not appear in the product documentation and in some cases might contradict existing product documentation. Whenever possible, these issues will be addressed in later releases.

### Guidance for installing or upgrading clients to App-V 4.5 CU1 using setup.msi

When installing or upgrading your App-V clients to App-V 4.5 CU1 by using setup.msi, the prerequisites are not installed automatically.

WORKAROUND   You must manually install the prerequisites before installing or upgrading the App-V client to 4.5 CU1. For detailed procedures for installing the prerequisites and the App-V client, see <https://go.microsoft.com/fwlink/?LinkId=144106>.

When this has been completed, install the App-V 4.5 CU1 client by using setup.msi with elevated privileges. This file is available on the App-V 4.5 CU1 release media in the Installers\\Client folder.

When installing Microsoft Application Error Reporting, use the following command if you are installing or upgrading to the App-V 4.5 CU1 Desktop client:

    msiexec /i dw20shared.msi APPGUID={FE495DBC-6D42-4698-B61F-86E655E0796D}  allusers=1 reboot=suppress REINSTALL=all REINSTALLMODE=vomus

Alternatively, if you are installing or upgrading to the App-V 4.5 CU1 Terminal Services client, use the following command:

    msiexec /i dw20shared.msi APPGUID={8A97C241-D92A-47DC-B360-E716C1AAA929} allusers=1 reboot=suppress REINSTALL=all REINSTALLMODE=vomus

**Note**  
The APPGUID parameter references the product code of the App-V client that you install or upgrade to. The product code is unique for each setup.msi. You can use the Orca database editor or similar tool to examine Windows Installer files and determine the product code. This step is required for all installs or upgrades to App-V 4.5 CU1.

 

### <a href="" id="some-applications-might-fail-to-install-during-the-monitoring-phase-when-sequencing-on-windows-7-beta--"></a>Some applications might fail to install during the monitoring phase when sequencing on Windows 7 Beta

When sequencing on Windows 7 Beta or on a computer with Windows Installer 5.0, some applications might fail to install during the monitoring phase.

WORKAROUND   You must manually grant the Everyone group Full Control permissions to the following registry key:

    HKEY\_LOCAL\_MACHINE\\SOFTWARE\\Microsoft\\SoftGrid\\4.5\\SystemGuard

**Important**  
You must use the **Advanced** button to set the “Include inheritable permissions from this object’s parent” option.

 

### Unable to save packages when sequencing on Windows 7 Beta

When sequencing on Windows 7 Beta, you might be unable to save your sequenced package because of a sharing violation.

WORKAROUND   As specified in the best practices section of the Microsoft Application Virtualization 4.5 Sequencing Guide (see <https://go.microsoft.com/fwlink/?LinkId=144108>), you must shutdown and disable the following software programs before you begin sequencing:

-   Windows Defender

-   Antivirus software

-   Disk defragmentation software

-   Windows Search

-   Any open Windows Explorer session

In addition, if you have Microsoft Update running on the sequencing station to capture updates during the package update process, you will need to add “C:\\Windows\\SoftwareDistribution” as a VFS exclusion before you start sequencing.

### Improving performance when sequencing the .NET Framework

When sequencing the .NET Framework, you might experience reduced system performance because the Microsoft .NET Framework NGEN service attempts to precompile assemblies as a background task.

WORKAROUND   When sequencing the .NET Framework, disable the Microsoft .NET Framework NGEN service (mscorsvw.exe) after completing the monitoring phase. You must use the **Virtual Services** tab in the Sequencer and change the startup type to disabled.

### Interoperability issues with the Windows 7 Taskbar

When you run the Application Virtualization Client on Windows 7, the Windows 7 taskbar does not collapse multiple instances of a virtual application into a single taskbar button. In addition, jump Lists do not appear when you right-click a taskbar button of a virtual application, unless the application has been pinned to the Windows 7 taskbar.

### When you uninstall the Microsoft Application Virtualization Client, user settings associated with the user performing the uninstall will be deleted

When you uninstall the Microsoft Application Virtualization Client, the Windows Installer will remove Application Virtualization settings from the current user's profile. If your computer uses roaming profiles, do not use your personal network account to uninstall the client because it will remove settings for your virtual applications on all of your computers.

WORKAROUND   You should perform the App-V Client uninstall with an administrative account that is not used for running virtual applications.

### Edits made on the virtual file system and virtual registry tabs must be saved while running the Sequencing wizard

If you open a package to perform an upgrade or have already run the Sequencing wizard with a new package and you make changes to the package in the virtual file system or virtual registry tabs, those changes are not automatically saved.

WORKAROUND   Save the changes before re-running the wizard, to ensure that they are reflected inside the wizard’s virtual environment.

### Command-line Sequencer must be run from an elevated command prompt

When you use the command-line Sequencer, it does not prompt for elevation.

WORKAROUND   Run the command-line Sequencer using an elevated command prompt.

### Server Management Console configuration in distributed environments

If you need to install management components onto systems other than the primary Application Virtualization publishing and streaming server, the server install supports installing our management console and Web service on separate servers from the primary Application Virtualization Server when properly configured.

To distribute the management components across multiple servers, Kerberos delegation must be enabled on the server where the Web service is installed.

### Short path variable names in OSD files can cause errors

If you receive error 450478-1F702339-0000010B “The directory name is invalid” when starting a virtual application on the client, it is possible that the variable in the OSD is set incorrectly. This can happen if the application’s installer sets a short path name during sequencing.

WORKAROUND   Remove the trailing tilde from any CSIDL variable that exists in the OSD file.

### <a href="" id="correct-syntax-for-decodepath-parameter-for-command-line-sequencer-"></a>Correct syntax for DECODEPATH parameter for command-line Sequencer

In the command-line Sequencer, when opening a package for upgrade and decoding it to the root of the Q drive, the syntax for the *DECODEPATH* parameter should not include a trailing slash.

WORKAROUND   You can use **Q:** rather than **Q:\\** (omitting the trailing “\\” character).

### <a href="" id="when-upgrading-4-2-packages--you-encounter-problems-caused-by-windows-installer-files-in-the-virtual-file-system-"></a>When upgrading 4.2 packages, you encounter problems caused by Windows Installer files in the Virtual File System

When upgrading a package from 4.2, you might experience issues relating to a mismatch of Windows Installer system files that were included by default in 4.2 and the Windows Installer libraries locally installed on your Sequencing workstation. The following files are located in CSIDL\_SYSTEM\\:

cabinet.dll

msi.dll

msiexec.exe

msihnd.dll

msimsg.dlll

WORKAROUND   Delete all of the preceding files from the package. Delete the mappings on the **VFS** tab as well as the actual files in the CSIDL\_SYSTEM folder in your decode path.

### <a href="" id="on-windows-xp--client-install-logging-is-not-enabled-by-default-"></a>On Windows XP, client install logging is not enabled by default

When installing the client, to ensure that any install errors are captured for troubleshooting purposes, you should enable logging by using the command line.

WORKAROUND   Add the parameter */l\*vx! log.txt* to the command line, as shown in the following example:

setup.exe /s /v”/qn /l\*vx! log.txt”

msiexec.exe /i setup.msi /qn /l\*vx! log.txt

Alternatively, you can set the registry key to the following value:

\[HKEY\_LOCAL\_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Installer\] "Logging"="voicewarmupx!"

### For Kerberos authentication to work, Service Principal Names (SPNs) must be registered for IIS

When using IIS 6.0 or 7.0 for icon or OSD file retrieval and streaming of packages, for Kerberos authentication to be enabled, the SPNs must be registered as follows:

-   On the IIS server, run the following commands by using the SETSPN.EXE Resource Kit tool. The server fully qualified domain name (FQDN) must be used.

    Setspn -r SOFTGRID/&lt;Server FQDN&gt;

    Setspn -r HTTP/&lt;Server FQDN&gt;

For more information, see <https://go.microsoft.com/fwlink/?LinkId=131407>.

### On upgrade from RC, the default permissions on client logs do not allow for non-admin users to access the logs for troubleshooting and support

The default permissions on client logs for the Application Virtualization RC client did not allow for non-admin access to log files, and manual changes to these log permissions were reverted when clients were restarted. This has been corrected in the RTM release for new client installs, but on upgrade from RC, the custom permissions on existing log files are not reset. However, when any new logs are created or after a log reset, the files will have the new default permissions.

WORKAROUND   After the upgrade, reset existing client logs or manually change their permissions.

### .NET compatibility changes

Microsoft Application Virtualization Cumulative Update 1 supports sequencing the .NET Framework on Windows XP (SP2 or later). Sequencing routines for .NET applications that were written for SoftGrid 4.2 might need to be updated when used with the App-V 4.5 Sequencer. For details and workarounds, please refer to the Knowledge Base article at <https://go.microsoft.com/fwlink/?LinkId=123412>.

### <a href="" id="after-client-upgrade-from-app-v-4-2--some-applications-are-not-shown-"></a>After client upgrade from App-V 4.2, some applications are not shown

Check for the following error in the log: ”The Application Virtualization Client could not parse the OSD file”. The Microsoft Application Virtualization 4.5 client filters out applications that have an OSD file containing an empty OS tag (&lt;OS&gt;&lt;/OS&gt;).

WORKAROUND   Delete the empty OS tag from the OSD file.

### The App-V server requires exemptions in its firewall for certain processes

For the server to stream applications correctly, the server's core processes, including the dispatcher, need access through the firewall.

WORKAROUND   Set exemptions in the server's firewall for the following processes: sghwsvr.exe and sghwdsptr.exe. This applies to the App-V Management Server and App-V Streaming Server.

### Sequencing packages that require new Visual Basic runtimes might fail

If you sequence a package that uses a newer version of a Visual Basic (VB) runtime on a system where an older version of the VB runtime is installed, you might see a crash or other unexpected behavior when you try to use your package. For example, if you try to sequence Microsoft Money 2007, which uses version 6.00.9782 of the VB runtime, on a Windows XP system with version 6.00.9690 of the VB runtime, you might see a crash in the Invoice Designer when you try to run it on another Windows XP system with that older VB runtime.

WORKAROUND   After installing the application on the sequencing computer, while still monitoring, copy the correct (newer) VB runtime to the directory in the package from where the executable is started. This allows the sequenced application to find the expected version of the VB runtime when it is started.

**Important**  
This issue has been fixed in Microsoft Application Virtualization 4.5 Cumulative Update 1.

 

### When the server installer is run in silent mode, it does not correctly check for MSXML6

The App-V Management Server depends on MSXML6. However, if you run the installer in silent mode—for example, by using the command “msiexec -i setup.msi /qn” on a system where MSXML6 is not already installed—the installer does not notice the missing dependency and installs anyway. The most common result is that when clients attempt to refresh publishing information from the App-V Management Server, they will see failures.

WORKAROUND   Verify that MSXML6 is installed on the system before attempting a silent install of the App-V Management Server.

### Error code 000C800 when attempting to connect to the Application Virtualization Management Console

An Application Virtualization administrator who is not a local admin on the Application Virtualization Management Service server will receive an error (Error code: 000C800) when attempting to connect to the Application Virtualization Management Console, and the sftmmc.log entry will indicate that access to SftMgmt.udl is denied. To successfully connect to the Application Virtualization Management Console, an Application Virtualization administrator who is not a local admin on the Application Virtualization Management Service server must have at least read and execute access to the SftMgmt.udl file.

The Application Virtualization administrators must be given read and execute permissions to the SftMgmt.UDL file under %systemdrive%\\Program Files\\Microsoft System Center App Virt Management Server\\App Virt Management Service.

### Client installer command-line parameters are ignored when used in conjunction with KEEPCURRENTSETTINGS=1

When used in conjunction with KEEPCURRENTSETTINGS=1, the following client installer command-line parameters are ignored: SWICACHESIZE, MINFREESPACEMB, ALLOWINDEPENDENTFILESTREAMING, APPLICATIONSOURCEROOT, ICONSOURCEROOT, OSDSOURCEROOT, SYSTEMEVENTLOGLEVEL, SWIGLOBALDATA, DOTIMEOUTMINUTES, SWIFSDRIVE, AUTOLOADTARGET, AUTOLOADTRIGGERS, SWIUSERDATA, and REQUIRESECURECONNECTION.

WORKAROUND   If you have settings you want to retain, use KEEPCURRENTSETTINGS=1 and then set the other parameters after deployment. The App-V ADM Template can be used to set the following client settings: APPLICATIONSOURCEROOT, ICONSOURCEROOT, OSDSOURCEROOT, AUTOLOADTARGET, AUTOLOADTRIGGERS, DOTIMEOUTMINUTES, and ALLOWINDEPENDENTFILESTREAMING. The ADM Template can be found at <https://go.microsoft.com/fwlink/?LinkId=121835>.

### Error initializing virtual applications with Symantec Endpoint Protection

When using Symantec Endpoint Protection with the Application and Device Control feature enabled, virtual applications might fail to start, with the error “The application failed to initialize properly (0xc000007b)”. For details and workarounds, please refer to the Knowledge Base article at <https://go.microsoft.com/fwlink/?LinkId=125851>.

**Important**  
This issue has been fixed in Microsoft Application Virtualization 4.5 Cumulative Update 1.

 

## Release Notes Copyright Information


Information in this document, including URL and other Internet Web site references, is subject to change without notice, and is provided for informational purposes only. The entire risk of the use or results of the use of this document remains with the user, and Microsoft Corporation makes no warranties, either express or implied. The example companies, organizations, products, people and events depicted herein are fictitious. No association with any real company, organization, product, person or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.



Microsoft, MS-DOS, Windows, Windows Server, Windows Vista, Active Directory, and ActiveSync are either registered trademarks or trademarks of Microsoft Corporation in the U.S.A. and/or other countries.

The names of actual companies and products mentioned herein may be the trademarks of their respective owners.

 

 





