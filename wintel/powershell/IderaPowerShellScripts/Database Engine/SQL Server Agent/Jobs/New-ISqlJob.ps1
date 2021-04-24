<#
	.SYNOPSIS
		New-ISqlJob
	.DESCRIPTION
		Create a daily SQL job to call a powershell script
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER server 
		server\instance
	.PARAMETER jobName 
		Job name
	.PARAMETER taskDesc 
		Job description
	.PARAMETER category 
		Job category
	.PARAMETER hrSched 
		Hour in military time
	.PARAMETER minSched 
		Minute 
	.PARAMETER psScript 
		Full path of PowerShell script <path\script.ps1>
	.EXAMPLE
		.\New-ISqlJob -server MyServer -jobname MyJob 
	       -taskDesc Perform something... -category Backup Job 
		   -hrSchedule 2 -psScript C:\TEMP\test.ps1 -minSchedule 0
	.INPUTS
	.OUTPUTS
	.NOTES
		Adapted from an Allen White script
	.LINK
#> 

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')",
	[string]$jobname = "$(Read-Host 'Job Name [e.g. PowerShellJob]')",
	[string]$taskDesc = "$(Read-Host 'Task Description [e.g. Perform some task]')",
	[string]$psScript = "$(Read-Host 'PS Script to Call [e.g. C:\TEMP\test.ps1]')",
	[int]$hrSchedule = "$(Read-Host 'Scheduled Hour [e.g. 2]')",
	[int]$minSchedule = "$(Read-Host 'Scheduled Minute [e.g. 0]')"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')
}
process {
	try {
		Write-Verbose "Create a daily SQL job to call a powershell script..."

		$server = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		#Check if SQL Agent service is running for instance
		$instance = $serverInstance.Split("\")
		$serviceName = "SQL Server Agent (" + $instance[1] + ")"
		if (Get-Service -name $serviceName | Where-Object {$_.status -ne "running"}) {
			Throw "SQL Agent service is not running for selected $namesInstance"
		}

		# Instantiate an Agent Job object, set its properties, and create it
		Write-Verbose "Create SQL Agent job ..."
		$job = new-object Microsoft.SqlServer.Management.Smo.Agent.Job $namedInstance.JobServer, $jobName
		$job.Description = $taskDesc

		# Create will fail if job already exists
		#  so don't build the job step or schedule
		if (!$job.Create()) {
			# Create the step to execute the PowerShell script
			#   and specify that we want the command shell with command to execute script, 
			Write-Verbose "Create SQL Agent job step..."
			$jobStep = new-object Microsoft.SqlServer.Management.Smo.Agent.JobStep $job, 'Step 1'
			$jobStep.SubSystem = "CmdExec"
			$runScript = "powershell " + "'" + $psScript + "'"
			$jobStep.Command = $runScript
			$jobStep.OnSuccessAction = "QuitWithSuccess"
			$jobStep.OnFailAction = "QuitWithFailure"
			$jobStep.Create()

			# Alter the Job to set the target server and tell it what step should execute first
			Write-Verbose "Alter SQL Agent to use designated job step..."
			$job.ApplyToTargetServer($namedInstance.Name)
			$job.StartStepID = $jobStep.ID
			$job.Alter()

			# Create start and end timespan objects to use for scheduling
			# TIP: using PowerShell to create a .Net Timespan object
			Write-Verbose "Create timespan objects for scheduling the time for 2am..."
			$StartTS = new-object System.Timespan($hrSched, $minSched, 0)
			$EndTS = new-object System.Timespan(23, 59, 59)

			# Create a JobSchedule object and set its properties and create the schedule
			Write-Verbose "Create SQL Agent Job Schedule..."
			$jobSchedule = new-object Microsoft.SqlServer.Management.Smo.Agent.JobSchedule $job, 'Sched 01'
			$jobSchedule.FrequencyTypes = "Daily"
			$jobSchedule.FrequencySubDayTypes = "Once"
			$jobSchedule.ActiveStartTimeOfDay = $StartTS
			$jobSchedule.ActiveEndTimeOfDay = $EndTS
			$jobSchedule.FrequencyInterval = 1
			$jobSchedule.ActiveStartDate = get-date
			$jobSchedule.Create()

			Write-Output "SQL Agent Job: $jobName was created."
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