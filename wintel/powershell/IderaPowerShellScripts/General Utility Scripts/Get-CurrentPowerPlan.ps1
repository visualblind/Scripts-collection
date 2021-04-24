<#
	.SYNOPSIS
		Get-CurrentPowerPlan
	.DESCRIPTION
		Retrieve computer powerplan
	.PARAMETER computer
		Computer name
	.EXAMPLE
		.\Get-CurrentPowerPlan -computer Server01
	.INPUTS
	.OUTPUTS
		Current power plan for specified computer identifed as High performance or not
	.NOTES
		Important for SQL Server since this can impact CPU performance
		Can fail with FileNotFoundException if Windows thinks a custom Power resource is installed but it's not
	.LINK
		http://www.englishtosql.com/english-to-sql-blog/2011/5/2/checking-windows-power-plans-with-powershell.html
#> 

param (
	[string]$computer = "$(Read-Host 'Computer [e.g. server01]')"
)

Try {
	# Grab the windows version so we know whether to query for the power plan or not
	$winver = gwmi -Class win32_OperatingSystem -ComputerName $Computer

	# Version 6x is Win7/2008 powerplan not relevant below that
	if ($winver.Version.substring(0,1) -gt 5) {
		$plan = Get-WmiObject -Class win32_Powerplan -Computername $Computer -Namespace root\CIMV2\power -Filter "isActive='true'" 
		$regex = [regex]"{(.*?)}$" 
		$planGuid = $regex.Match($plan.instanceID.Tostring()).groups[1].value 
		$PlanType = powercfg -query $planGuid

		# Grab just the first record which has the actual plan being used
		# From that record just grab the actual plan type which is enclosed in parenthesis            
		$PlanType = $PlanType[0].Substring($PlanType[0].LastIndexOf("(")+1) -replace "\)", ""

		# If the plan isn't high performance let's make it stand out
		if ($PlanType -ne "High performance") { 
			Write-Output "$Computer : $PlanType [NOT HIGH PERFORMANCE]"
		} else { 
			Write-Output "$Computer : $PlanType [HIGH PERFORMANCE]" 
		}
	} else {
		# If the Windows version doesn't support power plans just let us know
		Write-Output "$Computer : This computer doesn't support power plans"
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