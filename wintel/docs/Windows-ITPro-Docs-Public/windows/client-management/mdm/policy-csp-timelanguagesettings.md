---
title: Policy CSP - TimeLanguageSettings
description: Policy CSP - TimeLanguageSettings
ms.author: dansimp
ms.topic: article
ms.prod: w10
ms.technology: windows
author: manikadhiman
ms.date: 09/27/2019
ms.reviewer: 
manager: dansimp
---

# Policy CSP - TimeLanguageSettings



<hr/>

<!--Policies-->
## TimeLanguageSettings policies  

<dl>
  <dd>
    <a href="#timelanguagesettings-allowset24hourclock">TimeLanguageSettings/AllowSet24HourClock</a>
  </dd>
  <dd>
    <a href="#timelanguagesettings-configuretimezone">TimeLanguageSettings/ConfigureTimeZone</a>
  </dd>
</dl>


<hr/>

<!--Policy-->
<a href="" id="timelanguagesettings-allowset24hourclock"></a>**TimeLanguageSettings/AllowSet24HourClock**  

<!--SupportedSKUs-->
<table>
<tr>
    <th>Windows Edition</th>
    <th>Supported?</th>
</tr>
<tr>
    <td>Home</td>
    <td><img src="images/crossmark.png" alt="cross mark" /></td>
</tr>
<tr>
    <td>Pro</td>
    <td><img src="images/crossmark.png" alt="cross mark" /></td>
</tr>
<tr>
    <td>Business</td>
    <td><img src="images/crossmark.png" alt="cross mark" /></td>
</tr>
<tr>
    <td>Enterprise</td>
    <td><img src="images/crossmark.png" alt="cross mark" /></td>
</tr>
<tr>
    <td>Education</td>
    <td><img src="images/crossmark.png" alt="cross mark" /></td>
</tr>
<tr>
    <td>Mobile</td>
    <td><img src="images/checkmark.png" alt="check mark" /><sup>2</sup></td>
</tr>
<tr>
    <td>Mobile Enterprise</td>
    <td><img src="images/checkmark.png" alt="check mark" /><sup>2</sup></td>
</tr>
</table>

<!--/SupportedSKUs-->
<hr/>

<!--Scope-->
[Scope](./policy-configuration-service-provider.md#policy-scope):

> [!div class = "checklist"]
> * Device

<hr/>

<!--/Scope-->
<!--Description-->
Allows for the configuration of the default clock setting to be the 24 hour format. If set to 0 (zero), the device uses the default clock as prescribed by the current locale setting.

<!--/Description-->
<!--SupportedValues-->
The following list shows the supported values:

-   0 (default) – Current locale setting.
-   1 – Set 24 hour clock.

<!--/SupportedValues-->
<!--/Policy-->

<hr/>

<!--Policy-->
<a href="" id="timelanguagesettings-configuretimezone"></a>**TimeLanguageSettings/ConfigureTimeZone**  

<!--SupportedSKUs-->
<table>
<tr>
    <th>Windows Edition</th>
    <th>Supported?</th>
</tr>
<tr>
    <td>Home</td>
    <td><img src="images/crossmark.png" alt="cross mark" /></td>
</tr>
<tr>
    <td>Pro</td>
    <td><img src="images/checkmark.png" alt="check mark" /><sup>6</sup></td>
</tr>
<tr>
    <td>Business</td>
    <td><img src="images/checkmark.png" alt="check mark" /><sup>6</sup></td>
</tr>
<tr>
    <td>Enterprise</td>
    <td><img src="images/checkmark.png" alt="check mark" /><sup>6</sup></td>
</tr>
<tr>
    <td>Education</td>
    <td><img src="images/checkmark.png" alt="check mark" /><sup>6</sup></td>
</tr>
<tr>
    <td>Mobile</td>
    <td></td>
</tr>
<tr>
    <td>Mobile Enterprise</td>
    <td></td>
</tr>
</table>

<!--/SupportedSKUs-->
<hr/>

<!--Scope-->
[Scope](./policy-configuration-service-provider.md#policy-scope):

> [!div class = "checklist"]
> * Device

<hr/>

<!--/Scope-->
<!--Description-->
Specifies the time zone to be applied to the device. This is the standard Windows name for the target time zone.

<!--/Description-->
<!--SupportedValues-->

<!--/SupportedValues-->
<!--Example-->

<!--/Example-->
<!--Validation-->

<!--/Validation-->
<!--/Policy-->
<hr/>

Footnotes:

-   1 - Added in Windows 10, version 1607.
-   2 - Added in Windows 10, version 1703.
-   3 - Added in Windows 10, version 1709.
-   4 - Added in Windows 10, version 1803.
-   5 - Added in Windows 10, version 1809.
-   6 - Added in Windows 10, version 1903.

<!--/Policies-->

