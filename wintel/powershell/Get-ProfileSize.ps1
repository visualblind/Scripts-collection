$colItems = (Get-ChildItem C:\Scripts -recurse | Measure-Object -property length -sum)
"{0:N2}" -f ($colItems.sum / 1MB) + " MB"


#Old COM object for file system
#$objFSO = New-Object -com  Scripting.FileSystemObject
#"{0:N2}" -f (($objFSO.GetFolder("C:\Scripts").Size) / 1MB) + " MB"


ni $profile -type f -fo
$profile
. $profile

get-size C:\users\visualblind\Documents\scripts
