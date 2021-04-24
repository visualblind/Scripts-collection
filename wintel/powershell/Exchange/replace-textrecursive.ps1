<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.148
	 Created on:   	11/21/2018 2:16 AM
	 Created by:   	visualblind
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

$configFiles = Get-ChildItem "C:\Users\User1\Directory" *.txt -Recurse
foreach ($file in $configFiles)
{
	(Get-Content $file.PSPath) |
	Foreach-Object {
		$_ -replace
		"OldText", "NewText"
	} |
	Set-Content $file.PSPath
}