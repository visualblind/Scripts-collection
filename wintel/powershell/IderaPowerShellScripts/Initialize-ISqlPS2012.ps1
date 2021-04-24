<#
.SYNOPSIS
   Initialize-ISqlPS2012
.DESCRIPTION
   Initialize SQL Server 2012 Shell
.EXAMPLE
   Initialize-ISqlPS2012
#>

$sqlpsreg = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.SqlServer.Management.PowerShell.sqlps110"
$item = Get-ItemProperty $sqlpsreg
$powershelldir = [System.IO.Path]::GetDirectoryName($item.Path)
$smoarray =
"Microsoft.SqlServer.Management.Common",
"Microsoft.SqlServer.Dmf ",
"Microsoft.SqlServer.Smo",
"Microsoft.SqlServer.Instapi ",
"Microsoft.SqlServer.SqlWmiManagement ",
"Microsoft.SqlServer.SmoExtended ",
"Microsoft.SqlServer.ConnectionInfo ",
"Microsoft.SqlServer.SqlTDiagM ",
"Microsoft.SqlServer.SString ",
"Microsoft.SqlServer.Management.Sdk.Sfc ",
"Microsoft.SqlServer.SqlEnum ",
"Microsoft.SqlServer.RegSvrEnum ",
"Microsoft.SqlServer.WmiEnum ",
"Microsoft.SqlServer.Management.DacEnum",
"Microsoft.SqlServer.ServiceBrokerEnum ",
"Microsoft.SqlServer.Management.Collector ",
"Microsoft.SqlServer.Management.CollectorEnum",
"Microsoft.SqlServer.ConnectionInfoExtended ",
"Microsoft.SqlServer.Management.RegisteredServers ",
"Microsoft.SqlServer.Management.Dac",
"Microsoft.SqlServer.Management.Utility"

foreach ($assembly in $smoarray) {
	$assembly = [Reflection.Assembly]::LoadWithPartialName($assembly)
}

#Load 'sqlps' Module so we can use the Provider
if (-not(Get-Module -name sqlps)) { 
	if(Get-Module -ListAvailable | Where-Object { $_.name -eq "sqlps" }) { 
		Import-Module -Name sqlps -DisableNameChecking
	} else { 
		Throw "SQL Server 2012 'sqlps' module is not available" 
	} 
}