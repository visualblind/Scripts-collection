---
title: Performance Guidance for Application Virtualization (Windows 10)
description: Performance Guidance for Application Virtualization
author: lomayor
ms.pagetype: mdop, appcompat, virtualization
ms.mktglfcycl: deploy
ms.sitesec: library
ms.prod: w10
ms.date: 04/19/2017
ms.reviewer: 
manager: dansimp
ms.author: dansimp
---


# Performance Guidance for Application Virtualization

**Applies to**
-   Windows 7 SP1
-   Windows 10 
-   Server 2012 R2
-   Server 2016

Learn how to configure App-V for optimal performance, optimize virtual app packages, and provide a better user experience with RDS and VDI.

Implementing multiple methods can help you improve the end-user experience. However, your environment may not support all methods.

You should read and understand the following information before reading this document.

-   [Application Virtualization (App-V) overview](appv-for-windows.md)

-   [Application Publishing and Client Interaction](appv-application-publishing-and-client-interaction.md)

-   [App-V Sequencing Guide](https://www.microsoft.com/download/details.aspx?id=27760)

**Note**  
Some terms used in this document may have different meanings depending on external source and context. For more information about terms used in this document followed by an asterisk <strong>*</strong> review the [Application Virtualization Performance Guidance Terminology](#bkmk-terms1) section of this document.

Finally, this document will provide you with the information to configure the computer running App-V client and the environment for optimal performance. Optimize your virtual application packages for performance using the sequencer, and to understand how to use User Experience Virtualization (UE-V) or other user environment management technologies to provide the optimal user experience with App-V in both Remote Desktop Services (RDS) and non-persistent virtual desktop infrastructure (VDI).

To help determine what information is relevant to your environment you should review each section’s brief overview and applicability checklist.

## <a href="" id="---------app-v-5-1-in-stateful--non-persistent-deployments"></a> App-V in stateful\* non-persistent deployments

This section provides information about an approach that helps ensure a user will have access to all virtual applications within seconds after logging in. This is achieved by uniquely addressing the often long-running App-V publishing refresh. As you will discover the basis of the approach, the fastest publishing refresh, is one that doesn’t have to actually do anything. A number of conditions must be met and steps followed to provide the optimal user experience.

Use the information in the following section for more information:

[Usage Scenarios](#bkmk-us) - As you review the two scenarios, keep in mind that these are the approach extremes. Based on your usage requirements, you may choose to apply these steps to a subset of users and/or virtual applications packages.

-   Optimized for Performance – To provide the optimal experience, you can expect the base image to include some of the App-V virtual application package. This and other requirements are discussed.

-   Optimized for Storage – If you are concerned with the storage impact, following this scenario will help address those concerns.

[Preparing your Environment](#bkmk-pe)

-   Steps to Prepare the Base Image – Whether in a non-persistent VDI or RDSH environment, only a few steps must be completed in the base image to enable this approach.

-   Use UE-V as the User Profile Management (UPM) solution for the App-V approach – the cornerstone of this approach is the ability of a UEM solution to persist the contents of just a few registry and file locations. These locations constitute the user integrations\*. Be sure to review the specific requirements for the UPM solution.

[User Experience Walk-through](#bkmk-uewt)

-   Walk-through – This is a step-by-step walk-through of the App-V and UE-V operations and the expectations users should have.

-   Outcome – This describes the expected results.

[Impact to Package Lifecycle](#bkmk-plc)

[Enhancing the VDI Experience through Performance Optimization/Tuning](#bkmk-evdi)

### <a href="" id="applicability-checklist-"></a>Applicability Checklist

Deployment Environment

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><img src="images/checklistbox.gif" alt="Checklist box" /></td>
<td align="left"><p>Non-Persistent VDI or RDSH.</p></td>
</tr>
<tr class="even">
<td align="left"><img src="images/checklistbox.gif" alt="Checklist box" /></td>
<td align="left"><p>User Experience Virtualization (UE-V), other UPM solutions or User Profile Disks (UPD).</p></td>
</tr>
</tbody>
</table>

 

Expected Configuration

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><img src="images/checklistbox.gif" alt="Checklist box" /></td>
<td align="left"><p>User Experience Virtualization (UE-V) with the App-V user state template enabled or User Profile Management (UPM) software. Non-UE-V UPM software must be capable of triggering on Login or Process/Application Start and Logoff.</p></td>
</tr>
<tr class="even">
<td align="left"><img src="images/checklistbox.gif" alt="Checklist box" /></td>
<td align="left"><p>App-V Shared Content Store (SCS) is configured or can be configured.</p></td>
</tr>
</tbody>
</table>

 

IT Administration

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><img src="images/checklistbox.gif" alt="Checklist box" /></td>
<td align="left"><p>Admin may need to update the VM base image regularly to ensure optimal performance or Admin may need to manage multiple images for different user groups.</p></td>
</tr>
</tbody>
</table>

 

### <a href="" id="bkmk-us"></a>Usage Scenarios

As you review the two scenarios, keep in mind that these approach the extremes. Based on your usage requirements, you may choose to apply these steps to a subset of users, virtual application packages, or both.

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Optimized for Performance</th>
<th align="left">Optimized for Storage</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>To provide the most optimal user experience, this approach leverages the capabilities of a UPM solution and requires additional image preparation and can incur some additional image management overhead.</p>
<p>The following describes many performance improvements in stateful non-persistent deployments. For more information, see <a href="#sequencing-steps-to-optimize-packages-for-publishing-performance" data-raw-source="[Sequencing Steps to Optimize Packages for Publishing Performance](#sequencing-steps-to-optimize-packages-for-publishing-performance)">Sequencing Steps to Optimize Packages for Publishing Performance</a> later in this topic.</p></td>
<td align="left"><p>The general expectations of the previous scenario still apply here. However, keep in mind that VM images are typically stored in very costly arrays; a slight alteration has been made to the approach. Do not pre-configure user-targeted virtual application packages in the base image.</p>
<p>The impact of this alteration is detailed in the <a href="#bkmk-uewt" data-raw-source="[User Experience Walk-through](#bkmk-uewt)">User Experience Walk-through</a> section of this document.</p></td>
</tr>
</tbody>
</table>

 

### <a href="" id="bkmk-pe"></a>Preparing your Environment

The following table displays the required steps to prepare the base image and the UE-V or another UPM solution for the approach.

**Prepare the Base Image**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Optimized for Performance</th>
<th align="left">Optimized for Storage</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p></p>
<ul>
<li><p>Enable the App-V client as described in <a href="appv-enable-the-app-v-desktop-client.md" data-raw-source="[Enable the App-V in-box client](appv-enable-the-app-v-desktop-client.md)">Enable the App-V in-box client</a>.</p></li>
<li><p>Enable UE-V and download the App-V Settings Template from the UE-V template Gallery, see the following steps.</p></li>
<li><p>Configure for Shared Content Store (SCS) mode. For more information see <a href="appv-deploying-the-appv-sequencer-and-client.md" data-raw-source="[Deploying the App-V Sequencer and Configuring the Client](appv-deploying-the-appv-sequencer-and-client.md)">Deploying the App-V Sequencer and Configuring the Client</a>.</p></li>
<li><p>Configure Preserve User Integrations on Login Registry DWORD.</p></li>
<li><p>Pre-configure all user- and global-targeted packages for example, <strong>Add-AppvClientPackage</strong>.</p></li>
<li><p>Pre-configure all user- and global-targeted connection groups for example, <strong>Add-AppvClientConnectionGroup</strong>.</p></li>
<li><p>Pre-publish all global-targeted packages.</p>
<p></p>
<p>Alternatively,</p>
<ul>
<li><p>Perform a global publishing/refresh.</p></li>
<li><p>Perform a user publishing/refresh.</p></li>
<li><p>Un-publish all user-targeted packages.</p></li>
<li><p>Delete the following user-Virtual File System (VFS) entries.</p></li>
</ul>
<p><code>AppData\Local\Microsoft\AppV\Client\VFS</code></p>
<p><code>AppData\Roaming\Microsoft\AppV\Client\VFS</code></p></li>
</ul></td>
<td align="left"><p></p>
<ul>
<li><p>Enable the App-V client as described in <a href="appv-enable-the-app-v-desktop-client.md" data-raw-source="[Enable the App-V in-box client](appv-enable-the-app-v-desktop-client.md)">Enable the App-V in-box client</a>.</p></li>
<li><p>Enable UE-V and download the App-V Settings Template from the UE-V template Gallery, see the following steps.</p></li>
<li><p>Configure for Shared Content Store (SCS) mode. For more information see <a href="appv-deploying-the-appv-sequencer-and-client.md" data-raw-source="[Deploying the App-V Sequencer and Configuring the Client](appv-deploying-the-appv-sequencer-and-client.md)">Deploying the App-V Sequencer and Configuring the Client</a>.</p></li>
<li><p>Configure Preserve User Integrations on Login Registry DWORD.</p></li>
<li><p>Pre-configure all global-targeted packages for example, <strong>Add-AppvClientPackage</strong>.</p></li>
<li><p>Pre-configure all global-targeted connection groups for example, <strong>Add-AppvClientConnectionGroup</strong>.</p></li>
<li><p>Pre-publish all global-targeted packages.</p>
<p></p></li>
</ul></td>
</tr>
</tbody>
</table>

 

**Configurations** - For critical App-V Client configurations and for a little more context and how-to, review the following information:

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Configuration Setting</th>
<th align="left">What does this do?</th>
<th align="left">How should I use it?</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>Shared Content Store (SCS) Mode</p>
<ul>
<li><p>Configurable in Windows PowerShell with <code>Set-AppvClientConfiguration -SharedContentStoreMode 1</code><br>or configurable with Group Policy, as described in <a href="appv-deploying-the-appv-sequencer-and-client.md" data-raw-source="[Deploying the App-V Sequencer and Configuring the Client](appv-deploying-the-appv-sequencer-and-client.md)">Deploying the App-V Sequencer and Configuring the Client</a>.</p></li>
</ul></td>
<td align="left"><p>When running the shared content store only publishing data is maintained on hard disk; other virtual application assets are maintained in memory (RAM).</p>
<p>This helps to conserve local storage and minimize disk I/O per second (IOPS).</p></td>
<td align="left"><p>This is recommended when low-latency connections are available between the App-V Client endpoint and the SCS content server, SAN.</p></td>
</tr>
<tr class="even">
<td align="left"><p>PreserveUserIntegrationsOnLogin</p>
<ul>
<li><p>Configure in the Registry under <strong>HKEY_LOCAL_MACHINE</strong> \ <strong>Software</strong> \ <strong>Microsoft</strong> \ <strong>AppV</strong> \ <strong>Client</strong> \ <strong>Integration</strong>.</p></li>
<li><p>Create the DWORD value <strong>PreserveUserIntegrationsOnLogin</strong> with a value of <strong>1</strong>.</p></li>
<li><p>Restart the App-V client service or restart the computer running the App-V Client.</p></li>
</ul></td>
<td align="left"><p>If you have not pre-configured (<strong>Add-AppvClientPackage</strong>) a specific package and this setting is not configured, the App-V Client will de-integrate* the persisted user integrations, then re-integrate*.</p>
<p>For every package that meets the above conditions, effectively twice the work will be done during publishing/refresh.</p></td>
<td align="left"><p>If you don’t plan to pre-configure every available user package in the base image, use this setting.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxConcurrentPublishingRefresh</p>
<ul>
<li><p>Configure in the Registry under <strong>HKEY_LOCAL_MACHINE</strong> \ <strong>Software</strong> \ <strong>Microsoft</strong> \ <strong>AppV</strong> \ <strong>Client</strong> \ <strong>Publishing</strong>.</p></li>
<li><p>Create the DWORD value <strong>MaxConcurrentPublishingrefresh</strong> with the desired maximum number of concurrent publishing refreshes.</p></li>
<li><p>The App-V client service and computer do not need to be restarted.</p></li>
</ul></td>
<td align="left"><p>This setting determines the number of users that can perform a publishing refresh/sync at the same time. The default setting is no limit.</p></td>
<td align="left"><p>Limiting the number of concurrent publishing refreshes prevents excessive CPU usage that could impact computer performance. This limit is recommended in an RDS environment, where multiple users can log in to the same computer at the same time and perform a publishing refresh sync.</p>
<p>If the concurrent publishing refresh threshold is reached, the time required to publish new applications and make them available to end users after they log in could take an indeterminate amount of time.</p></td>
</tr>
</tbody>
</table>

 

### Configure UE-V solution for App-V Approach

We recommend using User Experience Virtualization (UE-V) to capture and centralize application settings and Windows operating system settings for a specific user. These settings are then applied to the different computers that are accessed by the user, including desktop computers, laptop computers, and virtual desktop infrastructure (VDI) sessions. UE-V is optimized for RDS and VDI scenarios.

For more information, see:

- [User Experience Virtualization (UE-V) for Windows 10 overview](/windows/configuration/ue-v/uev-for-windows)

- [Get Started with UE-V](/windows/configuration/ue-v/uev-getting-started)

In essence all that is required is to enable the UE-V service and download the following Microsoft authored App-V settings template from the [Microsoft User Experience Virtualization (UE-V) template gallery](https://gallery.technet.microsoft.com/Authored-UE-V-Settings-bb442a33). Register the template. For more information about UE-V templates, see [User Experience Virtualization (UE-V) for Windows 10 overview](/windows/configuration/ue-v/uev-for-windows).

**Note**  
Without performing an additional configuration step, User Environment Virtualization (UE-V) will not be able to synchronize the Start menu shortcuts (.lnk files) on the target computer. The .lnk file type is excluded by default.

UE-V will only support removing the .lnk file type from the exclusion list in the RDS and VDI scenarios, where every user’s device will have the same set of applications installed to the same location and every .lnk file is valid for all the users’ devices. For example, UE-V would not currently support the following two scenarios, because the net result will be that the shortcut will be valid on one but not all devices.

-   If a user has an application installed on one device with .lnk files enabled and the same native application installed on another device to a different installation root with .lnk files enabled.

-   If a user has an application installed on one device but not another with .lnk files enabled.

**Important**  
This topic describes how to change the Windows registry by using Registry Editor. If you change the Windows registry incorrectly, you can cause serious problems that might require you to reinstall Windows. You should make a backup copy of the registry files (System.dat and User.dat) before you change the registry. Microsoft cannot guarantee that the problems that might occur when you change the registry can be resolved. Change the registry at your own risk.

 

Using the Microsoft Registry Editor (regedit.exe), navigate to **HKEY\_LOCAL\_MACHINE** \\ **Software** \\ **Microsoft** \\ **UEV** \\ **Agent** \\ **Configuration** \\ **ExcludedFileTypes** and remove **.lnk** from the excluded file types.

## Configure other User Profile Management (UPM) solutions for App-V Approach

The expectation in a stateful environment is that a UPM solution is implemented and can support persistence of user data across sessions and between logins.

The requirements for the UPM solution are as follows.

To enable an optimized login experience, for example the App-V approach for the user, the solution must be capable of:

-   Persisting the below user integrations as part of the user profile/persona.

-   Triggering a user profile sync on login (or application start), which can guarantee that all user integrations are applied before publishing/refresh begin, or,

-   Attaching and detaching a user profile disk (UPD) or similar technology that contains the user integrations.

    **Note**  
    App-V is supported when using UPD only when the entire profile is stored on the user profile disk.

    App-V packages are not supported when using UPD with selected folders stored in the user profile disk. The Copy on Write driver does not handle UPD selected folders.

     

-   Capturing changes to the locations, which constitute the user integrations, prior to session logoff.

With App-V when you add a publishing server (**Add-AppvPublishingServer**) you can configure synchronization, for example refresh during log on and/or after a specified refresh interval. In both cases a scheduled task is created.

In previous versions of App-V, both scheduled tasks were configured using a VBScript that would initiate the user and global refresh. Starting with Hotfix Package 4 for Application Virtualization 5.0 SP2 the user refresh on log on was initiated by **SyncAppvPublishingServer.exe**. This change was introduced to provide UPM solutions a trigger process. This process delays the publish /refresh to allow the UPM solution to apply the user integrations. It will exit once the publishing/refresh is complete.

### User Integrations

Registry – HKEY\_CURRENT\_USER

-   Path - Software\\Classes

    Exclude: Local Settings, ActivatableClasses, AppX\*

-   Path - Software\\Microsoft\\AppV

-   Path- Software\\Microsoft\\Windows\\CurrentVersion\\App Paths

### File Locations

-   Root – “Environment Variable” APPDATA

    Path – Microsoft\\AppV\\Client\\Catalog

-   Root – “Environment Variable” APPDATA

    Path – Microsoft\\AppV\\Client\\Integration

-   Root – “Environment Variable” APPDATA

    Path - Microsoft\\Windows\\Start Menu\\Programs

-   (To persist all desktop shortcuts, virtual and non-virtual)

    Root - “KnownFolder” {B4BFCC3A-DB2C-424C-B029-7FE99A87C641}FileMask - \*.lnk

### <a href="" id="bkmk-uewt"></a>User Experience Walk-through

This following is a step-by-step walk-through of the App-V and UPM operations and the expectations users should expect.

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Optimized for Performance</th>
<th align="left">Optimized for Storage</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>After implementing this approach in the VDI/RDSH environment, on first login,</p>
<ul>
<li><p>(Operation) A user-publishing/refresh is initiated. (Expectation) If this is the first time a user has published virtual applications (e.g. non-persistent), this will take the usual duration of a publishing/refresh.</p></li>
<li><p>(Operation) After the publishing/refresh, the UPM solution captures the user integrations. (Expectation) Depending on how the UPM solution is configured, this may occur as part of the logoff process. This will incur the same/similar overhead as persisting the user state.</p></li>
</ul>
<p>On subsequent logins:</p>
<ul>
<li><p>(Operation) UPM solution applies the user integrations to the system prior to publishing/refresh.</p>
<p>(Expectation) There will be shortcuts present on the desktop, or in the start menu, which work immediately. When the publishing/refresh completes (i.e., package entitlements change), some may go away.</p></li>
<li><p>(Operation) Publishing/refresh will process un-publish and publish operations for changes in user package entitlements. (Expectation) If there are no entitlement changes, publishing1 will complete in seconds. Otherwise, the publishing/refresh will increase relative to the number and complexity* of virtual applications</p></li>
<li><p>(Operation) UPM solution will capture user integrations again at logoff. (Expectation) Same as previous.</p></li>
</ul>
<p>¹ The publishing operation (<strong>Publish-AppVClientPackage</strong>) adds entries to the user catalog, maps entitlement to the user, identifies the local store, and finishes by completing any integration steps.</p></td>
<td align="left"><p>After implementing this approach in the VDI/RDSH environment, on first login,</p>
<ul>
<li><p>(Operation) A user-publishing/refresh is initiated. (Expectation)</p>
<ul>
<li><p>If this is the first time a user has published virtual applications (e.g., non-persistent), this will take the usual duration of a publishing/refresh.</p></li>
<li><p>First and subsequent logins will be impacted by pre-configuring of packages (add/refresh).</p>
<p></p></li>
</ul></li>
<li><p>(Operation) After the publishing/refresh, the UPM solution captures the user integrations. (Expectation) Depending on how the UPM solution is configured, this may occur as part of the logoff process. This will incur the same/similar overhead as persisting the user state</p></li>
</ul>
<p>On subsequent logins:</p>
<ul>
<li><p>(Operation) UPM solution applies the user integrations to the system prior to publishing/refresh.</p></li>
<li><p>(Operation) Add/refresh must pre-configure all user targeted applications. (Expectation)</p>
<ul>
<li><p>This may increase the time to application availability significantly (on the order of 10’s of seconds).</p></li>
<li><p>This will increase the publishing refresh time relative to the number and complexity* of virtual applications.</p>
<p></p></li>
</ul></li>
<li><p>(Operation) Publishing/refresh will process un-publish and publish operations for changes to user package entitlements.</p></li>
</ul></td>
</tr>
</tbody>
</table>

 

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Outcome</th>
<th align="left">Outcome</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p></p>
<ul>
<li><p>Because the user integrations are entirely preserved, there will be no work for example, integration for the publishing/refresh to complete. All virtual applications will be available within seconds of login.</p></li>
<li><p>The publishing/refresh will process changes to the users entitled virtual applications which impacts the experience.</p></li>
</ul></td>
<td align="left"><p>Because the add/refresh must re-configure all the virtual applications to the VM, the publishing refresh time on every login will be extended.</p></td>
</tr>
</tbody>
</table>

 

### <a href="" id="bkmk-plc"></a>Impact to Package Life Cycle

Upgrading a package is a crucial aspect of the package lifecycle. To help guarantee users have access to the appropriate upgraded (published) or downgraded (un-published) virtual application packages, it is recommended you update the base image to reflect these changes. To understand why review the following section:

App-V 5.0 SP2 introduced the concept of pending states. In the past,

-   If an administrator changed entitlements or created a new version of a package (upgraded) and during a publishing/refresh that package was in-use, the un-publish or publish operation, respectively, would fail.

-   Now, if a package is in-use the operation will be pended. The un-publish and publish-pend operations will be processed on service restart or if another publish or un-publish command is issued. In the latter case, if the virtual application is in-use otherwise, the virtual application will remain in a pending state. For globally published packages, a restart (or service restart) often needed.

In a non-persistent environment, it is unlikely these pended operations will be processed. The pended operations, for example tasks are captured under **HKEY\_CURRENT\_USER** \\ **Software** \\ **Microsoft** \\ **AppV** \\ **Client** \\ **PendingTasks**. Although this location is persisted by the UPM solution, if it is not applied to the environment prior to log on, it will not be processed.

### <a href="" id="bkmk-evdi"></a>Enhancing the VDI Experience through Performance Optimization Tuning

The following section contains lists with information about Microsoft documentation and downloads that may be useful when optimizing your environment for performance.

<!-- Following bold text used to say **.NET NGEN Blog and Script (Highly Recommended)**  but the script doesn't seem to exist any more. The link to the script was [Script](https://aka.ms/DrainNGenQueue)  -->

**.NET NGEN Blog (Highly Recommended)**

-   [How to speed up NGEN optimization](https://blogs.msdn.com/b/dotnet/archive/2013/08/06/wondering-why-mscorsvw-exe-has-high-cpu-usage-you-can-speed-it-up.aspx)

**Windows Server and Server Roles**

Server Performance Tuning Guidelines for

-   [Microsoft Windows Server 2012 R2](https://msdn.microsoft.com/library/windows/hardware/dn529133.aspx)

-   [Microsoft Windows Server 2012](https://download.microsoft.com/download/0/0/B/00BE76AF-D340-4759-8ECD-C80BC53B6231/performance-tuning-guidelines-windows-server-2012.docx)

-   [Microsoft Windows Server 2008 R2](https://download.microsoft.com/download/6/B/2/6B2EBD3A-302E-4553-AC00-9885BBF31E21/Perf-tun-srv-R2.docx)

**Server Roles**

-   [Remote Desktop Virtualization Host](https://msdn.microsoft.com/library/windows/hardware/dn567643.aspx)

-   [Remote Desktop Session Host](https://msdn.microsoft.com/library/windows/hardware/dn567648.aspx)

-   [IIS Relevance: App-V Management, Publishing, Reporting Web Services](https://msdn.microsoft.com/library/windows/hardware/dn567678.aspx)

-   [File Server (SMB) Relevance: If used for App-V Content Storage and Delivery in SCS Mode](https://technet.microsoft.com/library/jj134210.aspx)

**Windows Client (Guest OS) Performance Tuning Guidance**

-   [Microsoft Windows 7](https://download.microsoft.com/download/E/5/7/E5783D68-160B-4366-8387-114FC3E45EB4/Performance Tuning Guidelines for Windows 7 Desktop Virtualization v1.9.docx)

-   [Optimization Script: (Provided by Microsoft Support)](https://blogs.technet.com/b/jeff_stokes/archive/2012/10/15/the-microsoft-premier-field-engineer-pfe-view-on-virtual-desktop-vdi-density.aspx)

-   [Microsoft Windows 8](https://download.microsoft.com/download/6/0/1/601D7797-A063-4FA7-A2E5-74519B57C2B4/Windows_8_VDI_Image_Client_Tuning_Guide.pdf)

-   [Optimization Script: (Provided by Microsoft Support)](https://blogs.technet.com/b/jeff_stokes/archive/2013/04/09/hot-off-the-presses-get-it-now-the-windows-8-vdi-optimization-script-courtesy-of-pfe.aspx)

## Sequencing Steps to Optimize Packages for Publishing Performance

Several App-V features facilitate new scenarios or enable new customer deployment scenarios. These following features can impact the performance of the publishing and launch operations.

<table>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Step</th>
<th align="left">Consideration</th>
<th align="left">Benefits</th>
<th align="left">Tradeoffs</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>No Feature Block 1 (FB1, also known as Primary FB)</p></td>
<td align="left"><p>No FB1 means the application will launch immediately and stream fault (application requires file, DLL and must pull down over the network) during launch. If there are network limitations, FB1 will:</p>
<ul>
<li><p>Reduce the number of stream faults and network bandwidth used when you launch an application for the first time.</p></li>
<li><p>Delay launch until the entire FB1 has been streamed.</p></li>
</ul></td>
<td align="left"><p>Stream faulting decreases the launch time.</p></td>
<td align="left"><p>Virtual application packages with FB1 configured will need to be re-sequenced.</p></td>
</tr>
</tbody>
</table>

 

### Removing FB1

Removing FB1 does not require the original application installer. After completing the following steps, it is suggested that you revert the computer running the sequencer to a clean snapshot.

**Sequencer UI** - Create a New Virtual Application Package.

1.  Complete the sequencing steps up to Customize -&gt; Streaming.

2.  At the Streaming step, do not select **Optimize the package for deployment over slow or unreliable network**.

3.  If desired, move on to **Target OS**.

**Modify an Existing Virtual Application Package**

1.  Complete the sequencing steps up to Streaming.

2.  Do not select **Optimize the package for deployment over a slow or unreliable network**.

3.  Move to **Create Package**.

**Windows PowerShell** - Update an Existing Virtual Application Package.

1.  Open an elevated Windows PowerShell session.

2.  Import-module **appvsequencer**.

3.  **Update-AppvSequencerPackage** - **AppvPackageFilePath**

    "C:\\Packages\\MyPackage.appv" -Installer

    "C:\\PackageInstall\\PackageUpgrade.exe empty.exe" -OutputPath

    "C:\\UpgradedPackages"

    **Note**  
    This cmdlet requires an executable (.exe) or batch file (.bat). You must provide an empty (does nothing) executable or batch file.

     

<table>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Step</th>
<th align="left">Considerations</th>
<th align="left">Benefits</th>
<th align="left">Tradeoffs</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>No SXS Install at Publish (Pre-Install SxS assemblies)</p></td>
<td align="left"><p>Virtual Application packages do not need to be re-sequenced. SxS Assemblies can remain in the virtual application package.</p></td>
<td align="left"><p>The SxS Assembly dependencies will not install at publishing time.</p></td>
<td align="left"><p>SxS Assembly dependencies must be pre-installed.</p></td>
</tr>
</tbody>
</table>

 

### Creating a new virtual application package on the sequencer

If, during sequencer monitoring, an SxS Assembly (such as a VC++ Runtime) is installed as part of an application’s installation, SxS Assembly will be automatically detected and included in the package. The administrator will be notified and will have the option to exclude the SxS Assembly.

**Client Side**:

When publishing a virtual application package, the App-V Client will detect if a required SxS dependency is already installed. If the dependency is unavailable on the computer and it is included in the package, a traditional Windows Installer (.**msi**) installation of the SxS assembly will be initiated. As previously documented, simply install the dependency on the computer running the client to ensure that the Windows Installer (.msi) installation will not occur.

<table>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Step</th>
<th align="left">Considerations</th>
<th align="left">Benefits</th>
<th align="left">Tradeoffs</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>Selectively Employ Dynamic Configuration files</p></td>
<td align="left"><p>The App-V client must parse and process these Dynamic Configuration files.</p>
<p>Be conscious of size and complexity (script execution, VREG inclusions/exclusions) of the file.</p>
<p>Numerous virtual application packages may already have User- or computer–specific dynamic configurations files.</p></td>
<td align="left"><p>Publishing times will improve if these files are used selectively or not at all.</p></td>
<td align="left"><p>Virtual application packages would need to be reconfigured individually or via the App-V server management console to remove associated Dynamic Configuration files.</p></td>
</tr>
</tbody>
</table>

 

### Disabling a Dynamic Configuration by using Windows PowerShell

-   For already published packages, you can use `Set-AppVClientPackage –Name Myapp –Path c:\Packages\Apps\MyApp.appv` without

    **-DynamicDeploymentConfiguration** parameter

-   Similarly, when adding new packages using `Add-AppVClientPackage –Path c:\Packages\Apps\MyApp.appv`, do not use the

    **-DynamicDeploymentConfiguration** parameter.

For documentation on How to Apply a Dynamic Configuration, see:

-   [How to Apply the User Configuration File by Using Windows PowerShell](appv-apply-the-user-configuration-file-with-powershell.md)

-   [How to Apply the Deployment Configuration File by Using Windows PowerShell](appv-apply-the-deployment-configuration-file-with-powershell.md)

<table>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Step</th>
<th align="left">Considerations</th>
<th align="left">Benefits</th>
<th align="left">Tradeoffs</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>Account for Synchronous Script Execution during Package Lifecycle.</p></td>
<td align="left"><p>If script collateral is embedded in the package, Add cmdlets may be significantly slower.</p>
<p>Running of scripts during virtual application launch (StartVirtualEnvironment, StartProcess) and/or Add+Publish will impact the perceived performance during one or more of these lifecycle operations.</p></td>
<td align="left"><p>Use of Asynchronous (Non-Blocking) Scripts will ensure that the lifecycle operations complete efficiently.</p></td>
<td align="left"><p>This step requires working knowledge of all virtual application packages with embedded script collateral, which have associated dynamic configurations files and which reference and run scripts synchronously.</p></td>
</tr>
<tr class="even">
<td align="left"><p>Remove Extraneous Virtual Fonts from Package.</p></td>
<td align="left"><p>The majority of applications investigated by the App-V product team contained a small number of fonts, typically fewer than 20.</p></td>
<td align="left"><p>Virtual Fonts impact publishing refresh performance.</p></td>
<td align="left"><p>Desired fonts will need to be enabled/installed natively. For instructions, see Install or uninstall fonts.</p></td>
</tr>
</tbody>
</table>

 

### Determining what virtual fonts exist in the package

-   Make a copy of the package.

-   Rename Package\_copy.appv to Package\_copy.zip

-   Open AppxManifest.xml and locate the following:

    ```
    <appv:Extension Category="AppV.Fonts">
    <appv:Fonts>
    <appv:Font Path="[{Fonts}]\private\CalibriL.ttf" DelayLoad="true"></appv:Font>
    </appv:Fonts>
    ```

    **Note**&nbsp;&nbsp;If there are fonts marked as **DelayLoad**, those will not impact first launch.


### Excluding virtual fonts from the package

Use the dynamic configuration file that best suits the user scope – deployment configuration for all users on computer, user configuration for specific user or users.

-   Disable fonts with the deployment or user configuration.

Fonts

```
-->
<Fonts Enabled="false" />
<!--
```

## <a href="" id="bkmk-terms1"></a> App-V Performance Guidance Terminology


The following terms are used when describing concepts and actions related to App-V performance optimization.

-   **Complexity** – Refers to the one or more package characteristics that may impact performance during pre-configure (**Add-AppvClientPackage**) or integration (**Publish-AppvClientPackage**). Some example characteristics are: manifest size, number of virtual fonts, number of files.

-   **De-Integrate** – Removes the user integrations

-   **Re-Integrate** – Applies the user integrations.

-   **Non-Persistent, Pooled** – Creates a computer running a virtual environment each time they log in.

-   **Persistent, Personal** – A computer running a virtual environment that remains the same for every login.

-   **Stateful** - For this document, implies that user integrations are persisted between sessions and a user environment management technology is used in conjunction with non-persistent RDSH or VDI.

-   **Stateless** – Represents a scenario when no user state is persisted between sessions.

-   **Trigger** – (or Native Action Triggers). UPM uses these types of triggers to initiate monitoring or synchronization operations.

-   **User Experience** - In the context of App-V, the user experience, quantitatively, is the sum of the following parts:

    -   From the point that users initiate a log-in to when they are able to manipulate the desktop.

    -   From the point where the desktop can be interacted with to the point a publishing refresh begins (in Windows PowerShell terms, sync) when using the App-V full server infrastructure. In standalone instances, it is when the **Add-AppVClientPackage** and **Publish-AppVClientPackage** Windows PowerShell commands are initiated.

    -   From start to completion of the publishing refresh. In standalone instances, this is the first to last virtual application published.

    -   From the point where the virtual application is available to launch from a shortcut. Alternatively, it is from the point at which the file type association is registered and will launch a specified virtual application.

-   **User Profile Management** – The controlled and structured approach to managing user components associated with the environment. For example, user profiles, preference and policy management, application control and application deployment. You can use scripting or third-party solutions configure the environment as needed.



<br>For App-V issues, use the [App-V TechNet Forum](https://social.technet.microsoft.com/Forums/en-US/home?forum=mdopappv).

## Related topics

[Application Virtualization (App-V) overview](appv-for-windows.md)
