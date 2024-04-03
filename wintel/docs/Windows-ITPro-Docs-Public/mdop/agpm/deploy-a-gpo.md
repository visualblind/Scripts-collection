---
title: Deploy a GPO
description: Deploy a GPO
author: dansimp
ms.assetid: a0a3f292-e3ab-46ae-a0fd-d7b2b4ad8883
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.pagetype: mdop
ms.mktglfcycl: manage
ms.sitesec: library
ms.prod: w10
ms.date: 06/16/2016
---


# Deploy a GPO


Advanced Group Policy Management (AGPM) enables an Approver to deploy a new or edited Group Policy object (GPO) to the production environment. For information about redeploying a previous version of a GPO, see [Roll Back to a Previous Version of a GPO](roll-back-to-a-previous-version-of-a-gpo.md).

A user account with the Approver or AGPM Administrator (Full Control) role or necessary permissions in Advanced Group Policy Management is required to complete this procedure. Review the details in "Additional considerations" in this topic.

**To deploy a GPO to the production environment**

1.  In the **Group Policy Management Console** tree, click **Change Control** in the forest and domain in which you want to manage GPOs.

2.  On the **Contents** tab, click the **Controlled** tab to display the controlled GPOs.

3.  Right-click the GPO to be deployed and then click **Deploy**.

4.  To review links to the GPO, click **Advanced**. Pause the mouse pointer on a node in the tree to display details.

    -   By default, all links to the GPO will be restored.

    -   To prevent a link from being restored, clear the check box for that link.

    -   To prevent all links from being restored, clear the **Restore Links** check box in the **Deploy GPO** dialog box.

5.  Click **Yes**. When the **Progress** window indicates that overall progress is complete, click **Close**.

**Note**  
To verify whether the most recent version of a GPO has been deployed, on the **Controlled** tab, double-click the GPO to display its **History**. In the **History** for the GPO, the **State** column indicates whether a GPO has been deployed.

 

### Additional considerations

-   By default, you must be an Approver or an AGPM Administrator (Full Control) to perform this procedure. Specifically, you must have **List Contents** and **Deploy GPO** permissions for the GPO.

### Additional references

-   [Performing Approver Tasks](performing-approver-tasks.md)

 

 





