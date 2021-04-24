<#
	.SYNOPSIS
		Get-ISsisDTSPackageInfo
	.DESCRIPTION
		Get SQL Server Integrarion Server MSDB Package Information
	.PARAMETER server
		Integration Services server
	.EXAMPLE
		.\Get-ISsisDTSPackageInfo -server Server01
	.INPUTS
	.OUTPUTS
				
	.NOTES
		Only works on SQL2008 and above
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
		Write-Verbose "Get SQL Server Integration Server MSDB package information..."
		
		$app = new-object ("Microsoft.SqlServer.Dts.Runtime.Application") 

		$msdbPackages = $app.GetPackageInfos("\\", $server, $null, $null)
		if ($msdbPackages.count -eq 0) {
			Write-Error "No MSDB packages are defined for $server"
		} 
		
		$packages = @()
		
		Write-Verbose "The following MSDB packages are configured for $server :"
		foreach ($pkg in $msdbPackages) {
			if ($pkg.Flags -eq "Folder") {
				#recurse next level
				$morePackages = $app.GetPackageInfos("\\" + $pkg.Name, $server, $null, $null)
				$package = $morePackages | Where-Object {$_.Flags -ne "Folder"} | Select Name, Description, CreationDate, PackageDataSize
			} else {
				$package = $pkg | Select Name, Description, CreationDate, PackageDataSize
			}
			$packages += $package
		}
		
		Write-Output $packages
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