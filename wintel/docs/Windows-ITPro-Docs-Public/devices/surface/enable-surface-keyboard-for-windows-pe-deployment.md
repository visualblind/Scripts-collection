---
title: How to enable the Surface Laptop keyboard during MDT deployment (Surface)
description: When you use MDT to deploy Windows 10 to Surface laptops, you need to import keyboard drivers to use in the Windows PE environment.
keywords: windows 10 surface, automate, customize, mdt
ms.prod: w10
ms.mktglfcycl: deploy
ms.pagetype: surface
ms.sitesec: library
author: Teresa-Motiv
ms.author: v-tea
ms.topic: article
ms.date: 10/2/2019
ms.reviewer: scottmca
manager: jarrettr
appliesto:
- Surface Laptop (1st Gen)
- Surface Laptop 2
---

# How to enable the Surface Laptop keyboard during MDT deployment

> [!NOTE]
> This article addresses a deployment approach that uses Microsoft Deployment Toolkit (MDT). You can also apply this information to other deployment methodologies.

> [!IMPORTANT]
> If you are deploying a Windows 10 image to a Surface Laptop that has Windows 10 in S mode preinstalled, see KB [4032347, Problems when deploying Windows to Surface devices with preinstalled Windows 10 in S mode](https://support.microsoft.com/help/4032347/surface-preinstall-windows10-s-mode-issues).

On most types of Surface devices, the keyboard should work during Lite Touch Installation (LTI). However, Surface Laptop requires some additional drivers to enable the keyboard. For Surface Laptop (1st Gen) and Surface Laptop 2 devices, you must prepare the folder structure and selection profiles that allow you to specify keyboard drivers for use during the Windows Preinstallation Environment (Windows PE) phase of LTI. For more information about this folder structure, see [Deploy a Windows 10 image using MDT: Step 5: Prepare the drivers repository](https://docs.microsoft.com/windows/deployment/deploy-windows-mdt/deploy-a-windows-10-image-using-mdt?redirectedfrom=MSDN#step-5-prepare-the-drivers-repository).

To add the keyboard drivers to the selection profile, follow these steps:

1. Download the latest Surface Laptop MSI file from the appropriate locations:
   - [Surface Laptop (1st Gen) Drivers and Firmware](https://www.microsoft.com/download/details.aspx?id=55489)
   - [Surface Laptop 2 Drivers and Firmware](https://www.microsoft.com/download/details.aspx?id=57515)

1. Extract the contents of the Surface Laptop MSI file to a folder that you can easily locate (for example, c:\surface_laptop_drivers). To extract the contents, open an elevated Command Prompt window and run the following command:

   ```cmd
   Msiexec.exe /a SurfaceLaptop_Win10_15063_1703008_1.msi targetdir=c:\surface_laptop_drivers /qn
   ```

1. Open the Deployment Workbench and expand the **Deployment Shares** node and your deployment share, then navigate to the **WindowsPEX64** folder.

   ![Image that shows the location of the WindowsPEX64 folder in the Deployment Workbench](./images/surface-laptop-keyboard-1.png)

1. Right-click the **WindowsPEX64** folder and select **Import Drivers**.
1. Follow the instructions in the Import Driver Wizard to import the driver folders into the WindowsPEX64 folder.  
   
   To support Surface Laptop (1st Gen), import the following folders:
   - SurfacePlatformInstaller\Drivers\System\GPIO
   - SurfacePlatformInstaller\Drivers\System\SurfaceHidMiniDriver
   - SurfacePlatformInstaller\Drivers\System\SurfaceSerialHubDriver  
   
   To support Surface Laptop 2, import the following folders:
   - SurfacePlatformInstaller\Drivers\System\GPIO
   - SurfacePlatformInstaller\Drivers\System\SurfaceHIDMiniDriver
   - SurfacePlatformInstaller\Drivers\System\SurfaceSerialHubDriver
   - SurfacePlatformInstaller\Drivers\System\I2C
   - SurfacePlatformInstaller\Drivers\System\SPI
   - SurfacePlatformInstaller\Drivers\System\UART  

1. Verify that the WindowsPEX64 folder now contains the imported drivers. The folder should resemble the following:  

   ![Image that shows the newly imported drivers in the WindowsPEX64 folder of the Deployment Workbench](./images/surface-laptop-keyboard-2.png)

1. Configure a selection profile that uses the WindowsPEX64 folder. The selection profile should resemble the following:  

   ![Image that shows the WindowsPEX64 folder selected as part of a selection profile](./images/surface-laptop-keyboard-3.png)

1. Configure the Windows PE properties of the MDT deployment share to use the new selection profile, as follows:  

   - For **Platform**, select **x64**.
   - For **Selection profile**, select the new profile.
   - Select **Include all drivers from the selection profile**.
   
   ![Image that shows the Windows PE properties of the MDT Deployment Share](./images/surface-laptop-keyboard-4.png)

1. Verify that you have configured the remaining Surface Laptop drivers by using either a selection profile or a **DriverGroup001** variable.  
   - For Surface Laptop (1st Gen), the model is **Surface Laptop**. The remaining Surface Laptop drivers should reside in the \MDT Deployment Share\Out-of-Box Drivers\Windows10\X64\Surface Laptop folder as shown in the figure that follows this list.
   - For Surface Laptop 2, the model is **Surface Laptop 2**. The remaining Surface Laptop drivers should reside in the \MDT Deployment Share\Out-of-Box Drivers\Windows10\X64\Surface Laptop 2 folder.  

   ![Image that shows the regular Surface Laptop (1st Gen) drivers in the Surface Laptop folder of the Deployment Workbench](./images/surface-laptop-keyboard-5.png)

After configuring the MDT Deployment Share to use the new selection profile and related settings, continue the deployment process as described in [Deploy a Windows 10 image using MDT: Step 6: Create the deployment task sequence](https://docs.microsoft.com/windows/deployment/deploy-windows-mdt/deploy-a-windows-10-image-using-mdt#step-6-create-the-deployment-task-sequence).
