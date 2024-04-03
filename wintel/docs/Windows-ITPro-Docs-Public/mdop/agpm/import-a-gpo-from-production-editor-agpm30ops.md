---
title: Import a GPO from Production
description: Import a GPO from Production
author: dansimp
ms.assetid: ad90f13e-e73c-400f-b86f-c12f2e75d19d
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.pagetype: mdop
ms.mktglfcycl: manage
ms.sitesec: library
ms.prod: w10
ms.date: 06/16/2016
---


# Import a GPO from Production


If changes are made to a controlled Group Policy Object (GPO) outside of Advanced Group Policy Management (AGPM), you can import a copy of the GPO from the production environment and save it to the archive to bring the archive and the production environment to a consistent state. (To import an uncontrolled GPO, control the GPO. See [Control an Uncontrolled GPO](control-an-uncontrolled-gpo-agpm30ops.md).)

A user account with the Editor, Approver, or AGPM Administrator (Full Control) role or necessary permissions in AGPM is required to complete this procedure. Review the details in "Additional considerations" in this topic.

**To import a GPO from the production environment**

1.  In the **Group Policy Management Console** tree, click **Change Control** in the forest and domain in which you want to manage GPOs.

2.  On the **Contents** tab, click the **Controlled** tab to display the controlled GPOs.

3.  Right-click the GPO, and then click **Import from Production**.

4.  Type a comment for the audit trail of the GPO, and then click **OK**.

### Additional considerations

-   By default, you must be an Editor, Approver, or AGPM Administrator (Full Control) to perform this procedure. Specifically, you must have **List Contents** and either **Edit Settings**, **Deploy GPO**, or **Delete GPO** permissions for the GPO.

### Additional references

-   [Creating, Controlling, or Importing a GPO](creating-controlling-or-importing-a-gpo-editor-agpm30ops.md)

 

 





