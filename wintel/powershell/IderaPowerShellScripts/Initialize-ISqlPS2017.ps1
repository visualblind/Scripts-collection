<#
.SYNOPSIS
   	Initialize-ISqlPS2017
.DESCRIPTION
   	Initialize SQL Server 2017 SQLPS PowerShell Module
	Once the module is loaded test it by typing:
		cd SQLSERVER:
	You can now explored the SQLSERVER Provider
.EXAMPLE
   	Initialize-ISqlPS2017
.NOTES
	This may raise a warning when a Microsoft script (SqlPsPostScript.ps1) is run
	The warning occurs when this script tries import the SQLASCmdlets
	This warning does not mean that the SQLPS module is not loaded
	PowerShellPlus automately loads any called scripts so it can't be avoided
#>

$ErrorActionPreference = "Stop"

$sqlpsreg="HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.SqlServer.Management.PowerShell.sqlps140"

if (Get-ChildItem $sqlpsreg -ErrorAction "SilentlyContinue")
{
    throw "SQL Server Provider for Windows PowerShell is not installed."
}
else
{
    $item = Get-ItemProperty $sqlpsreg
    $sqlpsPath = [System.IO.Path]::GetDirectoryName($item.Path)
}

$assemblylist = 
"Microsoft.SqlServer.Management.Common",
"Microsoft.SqlServer.Smo",
"Microsoft.SqlServer.Dmf ",
"Microsoft.SqlServer.Instapi ",
"Microsoft.SqlServer.SqlWmiManagement ",
"Microsoft.SqlServer.ConnectionInfo ",
"Microsoft.SqlServer.SmoExtended ",
"Microsoft.SqlServer.SqlTDiagM ",
"Microsoft.SqlServer.SString ",
"Microsoft.SqlServer.Management.RegisteredServers ",
"Microsoft.SqlServer.Management.Sdk.Sfc ",
"Microsoft.SqlServer.SqlEnum ",
"Microsoft.SqlServer.RegSvrEnum ",
"Microsoft.SqlServer.WmiEnum ",
"Microsoft.SqlServer.ServiceBrokerEnum ",
"Microsoft.SqlServer.ConnectionInfoExtended ",
"Microsoft.SqlServer.Management.Collector ",
"Microsoft.SqlServer.Management.CollectorEnum",
"Microsoft.SqlServer.Management.Dac",
"Microsoft.SqlServer.Management.DacEnum",
"Microsoft.SqlServer.Management.Utility"


foreach ($asm in $assemblylist)
{
    $asm = [Reflection.Assembly]::LoadWithPartialName($asm)
}

#Load 'sqlps' Module so we can use the Provider
if (-not(Get-Module -name sqlps)) { 
	if(Get-Module -ListAvailable | Where-Object { $_.name -eq "sqlps" }) { 
		Import-Module -Name sqlps -DisableNameChecking
	} else { 
		Throw "SQL Server 'sqlps' module is not available" 
	} 
}