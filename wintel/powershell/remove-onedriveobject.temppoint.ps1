<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.148
	 Created on:   	3/14/2019 10:54 AM
	 Created by:   	visualblind
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

<#
	.SYNOPSIS
		Test text for the synopsis
	
	.DESCRIPTION
		This will effectively remove the Microsoft OneDrive object in the navigation pane of Windows File Explorer (left-hand side).
		Supported on Windows 8/8.1/10
	
	.PARAMETER Enable
		A description of the Enable parameter.
	
	.PARAMETER Disable
		A description of the Disable parameter.
	
	.EXAMPLE
				PS C:\> Remove-OneDriveObject
	
	.NOTES
		Additional information about the function.
	
	.LINK
		https://sysinfo.io/scripts/wintel/powershell/online-help/remove-onedriveobject
#>
function Remove-OneDriveObject
{
	[CmdletBinding(HelpUri = 'https://sysinfo.io/scripts/wintel/powershell/online-help/remove-onedriveobject',
				   SupportsShouldProcess = $true)]
	param
	(
		[switch]$Enable,
		[switch]$Disable
	)
	
	if ($pscmdlet.ShouldProcess("Target", "Operation"))
	{
		#TODO: Place script here
	}
}
