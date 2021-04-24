<#
	.SYNOPSIS
		Enable-ISqlTCPProtocol
	.DESCRIPTION
		Enable the TCP protocol
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Enable-ISqlTCPProtocol -serverInstance MyServer\SQL2012
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
		
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")
}
process {
	try {
		$wmi = new-object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer

		$server = $serverInstance.ToUpper().Split("\")[0]
		$instance = $serverInstance.ToUpper().Split("\")[1]

        if($instance -eq $null) {
			$instance = "MSSQLSERVER"
		}

		$ProtocolUri = "ManagedComputer[@Name='" + $server + "']/ServerInstance[@Name='"+ $instance + "']/ServerProtocol"
		$tcp = $wmi.getsmoobject($ProtocolUri + "[@Name='Tcp']")

		# Enable the TCP protocol on the default instance.
		$Tcp.IsEnabled = $true
		$Tcp.Alter()
		
		Write-Output $Tcp
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