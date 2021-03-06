# Adds snap-ins to the current powershell session for Powershell for Amazon Web Services.
if (-not (Get-Module AWSPowerShell -ErrorAction SilentlyContinue)) 
	{
	Import-Module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1" > $null
	}

$Snapshots = Get-EC2Snapshot

foreach ($Snapshot in $Snapshots)
	{ 
	$Retention = ([DateTime]::Now).AddDays(-30)
	if ([DateTime]::Compare($Retention, $Snapshot.StartTime) -gt 0)
		{ 
		 Remove-EC2Snapshot -SnapshotId $Snapshot.SnapshotId -Force
         write-host "Removed snapshot: " $Snapshot.SnapshotId
		} 
	}