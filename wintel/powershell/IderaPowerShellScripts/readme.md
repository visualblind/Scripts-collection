The purpose of the **SQL Server** samples is to demonstrate the scripting capabilities of PowerShell for performing DBA tasks against SQL Server.

**Important: **
---------------
Samples are provided for educational purposes only. They are not intended to be used in a production environment and have not been tested in a production environment. Idera does not provide technical support for these samples. Sample applications should not be connected to or used with your production environment without the permission of the SQL Server administrator.

Scenario
========
The sample scripts demonstrate various techniques for gathering and managing SQL Server objects using PowerShell. The scripts can against a local or remote SQL Server (See Prerequisites for more information).

Each script is designed to be loaded and run using default parameters against a local installation of SQL Server but can be changed to refer to the SQL Server instance. Please load each script into a compatible PowerShell editor, such as PowerShellPlus Professional Edition, and review before running. After running each script, use the PowerShell Integrated Console to supply inputs for the script and review the results.

**Tip: **
---------
The Interactive console opened for viewing while editing a script or you can click on the Console tab in the Code Editor.

Languages
=========
PowerShell – recommended version is v5.0 or higher (For Azure SQL Database scripts v5.0 is required).

Prerequisites
=============
Before running this sample, make sure the following software is installed:

-   SQL Server 2008R2, 2012, 2014, 2016 and 2017
-   PowerShell v5.0 and higher is preferred
-   SQLPS module (see Initialize-ISqlPSxxxx scripts)
-   AzureRM module (see Initialize-IAzurePowerShell script in the AzureSQLDB folder)

What's New in v6 of these scripts
==================================
Azure SQL Database automation scripts. To learn more about using PowerShell for Azure SQL Database, see this Quick Start – Create a single Azure SQL database using PowerShell (https://docs.microsoft.com/en-us/azure/sql-database/sql-database-get-started-powershell) and an Overview of Azure PowerShell (https://docs.microsoft.com/en-us/powershell/azure/overview?view=azurermps-6.3.0).

Running the Samples
===================
The following procedure shows how to run the samples.

1.  From PowerShellPlus Script Editor, open **any sample** script.
2.  Select the Execution tab and Click **Run**.

© 2005-2018 Idera, Inc. All rights reserved.
