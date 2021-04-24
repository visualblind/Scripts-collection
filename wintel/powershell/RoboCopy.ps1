<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.155
	 Created on:   	12/3/2018 11:00 AM
	 Created by:   	visualblind
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
$getUserMsg = "Username of drive you're archiving"
$username = read-host -prompt $getUserMsg # TODO: Get list of users from file or AD lookup
$source = "C:\Workspaces\Sandbox\Archive folder\$username"
$archive = "C:\Workspaces\Sandbox\Archive folder\archive\$username"
$roboExe = "robocopy.exe"
$roboOptions = @("/s", "/move", "/NFL", "/NDL", "/NJH", "/NJS", "/nc", "/ns", "/np")
$bothExistMsg = "Source & archive locations both exist"
$archiveMsg = "Home drive of '{0}' complete"
$srcNotExistMsg = "User drive doesn't exist"

$roboParams = @($source, $archive)
$roboParams += $roboOptions
if (test-path $source)
{
	if (!(test-path $archive))
	{
		New-Item $archive -ItemType Directory
		& $roboExe $roboParams
		Write-Host ""
		Write-Host ("$archiveMsg" -f $username)
	}
	else
	{
		Write-Host $bothExistMsg
	}
}
else
{
	Write-Host $srcNotExistMsg
}


