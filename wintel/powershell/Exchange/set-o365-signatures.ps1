<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.155
	 Created on:   	11/29/2018 12:45 AM
	 Created by:   	visualblind
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#set folder location for files, the folder must already exist

$save_location = '\\server\sigs\o365\'
$email_domain = '@website.org.uk'

#connect to O365 tenant
$Cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic –AllowRedirection
Import-PSSession $Session

#Get a list of all the filenames in the target folder
$sig_files = Get-ChildItem -Path $save_location

#Now push the html to the users signature
foreach ($item in $sig_files)
{
	
	$user_name = $($item.Basename)
	$filename = $save_location + $($item.Basename) + ".htm"
	
	Write-Host "Now attempting to set signature for " $user_name
	set-mailboxmessageconfiguration -identity $user_name -signaturehtml (get-content $filename) -autoaddsignature $true
}

#disconnect O365 connection
get-PSSession | remove-PSSession
pause
