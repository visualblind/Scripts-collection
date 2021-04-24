<#
    .SYNOPSIS
		Initialize-ISqlPS2008
	.DESCRIPTION
		Sets up the PowerShell Console for use with SQL Server 
	.EXAMPLE
		PS> .\Initialize-ISqlPS2008
	.NOTES
		Adapted from Microsoft SQL Server Shell startup profile
#>

Write-Verbose "Initializing SQL Server 2008 PowerShell environment..."
Write-Verbose "Setting SQLPS registry and path variables..."

$sqlpsreg = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.SqlServer.Management.PowerShell.sqlps"

if (Get-ChildItem $sqlpsreg -ErrorAction "SilentlyContinue") {
	Throw "SQL Server Powershell is not installed."
} else {
	$item = Get-ItemProperty $sqlpsreg
	$sqlpsPath = [System.IO.Path]::GetDirectoryName($item.Path)
}

# Preload the assemblies
Write-Verbose "Pre-loading SQL Server assemblies..."
$assemblylist =
"Microsoft.SqlServer.Smo",
"Microsoft.SqlServer.Dmf",
"Microsoft.SqlServer.SqlWmiManagement",
"Microsoft.SqlServer.ConnectionInfo",
"Microsoft.SqlServer.SmoExtended",
"Microsoft.SqlServer.Management.RegisteredServers",
"Microsoft.SqlServer.Management.Sdk.Sfc",
"Microsoft.SqlServer.SqlEnum",
"Microsoft.SqlServer.RegSvrEnum",
"Microsoft.SqlServer.WmiEnum",
"Microsoft.SqlServer.ServiceBrokerEnum",
"Microsoft.SqlServer.ConnectionInfoExtended",
"Microsoft.SqlServer.Management.Collector",
"Microsoft.SqlServer.Management.CollectorEnum"

foreach ($asm in $assemblylist) {
	Add-Type -AssemblyName $asm
}

Write-Verbose "Set variables that the provider expects (mandatory for the SQL provider)..."
Set-Variable -scope Global -name SqlServerMaximumChildItems -Value 0
Set-Variable -scope Global -name SqlServerConnectionTimeout -Value 30
Set-Variable -scope Global -name SqlServerIncludeSystemObjects -Value $false
Set-Variable -scope Global -name SqlServerMaximumTabCompletion -Value 1000

Write-Verbose "Change SQL Server path to top of the path stack..."
$currPath = get-location
if ($currPath.Path -ne $sqlpsPath) {
	Push-Location
	Set-Location $sqlpsPath
	Pop-Location
} 

Write-Verbose "Optionally load the snapins, type data, and format data if they are not already loaded..."
$Error.Clear() 
Get-PSSnapin SqlServerCmdletSnapin100 -ErrorAction SilentlyContinue
if($Error.Count -ne 0) {
	Add-PSSnapin SqlServerCmdletSnapin100
}

$Error.Clear() 
Get-PSSnapin SqlServerProviderSnapin100 -ErrorAction SilentlyContinue
if($Error.Count -ne 0) {
	Add-PSSnapin SqlServerProviderSnapin100
}

Update-TypeData -PrependPath SQLProvider.Types.ps1xml -ErrorAction SilentlyContinue
Update-FormatData -PrependPath SQLProvider.Format.ps1xml -ErrorAction SilentlyContinue

Write-Host -ForegroundColor Yellow 'SQL Server Powershell extensions are loaded.'
Write-Host -ForegroundColor Yellow '  For more information, type "get-help SQLServer".' 
Write-Host
Set-Location SQLSERVER:\