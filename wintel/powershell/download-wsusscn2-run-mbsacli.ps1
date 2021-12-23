$datetime = Get-Date -f yyyy-MM-dd-HH-mm
$basename = "wsusscn2_"
$extension = ".cab"
##Remove archived wsusscn2.cab file, if any
function RemoveArchive
{
if (Test-Path C:tempMBSAArchive*.cab)
{Remove-Item -Path C:tempMBSAArchivewsusscn2*.cab
MoveExisting
}
else
{
MoveExisting
}
}
##Move existing wsusscn2.cab file to Archive and rename it with the move date timestamp
function MoveExisting
{
if (Test-Path C:tempMBSAwsusscn2.cab)
{
Move-Item C:tempMBSAwsusscn2.cab C:tempMBSAArchivewsusscn2.cab
Rename-Item -Path C:tempMBSAArchivewsusscn2.cab -NewName ($basename+$datetime+$extension)
DownloadNewCab
}
else
{
DownloadNewCab
}}
##Download the new wsusscn2.cab file
function DownloadNewCab
{
$client = new-object System.Net.WebClient
$client.DownloadFile("http://go.microsoft.com/fwlink/?LinkID=74689","C:tempMBSAwsusscn2.cab")
##Validate that the file is there and write entries to the eventlog
if (Test-Path C:tempMBSAwsusscn2.cab)
{
Write-EventLog -Logname "Windows PowerShell" -Source PowerShell -EventId 555 -EntryType Information -Message "wsusscn2.cab file successfully downloaded to C:TempMBSA"
RunMBSAScan
}
else
{
Write-EventLog -Logname "Windows PowerShell" -Source PowerShell -EventId 8082 -EntryType Error -Message "wsusscn2.cab file download failed"
Exit
}
}
##Of course, we need to run a scan with MBSA
function RunMBSAScan
{
cd "C:Program FilesMicrosoft Baseline Security Analyzer 2"
mbsacli /listfile c:tempMBSAserverlist.txt /catalog c:tempMBSAwsusscn2.cab /n os+iis+sql+password
}
##Internet connection testing because without an internet connection, all this will be useless right?
Write-EventLog -Logname "Windows PowerShell" -Source PowerShell -EventId 1000 -EntryType Information -Message "wsusscn2.cab file download script executed"
if (Test-Connection www.google.com -Quiet)
{
RemoveArchive
}
else
{
Write-EventLog -Logname "Windows PowerShell" -Source PowerShell -EventId 1234 -EntryType Error -Message "Internet connection DOWN! wsusscn2.cab file download failed"
}