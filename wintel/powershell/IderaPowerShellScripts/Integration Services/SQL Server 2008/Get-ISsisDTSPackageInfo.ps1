<#
	.SYNOPSIS
		Get-ISsisDTSPackageInfo
	.DESCRIPTION
		Get SQL Server Integration Server File System Package Information
	.PARAMETER server
		Integration Services server
	.EXAMPLE
		.\Get-ISsisDTSPackageInfo -server Server01
	.INPUTS
	.OUTPUTS
		File system packages		
	.NOTES
		Compatible with SQL Server 2008
	.LINK
#>

param (
	[string]$server = "$(Read-Host 'Server Instance' [e.g. server01])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Dts.Runtime")
}
process {
	try {
		Write-Verbose "Get SQL Server Integration Server File System package information..."

		$app = new-object ("Microsoft.SqlServer.Dts.Runtime.Application") 
		$fsPackages = $app.GetDtsServerPackageInfos("File System", $server)
		if ($fsPackages.count -eq 0) {
			Write-Error "No File System packages are defined for $server"
		} 

		Write-Output $fsPackages
	}
	catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
}