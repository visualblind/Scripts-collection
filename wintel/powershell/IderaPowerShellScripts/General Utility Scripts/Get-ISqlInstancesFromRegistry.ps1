<#
	.SYNOPSIS
		Get-ISqlInstancesFromRegistry
	.DESCRIPTION
		Get SQL Server instances from remote registry
	.PARAMETER serverName
		Get server name
	.EXAMPLE
		PS> .\Get-ISqlInstancesFromRegistry -serverName Server01
	.NOTE
		On a 64-bit machine the registery read depends on the version of PSP you are running:
		  	On x86 version of PSP - it reads from Wow6432Node
			On x64 version of PSP - it reads from main registry
	.LINK
		To provide remote access to the Registry, consult this KB article:
		http://support.microsoft.com/kb/314837
#>

param (
	[string]$serverName = "$(Read-Host 'Server Name [e.g. server01]')"
)

try {
	$instances = @()
	$regkeyHive = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $serverName)
	$regkeySQLServer = $regkeyHive.OpenSubKey('SOFTWARE\Microsoft\Microsoft SQL Server')
	$installedInstances = $regkeySQLServer.GetValue('InstalledInstances')
	
	foreach ($i in $installedInstances)
	{
	    $regkeyInstNames = $regkeyHive.OpenSubKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL')
		$p = $regkeyInstNames.GetValue($i)

		$regkeySetup = 'SOFTWARE\Microsoft\Microsoft SQL Server\' + $p + '\Setup'
	    $regkeySetupProps = $regkeyHive.OpenSubKey($regkeySetup)

		$instance = New-Object -TypeName PSObject -Property @{
			Edition = $regkeySetupProps.GetValue('Edition')
			SP = $regkeySetupProps.GetValue('SP')
			SQLPath = $regkeySetupProps.GetValue('SQLPath')
			SqlProgramDir = $regkeySetupProps.GetValue('SqlProgramDir')
			Version = $regkeySetupProps.GetValue('Version')
		}
		$instances += $instance 
	}
	Write-Output $instances
}
catch {
	Write-Error $Error[0]
	$err = $_.Exception
	while ( $err.InnerException ) {
		$err = $err.InnerException
		Write-Output $err.Message
	}
}