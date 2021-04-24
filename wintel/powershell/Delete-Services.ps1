#$service = Get-WmiObject -Class Win32_Service -Filter "displayname like 'ServiceName_%'"
#get-service | ?{$_.displayname -like 'ServiceName_*' -and $_.displayname -notlike '*Blah'}
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
$service = Get-WmiObject -Class Win32_Service | ?{$_.displayname -like 'ServiceName_*' -and $_.displayname -notlike '*Blah'}
$service.delete()