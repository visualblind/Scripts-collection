Set-Location C:\
Clear-Host

#Performance Counters
Get-CimClass "Win32_PerfFormattedData*" | Select-Object CimClassName 

Get-CimClass *Perf*LogicalDisk* | Select-Object CimClassName

Get-CimInstance "Win32_PerfFormattedData_PerfDisk_LogicalDisk" -Filter 'Name = "C:"' | Select-Object "Percent*"
Get-CimInstance "Win32_PerfRawData_PerfDisk_LogicalDisk" -Filter 'Name = "C:"' | Select-Object "Percent*"
 

#Which Process is hogging the CPU
Get-CIMClass *Perf*Process* | Select-Object CimClassName

Get-CIMInstance -ClassName "Win32_PerfFormattedData_PerfProc_Process" | Select-Object Name, IDProcess, PercentProcessorTime
$CimProcessPerformance = Get-CIMInstance -ClassName "Win32_PerfFormattedData_PerfProc_Process"
$CimProcessPerformance = $CimProcessPerformance | Where-Object {$_.Name -notin "Idle","_Total"}
$CimProcessPerformance | Sort-Object PercentProcessorTime -Descending | Select-Object Name, PercentProcessorTime, IdProcess -First 3




#Events 

Get-WinEvent -ListLog application, system, Microsoft-Windows-Winlogon/Operational

Get-WinEvent -ListProvider Microsoft-Windows*
Get-WinEvent -ListProvider *Service* | select name, loglinks

Get-WinEvent -LogName "Microsoft-Windows-PrintService/Admin"

# The 3 most recent bootups
Get-WinEvent -FilterHashtable @{Logname="System";Id="6009"} -MaxEvents 3




Get-WinEvent  -FilterXml '<QueryList>
<Query Id="0" Path="Application">
  <Select Path="Application">*[System[(Level=1  or Level=2 or Level=3) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
</Query>
</QueryList>'

#Getting the events out of a saved logfile
