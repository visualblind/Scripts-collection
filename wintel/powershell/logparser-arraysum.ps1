
#Run the Log Parser utility and generate the report CSV file
&"C:\Program Files (x86)\Log Parser 2.2\LogParser.exe" --% -i:IISW3C "SELECT date, cs-uri-stem AS Page,  COUNT(*) AS Hits INTO D:\WebserverReport\ReportTemp\results.csv FROM D:\WebserverReport\LogFiles\*.log WHERE (cs-uri-stem LIKE '%aspx%') GROUP BY Date,Page ORDER BY Hits DESC" -o:CSV -headers:ON -recurse

[int] $sum = 0;
$File = Import-CSV D:\WebserverReport\ReportTemp\results.csv
foreach ($arrayHits in $File)
  {
    #Write-Host $arrayHits.Hits;
    $sum = $sum + $arrayHits.Hits;
  }
Write-Host ("The Sum is: $sum");
    $arrayHits = $NULL
    $sum = $NULL