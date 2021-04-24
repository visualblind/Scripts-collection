<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.148
	 Created on:   	3/14/2019 10:54 AM
	 Created by:   	Travis Runyard
	 Organization: 	Sysinfo.io
	 Filename:     	Remove-OneDriveObject.ps1
	===========================================================================
#>

<#
	.SYNOPSIS
		Remove the OneDrive object in the File Explorer
	
	.DESCRIPTION
		This will effectively remove the Microsoft OneDrive object in the navigation pane of Windows File Explorer (left-hand side).
	
	.PARAMETER Enable
		'Remove-OneDriveObject -Enable' will remove the OneDrive object in the nagivation pane of Windows File Explorer. This is the default switch if you do not specify it explicitly. 
	
	.PARAMETER Disable
		'Remove-OneDriveObject -Disable' will revert changes this function performs, effectively re-adding the OneDrive object to the nagivation pane.
	
	.EXAMPLE
				PS C:\> Remove-OneDriveObject
				PS C:\> Remove-OneDriveObject -Enable
				PS C:\> Remove-OneDriveObject -Disable

	.NOTES
		Supported on Windows 8/8.1/10
	
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
