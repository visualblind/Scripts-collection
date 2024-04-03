---
title: Recovering Computers Using DaRT 8.0
description: Recovering Computers Using DaRT 8.0
author: dansimp
ms.assetid: 0caeb7d9-c1e6-4f32-bc27-157b91630989
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.pagetype: mdop
ms.mktglfcycl: support
ms.sitesec: library
ms.prod: w10
ms.date: 06/16/2016
---


# Recovering Computers Using DaRT 8.0


After deploying the Microsoft Diagnostics and Recovery Toolset (DaRT) 8.0 recovery image, you can use DaRT 8.0 to recover computers. The information in this section describes the recovery tasks that you can perform.

You have several different methods to choose from to boot into DaRT, depending on how you deploy the DaRT recovery image.

-   Insert a DaRT recovery image CD, DVD, or USB flash drive into the problem computer and use it to boot into the computer.

-   Boot into DaRT from a recovery partition on the problem computer.

-   Boot into DaRT from a remote partition on the network.

For information about the advantages and disadvantages of each method, see [Planning How to Save and Deploy the DaRT 8.0 Recovery Image](planning-how-to-save-and-deploy-the-dart-80-recovery-image-dart-8.md).

Whichever method that you use to boot into DaRT, you must enable the boot device in the BIOS for the boot option or options that you want to make available to the end user.

**Note**  
Configuring the BIOS is unique, depending on the kind of hard disk drive, network adapters, and other hardware that is used in your organization.

 

## Recover a local computer by using the DaRT recovery image


To recover a local computer by using DaRT, you must be physically present at the end-user computer that is experiencing problems that require DaRT.

[How to Recover Local Computers by Using the DaRT Recovery Image](how-to-recover-local-computers-by-using-the-dart-recovery-image-dart-8.md)

## Recover a remote computer by using the DaRT recovery image


The Remote Connection feature in DaRT lets an IT administrator run the DaRT tools remotely on an end-user computer. After certain information is provided by the end user (or by a help desk professional working on the end-user computer), the IT administrator or help desk worker can take control of the end user's computer and run the necessary DaRT tools remotely.

**Important**  
The two computers establishing a remote connection must be part of the same network.

 

The **Diagnostics and Recovery Toolset** window includes the option to run DaRT on an end-user computer remotely from an administrator computer. The end user opens the DaRT tools on the problem computer and starts the remote session by clicking **Remote Connection**.

The Remote Connection feature on the end-user computer creates the following connection information: a ticket number, a port, and a list of all available IP addresses. The ticket number and port are generated randomly.

The IT administrator or help desk worker enters this information into the **DaRT Remote Connection Viewer** to establish the terminal services connection to the end-user computer. The terminal services connection that is established lets an IT administrator remotely interact with the DaRT tools on the end-user computer. The end-user computer then processes the connection information, shares its screen, and responds to instructions from the IT administrator computer.

[How to Recover Remote Computers by Using the DaRT Recovery Image](how-to-recover-remote-computers-by-using-the-dart-recovery-image-dart-8.md)

## Other resources for recovering computers using DaRT 8.0


[Operations for DaRT 8.0](operations-for-dart-80-dart-8.md)

 

 





