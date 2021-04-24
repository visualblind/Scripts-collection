Function Delete-VMSnapshots 
{
	<#
			.SYNOPSIS
			Deletes all virtual machine snapshots in a VMWare vSphere (vCenter) environment older/greater than an integer number of days specified by using the parameter daysold parameter described below.
			Best practices for using snapshots in the vSphere environment


			.DESCRIPTION
			Best practices for using snapshots in the vSphere environment

			.PARAMETER UserName
			Specify a user to enumerate. The default is the current user context.

			.PARAMETER keywords
			Specify a keyword or array of keywords to use in file searches. 
    
			.EXAMPLE
			Conduct enumeration with a keyword for file searches. 
    
			Invoke-WindowsEnum -keyword "putty"
    
			.EXAMPLE
			Conduct enumeration with a username and keyword
    
			Invoke-WindowsEnum -User "sandersb"

			.LINK
    

	#>
		
	Param(

		[Parameter(Mandatory = $false,Position = 0)]
		[string]$servername = $env:COMPUTERNAME,

		[Parameter(Mandatory = $false,Position = 1)]
		[string]$username = "$env:USERDOMAIN\$env:USERNAME",

		[Parameter(Mandatory = $false,Position = 2)]
		[string]$password = '',

		[Parameter(Mandatory = $false)]
		[int]$daysold = 3,

		[Parameter(Mandatory = $false)]
		[string]$logpath = 'E:\Scripts\Script_Logs',

		[Parameter(Mandatory = $false)]
		[switch]$whatif
	)

	#$servername = "ServerName"
	#$username = "UserName"
	#$password = "password"
	#Get-VM | Get-Snapshot -VM *
    

	#Start PS transcription
	Start-Transcript

	# Load VMware.VimAutomation.Core module
	if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue)) 
	{
		Add-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction Stop
	}

	if ([string]::IsNullOrWhiteSpace($servername)) 
	{
		Write-Host -Object 'servername not specified'
		$servername = Read-Host -Prompt 'Enter the servername'
	}


	if ([string]::IsNullOrWhiteSpace($password)) 
	{
		$credentials = Get-Credential
		$username = $credentials.UserName
		$password  = $credentials.GetNetworkCredential().Password
	}
    
	#Disconnect-VIServer ServerName
	# Connect to vSphere vCenter Server
	Try
	{
		Connect-VIServer -Server $servername -User $username -Password $password
	}
	Catch
	{
		Write-Host -Object 'Failed Connecting to VSphere Server.'
		#Send-MailMessage -From "" -To "server@domain.com" -Subject "Unable to Connect to VSphere to clean snapshots" -Body `
		# "The powershell script is unable to connect to host your.vmware.server. Please investigate." -SmtpServer "smtp.server.com"
		Break
	}
 
	# Variables
	$date = Get-Date -Format MMddhhyyyy

 
	# Verify the log folder exists.
	If(!(Test-Path $logpath))
	{
		Write-Host -Object 'Log path not found, creating folder.'
		New-Item $logpath -Type Directory
	}

	# Get all snapshots older than the specified parameter "$olderthan"
	$snaps = Get-Snapshot -VM * | Where-Object -FilterScript {
		$_.Created -lt (Get-Date).AddDays(-$daysold) 
	}
	$snapshotlist = $snaps | Select-Object -Property VM, Name, @{
		Name       = 'SizeGB'
		Expression = {
			[math]::Round($_.SizeGB)
		}
	}, @{
		Name       = 'Age'
		Expression = {
			((Get-Date)-$_.Created).Days
		}
	}


	If(($snaps) -ne $null)
	{
		Write-Host -Object "Snapshots older than $daysold days before cleanup:"
		Write-Output -InputObject $snapshotlist | Tee-Object -FilePath $logpath\Snapshots_$date.txt -Append
		#Remove snapshots
		$snaps | Remove-Snapshot -Confirm:$false

		#Write-Output "Snapshots existing before cleanup" | Out-File $logpath\Snapshots_$date.txt -Append
		#Write-Output $snapshotlist | Out-File $logpath\Snapshots_$date.txt -Append
	}
 
	# Get all snapshots older than the specified parameter "$olderthan"
	$snaps = Get-Snapshot -VM * | Where-Object -FilterScript {
		$_.Created -lt (Get-Date).AddDays(-$daysold) 
	}
	$snapshotlist = $snaps | Select-Object -Property VM, Name, @{
		Name       = 'SizeGB'
		Expression = {
			[math]::Round($_.SizeGB)
		}
	}, @{
		Name       = 'Age'
		Expression = {
			((Get-Date)-$_.Created).Days
		}
	}

	# Check to make sure that all snapshots have been cleaned up.
	If(($snaps) -ne $null)
	{
		Write-Host -Object 'Snapshots existing after cleanup:'
		Write-Output -InputObject $snapshotlist | Tee-Object -FilePath $logpath\Snapshots_$date.txt -Append
		# Write-Output $snapshotlist | Out-File $logpath\Snapshots_$date.txt -Append
	}
	Else 
	{
		Write-Output -InputObject 'All snapshots have been cleaned up.' | Tee-Object -FilePath $logpath\Snapshots_$date.txt -Append
	}





	# Send snapshot log to email.
	$emailbody = (Get-Content -Path $logpath\Snapshots_$date.txt | Out-String)
	Send-MailMessage -From 'server@domain.com' -To 'user@domain.com.com' -Subject 'Daily vSphere snapshot cleanup report' -Body $emailbody -SmtpServer 'smtp.server.com'
 
	# Exit VIM server session.
	Try
	{
		Disconnect-VIServer -Server tstbpvvc02 -Confirm:$false
	}
	Catch
	{
		Write-Host -Object 'Failed disconnecting from VSphere.'
		# Send-MailMessage -From "server@domain.com" -To "user@domain.com" -Subject "Disconnection from VSphere Failed" -Body `
		#"The powershell script is unable to disconnect from VSphere. Please manually disconnect" -SmtpServer "smtp.server.com"
	}

	# Cleanup Snapshot logs older than 30 days.
	Get-ChildItem -Path $logpath -Recurse -Force |
	Where-Object -FilterScript {
		!$_.PSIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)
	} |
	Remove-Item -Force

	Clear-Variable -Name daysold, logpath, username, servername, password, whatif -ErrorAction SilentlyContinue

	#Stop transcript
	Stop-Transcript
}
