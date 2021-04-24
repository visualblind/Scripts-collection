<#
	.SYNOPSIS
		Set-PowerPlan
	.DESCRIPTION
		The POWERCFG.EXE utility requires GUIDS when changing a power plan.This simple script 
		simplies changing plans using plan names like "Balanced" or "Power Saver" instead.
		To get the list of power plans on your computer execute 'powercfg -l'
	.PARAMETER plan
		Set to "High Performance" by default
	.EXAMPLE
		.\Set-PowerPlan -Plan High Performance
	.INPUTS
	.OUTPUTS
	.NOTES
		SQL Server runs most effeciently on 'High Performance' plan option.
		Run this script on the actual server to change the Power Plan option.
	.LINK
		http://www.wintellect.com/CS/blogs/jrobbins/archive/tags/PowerShell/default.aspx
#>

param (
	[string]$plan = "High Performance"
)

try {
	# The regular expression to pull out the GUID for the specified plan.
	$planRegEx = "(?<PlanGUID>[A-Fa-f0-9]{8}-(?:[A-Fa-f0-9]{4}\-){3}[A-Fa-f0-9]{12})" + ("(?:\s+\({0}\))" -f $Plan)

	$planList = powercfg -l

	# If the plan appears in the list...
	if ( ($planList | Out-String) -match $planRegEx ) {
		# Pull out the matching GUID and capture both stdout and stderr.
		$result = powercfg -s $matches["PlanGUID"] 2>&1

		# If there were any problems, show the error.
		if ( $LASTEXITCODE -ne 0) {
			Write-Output $result
		} else {
			Write-Output ("The requested power scheme '{0}' has been set." -f $Plan)
		}
	} else {
		Write-Output ("The requested power scheme '{0}' does not exist on this machine." -f $Plan)
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