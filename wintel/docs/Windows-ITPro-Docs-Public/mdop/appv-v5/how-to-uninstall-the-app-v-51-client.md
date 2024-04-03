---
title: How to Uninstall the App-V 5.1 Client
description: How to Uninstall the App-V 5.1 Client
author: dansimp
ms.assetid: 21f2d946-fc9f-4cd3-899b-ac52b3fbc306
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.pagetype: mdop, appcompat, virtualization
ms.mktglfcycl: deploy
ms.sitesec: library
ms.prod: w10
ms.date: 06/16/2016
---


# How to Uninstall the App-V 5.1 Client


Use the following procedure to uninstall the Microsoft Application Virtualization (App-V) 5.1 client from a computer. When you uninstall the App-V 5.1 client all packages published to the computer running the client are also removed. If the uninstall operation does not complete the packages will need to be re-published to the computer running the App-V 5.1 client.

**Important**  
You should ensure that the App-V 5.1 client service is running prior to performing the uninstall procedure.



**To uninstall the App-V 5.1 Client**

1.  In Control Panel, double-click **Programs** / **Uninstall a Program**, and then double-click **Microsoft Application Virtualization Client**.

2.  In the dialog box that appears, click **Yes** to continue with the uninstall process.

    **Important**  
    The uninstall process cannot be canceled or interrupted.



3.  A progress bar shows the time remaining. When this step finishes, you must restart the computer so that all associated drivers can be stopped to complete the uninstall process.

    **Note**  
    You can also use the command line to uninstall the App-V 5.1 client with the following switch: **/UNINSTALL**.



~~~
**Got a suggestion for App-V**? Add or vote on suggestions [here](http://appv.uservoice.com/forums/280448-microsoft-application-virtualization). **Got an App-V issue?** Use the [App-V TechNet Forum](https://social.technet.microsoft.com/Forums/home?forum=mdopappv).
~~~

## Related topics


[Deploying App-V 5.1](deploying-app-v-51.md)









