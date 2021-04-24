#Purpose: IIS Server Log Monthly Hit Counter
#By: Travis Runyard
#Date: 1/8/2015

#Variables
$LastMonth = (Get-Date).AddMonths(-1)
$LastMonthName = Get-Date -year $LastMonth.year -month $LastMonth.month -format Y
$CurrentDate = Get-Date
$FirstDayofLastMonth = Get-Date -year $LastMonth.year -month $LastMonth.month -day 1 -format d
$FirstDayofThisMonth = Get-Date -year $CurrentDate.year -month $CurrentDate.month -day 1 -format d
$RemoteLogPathIIS1 = "\\SERVER1\logfiles"
$RemoteLogPathIIS2 = "\\SERVER2\logfiles"
$LocalLogPathIIS1 = "D:\WebserverReport\LogFiles\SERVER1"
$LocalLogPathIIS2 = "D:\WebserverReport\LogFiles\SERVER2"

#Create folders and delete logs if they exist
if(!(Test-Path -Path $LocalLogPathIIS1 )){
    New-Item -ItemType directory -Path $LocalLogPathIIS1
}
Else
{
Remove-Item -path ( $LocalLogPathIIS1 + "\*") -Recurse -Force
}

if(!(Test-Path -Path $LocalLogPathIIS2 )){
    New-Item -ItemType directory -Path $LocalLogPathIIS2
}
Else
{
Remove-Item -path ( $LocalLogPathIIS2 + "\*") -Recurse -Force
}

#Delete all files older than one month
#Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $FirstDayofLastMonth } | Remove-Item -Force -WhatIf

#Copy IIS1 log files from last month
Get-ChildItem -Path $RemoteLogPathIIS1 -Recurse | ? { $_.LastWriteTime -gt $FirstDayofLastMonth -and (($_.LastWriteTime -lt $FirstDayofThisMonth) -or ($_.PSIsContainer)) } | 
    Copy-Item -Destination {
        if ($_.PSIsContainer) {
            Join-Path $LocalLogPathIIS1 $_.Parent.FullName.Substring($RemoteLogPathIIS1.length)
        } else {
            Join-Path $LocalLogPathIIS1 $_.FullName.Substring($RemoteLogPathIIS1.length)
        }
    } -Force

#Remove-Item ($LocalLogPathIIS1 + "\*.*") | Where { ! $_.PSIsContainer }

#Copy IIS2 log files from last month
Get-ChildItem -Path $RemoteLogPathIIS2 -Recurse | ? { $_.LastWriteTime -gt $FirstDayofLastMonth -and (($_.LastWriteTime -lt $FirstDayofThisMonth) -or ($_.PSIsContainer)) } | 
    Copy-Item -Destination {
        if ($_.PSIsContainer) {
            Join-Path $LocalLogPathIIS2 $_.Parent.FullName.Substring($RemoteLogPathIIS2.length)
        } else {
            Join-Path $LocalLogPathIIS2 $_.FullName.Substring($RemoteLogPathIIS2.length)
        }
    } -Force


#Run the Log Parser utility and generate the server report CSV file (SERVER1)
&"C:\Program Files (x86)\Log Parser 2.2\LogParser.exe" --% -i:IISW3C "SELECT date, cs-uri-stem AS Page,  COUNT(*) AS Hits INTO D:\WebserverReport\ReportTemp\results-IIS1-svrhits.csv FROM D:\WebserverReport\LogFiles\SERVER1\*.log WHERE (cs-uri-stem LIKE '%aspx%') GROUP BY Date,Page ORDER BY Hits DESC" -o:CSV -headers:ON -recurse

#Run the Log Parser utility and generate the server report CSV file (SERVER2)
&"C:\Program Files (x86)\Log Parser 2.2\LogParser.exe" --% -i:IISW3C "SELECT date, cs-uri-stem AS Page,  COUNT(*) AS Hits INTO D:\WebserverReport\ReportTemp\results-IIS2-svrhits.csv FROM D:\WebserverReport\LogFiles\SERVER2\*.log WHERE (cs-uri-stem LIKE '%aspx%') GROUP BY Date,Page ORDER BY Hits DESC" -o:CSV -headers:ON -recurse

