<#
	.SYNOPSIS
		Get-ISqlFirewallRule
	.DESCRIPTION
		List TCP and UDP firewall rules that exclude System rules matching Display Name wildcard
	.PARAMETER dn
		Rule Display Name
	.PARAMETER isOutgrid
		Output as grid (0,1)
	.EXAMPLE Match on Wildcard and output as grid
		.\Get-ISqlFirewallRule -dn *SQL* -isOutgrid 1
	.EXAMPLE All
		.\Get-ISqlFirewallRule -dn * -isOutgrid 0
	.INPUTS
	.OUTPUTS
		Outgrid view or standard console output
	.NOTES
	.LINK
#>

param
(
	[string]$dn = "$(Read-Host 'Firewall rule display name [e.g. * for all or wildcards like *SQL*]')",
	[int]$isOutgrid = "$(Read-Host 'Output as grid [e.g. 0=False, 1=True]')"
)

begin {
	try {
		if (-not (Get-Module -Name "NetSecurity")) {
			Import-Module NetSecurity
		}
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
process {
	try {
		$Firewall = @()
		$Rules = Get-NetFirewallRule
		foreach ($App in Get-NetFirewallApplicationFilter | Select Program, InstanceID)
		{
			$InstanceID = ($App | Format-Table -Property InstanceID -HideTableHeaders | Out-String).Trim()
			$Rule = $Rules | Where { $_.InstanceID -eq $InstanceID }
			$DisplayName = ($Rule.DisplayName + "").Trim()
			If ($DisplayName -like $dn ) {
				$Program = ($App | Format-Table -Property Program -HideTableHeaders | Out-String).Trim()
				$Ports = Get-NetFirewallPortFilter | Where { $_.InstanceID -eq $InstanceID}
		
				If ($Ports.Protocol -eq "TCP" -or $Ports.Protocol -eq "UDP" -or $Program -ne "Any") {
					$Firewall += New-Object -TypeName PSObject -Property @{
						DisplayName = $DisplayName
						RuleGroup = $Rule.RuleGroup
						Direction = $Rule.Direction
						Action = $Rule.Action
						Enabled = $Rule.Enabled
						Protocol = $Ports.Protocol
						LocalPort = $Ports.LocalPort
						RemotePort = $Ports.RemotePort
						RemoteAddress = (Get-NetFirewallAddressFilter | where { $_.InstanceID -eq $InstanceID}).RemoteAddress
						Program = $Program
						InstanceID = $InstanceID
					} 
				}
			}
		}
		
		if ($isOutgrid -eq 1) {
			$Firewall | Select -Property DisplayName, RuleGroup, Direction, Action, Enabled, Protocol, LocalPort, RemotePort, RemoteAddress, Program, InstanceID | Out-GridView
		} else {
			$Firewall |	Format-List -Property DisplayName, RuleGroup, Direction, Action, Enabled, Protocol, LocalPort, RemotePort, RemoteAddress, Program, InstanceID
		}
		
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
