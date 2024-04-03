---
title: Manage Microsoft Defender ATP incidents
description: Manage incidents by assigning it, updating its status, or setting its classification. 
keywords: incidents, manage, assign, status, classification, true alert, false alert
search.product: eADQiWindows 10XVcnh
search.appverid: met150
ms.prod: w10
ms.mktglfcycl: deploy
ms.sitesec: library
ms.pagetype: security
ms.author: macapara
author: mjcaparas
ms.localizationpriority: medium
manager: dansimp
audience: ITPro
ms.collection: M365-security-compliance 
ms.topic: article
ms.date: 010/08/2018
---

# Manage Microsoft Defender ATP incidents

**Applies to:**
- [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

Managing incidents is an important part of every cybersecurity operation. You can manage incidents by selecting an incident from the **Incidents queue** or the **Incidents management pane**. 


Selecting an incident from the **Incidents queue** brings up the **Incident management pane** where you can open the incident page for details.


![Image of the incidents management pane](images/atp-incidents-mgt-pane.png)

You can assign incidents to yourself, change the status and classification, rename, or comment on them to keep track of their progress. 

![Image of incident detail page](images/atp-incident-details-page.png)


## Assign incidents
If an incident has not been assigned yet, you can select **Assign to me** to assign the incident to yourself. Doing so assumes ownership of not just the incident, but also all the alerts associated with it.

## Set status and classification
### Incident status
You can categorize incidents (as **Active**, or **Resolved**) by changing their status as your investigation progresses. This helps you organize and manage how your team can respond to incidents.

For example, your SoC analyst can review the urgent **Active** incidents for the day, and decide to assign them to himself for investigation.

Alternatively, your SoC analyst might set the incident as **Resolved** if the incident has been remediated. 

### Classification
You can choose not to set a classification, or decide to specify whether an incident is true or false. Doing so helps the team see patterns and learn from them.

### Add comments
You can add comments and view historical events about an incident to see previous changes made to it.

Whenever a change or comment is made to an alert, it is recorded in the Comments and history section.

Added comments instantly appear on the pane.



## Related topics
- [Incidents queue](https://docs.microsoft.com/windows/security/threat-protection/microsoft-defender-atp/view-incidents-queue)
- [View and organize the Incidents queue](view-incidents-queue.md)
- [Investigate incidents](investigate-incidents.md)
