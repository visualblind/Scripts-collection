<#
	.SYNOPSIS
		Get-ISqlFailedJobs
	.DESCRIPTION
		List failed SQL Server jobs using SMO
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlFailedJobs -serverInstance MyServer
	.INPUTS
	.OUTPUTS
		List failed jobs
	.NOTES
		Adapted from Jakob Bindslet script
	.LINK
#> 

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\sql2012])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "List failed SQL Server jobs using SMO..."

		$server = new-object Microsoft.SqlServer.Management.Smo.server $serverInstance

		$results = @()
		$reasons = @()

		$jobs = $server.jobserver.jobs | where-object {$_.isenabled}

		# Process all SQL Agent Jobs looking for failed jobs based on the last run outcome
		foreach ($job in $jobs) {
			[int]$outcome = 0
			[string]$reason = ""

			# Did the job fail completely?
			if ($job.LastRunOutcome -eq "Failed") {
				$outcome++
				$reasons += "Job failed: " + $job.name + " Result: " + $job.LastRunOutcome

				# Did any of the steps fail?
				foreach ($jobStep in $job.jobsteps) {
					if ($jobStep.LastRunOutcome -ne "Succeeded") {
						$outcome++
						$reasons += "Step failed: " + $jobStep.name + " Result: " + $jobStep.LastRunOutcome
					}
				}
			}

			if ($outcome -gt 0) {
				$jobFailure = New-Object -TypeName PSObject -Property @{
					name = $job.name
					lastrundate = $job.lastrundate
					lastrunoutcome = $reasons
				}
				$results += $jobFailure
			}
		}

		Write-Output $results
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