# ExportShareInfo.ps1
# This script will export type 0 shares with security info, and provide a hash table of shares
# in which security info could not be found.
#
#reference: http://mow001.blogspot.com/2006/05/powershell-export-shares-and-security.html
#SID was removed from the script. Instead, the username is used to find SID when the import is run
 
# CHANGE TO SERVER THAT HAS SHARES TO EXPORT
$fileServer = "your file server here"
 
$date = get-date
$datefile = get-date -uformat '%m-%d-%Y-%H%M%S'
$filename = 'desired destination for csv file here'
#Store shares where security cant be found in this hash table
$problemShares = @{}
 
Function Get-ShareInfo($shares) {
$arrShareInfo = @()
Foreach ($share in $shares) {
trap{continue;}
write-host $share.name
$strWMI = "\\" + $fileServer + "\root\cimv2:win32_LogicalShareSecuritySetting.Name='" + $share.name + "'"
$objWMI_ThisShareSec = $null
$objWMI_ThisShareSec = [wmi]$strWMI
 
#In case the WMI query or 'GetSecurityDescriptor' fails, we retry a few times before adding to 'problem shares'
For($i=0;($i -lt 5) -and ($objWMI_ThisShareSec -eq $null);$i++) {
sleep -milliseconds 200
$objWMI_ThisShareSec = [wmi]$strWMI
}
$objWMI_SD = $null
$objWMI_SD = $objWMI_ThisShareSec.invokeMethod('GetSecurityDescriptor',$null,$null)
For($j=0;($j -lt 5) -and ($objWMI_SD -eq $null);$j++) {
sleep -milliseconds 200
$objWMI_SD = $objWMI_ThisShareSec.invokeMethod('GetSecurityDescriptor',$null,$null)
}
If($objWMI_SD -ne $null) {
$arrShareInfo += $objWMI_SD.Descriptor.DACL | % {
$_ | select @{e={$share.name};n='Name'},
@{e={$share.Path};n='Path'},
@{e={$share.Description};n='Description'},
AccessMask,
AceFlags,
AceType,
@{e={$_.trustee.Name};n='User'},
@{e={$_.trustee.Domain};n='Domain'}
}
}
Else {
$ProblemShares.Add($share.name, "failed to find security info")
}
}
return $arrshareInfo
}
 
Write-Host "Finding Share Security Information"
 
# get Shares (Type 0 is "Normal" shares) # can filter on path, etc. with where
$shares = gwmi Win32_Share -computername $fileServer -filter 'type=0'

# get the security info from shares, add the objects to an array
Write-Host " Complete" -ForegroundColor green
Write-Host "Preparing Security Info for Export"
 
$ShareInfo = Get-ShareInfo($shares)
 
Write-Host " Complete" -ForegroundColor green
Write-Host "Exporting to CSV"
 
# Export them to CSV
$ShareInfo | select Name,Path,Description,User,Domain,
AccessMask,AceFlags,AceType | export-csv -noType $filename
 
Write-Host " Complete" -ForegroundColor green
Write-Host "Your file has been saved to $filename"
If ($problemShares.count -ge 1) {
Write-Host "These Shares Failed to Export:"
}
$problemShares