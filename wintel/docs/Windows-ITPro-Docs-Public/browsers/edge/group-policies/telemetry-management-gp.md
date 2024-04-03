---
title: Microsoft Edge - Telemetry and data collection group policies
description: Microsoft Edge gathers diagnostic data, intranet history, internet history, tracking information of sites visited, and Live Tile metadata. You can configure Microsoft Edge to collect all or none of this information.
audience: itpro
manager: dansimp
ms.author: dansimp
author: dansimp
ms.date: 10/02/2018
ms.reviewer: 
ms.localizationpriority: medium
ms.topic: reference
---

# Telemetry and data collection 

> [!NOTE]
> You've reached the documentation for Microsoft Edge version 45 and earlier. To see the documentation for Microsoft Edge version 77 or later, go to the [Microsoft Edge documentation landing page](https://docs.microsoft.com/DeployEdge/).

Microsoft Edge gathers diagnostic data, intranet history, internet history, tracking information of sites visited, and Live Tile metadata. You can configure Microsoft Edge to collect all or none of this information.

You can find the Microsoft Edge Group Policy settings in the following location of the Group Policy Editor unless otherwise noted in the policy:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Computer Configuration\\Administrative Templates\\Windows Components\\Microsoft Edge\\**

## Allow extended telemetry for the Books tab
[!INCLUDE [allow-ext-telemetry-books-tab-include.md](../includes/allow-ext-telemetry-books-tab-include.md)]

## Configure collection of browsing data for Microsoft 365 Analytics
[!INCLUDE [configure-browser-telemetry-for-m365-analytics-include](../includes/configure-browser-telemetry-for-m365-analytics-include.md)]

## Configure Do Not Track
[!INCLUDE [configure-do-not-track-include.md](../includes/configure-do-not-track-include.md)]

## Prevent Microsoft Edge from gathering Live Tile information when pinning a site to Start
[!INCLUDE [prevent-live-tile-pinning-start-include](../includes/prevent-live-tile-pinning-start-include.md)]
