---
title: Policy CSP - Bitlocker
description: Policy CSP - Bitlocker
ms.author: dansimp
ms.topic: article
ms.prod: w10
ms.technology: windows
author: manikadhiman
ms.date: 09/27/2019
ms.reviewer: 
manager: dansimp
---

# Policy CSP - Bitlocker



> [!NOTE]
> To manage encryption of PCs and devices, use [BitLocker CSP](https://docs.microsoft.com/windows/client-management/mdm/bitlocker-csp).

<hr/>

<!--Policies-->
## Bitlocker policies  

<dl>
  <dd>
    <a href="#bitlocker-encryptionmethod">Bitlocker/EncryptionMethod</a>
  </dd>
</dl>


<hr/>

<!--Policy-->
<a href="" id="bitlocker-encryptionmethod"></a>**Bitlocker/EncryptionMethod**  

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
    <td><img src="images/checkmark.png" alt="check mark" /></td>
</tr>
<tr>
    <td>Business</td>
    <td><img src="images/checkmark.png" alt="check mark" /></td>
</tr>
<tr>
    <td>Enterprise</td>
    <td><img src="images/checkmark.png" alt="check mark" /></td>
</tr>
<tr>
    <td>Education</td>
    <td><img src="images/checkmark.png" alt="check mark" /></td>
</tr>
<tr>
    <td>Mobile</td>
    <td><img src="images/checkmark.png" alt="check mark" /></td>
</tr>
<tr>
    <td>Mobile Enterprise</td>
    <td><img src="images/checkmark.png" alt="check mark" /></td>
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
Specifies the BitLocker Drive Encryption method and cipher strength.

> [!NOTE]
> XTS-AES 128-bit and XTS-AES 256-bit values are supported only on Windows 10 for desktop.

<!--/Description-->
<!--SupportedValues-->
The following list shows the supported values:

-   3 - AES-CBC 128-bit
-   4 - AES-CBC 256-bit
-   6 - XTS-AES 128-bit (Desktop only)
-   7 - XTS-AES 256-bit (Desktop only)

<!--/SupportedValues-->
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

