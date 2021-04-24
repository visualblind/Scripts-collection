<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.148
	 Created on:   	12/27/2018 7:21 AM
	 Created by:   	visualblind
	 Organization: 	visualblind
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

$dir = 'C:\Program Files\SAPIEN Technologies, Inc'

$files2block = gci -Path $dir -Include *.exe, *.dll -Recurse

foreach ($file in $files2block)
{
	New-NetFirewallRule -DisplayName "PS Studio - $($file.BaseName)" -Direction Inbound -Program "$file.fullname" -Action Block
	New-NetFirewallRule -DisplayName "PS Studio - $($file.BaseName)" -Direction Outbound -Program "$file.fullname" -Action Block
}