#Run the Log Parser utility and generate website hit stats for email report (SERVER1)
&"C:\Program Files (x86)\Log Parser 2.2\LogParser.exe" --% -i:IISW3C "SELECT cs-host AS Host, COUNT(*) AS Hits INTO D:\WebserverReport\ReportTemp\results-IIS1-sitehits.csv  FROM 'D:\WebserverReport\LogFiles\SERVER1\*.log' WHERE (cs-uri-stem LIKE '%aspx%') AND cs-host IS NOT NULL GROUP BY Host ORDER BY Hits, Host DESC" -o:CSV -headers:ON -recurse
$SiteHitsIIS1 = Import-CSV D:\WebserverReport\ReportTemp\results-IIS1-sitehits.csv | Format-Table @{Expression={$_.Host};Label="Host";width=45}, `
@{Expression={$_.Hits};Label="Hits";width=15} | Out-String

#Run the Log Parser utility and generate website hit stats for email report (SERVER2)
&"C:\Program Files (x86)\Log Parser 2.2\LogParser.exe" --% -i:IISW3C "SELECT cs-host AS Host, COUNT(*) AS Hits INTO D:\WebserverReport\ReportTemp\results-IIS2-sitehits.csv  FROM 'D:\WebserverReport\LogFiles\SERVER2\*.log' WHERE (cs-uri-stem LIKE '%aspx%') AND cs-host IS NOT NULL GROUP BY Host ORDER BY Hits, Host DESC" -o:CSV -headers:ON -recurse
$SiteHitsIIS2 = Import-CSV D:\WebserverReport\ReportTemp\results-IIS2-sitehits.csv | Format-Table @{Expression={$_.Host};Label="Host";width=45}, `
@{Expression={$_.Hits};Label="Hits";width=15} | Out-String

#Count all server hits for email report IIS1
[int] $sumIIS1 = 0;
$File = Import-CSV D:\WebserverReport\ReportTemp\results-IIS1-svrhits.csv
foreach ($arrayHits in $File)
  {
    #Write-Host $arrayHits.Hits;
    $sumIIS1 = $sumIIS1 + $arrayHits.Hits;
  }
$arrayHits = $NULL

#Count all server hits for email report IIS2
[int] $sumIIS2 = 0;
$File = Import-CSV D:\WebserverReport\ReportTemp\results-IIS2-svrhits.csv
foreach ($arrayHits in $File)
  {
    #Write-Host $arrayHits.Hits;
    $sumIIS2 = $sumIIS2 + $arrayHits.Hits;
  }

#Add thousands separator
$sumIIS1sep = [string]::Format('{0:N0}',$sumIIS1)
$sumIIS2sep = [string]::Format('{0:N0}',$sumIIS2)

#Send the report by email
$body = "Report is for the month of $LastMonthName`n`nServer Report:`n`nTotal hits for SERVER1: $sumIIS1sep `nTotal hits for SERVER2: $sumIIS2sep`n`nSite Hits (SERVER1):`n$SiteHitsIIS1`nSite Hits (SERVER2):`n$SiteHitsIIS2"
send-mailmessage -to "helpdesk <helpdesk@company.com>" -from "Webserver Reporting <helpdesk@company.com>" -subject "Webserver Report" -body $body -smtpserver 192.168.1.100

#Release variables
  $arrayHits = $NULL
  $sumIIS1 = $NULL
  $sumIIS1sep = $NULL
  $sumIIS2 = $NULL
  $sumIIS2sep = $NULL

#Remove Log files
Remove-Item -path ( $LocalLogPathIIS1 + "\*") -Recurse -Force
Remove-Item -path ( $LocalLogPathIIS2 + "\*") -Recurse -Force
