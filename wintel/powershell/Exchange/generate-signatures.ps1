<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.155
	 Created on:   	11/29/2018 12:20 AM
	 Created by:   	visualblind
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#import the active directory module which is needed for Get-ADUser
import-module activedirectory

#set folder location for files, the folder must already exist
$save_location = '\\server\sigs\'
$save_location2 = '\\server\sigs\o365\'

#$users = Get-ADUser -filter * -searchbase "OU=Office 365,DC=domain,DC=org,DC=uk" -Properties * | ? {$_.distinguishedname -notmatch 'OU=Students*'} | -Credential domain\administrator -Server company.org.uk
$users = Get-ADUser -filter * -searchbase "OU=Office 365,DC=domain,DC=org,DC=uk" -Properties * | Where-Object {
	$_.distinguishedname -notmatch 'OU=Students*'
}

foreach ($user in $users)
{
	$full_name = "$($user.GivenName) $($User.Surname)"
	$account_name = "$($User.sAMAccountName)"
	$job_title = "$($User.title)"
	$comp = "A Building , A Road, Timbuktu, AA1 0BB"
	$email = "$($User.emailaddress)"
	$phone = If ($User.telephoneNumber -gt 0)
	{
		"Ext." + "$($User.telephoneNumber)"
	}
	else
	{
		$phone = ""
	}
	$logo = "http://www.website.org.uk"
	
	#Construct and write the html signature file
	$output_file = $save_location + $account_name + ".htm"
	$output_file1 = $save_location + $User.userPrincipalName + ".htm"
	$output_file2 = $save_location2 + $User.mail + ".htm"
	Write-Host "Now attempting to create signature html file for " $full_name
	"<p span style=`"font-family:calibri;`"><table><tr><td><a href=`"http://www.website.org.uk`"><img src=`"iconsingle.jpg`"></img></a></td><td><font face=`"calibri`" size=`"3`"><b> $full_name </b><br></font><font face=`"calibri`" size=`"2`"> $job_title <br>A Building , A Road, Timbuktu, AA1 0BB<br>Tel: 01234 567890<br>$phone<br><a href=`"http://www.website.org.uk`">www.website.org.uk</a><br></font></td></table></span></p> " | Out-File $output_file
	"<p span style=`"font-family:calibri;`"><table><tr><td><a href=`"http://www.website.org.uk`"><img src=`"iconsingle.jpg`"></img></a></td><td><font face=`"calibri`" size=`"3`"><b> $full_name </b><br></font><font face=`"calibri`" size=`"2`"> $job_title <br>A Building , A Road, Timbuktu, AA1 0BB<br>Tel: 01234 567890<br>$phone<br><a href=`"http://www.website.org.uk`">www.website.org.uk</a><br></font></td></table></span></p> " | Out-File $output_file2
}
pause
