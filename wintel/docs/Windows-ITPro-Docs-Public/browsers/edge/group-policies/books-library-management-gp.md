---
title: Microsoft Edge - Books Library group policies
description: Microsoft Edge decreases the amount of storage used by book files by downloading them to a shared folder. You can also allow Microsoft Edge to update the configuration data for the library automatically.
services: 
keywords: 
ms.localizationpriority: medium
audience: itpro
manager: dansimp
author: dansimp
ms.author: dansimp
ms.date: 10/02/2018
ms.reviewer: 
ms.topic: reference
ms.prod: edge
ms.mktglfcycl: explore
ms.sitesec: library
---

# Books Library 

> [!NOTE]
> You've reached the documentation for Microsoft Edge version 45 and earlier. To see the documentation for Microsoft Edge version 77 or later, go to the [Microsoft Edge documentation landing page](https://docs.microsoft.com/DeployEdge/).

Microsoft Edge decreases the amount of storage used by book files by downloading them to a shared folder in Windows. You can configure Microsoft Edge to update the configuration data for the library automatically or gather diagnostic data, such as usage data. 


You can find the Microsoft Edge Group Policy settings in the following location of the Group Policy Editor unless otherwise noted in the policy:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Computer Configuration\\Administrative Templates\\Windows Components\\Microsoft Edge\\**

## Allow a shared books folder
[!INCLUDE [allow-shared-folder-books-include.md](../includes/allow-shared-folder-books-include.md)] 

## Allow configuration updates for the Books Library
[!INCLUDE [allow-config-updates-books-include.md](../includes/allow-config-updates-books-include.md)]

## Allow extended telemetry for the Books tab
[!INCLUDE [allow-ext-telemetry-books-tab-include.md](../includes/allow-ext-telemetry-books-tab-include.md)]

## Always show the Books Library in Microsoft Edge
[!INCLUDE [always-enable-book-library-include.md](../includes/always-enable-book-library-include.md)]
