---
title: Get product packages
description: The Get product packages operation retrieves the information about applications in the Micosoft Store for Business.
ms.assetid: 039468BF-B9EE-4E1C-810C-9ACDD55C0835
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.topic: article
ms.prod: w10
ms.technology: windows
author: manikadhiman
ms.date: 09/18/2017
---

# Get product packages

The **Get product packages** operation retrieves the information about applications in the Micosoft Store for Business.

## Request

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th>Method</th>
<th>Request URI</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>GET</p></td>
<td><p>https://bspmts.mp.microsoft.com/V1/Products/{productId}/{skuId}/Packages</p></td>
</tr>
</tbody>
</table>

 
### URI parameters

The following parameters may be specified in the request URI.

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>productId</p></td>
<td><p>string</p></td>
<td><p>Required. Product identifier for an application that is used by the Store for Business.</p></td>
</tr>
<tr class="even">
<td><p>skuId</p></td>
<td><p>string</p></td>
<td><p>Required. Product identifier that specifies a specific SKU of an application.</p></td>
</tr>
</tbody>
</table>
   
 
<table>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th>Error code</th>
<th>Description</th>
<th>Retry</th>
<th>Data field</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>400</p></td>
<td><p>Invalid parameters</p></td>
<td><p>No</p></td>
<td><p>Parameter name</p>
<p>Reason: Missing parameter or invalid parameter</p>
<p>Details: String</p></td>
</tr>
<tr class="even">
<td><p>404</p></td>
<td><p>Not found</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p>409</p></td>
<td><p>Conflict</p></td>
<td></td>
<td><p>Reason: Not owned</p></td>
</tr>
</tbody>
</table>


## Response

### Response body

The response body contains [ProductPackageSet](data-structures-windows-store-for-business.md#productpackageset).

 





