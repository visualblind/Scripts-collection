import-module ActiveDirectory

Get-ADGroupMember -Identity Internal_Users


get-help set-aduser -examples
get-help get-adgroupmember -examples
get-aduser -Identity trunyard -Properties samAccountName | Select samAccountName

$hours = New-Object byte[] 21
$hours[1] = 255
$hours[2] = 255
$hours[3] = 255
$hours[4] = 255
$hours[5] = 255
$hours[6] = 255
$hours[7] = 255
$hours[8] = 255
$hours[9] = 255
$hours[10] = 255
$hours[11] = 255
$hours[12] = 255
$hours[13] = 255
$hours[14] = 255
$hours[15] = 255
$hours[16] = 255
$hours[17] = 255
$hours[18] = 255
$hours[19] = 255
$hours[20] = 255
$hours[0] = 255

$ReplaceHashTable = New-Object HashTable
$ReplaceHashTable.Add(“logonHours”, $hours)
Get-ADGroupMember -Identity Internal_Users | Set-ADUser -Replace $ReplaceHashTable
#Set-ADUser trunyard –Replace $ReplaceHashTable

Write-Host $ReplaceHashTable

$allusers = @()
$users = Get-ADGroupMember –Identity Internal_Users
foreach ($user in $users){
$allusers += get-aduser -identity $user.samAccountName -Properties logonhours | select samAccountName,logonhours}
ConvertTo-CSV $allusers
$allusers | Export-CSV "Domain.int-Internal_Users-logonhours.csv" -NoTypeInformation

get-aduser -Identity trunyard -Properties logonhours
