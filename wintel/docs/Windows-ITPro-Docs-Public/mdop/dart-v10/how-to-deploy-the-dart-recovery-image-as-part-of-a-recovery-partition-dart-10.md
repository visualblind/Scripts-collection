---
title: How to Deploy the DaRT Recovery Image as Part of a Recovery Partition
description: How to Deploy the DaRT Recovery Image as Part of a Recovery Partition
author: dansimp
ms.assetid: 0d2192c1-4058-49fb-b0b6-baf4699ac7f5
ms.reviewer: 
manager: dansimp
ms.author: dansimp
ms.pagetype: mdop
ms.mktglfcycl: support
ms.sitesec: library
ms.prod: w10
ms.date: 08/30/2016
---


# How to Deploy the DaRT Recovery Image as Part of a Recovery Partition


After you have finished running the Microsoft Diagnostics and Recovery Toolset (DaRT) 10 Recovery Image wizard and created the recovery image, you can extract the boot.wim file from the ISO image file and deploy it as a recovery partition in a Windows 10 image. A partition is recommended, because any corruption issues that prevent the Windows operating system from starting would also prevent the recovery image from starting. A separate partition also eliminates the need to provide the BitLocker recovery key twice. Consider hiding the partition to prevent users from storing files on it.

**To deploy DaRT in the recovery partition of a Windows 10 image**

1.  Create a target partition in your Windows 10 image that is equal to or greater than the size of the ISO image file that you created by using the **DaRT 10 Recovery Image wizard**.

    The minimum size required for a DaRT partition is 500MB to accommodate the remote connection functionality in DaRT.

2.  Extract the boot.wim file from the DaRT ISO image file.

    1.  Using your company’s preferred method, mount the ISO image file that you created on the **Create Startup Image** page.

    2.  Open the ISO image file and copy the boot.wim file from the \\sources folder in the mounted image to a location on your computer or on an external drive.

        **Note**  
        If you burned a CD, DVD, or USB of the recovery image, you can open the files on the removable media and copy the boot.wim file from the \\sources folder. If you copy boot.wim file, you don’t need to mount the image.

         

3.  Use the boot.wim file to create a bootable recovery partition by using your company’s standard method for creating a custom Windows RE image.

    For more information about how to create or customize a recovery partition, see [Customizing the Windows RE Experience](https://go.microsoft.com/fwlink/?LinkId=214222).

4.  Replace the target partition in your Windows 10 image with the recovery partition.

    For more information about how to deploy a recovery solution to reinstall the factory image in the event of a system failure, see [Deploy a System Recovery Image](https://go.microsoft.com/fwlink/?LinkId=214221).

## Related topics


[Creating the DaRT 10 Recovery Image](creating-the-dart-10-recovery-image.md)

[Deploying the DaRT Recovery Image](deploying-the-dart-recovery-image-dart-10.md)

[Planning for DaRT 10](planning-for-dart-10.md)

 

 





