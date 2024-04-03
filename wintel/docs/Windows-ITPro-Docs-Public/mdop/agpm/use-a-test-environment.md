---
title: Use a Test Environment
description: Use a Test Environment
author: dansimp
ms.assetid: b8d7b3ee-030a-4b5b-8223-4a3276fd47a7
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.pagetype: mdop
ms.mktglfcycl: manage
ms.sitesec: library
ms.prod: w10
ms.date: 06/16/2016
---


# Use a Test Environment


If you use a testing organizational unit (OU) to test Group Policy objects (GPOs) before deployment to the production environment, you must have the necessary permissions to access the test OU. The use of a test OU is optional.

**To use a test OU**

1.  While you have the GPO checked out for editing, in the **Group Policy Management Console**, click **Group Policy Objects** in the forest and domain in which you are managing GPOs.

2.  Click the checked out copy of the GPO to be tested. The name will be preceded with **\[AGPM\]**. (If it is not listed, click **Action**, then **Refresh**. Sort the names alphabetically, and **\[AGPM\]** GPOs will typically appear at the top of the list.)

3.  Drag and drop the GPO to the test OU.

4.  Click **OK** in the dialog box asking whether to create a link to the GPO in the test OU.

### Additional considerations

-   When testing is complete, checking in the GPO automatically deletes the link to the checked-out copy of the GPO.

### Additional references

-   [Editing a GPO](editing-a-gpo.md)

 

 





