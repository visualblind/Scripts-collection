#Purpose: IIS Server Log Monthly Hit Counter
#Created: Travis Runyard
#Date: 1/8/2015

#Variable Declaration
$LastMonth = (Get-Date).AddMonths(-1)
$CurrentDate = Get-Date
$FirstDayofLastMonth = Get-Date -year $LastMonth.year -month $LastMonth.month -day 1 -format d
$FirstDayofThisMonth = Get-Date -year $CurrentDate.year -month $CurrentDate.month -day 1 -format d
$RemoteLogPathIIS1 = "\\si04swfiis1\logfiles"
$RemoteLogPathIIS2 = "\\si04swfiis2\logfiles"
$LocalLogPathIIS1 = "D:\WebserverReport\LogFiles\SI04SWFIIS1"
$LocalLogPathIIS2 = "D:\WebserverReport\LogFiles\SI04SWFIIS2"
$limit = (Get-Date).AddDays(-15)


#Delete all files older than one month
#Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $FirstDayofLastMonth } | Remove-Item -Force -WhatIf

#Copy IIS1 log files from last month
Get-ChildItem -path $RemoteLogPathIIS1 -recurse -force | ? { $_.LastWriteTime -gt $FirstDayofLastMonth -AND $_.LastWriteTime -lt $FirstDayofThisMonth -or $_.PSIsContainer } | % {Copy-Item -path $_.fullname -destination $LocalLogPathIIS1 -container -force -recurse}
Remove-Item $LocalLogPathIIS1 + "\*.*" | Where { ! $_.PSIsContainer }

#Copy IIS2 log files from last month
Get-ChildItem -path $RemoteLogPathIIS2 -recurse -force | ? { $_.LastWriteTime -gt $FirstDayofLastMonth -AND $_.LastWriteTime -lt $FirstDayofThisMonth -or $_.PSIsContainer } | % {Copy-Item -path $_.fullname -destination $LocalLogPathIIS2 -container -force -recurse}
Remove-Item $LocalLogPathIIS2 + "\*.*" | Where { ! $_.PSIsContainer }


