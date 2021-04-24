<#
    .SYNOPSIS
		Add-ISqlSvcAcctToPerfVolMaint

	.DESCRIPTION
		Adds the SQL Server service account for given instance to the local security privilege. 
		Must be run as Administrator in UAC mode.
		Returns a boolean $true if it was successful, $false if it was not.

		Uses the built in secedit.exe to export the current configuration then re-import
		the new configuration with the provided login added to the appropriate privilege.
	
		The pipeline object must be passed in a DOMAIN\User format as string.
	
		This function supports the -WhatIf, -Confirm, and -Verbose switches.

	.PARAMETER serverInstance
		SQL Server instance

	.EXAMPLE
		PS> .\Add-ISqlSvcAcctToPerfVolMaint -serverInstance Server01\SQL2012

	.NOTES
		The temporary files should be removed at the end of the script. 
		Local Policy changes will be applied on a delay. Wait a couple of minuted to the 
		privileges to be applied by the operating system.

		If there is error - two files may remain in the $TemporaryFolderPath (default $env:USERPFORILE)
			UserRightsAsTheyExist.inf
			ApplyUserRights.inf

		These should be deleted if they exist, but will be overwritten if this is run again.

		Attributed to: Kyle Neier
		Blog: http://sqldbamusings.blogspot.com
#>

#Specify the default parameterset
[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")
}
process {
	function Remove-TempFiles {
		#Evaluate whether the ApplyUserRights.inf file exists
		if (Test-Path $TemporaryFolderPath\ApplyUserRights.inf) {
			#Remove it if it does
			Write-Verbose "Removing $TemporaryFolderPath`\ApplyUserRights.inf"
			Remove-Item $TemporaryFolderPath\ApplyUserRights.inf -Force -WhatIf:$false
		}

		#Evaluate whether the UserRightsAsTheyExists.inf file exists
		if (Test-Path $TemporaryFolderPath\UserRightsAsTheyExist.inf) {
			#Remove it if it does.
			Write-Verbose "Removing $TemporaryFolderPath\UserRightsAsTheyExist.inf"
			Remove-Item $TemporaryFolderPath\UserRightsAsTheyExist.inf -Force -WhatIf:$false
		}
	}

	try {
		Write-Verbose "Get SQL Server object..."

		$serverName = $serverInstance.Split("\")[0]
		$instance = $serverInstance.Split("\")[1]
		
		#Get SQL service object
		if ($instance -eq "") {
			$service = Get-Service "MSSQLServer" -ErrorAction SilentlyContinue
		} else {
			$service = Get-Service "MSSQL*$instance" -ErrorAction SilentlyContinue
		}

		$server = New-Object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $serverName           

		$DomainAccount = ($server.Services | Where-Object {$_.Name -eq $service.Name} | Select ServiceAccount).ServiceAccount

		$Privilege = "SeManageVolumePrivilege"
		$TemporaryFolderPath = $env:USERPROFILE

		Write-Verbose "Adding $DomainAccount to $Privilege"
		Write-Verbose "Verifying that export file does not exist."

		#Clean Up any files that may be hanging around.
		Remove-TempFiles

		Write-Verbose "Executing secedit and sending to $TemporaryFolderPath"

		#Use secedit (built in command in windows) to export current User Rights Assignment
		$SeceditResults = secedit /export /areas USER_RIGHTS /cfg $TemporaryFolderPath\UserRightsAsTheyExist.inf 

		#Make certain export was successful
		if ($SeceditResults[$SeceditResults.Count-2] -eq "The task has completed successfully.") {
			Write-Verbose "Secedit export was successful, proceeding to re-import"

			#Save out the header of the file to be imported
			Write-Verbose "Save out header for $TemporaryFolderPath`\ApplyUserRights.inf"

			"[Unicode]
			Unicode=yes
			[Version]
			signature=`"`$CHICAGO`$`"
			Revision=1
			[Privilege Rights]" | Out-File $TemporaryFolderPath\ApplyUserRights.inf -Force -WhatIf:$false

			#Bring the exported config file in as an array
			Write-Verbose "Importing the exported secedit file."
			$SecurityPolicyExport = Get-Content $TemporaryFolderPath\UserRightsAsTheyExist.inf

			#enumerate over each of these files, looking for the Perform Volume Maintenance Tasks privilege
			$isFound = $false
			foreach ($line in $SecurityPolicyExport) {
				if ($line -like "$Privilege`*") {
					Write-Verbose "Line with the $Privilege found in export, appending $DomainAccount to it"
					#Add the current domain\user to the list
					$line = $line + ",$DomainAccount"
					#output line, with all old + new accounts to re-import
					$line | Out-File $TemporaryFolderPath\ApplyUserRights.inf -Append -WhatIf:$false
					$isFound = $true
				}
			}

			if ($isFound -eq $false) {
				#If the particular command we are looking for can't be found, create it to be imported.
				Write-Verbose "No line found for $Privilege - Adding new line for $DomainAccount"
				"$Privilege`=$DomainAccount" | Out-File $TemporaryFolderPath\ApplyUserRights.inf -Append -WhatIf:$false
			}

			#Import the new .inf into the local security policy.
			if ($pscmdlet.ShouldProcess($DomainAccount, "Add account to Local Security with $Privilege privilege?")) {
				# yes, Run the import:
				Write-Verbose "Importing $TemporaryfolderPath\ApplyUserRighs.inf"
				$SeceditApplyResults = SECEDIT /configure /db secedit.sdb /cfg $TemporaryFolderPath\ApplyUserRights.inf

				#Verify that update was successful (string reading, blegh.)
				if($SeceditApplyResults[$SeceditApplyResults.Count-2] -eq "The task has completed successfully.") {
					#Success, return true
					Write-Verbose "Import was successful."
					Write-Output $true
				} else {
					#Import failed for some reason
					Write-Verbose "Import from $TemporaryFolderPath\ApplyUserRights.inf failed."
					Write-Output $false
					Write-Error -Message "The import from$TemporaryFolderPath\ApplyUserRights using secedit failed. Full Text Below: $SeceditApplyResults)"
				}
			}
		} else {
			#Export failed for some reason.
			Write-Verbose "Export to $TemporaryFolderPath\UserRightsAsTheyExist.inf failed."
			Write-Output $false
			Write-Error -Message "The export to $TemporaryFolderPath\UserRightsAsTheyExist.inf from secedit failed. Full Text Below: $SeceditResults)"
		}

		Write-Verbose "Cleaning up temporary files that were created."
		#Delete the two temp files we created.
		Remove-TempFiles

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