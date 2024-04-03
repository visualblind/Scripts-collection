---
title: Sync Trigger Events for UE-V 2.x
description: Sync Trigger Events for UE-V 2.x
author: dansimp
ms.assetid: 4ed71a13-6a4f-4376-996f-74b126536bbc
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.pagetype: mdop, virtualization
ms.mktglfcycl: deploy
ms.sitesec: library
ms.prod: w10
ms.date: 06/16/2016
---


# Sync Trigger Events for UE-V 2.x


Microsoft User Experience Virtualization (UE-V) 2.0, 2.1, and 2.1 SP1 lets you synchronize your application and Windows settings across all your domain-joined devices. *Sync trigger events* define when the UE-V Agent synchronizes those settings with the settings storage location. UE-V 2 introduces a new *Sync Method* called the *SyncProvider*. For more information about Sync Method configuration, see [Sync Methods for UE-V 2.x](sync-methods-for-ue-v-2x-both-uevv2.md).

## UE-V 2 Sync Trigger Events


The following table explains the trigger events for classic applications and Windows settings.

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><p><strong>UE-V 2 Trigger Event</strong></p></td>
<td align="left"><p><strong>SyncMethod=SyncProvider</strong></p></td>
<td align="left"><p><strong>SyncMethod=None</strong></p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Windows Logon</strong></p></td>
<td align="left"><ul>
<li><p>Application and Windows settings are imported to the local cache from the settings storage location.</p></li>
<li><p><a href="https://technet.microsoft.com/library/dn458932.aspx#autosyncsettings2" data-raw-source="[Asynchronous Windows settings](https://technet.microsoft.com/library/dn458932.aspx#autosyncsettings2)">Asynchronous Windows settings</a> are applied.</p></li>
<li><p>Synchronous Windows settings will be applied during the next Windows logon.</p></li>
<li><p>Application settings will be applied when the application starts.</p></li>
</ul></td>
<td align="left"><ul>
<li><p>Application and Windows settings are read directly from the settings storage location.</p></li>
<li><p>Asynchronous and synchronous Windows settings are applied.</p></li>
<li><p>Application settings will be applied when the application starts.</p></li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Windows Logoff</strong></p></td>
<td align="left"><p>Store changes locally and cache and copy asynchronous and synchronous Windows settings to the settings storage location server, if available</p></td>
<td align="left"><p>Store changes to asynchronous and synchronous Windows settings storage location</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Windows Connect (RDP) / Unlock</strong></p></td>
<td align="left"><p>Synchronize any asynchronous Windows settings from settings storage location to local cache, if available.</p>
<p>Apply cached Windows settings</p></td>
<td align="left"><p>Download and apply asynchronous windows settings from settings storage location</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Windows Disconnect (RDP) / Lock</strong></p></td>
<td align="left"><p>Store asynchronous Windows settings changes to the local cache.</p>
<p>Synchronize any asynchronous Windows settings from the local cache to settings storage location, if available</p></td>
<td align="left"><p>Store asynchronous Windows settings changes to the settings storage location</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Application start</strong></p></td>
<td align="left"><p>Apply application settings from local cache as the application starts</p></td>
<td align="left"><p>Apply application settings from settings storage location as the application starts</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Application closes</strong></p></td>
<td align="left"><p>Store any application settings changes to the local cache and copy settings to settings storage location, if available</p></td>
<td align="left"><p>Store any application settings changes to settings storage location</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Sync Controller Scheduled Task or “Sync Now” is run from the Company Settings Center</strong></p>
<p></p></td>
<td align="left"><p>Application and Windows settings are synchronized between the settings storage location and the local cache.</p>
<div class="alert">
<strong>Note</strong><br/><p>Settings changes are not cached locally until an application closes. This trigger will not export changes made to a currently running application.</p>
<p>For Windows settings, this means that any changes will not be cached locally and exported until the next Lock (Asynchronous) or Logoff (Asynchronous and Synchronous).</p>
</div>
<div>

</div>
<p>Settings are applied in these cases:</p>
<ul>
<li><p>Asynchronous Windows settings are applied directly.</p></li>
<li><p>Application settings are applied when the application starts.</p></li>
<li><p>Both asynchronous and synchronous Windows settings are applied during the next Windows logon.</p></li>
<li><p>Windows app (AppX) settings are applied during the next refresh. See <a href="https://technet.microsoft.com/library/dn458944.aspx" data-raw-source="[Monitor Application Settings](https://technet.microsoft.com/library/dn458944.aspx)">Monitor Application Settings</a> for more information.</p></li>
</ul></td>
<td align="left"><p>NA</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Asynchronous Settings updated on remote store*</strong></p></td>
<td align="left"><p>Load and apply new asynchronous settings from the cache.</p></td>
<td align="left"><p>Load and apply settings from central server</p></td>
</tr>
</tbody>
</table>








## Related topics


[Technical Reference for UE-V 2.x](technical-reference-for-ue-v-2x-both-uevv2.md)

[Changing the Frequency of UE-V 2.x Scheduled Tasks](changing-the-frequency-of-ue-v-2x-scheduled-tasks-both-uevv2.md)

[Choose the Configuration Method for UE-V 2.x](https://technet.microsoft.com/library/dn458891.aspx#config)









