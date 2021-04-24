Try {

#Set-Location "\\freenas\p0ds0smb\visualblind" 
#Write-Host ( Get-ChildItem $DirectoryList -Recurse -Force | ?{$_.PsIsContainer} | Measure-Object ).Count;
$DirectoryList = "\\freenas\visualblind\torrent-files" # Build the list 

$Folders = Get-ChildItem -Recurse -Force "$DirectoryList" | ?{$_.PsIsContainer}
$Processes = @() 
ForEach ($Folder in $Folders) {

write-host "Processing: $($Folder.FullName)\*" 
$Processes += Start-Process takeown -WindowStyle Hidden -ArgumentList "/F ""$($Folder.FullName)""" -PassThru
$Processes += Start-Process takeown -WindowStyle Hidden -ArgumentList "/F ""$($Folder.FullName)\*"" /R" -PassThru
Start-Sleep -Milliseconds 100
        #write-host "Finished: $($Folder.FullName)"
        }
    }

Catch  {
  $ErrorMessage = $_.Exception.Message
  Throw "There was an error during the script: $($ErrorMessage)"
}