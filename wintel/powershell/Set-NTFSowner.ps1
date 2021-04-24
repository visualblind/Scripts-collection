Install-Module SplitPipeline

# some servers (from 1 to 10 for the test)
$servers = 1..10

# process servers by parallel pipelines and output results immediately
$servers | Split-Pipeline {process{"processing server $_"; sleep 1}} -Load 1, 1

Get-Job |
Remove-Job
cls
Try  {

  $Path = "\\freenas\p0ds0smb\backup\ubuntu-backup\visualblind\Downloads"

  $SubFolders = Get-ChildItem $Path -Directory -Recurse
  If ($SubFolders)  {
    $Job = Start-Job -ScriptBlock {$args[0] | %{Set-NTFSOwner -Path $_ -Verbose -Account 'SYSINFO\visualblind'}} -ArgumentList $SubFolders
    #$Job = Start-Job -ScriptBlock {dir $Path -Directory -Recurse | Set-NTFSOwner -Verbose -Account 'SYSINFO\visualblind'}
    Get-Job | ? {$_.State -eq 'Complete' -and $_.HasMoreData} | % {Receive-Job $_}
  }


  #Start the job that will reset permissions for each file, don't even start if there are no direct sub-files
  $SubFiles = Get-ChildItem $Path -Recurse
  If ($SubFiles)  {
      Foreach ($SubFolder in $SubFolders)  {
    $Job = Start-Job -ScriptBlock {$args[0] | %{Set-NTFSOwner -Path $_ -Verbose -Account 'SYSINFO\visualblind'}} -ArgumentList $SubFolder.FullName
    #$Job = Start-Job -ScriptBlock {dir $Path -File | Set-NTFSOwner -Verbose -Account 'SYSINFO\visualblind'}
    Get-Job | ? {$_.State -eq 'Complete' -and $_.HasMoreData} | % {Receive-Job $_}
    }
  }


   If ($SubFiles)  {
      
    $Job = Start-Job -ScriptBlock {$args[0] | %{Foreach ($SubFolder in $SubFolders)  {Set-NTFSOwner -Path $SubFolder.FullName -Verbose -Account 'SYSINFO\visualblind'}}}
    $Job = Start-Job -ScriptBlock {$args[0] | %{Foreach ($SubFile in $SubFiles)  {Set-NTFSOwner -Path $_ -Verbose -Account 'SYSINFO\visualblind'}}} -ArgumentList $SubFile
    #$Job = Start-Job -ScriptBlock {dir $Path -File | Set-NTFSOwner -Verbose -Account 'SYSINFO\visualblind'}

    Get-Job|Receive-Job

    Get-Job | ? {$_.State -eq 'Completed' -and $_.HasMoreData} | % {Receive-Job $_}
    
    while((Get-Job -State Running).count){
    Get-Job | ? {$_.State -eq "Completed" -and $_.HasMoreData} | % {Receive-Job $_}
    start-sleep -seconds 1
    }
  }



  
  If ($?) {
    $Job = Start-Job -ScriptBlock {$args[0] | %{icacls $_.FullName /Reset /T /C}} -ArgumentList $Path
  }

  If ($SubFiles)  {
    Wait-Job $Job -ErrorAction SilentlyContinue | Out-Null
  }

  Write-Host "The script has completed resetting permissions under $($Path)."
}
Catch  {
  $ErrorMessage = $_.Exception.Message
  Throw "There was an error during the script: $($ErrorMessage)"
}
  
  $SubFiles = Get-ChildItem $Path -Recurse
  If ($SubFiles)  {
    $Job = Start-Job -ScriptBlock {$args[0] | %{icacls $_.FullName /Reset /T /C}} -ArgumentList $SubFiles
  }
  
  #Now go through each $Path's direct folder (if there's any) and start a process to reset the permissions, for each folder.
  $Processes = @()
  $SubFolders = Get-ChildItem $Path -Directory
  If ($SubFolders)  {
    Foreach ($SubFolder in $SubFolders)  {
      #Start a process rather than a job, icacls should take way less memory than Powershell+icacls
      $Processes += Start-Process icacls -WindowStyle Hidden -ArgumentList """$($SubFolder.FullName)"" /Reset /T /C" -PassThru
    }
  }
  $Processes = @()
  $SubFolders = Get-ChildItem $Path -Directory -Depth 99
  If ($SubFolders)  {
    Foreach ($SubFolder in $SubFolders)  {
      #Start a process rather than a job, icacls should take way less memory than Powershell+icacls
      $Processes += Start-Process takeown -WindowStyle Hidden -ArgumentList "/F ""$($SubFolder.FullName)"" /R /D Y" -PassThru
    }
  }

  #Now that all processes/jobs have been started, let's wait for them (first check if there was any subfile/subfolder)
  #Wait for $Job
  If ($SubFiles)  {
    Wait-Job $Job -ErrorAction SilentlyContinue | Out-Null
    Remove-Job $Job
    Stop-Job $Job
  }
  #Wait for all the processes to end, if there's any still active
  If ($SubFolders)  {
    Wait-Process -Id $Processes.Id -ErrorAction SilentlyContinue
    Stop-Process -Id $Processes.Id
  }
  
  Write-Host "The script has completed resetting permissions under $($Path)."
}
Catch  {
  $ErrorMessage = $_.Exception.Message
  Throw "There was an error during the script: $($ErrorMessage)"
}