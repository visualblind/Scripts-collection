
##############################################################################
#
#.SYNOPSIS
# Get the Vms Disk foot print
#
#.DESCRIPTION
# Disk foot print is calculated below file which makes an VM
# Config files (.vmx, .vmxf, .vmsd, .nvram)
# Log files (.log)
# Disk files (.vmdk)
# Snapshots (delta.vmdk, .vmsn)
# Swapfile (.vswp)
#
# Get-View -VIObject centOs-1
# TypeName: VMware.Vim.VirtualMachineFileInfo

# FtMetadataDirectory Property   string FtMetadataDirectory {get;set;}
# LogDirectory        Property   string LogDirectory {get;set;}
# SnapshotDirectory   Property   string SnapshotDirectory {get;set;}
# SuspendDirectory    Property   string SuspendDirectory {get;set;}
# VmPathName          Property   string VmPathName {get;set;}
#
#.PARAMETER vm
# VM Object returned by Get-VM cmdlet
#
#.EXAMPLE
# $vmSize = Get-VmDisksFootPrint($vm)
#
##############################################################################

Function Get-VmDisksFootPrint($vm) {
   #Initialize variables
   $VmDirs = @()
   $VmSize = 0
   $searchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
   $searchSpec.details = New-Object VMware.Vim.FileQueryFlags
   $searchSpec.details.fileSize = $TRUE

   Get-View -VIObject $vm | % {
      #Populate the array with the vm's directories
      $VmDirs += $_.Config.Files.VmPathName.split("/")[0]
      $VmDirs += $_.Config.Files.SnapshotDirectory.split("/")[0]
      $VmDirs += $_.Config.Files.SuspendDirectory.split("/")[0]
      $VmDirs += $_.Config.Files.LogDirectory.split("/")[0]
      #Add directories of the vm's virtual disk files
      foreach ($disk in $_.Layout.Disk) {
         foreach ($diskfile in $disk.diskfile) {
            $VmDirs += $diskfile.split("/")[0]
         }
      }

      #Only take unique array items
      $VmDirs = $VmDirs | Sort-Object | Get-Unique

      foreach ($dir in $VmDirs) {
         $datastoreObj = Get-Datastore ($dir.split("[")[1]).split("]")[0]
         $datastoreBrowser = Get-View (($datastoreObj | get-view).Browser)
         $taskMoRef  = $datastoreBrowser.SearchDatastoreSubFolders_Task($dir,$searchSpec)
         $task = Get-View $taskMoRef

         while($task.Info.State -eq "running" -or $task.Info.State -eq "queued") {$task = Get-View $taskMoRef }
         foreach ($result in $task.Info.Result){
            foreach ($file in $result.File){
               $VmSize += $file.FileSize
            }
         }
      }
   }

   return $VmSize
}

##############################################################################
#
#.SYNOPSIS
# Get the ESX version of the Host
#
#.DESCRIPTION
# Return the ESX product version of the HostObjects supplied in parameter
#
#.PARAMETER EsxHosts
# Host Objects
#
#.EXAMPLE
# $HostObjects = Get-View -ViewType HostSystem
# $Hash = Get-HostVersion -EsxHosts $HostObjects
#
##############################################################################
Function Get-HostVersion {
   param([Object]$EsxHosts= "")
   $EsxHostVersion = @{}
   Foreach ($esx in $HostObjects) {
      $version = $esx.Config.Product.version
      $EsxHostVersion[$esx.Name] = $version
   }

   return $EsxHostVersion
}

##################################################################################################################
#
#.SYNOPSIS
# Perform preflight check before proceeding with migration
#
#.DESCRIPTION
# Top level function calling respective preflight checks before proceeding
#  with migration
#
#.PARAMETER Function
# Function to call
#
#.PARAMETER TargetObjects
# Target Object is being verified
#
#.PARAMETER ExpectedValue
# Attribute to verify
#
#.EXAMPLE
# PreFlightCheck -Function "CheckHostVersion" -TargetObjects $HostObjects -ExpectedValue $TargettedHostVersion
#
##################################################################################################################

Function PreFlightCheck {
   param(
      [parameter(Mandatory=$true)][string]$Function,
      [object]$TargetObjects,
      [object]$ExpectedValue
   )

   if(Get-Command $Function -ea SilentlyContinue) {
      #write-host $Function $TargetObjects $ExpectedValue
      & $Function $TargetObjects $ExpectedValue
   } else {
      # ignore
   }
}

##############################################################################
#.SYNOPSIS
# Get the Hosts connected to a datastores
#
#.DESCRIPTION
# Queries the List of datastores in VC and returns a hashmap with list of
# hosts connected to a datastore
# Key = Datastore Name
# Value = List of hosts connected
#
#.EXAMPLE
# $DatastoreHash = Get-HostsConnectedToDatastore
##############################################################################

Function Get-HostsConnectedToDatastore {
   $DatastoreHash = @{}
   $DatastoreObjects = Get-View -ViewType Datastore
   Foreach ($eachdatastoreObj in $DatastoreObjects) {
      $hostArray = Get-View -ID $eachdatastoreObj.Host.Key | ft -Property Name
      $DatastoreHash[$eachdatastoreObj.Name] = $hostArray
   }

   return $DatastoreHash
}

##############################################################################
#.SYNOPSIS
# Get the list of Datastoer associated with VM
#
#.DESCRIPTION
# Queries VM Object and construct a HashMap with Datastores associates
# with the VM
# Key = VM Name
# Value = List of Datastores associated
#
#.EXAMPLE
# $VmMap +=  Get-VmDatastore -Vm $vm
# Alternate option : Get-Datastore -Name "local-0" | Select $_ | Get-VM
##############################################################################

Function Get-VmDatastore {
   param([parameter(Mandatory=$true)][Object]$Vm="")

   $VmDatastoreMap = @{}
   foreach($datastore in $vm.Datastore) {
      $datastoreObj = Get-View -ID $datastore
      $dsNameList += , $datastoreObj.Name
   }

   $VmDatastoreMap[$vm.Name] = $dsNameList
   return $VmDatastoreMap
}

##############################################################################
#.SYNOPSIS
# PreFLight check for ESX version
#
#.DESCRIPTION
# Function check the host version
#
#.PARAMETER HostObjects
# Target Object is being verified
#
#.PARAMETER Version
# Expected Version
#
#.EXAMPLE
# $status = CheckHostVersion -HostObjects $hostObject -Version $version
##############################################################################

Function CheckHostVersion {
   param(
      [parameter(Mandatory=$true)][object]$HostObjects,
      [String]$Version
   )

   $status = $true
   $targetVersion = New-Object System.Version($version)
   $Hash = Get-HostVersion -EsxHosts $HostObjects
   foreach ($host in $HostObjects) {
      $hostName = $host.Name
      $hostVersion = New-Object System.Version($host.Config.Product.version)
      if($hostVersion -ge $targetVersion) {
         $status = $status -And $true
         Format-output -Text "VM host $hostName is of version $hostVersion" -Level "SUCCESS" -Phase "Pre-Check"
      } else {
         $status = $status -And $false
         Format-output -Text "VM host $hostName is of version $hostVersion" -Level "ERROR" -Phase "Pre-Check"
      }
   }

   return $status
}

##############################################################################
#
#.SYNOPSIS
# Format the log messages
#
#.DESCRIPTION
# Format the log message printed on the screen
# Also redirect the message to a log file
#
#.PARAMETER
# Text - log message to be printed
# Level - SUCCESS,INFO,ERROR
# Phase - Different phase of commandlet, Preperation,Migration,Roll back
#
#
#.EXAMPLE
# Format-output -Text $MsgText -Level "INFO" -Phase "Migration Pre-Check phase"
#
##############################################################################

Function Format-output {
   param (
      [Parameter(Mandatory=$true)][string]$Text,
      [Parameter(Mandatory=$true)][string]$Level,
      [Parameter(Mandatory=$false)][string]$Phase
   )

   BEGIN {
      filter timestamp {"$(Get-Date -Format s) `[$Phase`] $Text" }
   }

   PROCESS {
      $Text | timestamp | Out-File -FilePath $global:LogFile -Append -Force
      if($Level -eq "SUCCESS" ) {
         $Text | timestamp | write-host -foregroundcolor "green"
      } elseif ( $Level -eq "INFO") {
         $Text | timestamp | write-host -foregroundcolor "yellow"
      } else {
         $Text | timestamp | write-host -foregroundcolor "red"
      }
   }
}

<#
.SYNOPSIS
    Wrapper Funtion to Call Storage Vmotion
.DESCRIPTION
    You may send a list of vm names
.PARAMETER VM
    Pass vmnames
.PARAMETER Destination
    PASS Destination datastore name
.PARAMETER Destination
    PASS ParallelTasks to perform
.INPUTS
.OUTPUTS
.EXAMPLE
    Storage-Vmotion -VM $vmlist -Destination 'Datastore_1' -ParallelTasks 2
#>
Function Concurrent-SvMotion {
   [CmdletBinding()]
   param (
      [Parameter(Mandatory = $true)][VMware.VimAutomation.ViCore.Util10.VersionedObjectImpl]$session,
      [Parameter(Mandatory = $true)][string[]]$VM,
      [Parameter(Mandatory = $true)][string]$Source,
      [Parameter(Mandatory = $true)][string]$Destination,
      [Parameter(Mandatory = $true)][int]$ParallelTasks
   )

   BEGIN {
       $TargetDatastore = $Destination
       $Date = get-date
       $VmsToMigrate = $VM
       $Failures = 0;
       $LoopCtrl = 1
       $VmInput = $VM
       $GB = 1024 * 1024 * 1024
       $BufferSize = 5
       $RelocateTaskList = @()
   }

   PROCESS {
      while ($LoopCtrl -gt 0) {
         $shiftedVm = shift -array ([ref]$vmInput) -numberOfElements $ParallelTasks
         $vmToMigrate = $shiftedVm
         $LoopCtrl = $vmInput.Count
         #Check the datastore contain sufficient space
         foreach ($TargetVm in $vmToMigrate) {
            $vm = Get-VM $TargetVm
            $vmSize += Get-VmDisksFootPrint $vm
         }
         #$ds = Get-Datastore -Name $TargetDatastore
         $vmSize = [math]::Round(($vmSize / $GB) + $BufferSize)
         $tagetDatastoreObj = Get-Datastore -Name $TargetDatastore
         if($tagetDatastoreObj.FreeSpaceGB -gt $vmSize) {
            $MsgText = "$TargetDatastore Contain FreeSpace of $($tagetDatastoreObj.FreeSpaceGB) GB to accomodate $vmToMigrate of size $vmSize GB"
            Format-output -Text $MsgText -Level "INFO" -Phase "Migration Pre-Check phase"
            $RelocateTaskList += Storage-Vmotion -session $session -Source $Source -VM $vmToMigrate -Destination $Destination
            # Iterate through has list of TaskMap and check for task failures
            foreach ($Task in $RelocateTaskList ) {
               if ( $Task["State"] -ne "Success" ) {
                  $Failure += 1
                  return $RelocateTaskList
               } else {
                  $Success += 1
               }
            }
         } else {
            #If insufficient datastore space just mark the migration task as failure
            $MsgText = "$TargetDatastore have insufficient space. FreeSpace of $($tagetDatastoreObj.FreeSpaceGB) GB to accomdate $vmToMigrate of size $vmSize GB"
            Format-output -Text $MsgText -Level "INFO" -Phase "Migration Pre-Check phase"
            $TaskMap = @{}
            $TaskMap["Name"] = $TargetVm
            $TaskMap["State"] = "Error"
            $TaskMap["Cause"] = "INSUFFICIENT_DATASTORE_SPACE"
            $RelocTaskList += $TaskMap
            return $RelocateTaskList
         }
      }
      return $RelocateTaskList
   }
}

Function MoveTheVM {
   [CmdletBinding()]
   param (
      [Parameter(Mandatory=$true)][VMware.VimAutomation.ViCore.Util10.VersionedObjectImpl]$session,
      [Parameter(Mandatory=$true)][String]$VM,
      [Parameter(Mandatory=$true)][string]$Source,
      [Parameter(Mandatory=$true)][string]$Destination
   )

   BEGIN {
      $vm = $VM
      $datastore = $Source
      $tempdatastore = $Destination
   }

   PROCESS {
      try {
         $vmName=Get-VM -Name $vm
         $vmId = $vmName.id
         $MsgText ="VM = $vm, Datastore = $datastore and Target datastore = $tempdatastore and id is $vmId"
         Format-output -Text $MsgText -Level "INFO" -Phase "VM migration"
         $dsView=Get-View -viewtype Datastore -filter @{"Name"=$tempdatastore}
         $hds = Get-HardDisk -VM $vm
         $spec = New-Object VMware.Vim.VirtualMachineRelocateSpec
         $vmView=get-view -id $vmId
         if($vmView.Summary.Config.VmPathName.Contains($datastore)) {
            $spec.datastore = (Get-Datastore -Name $tempdatastore).Extensiondata.MoRef
         }

         $hds | %{
            if ($_.Filename.Contains($datastore)) {
               $disk = New-Object VMware.Vim.VirtualMachineRelocateSpecDiskLocator
               $disk.diskId = $_.ExtensionData.Key
               $disk.datastore = (Get-Datastore -Name $tempdatastore).Extensiondata.MoRef
               $spec.disk += $disk
            } else {
               $hdDS = $_.ExtensionData.Backing.FileName.Split("[,]")[1]
               $disk = New-Object VMware.Vim.VirtualMachineRelocateSpecDiskLocator
               $disk.diskId = $_.ExtensionData.Key
               $disk.datastore = (Get-Datastore -Name $hdDS).Extensiondata.MoRef
               $spec.disk += $disk
		      }
         }

         $task = $vmName.Extensiondata.RelocateVM_Task($spec, "defaultPriority")
         $task1 = Get-Task -server $session | where { $_.id -eq $task }
         return $task1
      } catch {
         $errName = $_.Exception.GetType().FullName
         $errMsg = $_.Exception.Message
         Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Moving Virtual Machines"
         Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option. If problem persists, move all the VMs from $Source to $Destination manually and then try again." -Level "Error" -Phase "Moving Virtual Machines"
         Return
      }
   }
}

########################################################################################################
#
#.SYNOPSIS
# Perform Concurrent Storage VMotion
#
#.DESCRIPTION
# Perform concurrent Migration based on no of Async task to run
# Continous DS space validation before migration
#
#.PARAMETER
# VM  - List of VM names to Migrate
# Destination - Destination Datastore Names
# Return the TaskMap about VC migration task
#
#
#.EXAMPLE
# $RelocTaskList = Concurrent-SvMotion -VM $vmList -Destination $TemporaryDatastore -ParallelTasks 2
#
########################################################################################################

function Storage-Vmotion {
   [CmdletBinding()]
   param (
      [Parameter(Mandatory=$true)][VMware.VimAutomation.ViCore.Util10.VersionedObjectImpl]$session,
      [Parameter(Mandatory=$true)][string[]]$VM,
      [Parameter(Mandatory=$true)][string]$Source,
      [Parameter(Mandatory=$true)][string]$Destination
   )

   BEGIN {
      $TargetDatastore = $Destination
      $VmsToMigrate = $VM
      $RelocateTaskStatus = @()
      $Failures = 0
      $Success = 0
      $TaskTab = @{}
      $GB = 1024 * 1024 * 1024
      Set-Variable -Name vm -Scope Local
      Set-Variable -Name ds -Scope Local
   }

   PROCESS {
      foreach ($TargetVm in $VmsToMigrate) {
         $date = get-date
         Format-output -Text "$TargetVm : Migration is in progress From:$Source To:$TargetDatastore" -Level "INFO" -Phase "Migration"
         $task = MoveTheVM -VM $TargetVm -session $session -Source $Source -Destination $TargetDatastore
         $TaskTab[$task.id] = $TargetVm
      }

      # Get the status of running tasks
      $RunningTasks = $TaskTab.Count
      while($RunningTasks -gt 0) {
         Get-Task | % {
            if ($TaskTab.ContainsKey($_.Id) -and $_.State -eq "Success") {
               $TaskMap = @{}
               $Success += 1
               $TaskMap["Name"] = $TaskTab[$_.Id]
               $TaskMap["TaskId"] = $_.Id
               $TaskMap["StartTime"] = $_.StartTime
               $TaskMap["EndTime"] = $_.FinishTime
               $TaskMap["State"] = $_.State
               $TaskMap["Cause"] = ""
               $TaskTab.Remove($_.Id)
               $RunningTasks--
               $RelocateTaskStatus += $TaskMap
            } elseif ($TaskTab.ContainsKey($_.Id) -and $_.State -eq "Error") {
               $TaskMap = @{}
               $Failures += 1
               $TaskMap["Name"] = $TaskTab[$_.Id]
               $TaskMap["TaskId"] = $_.Id
               $TaskMap["StartTime"] = $_.StartTime
               $TaskMap["EndTime"] = $_.FinishTime
               $TaskMap["State"] = $_.State
               $TaskMap["Cause"] = ""
               $TaskTab.Remove($_.Id)
               $RunningTasks--
               $RelocateTaskStatus += $TaskMap
            }
         }

         Start-Sleep -Seconds 15
      }
   }

   END {
      Foreach ($Tasks in $RelocateTaskStatus) {
         if ($Tasks["State"] -eq "Success") {
            $MsgText = "Migration of $($Tasks["Name"]) is successful Start Time : $($Tasks["StartTime"]) End Time : $($Tasks["EndTime"])"
            Format-output -Text $MsgText -Level "SUCCESS" -Phase "Migration"
         } else {
            $MsgText = "Migration of $($Tasks["Name"]) is failure    Start Time : $($Tasks["StartTime"]) End Time : $($Tasks["EndTime"])"
            Format-output -Text $MsgText -Level "FAILURE" -Phase "Migration"
         }
      }

      return  $RelocateTaskStatus
   }
}

##############################################################################
#
#.SYNOPSIS
# Function to shift an array
#
#.DESCRIPTION
# Perform shift action similar to Perl shift
#
#.PARAMETER
# array  - Array to shift
# numberOfElements - No of elements to shift
# On success Orginal array is resized
#
#
#.EXAMPLE
#
# $shiftedVm = shift -array ([ref]$array) -numberOfElements 2
#
##############################################################################

Function shift {
   param (
      [Parameter(Mandatory=$true)][ref]$array,
      [Parameter(Mandatory=$true)][int]$numberOfElements
   )

   BEGIN {
      $shiftedValue = @()
      $temp = @()
      $temp = $array.Value
   }

   PROCESS {
      if ($temp.Count -ge $numberOfElements) {
         $Iterate =  $numberOfElements
      } else {
         $Iterate = $temp.Count
      }

      for ($i = $Iterate; $i -gt 0; $i -= 1) {
         $firstElement,$temp = $temp;
         $shiftedValue += $firstElement
      }
   }

   END {
      $array.value = $temp
      return $shiftedValue
   }
}

###############################################################################
#
#.SYNOPSIS
# Get the Items in a Datastore
#
#.DESCRIPTION
# Get the list of Items in a Datastore
#
#.PARAMETER
# Datastore - Name of the Datastore
#
#.EXAMPLE
# $list = Get-DatastoreItems -Datastore "local-0"
#
##############################################################################

Function Get-DatastoreItems {
   param(
      [Parameter(Mandatory=$true)][string]$Datastore,
      [Parameter()][Switch]$Recurse,
      [Parameter()][string]$fileType
   )
      
   $childItems = @()
   $datastoreObj = Get-DataStore -Name $Datastore    
   if ($Recurse) {
      $childItems = Get-ChildItem -Recurse $datastoreObj.DatastoreBrowserPath | Where-Object {$_.name.EndsWith($fileType)} 
   } else {
      $childItems = Get-ChildItem $datastoreObj.DatastoreBrowserPath | Where-Object {$_.name -notmatch "^[.]"}
   }

   return $childItems 
}

###################################################################################################
#
#.SYNOPSIS
# Copy files from Source to Desintation
#
#.DESCRIPTION
# Copy Orphaned files, not registered in VC
#
#.PARAMETER
# SourceDatastore - Source
# DestinationDatastore - Destination
#
#.EXAMPLE
# $Return Status = Copy-DatastoreItems -SourceDatastore "local-0" -DestinationDatastore "local-1"
#
###################################################################################################

Function Copy-DatastoreItems {
   param(
      [Parameter(Mandatory=$true)][string]$SourceDatastore,
      [Parameter(Mandatory=$true)][string]$DestinationDatastore
   )

   $copyOrphanPhase = "Copying Orphaned data"
   $SrcChildItems = @()
   $DstChildItems = @()
   $sourceDsObj = get-datastore -Name $SourceDatastore
   $targetDsObj = get-datastore -Name $DestinationDatastore

   #Map Drives
   try {
      $sourceDrive = new-psdrive -Location $sourceDsObj -Name sourcePsDrive -PSProvider VimDatastore -Root "/" 
      $targetDrive = new-psdrive -Location $targetDsObj -Name targetPsDrive -PSProvider VimDatastore -Root "/" 
      $SrcChildItems = Get-DatastoreItems -Datastore $SourceDatastore 
      $DstChildItems = Get-DatastoreItems -Datastore $DestinationDatastore
      Format-output -Text "Copying Orphaned Items: $SrcChildItems" -Level "INFO" -Phase $copyOrphanPhase
      $Fileinfo = Copy-DatastoreItem -Recurse -Item sourcePsDrive:/* targetPsDrive:/ -Force
   } catch [Exception] {
      Remove-PSDrive -Name sourcePsDrive
      Remove-PSDrive -Name targetPsDrive
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase $copyOrphanPhase
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option. If problem persists, move all the orphaned data from $SourceDatastore to $DestinationDatastore manually and then try again." -Level "ERROR" -Phase $copyOrphanPhase
      Return $false
   }

   Remove-PSDrive -Name sourcePsDrive
   Remove-PSDrive -Name targetPsDrive
   Return $true
}

####################################################################################
#
#.SYNOPSIS
# Return Success or Failure list of Tasks
#
#.DESCRIPTION
# This Function checks through the list of Task and return a list of success or
# Failure tasks based on the input
#
#.PARAMETER
# RelocateTasksList = List containing the Relocate Task Map
#
#.EXAMPLE
# $SuccessTaskList=Get-RelocTask -RelocateTasksList $migrateTaskList -State "SUCCESS"
#
####################################################################################

Function Get-RelocTask {
   param (
      [Parameter(Mandatory=$true)][hashtable[]]$TasksList,
      [Parameter(Mandatory=$true)][string]$State
   )

   BEGIN {
      $SuccessList = @()
      $FailureList = @()
   }

   PROCESS {
      # Iterate through has list of TaskMap hash and check for task failures
      foreach ($Task in $TasksList ) {
         $NumberOfMigration += 1
         if ($Task["State"] -ne "Success") {
            $FailureList += $Task
         } else {
            $SuccessList += $Task
         }
      }
   }

   END {
      if ($State -eq "SUCCESS") {
         return $SuccessList
      } else {
         return $FailureList
      }
   }
}

####################################################################################
#.SYNOPSIS
#  Creats Zip file with the log folder
#
#.PARAMETER
# $logdir = Log directory to zip/archive
#
#
#
####################################################################################
Function Zip-Logs {
   param([Parameter(Mandatory=$true)][string] $logdir)

   $sourceDir = Join-Path -Path $pwd -ChildPath $logdir
   $LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
   $destination = "$sourceDir" + "_" + "$LogTime.zip"
	If (Test-path $destination) {
      Remove-item $destination
   }

   Add-Type -assembly "system.io.compression.filesystem"
   [io.compression.zipfile]::CreateFromDirectory($sourceDir, $destination) 
	Format-output -Text "Zip file is available at: $destination" -Level "INFO" -Phase "Log Zip"
}


####################################################################################
#
#.SYNOPSIS
# Unmount the datastore
#
#.DESCRIPTION
# Unmount the datastore from all connected hosts
#
#.PARAMETER
# Datastore = Datastore to unmount
#
#.EXAMPLE
#
# Unmount-Datastore -Datastore "local-0"
#
####################################################################################

Function Unmount-Datastore {
   [CmdletBinding()]
   Param ([Parameter(ValueFromPipeline=$true)][string]$Datastore)

   BEGIN {
      $dsObject = Get-Datastore -Name $Datastore
   }

   Process {
      Foreach ($eachDsObj in $dsObject) {
         $hostviewDSDiskName = $eachDsObj.ExtensionData.Info.vmfs.extent[0].Diskname
         if ($eachDsObj.ExtensionData.Host) {
            $attachedHosts = $eachDsObj.ExtensionData.Host
            Foreach ($VMHost in $attachedHosts) {
               $hostview = Get-View $VMHost.Key
               $mounted = $VMHost.MountInfo.Mounted
               #If the device is mounted then unmount it
               if ($mounted -eq $true) {
                  $StorageSys = Get-View $HostView.ConfigManager.StorageSystem
                  Format-output -Text "Unmounting VMFS Datastore $($eachDsObj.Name) from host $($hostview.Name)..." -Level "INFO" -Phase "Unmount Datastore"
                  $StorageSys.UnmountVmfsVolume($eachDsObj.ExtensionData.Info.vmfs.uuid);
               } else {
                  Format-output -Text "VMFS Datastore $($eachDsObj.Name) is already unmounted on host $($hostview.Name)..." -Level "INFO" -Phase "Unmount Datastore"
               }
            }
         }
      }
   }
}

####################################################################################
#
#.SYNOPSIS
# Remove a datastore
#
#.DESCRIPTION
# Remove a datastore
#
#.PARAMETER
# Datastore = Datastore to delete
#
#.EXAMPLE
#
# Delete-Datastore -Datastore "local-0"
#
####################################################################################

Function Delete-Datastore {
   [CmdletBinding()]
   Param (
      [Parameter(ValueFromPipeline=$true)] [string]$Datastore
   )

   BEGIN {
      $dsObjectList = Get-Datastore -Name $Datastore
   }

   Process {
      Foreach ($eachDsObj in $dsObjectList) {
         if ($eachDsObj.ExtensionData.Host) {
            $attachedHosts = $ds.ExtensionData.Host
            $deleted = $false
            Foreach ($VMHost in $attachedHosts) {
               $hostview = Get-View $VMHost.Key
               if($deleted -eq $false) {
                  Format-output -Text "Removing Datastore $($eachDsObj.Name) on host $($hostview.Name)..." -Level "INFO" -Phase "Delete Datastore"
                  Remove-Datastore -Datastore $Datastore -VMHost $hostview.Name -Confirm:$false
                  $deleted = $true
               }
            }
         }
      }
   }
}

####################################################################################
#
#.SYNOPSIS
# Create a Vmfs6 datastore
#
#.DESCRIPTION
# Create a New Vmfs6 volume on the give Lun a datastore
#
#.PARAMETER
# LunCanonical = Canonical name of lun
# hostConnected = Hostobjects
#
#.EXAMPLE
#
# $LunCanonical = Get-ScsiLun -Datastore $Datastore | select -Property CanonicalName
# $hostConnected = Get-VMHost -Datastore $Datastore
# Create-Datastore -LunCanonical $LunCanonical -hostConnected $hostConnected
#
#
####################################################################################

Function Create-Datastore {
   [CmdletBinding()]
   Param (
      [Parameter(ValueFromPipeline=$true)] $LunCanonical,
      [Parameter(ValueFromPipeline=$true)] $hostConnected
   )

   Process {
      $device = @()
      $device = $LunCanonical
      $isCreated = $false
      $found = $True
      #check if the Datastore is still mounted or not in a busy vCenter
      $cliXmlPath = Join-Path -Path $variableFolder -ChildPath ("$Vmfs6Datastore" + ".xml")
      if (Test-Path $cliXmlPath) {
         $newVmfs6Datastore = Import-Clixml $cliXmlPath
         $Datastore = Get-Datastore -Name $newVmfs6Datastore.Name
      }

      #$Datastore1 = Get-Datastore -Name $Datastore.Name: 
      #This will fail, becaue $Datastore is already removed from host
      $fileSystemVersion = ($Datastore.FileSystemVersion).Split('.')[0]
      while ($found -and ($fileSystemVersion -eq 5)) {
         $srcDs = @() 
         $srcDs  += Get-Datastore     
         if (!$srcDs.contains($Datastore)) {
            $found = $False
         } 
      }

      $hostScsiDisk = @()
      foreach ($mgdHost in $hostConnected) {
         $path = $null
         if ($isCreated -eq $false) { 
            if ($device -is [System.Array]) { 
               $path = $device[0]
            } else {
               $path = $device
            }

            if ($fileSystemVersion -lt 6) {
               New-Datastore -VMHost $mgdHost.Name  -Name $Datastore.Name -Path $path -Vmfs -FileSystemVersion 6 | Out-Null
               Format-output -Text "Create new datastore is done" -Level "INFO" -Phase "Datastore Create"
               $newVmfs6Datastore = Get-Datastore -Name $Datastore.Name | Export-Clixml $cliXmlPath
            }

            # if we have more than one unique $device per datastore, we need to expand the current DS.
            if ($device.Count -gt 1) {
               $newDatastoreObj = Get-Datastore -Name $Datastore -ErrorAction SilentlyContinue             
               $BaseExtent = $newDatastoreObj.ExtensionData.Info.Vmfs.Extent | Select -ExpandProperty DiskName
               $hostSys = Get-View -Id ($newDatastoreObj.ExtensionData.Host | Get-Random | Select -ExpandProperty Key)
               $DataStoreSys = Get-View -Id $hostSys.ConfigManager.DatastoreSystem
               $hostScsiDisk = $DataStoreSys.QueryAvailableDisksForVmfs($newDatastoreObj.ExtensionData.MoRef)
               $existingLuns = Get-ScsiLun -Datastore $Datastore.Name |select -ExpandProperty CanonicalName|select -Unique 
               $newDevList = Compare-Object  $device $existingLuns -PassThru
               foreach ($eachDevice in $newDevList) {
                  # expand the datastore.
                  $canName = Get-ScsiLun -CanonicalName $eachDevice -VmHost $mgdHost.Name
                  $lun = $hostScsiDisk | where{ $BaseExtent -notcontains $_.CanonicalName -and $_.CanonicalName -eq $CanName }
                  $vmfsExtendOpts = $DataStoreSys.QueryVmfsDatastoreExtendOptions($newDatastoreObj.ExtensionData.MoRef, $lun.DevicePath, $null)                    
   			      $spec = $vmfsExtendOpts.Spec
                  $DataStoreSys.ExtendVmfsDatastore($newDatastoreObj.ExtensionData.MoRef, $spec)
                  Format-output -Text "Extending of datastore is done" -Level "INFO" -Phase "Extend Datastore"
               }
            }
            $isCreated = $true
         }

         #refresh storage on this host and see if the datastore created can be fetched from $mdgHost.
         $mgdHostDatastores = Get-Datastore -VMHost $mgdHost.Name
         if($mgdHostDatastores -contains $Datastore ){
            Format-output -Text "The datastore $Datastore found on host: $mgdHost " -Level "INFO" -Phase "VMFS6 Verify"
         }
      }
   }   
}

#.ExternalHelp StorageUtility.psm1-help.xml
Function Update-VmfsDatastore {
   [CmdletBinding(SupportsShouldProcess=$true,  ConfirmImpact='High')]
   param (
      [Parameter(Mandatory=$true)][VMware.VimAutomation.ViCore.Types.V1.VIServer]$Server,
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)][VMware.VimAutomation.ViCore.Types.V1.DatastoreManagement.Datastore]$Datastore,
      [Parameter(Mandatory=$true)][VMware.VimAutomation.ViCore.Types.V1.DatastoreManagement.Datastore]$TemporaryDatastore,
      [Parameter()][Int32]$TargetVmfsVersion,
      [Switch]$Rollback,
      [Switch]$Resume,
      [Switch]$Force
   )

   $variableFolder = "log_folder_$($Server.Name)_$($Datastore.Name)"
   if(!(Test-Path $variableFolder)) {
      New-Item -ItemType directory -Path $variableFolder | Out-Null
   }

   #check point saved for each stage
   $checkFile = "check$($Server.Name)$($Datastore.Name)"
   $LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
   $workingDirectory = (Get-Item -Path $variableFolder -Verbose).FullName
   $logFileName = "Datastore_Upgrade_" + $LogTime + ".log"
   $global:LogFile = Join-Path $workingDirectory $logFileName
   Format-output -Text "Log  folder path: $workingDirectory" -Level "INFO" -Phase  "Preparation"
   Format-output -Text "Log  file path: $global:LogFile" -Level "INFO" -Phase  "Preparation"
   Format-output -Text "Checkpoint file path: $checkFile" -Level "INFO" -Phase  "Preparation"
   $caption = "WARNING !!"
   $warning = "Update VMFS datastore. This operation will delete the datastore to update and will re-create the VMFS 6 datastore using the same LUN. Do yo want to continue?"
   $description = "This operation will delete the datastore to update and will re-create the VMFS 6 datastore using the same LUN."
   Format-output -Text "The datastore $Datastore will deleted and Recreated with VMFS-6." -Level "ERROR" -Phase "Preparation"
   if ($PSCmdlet.ShouldProcess($description, $warning, $caption) -eq $false) {
      Return
   }

   # Check if HBR or SRM is enabled
   $warningCaption = "WARNING !!"
   $warningQuery = "The update to VMFS-6 of VMFS-5 datastore should not be done if HBR or SRM is enabled. Do you still want to continue?"
   Format-output -Text "The datastore $Datastore Should not be part of HBR[Target/Source] / SRM config." -Level "ERROR" -Phase "Preparation"
   if (($Force -Or $PSCmdlet.ShouldContinue($warningQuery, $warningCaption)) -eq $false) {
      Return
   }

   #Workflow begins here

   # Check that target VMFS version is 6. only 6 is supported at present
   if ($TargetVmfsVersion -ne 0 -and $TargetVmfsVersion -ne 6) {
      Format-output -Text "Update to target VMFS version $TargetVmfsVersion is not supported. Only VMFS 6 is supported as target VMFS version" -Level "ERROR" -Phase "Preparation"
      Return
   }

   #Check PrimaryDatastore is present in the Datastore list from VC
   $PrimaryDsStaus = Get-Datastore |where { $_.Name -eq $Datastore.Name}
   $DatastoreName = $null
   if ($PrimaryDsStaus -ne $null) {
      $PrimaryDatastore = Get-Datastore $Datastore.Name
      if ($PrimaryDatastore -eq $null) {
         Format-output -Text "The datastore $Datastore does not exist or has been removed." -Level "ERROR" -Phase "Preparation"
         Return
      }
      $Datastore | Export-Clixml (Join-Path $variableFolder 'PrimaryDs.xml')
   }

   # Verify thet the specified server is vCenter server
   if (-not $server.ExtensionData.Content.About.Name.Contains("vCenter")) {
      Format-output -Text "The specified server is not a vCenter server." -Level "ERROR" -Phase "Preparation"
      Return
   }

   # Verify the vCenter server is of $targetServerVersion or higher
   $targetServerVersion = New-Object System.Version("6.5.0")
   $vcVersion = New-Object System.Version($Server.Version)
   if ($vcVersion -lt $targetServerVersion) {
      Format-output -Text "The vCenter server is not upgraded to $targetServerVersion." -Level "ERROR" -Phase "Preflight Check"
      Return
   }

   # Verify that $PrimaryDatastore and $TemporaryDatastore are in specified vCenter server
   if ($PrimaryDsStaus -ne $null) {
      $ds = Get-Datastore -Id $PrimaryDatastore.Id -Server $Server
      if ($ds -eq $null -Or $ds.Uid -ne $PrimaryDatastore.Uid) {
         Format-output -Text "The datastore $PrimaryDatastore is not present in specified vCenter $Server." -Level "ERROR" -Phase "Preflight Check"
         Return
      }
   }
   $tempDs = Get-Datastore -Id $TemporaryDatastore.Id -Server $Server
   if ($tempDs -eq $null -Or $tempDs.Uid -ne $TemporaryDatastore.Uid) {
      Format-output -Text "The temporary datastore $TemporaryDatastore is not present in specified vCenter $Server." -Level "ERROR" -Phase "Preflight Check"
      Return
   }

   #Verify if first class disks are present in the primary datastore
   $vdisk = Get-VDisk -Datastore $PrimaryDatastore
   if ($vdisk -ne $null) {
      $msgText = "FCD disks can't be moved. Please migrate them then start the commandlet again."
      Format-output -Text "$msg1" -Level "ERROR" -Phase "Preflight Check"
      Return
   }

   #Verify if the Host connected to Primary datastore is part of HA
   $cluster = Get-VMHost -Datastore $PrimaryDatastore | Get-Cluster
   if($cluster) {
      if($cluster.HAEnabled){
         $msg1 = "The host connected to datastore $PrimaryDatastore is part of HA cluster"
         Format-output -Text "$msg1" -Level "INFO" -Phase "Preflight Check"
      }
   }

   # Verify that VADP is disable. If enabled quit
   Format-output -Text "checking if VADP is enabled on any of the VMs" -Level "INFO" -Phase "Preflight Check"
   if ($PrimaryDsStaus -ne $null) {
      $vmList = Get-VM -Datastore $PrimaryDatastore
      Format-output -Text "Checking for VADP enabled VM(s)" -Level "INFO" -Phase "Preflight Check"
      foreach ($vm in $vmList) {
         $disabledMethods = $vm.ExtensionData.DisabledMethod
         if ($disabledMethods -contains 'RelocateVM_Task') {
            Format-output -Text "Cannot move virtual machine $vm because migration is disabled on it." -Level "ERROR" -Phase "Preflight Check"
            Return
         }
      }

      # Verify that SMPFT is not turned ON
      Format-output -Text "checking if SMPFT is enabled on any of the VMs" -Level "INFO" -Phase "Preflight Check"
      foreach ($vm in $vmList) {
         $vmRuntime = $vm.ExtensionData.Runtime
         if ($vmRuntime -ne $null -and $vmRuntime.FaultToleranceState -ne 'notConfigured') {
            Format-output -Text "Cannot move VM $vm because FT is configured for this VM." -Level "ERROR" -Phase "Preflight Check"
            Return
         }
      }

      #If PrimaryDs is part of DsCluster the TempDs should be part of same DsCluster
      $primeDsCluster = Get-DatastoreCluster -Datastore $PrimaryDatastore
      $tempDsCluster  = Get-DatastoreCluster -Datastore $TemporaryDatastore
      if (($primeDsCluster -ne $tempDsCluster) -and !$Resume) {
         Format-output -Text "Both Primary/Source Datastore and Temparory Datastore should be part of same sDrs-Cluster : $primeDsCluster" -Level "ERROR" -Phase "Preflight Check"
         Return
      }

      # Verify MSCS, Oracle cluster is not enabled
      Format-output -Text "checking if MSCS/Oracle[RAC] Cluster is configured on any of the VMs" -Level "INFO" -Phase "Preflight Check"
      if ($vmList -ne $null){
         $hdList = Get-HardDisk -VM $vmList
         foreach ($hd in $hdList) {
            if ($hd.ExtensionData.Backing.Sharing -eq 'sharingMultiWriter') {
               $vm = $hd.Parent
               $msg1= "The disk:$hd is in Sharing mode -Multi-writer flag is on. The virtual machine:$vm may be part of a cluster"
               $msg2= "If you want to proceed please disable the cluster settings on VM and -Resume again."
               Format-output -Text "$msg1, $msg2" -Level "ERROR" -Phase "Preflight Check"
               Return
            } else {
               $scsiController = Get-ScsiController -HardDisk $hd
               if (($scsiController.UnitNumber -ge 1) -and ($scsiController.BusSharingMode -ne 'NoSharing')) {
                  $msg1= "The scsi controller:$scsiController attached to the $vm is in sharing mode and hence the VM cannot be migrated. The VM may be part of a cluster"
                  $msg2= "If you want to proceed please disable the cluster settings on VM and -Resume again."
                  Format-output -Text "$msg1,$msg2" -Level "ERROR" -Phase "Preflight Check"
                  Return
               }
            }
         }
      }
   }

   $ErrorActionPreference = "stop"
   $checkCompleted = $null
   $ImportPrimeDs = Import-Clixml (Join-Path $variableFolder 'PrimaryDs.xml')
   $DatastoreName = $ImportPrimeDs.Name
   $RollBackOption = $Rollback 
   if($RollBackOption -eq $true -and $Resume -eq $true) {
      write-host "Both Resume and Staging-rollback cannot be true at the same time. Returning.."
      Return
   }

   if ($Resume -eq $true -or $RollBackOption -eq $true) {
      if (Test-Path $checkFile) {
         $checkCompleted = get-content $checkFile
         $checkCompleted = $checkCompleted -as [int]
         if ($checkCompleted -eq $null -and $Resume -eq $True) {
            $datastoreFsVersion = (Get-Datastore -name $DatastoreName).FileSystemVersion.split('.')[0]
            if($datastoreFsVersion -eq 6) {
               # In case post vmfs update, if the checkpoint get corrupted then cmdlet can't proceed futher.
               Format-output -Text "Datastore is of VMFS-6 type and " -Level "ERROR" -Phase "Resume-Post Update" 
               Format-output -Text "check-point file is corrupted so cannot proceed further. Manually move back the contents from Temporary Datastore " -Level "ERROR" -Phase "Resume-Post Update" 
               Return
            }
            Format-output -Text "check-point file is corrupted/not found, proceeds from beginning" -Level "INFO" -Phase "Preparation" 
         }
      } elseif ($RollBackOption -eq $false) {
         $datastoreFsVersion = (Get-Datastore -name $DatastoreName).FileSystemVersion.split('.')[0]
         if ($datastoreFsVersion -eq 6 -and $Resume -eq $true) {
            # In case post vmfs update, if the checkpoint file removed then cmdlet can't proceed futher.
            # If checkpoint file is missing post vmfs update cmdlet don't know the progress, so throw error
            Format-output -Text "Datastore is of VMFS-6 type and " -Level "ERROR" -Phase "Resume-Post Update" 
            Format-output -Text "check-point file is not available so cannot proceed further. Manually move back the contents from Temporary Datastore " -Level "ERROR" -Phase "Resume-Post Update" 
            Return
         } 

         #pre vmfs6 update proceed the resume from beginning
         $checkCompleted = 0
         Format-output -Text "Writing checkCompleted :  $checkCompleted" -Level "INFO" -Phase "Preparation"
         $checkCompleted | out-file $checkFile
      }
   } else {
      $checkCompleted = 0
      $checkCompleted | out-file $checkFile
   }

   if ($RollBackOption -eq $true) {
      if($checkCompleted -eq $null){
         Format-output -Text "check-point file is corrupted/not found cannot roll back. Manually move back the contents from Temporary Datastore " -Level "ERROR" -Phase "Roll Back" 
         Return
      } elseif ($checkCompleted -lt 5) {
         $msgText = "No action performed previously to Roll back, Rollback is not needed"
         Format-output -Text $msgText -Level "INFO" -Phase "Roll-back"
         Return
      }

      $checkCompleted = $checkCompleted + 1
      $dsCheck = Get-Datastore -name $DatastoreName
      if ($dsCheck.Type.Equals('VMFS')) {
  	      if (($dsCheck.FileSystemVersion).split('.')[0] -eq 6) {
            $msgText1 = "Datastore is upgraded to VMFS6.Upgrade is in post-upgrade stage,can not rollback. Returning"
            $msgText2 = "At this stage only -Resume is allowed"
            Format-output -Text "$msgText1, $msgText2" -Level "Error" -Phase "Pre-Roll Back Check"
            Return
         }
      } else {
         $msgText = "Datastore to upgrade is not of VMFS type. Returning."
         Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
         Return
      }

      if ($checkCompleted -ge 9) {
         $msgText = "Moving VMs back to original datastore, if present."
         Format-output -Text $msgText -Level "INFO" -Phase "VM Migration"
         $vmList = @()
         $vms = Get-Datastore $TemporaryDatastore | Get-VM
         foreach ($eachVM in $vms ) {
            $vmList += $eachVM.Name 
         }

         try {
            if ($vmList.Count -gt 0) {
               $RelocTaskList = Concurrent-SvMotion -session $Server -Source $TemporaryDatastore -VM $vmList -Destination $DatastoreName -ParallelTasks 2
               foreach ($eachTask in $RelocTaskList) {
                  if ($eachTask["State"] -ne "Success") { 
                     Format-output -Text "VM failed to Migrate try running the commandlet again with -Resume option." -Level "Error" -Phase "VM Migration"
                     Return
                  }
               }
            }
         } catch {
            $errName = $_.Exception.GetType().FullName
            $errMsg = $_.Exception.Message
            Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Moving Vms during Rollback."
            Format-output -Text "Unable to proceed, try running the commandlet again. If problem persists, move all the VMs from $TemporaryDataStore to $DatastoreName manually and then try again." -Level "ERROR" -Phase "Moving VMs during rollback."
            Return
         }
      }

      if ($checkCompleted -ge 11) {
         $msgText = "Moving orphaned data back to original datastore, if present"
         Format-output -Text $msgText -Level "INFO" -Phase "Roll-back Orphan data"
         try {
            $dsItems = Get-DatastoreItems -Datastore $TemporaryDatastore
            if (($dsItems -ne $null) -and ($dsItems.Count) -gt 0 ) {
               Format-output -Text "Moving Orphaned items to $DatastoreName" -Level "INFO" -Phase "Copying Orphaned Items"
               Format-output -Text "all the contents already available in $DatastoreName; so skip copy from $TemporaryDatastore" -Level "INFO" -Phase "Copying Orphaned Items"
            }

            #Register template VM[s] back in respective hosts.
            $SrcTemplateMapXml = Join-Path $variableFolder 'SrcTemplateMap.xml'
            if (Test-Path SrcTemplateMapFilepath) {
               $SrcTemplateMap = Import-Clixml $SrcTemplateMapXml
               foreach ($templatePath in $SrcTemplateMap.Keys) {
                  try {
                     $register = New-Template –VMHost $SrcTemplateMap[$templatePath] -TemplateFilePath $templatePath
                     $esxHost= $SrcTemplateMap[$templatePath]
                     Format-output -Text "Template VM registered in host $esxHost " -Level "INFO" -Phase "Template Register" 
                  } catch {
                     $errName = $_.Exception.GetType().FullName
                     if ($errName -match  "AlreadyExists") {
                        Format-output -Text "$templatePath :Template already registered" -Level "INFO" -Phase "Template Register"
                     }
                  }
               }
            } 
         } catch {
            $errName = $_.Exception.GetType().FullName
            $errMsg = $_.Exception.Message
            Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Moving orphaned data"
            Format-output -Text "Unable to proceed, try running the commandlet again. If problem persists, move all the orphaned data from $TemporaryDataStore to $DatastoreName manually and then try again." -Level "ERROR" -Phase "Moving orphaned data."
            Return
         }
      }

      if ($checkCompleted -ge 8) {
         $msgText = "Changing back datastore cluster properties to previous State."
         Format-output -Text $msgText -Level "INFO" -Phase "SDRS Cluster"
         $sdrsClusterXml = Join-Path $variableFolder 'sdrsCluster.xml'
         if (Test-Path $sdrsClusterXml) {
            $dsCluster =  Import-CliXml $sdrsClusterXml
            if ($dsCluster.Name -ne $null) {
               $datastorecluster = Get-DatastoreCluster -Name $dsCluster.Name
            }
         }

         $oldAutomationLevelXml = Join-Path $variableFolder 'oldAutomationLevel.xml'
         if (Test-Path $oldAutomationLevelXml) {
            $oldAutomationLevel = Import-CliXml $oldAutomationLevelXml
         }

         $ioloadbalancedXml = Join-Path $variableFolder 'ioloadbalanced.xml'
         if (Test-Path $ioloadbalancedXml) {
            $ioloadbalanced = Import-CliXml $ioloadbalancedXml
         }

         if ($oldAutomationLevel) {
            Set-DatastoreCluster -DatastoreCluster $datastorecluster -SdrsAutomationLevel $oldAutomationLevel | Out-Null
         }

         if ($ioloadbalanced) {
            Set-DatastoreCluster -DatastoreCluster $datastorecluster -IOLoadBalanceEnabled $ioloadbalanced | Out-Null
         }
      }

      if ($checkCompleted -ge 7) {
         $msgText = "Changing datastore properties to previous State"
         Format-output -Text $msgText -Level "INFO" -Phase "StorageIOControl"

         $ds1iocontrolXml = Join-Path $variableFolder 'ds1iocontrol.xml'
         if (Test-Path $ds1iocontrolXml) {
            $ds1iocontrol = Import-CliXml $ds1iocontrolXml
         }

         $ds2iocontrolXml = Join-Path $variableFolder 'ds2iocontrol.xml'
         if (Test-Path $ds2iocontrolXml) {
            $ds2iocontrol = Import-CliXml $ds2iocontrolXml
         }

         if ($ds1iocontrol) {
            (Get-Datastore -Name $DatastoreName) | set-datastore -storageIOControlEnabled $ds1iocontrol | Out-Null
         }

         if ($ds2iocontrol) {
            (Get-Datastore -Name $TemporaryDatastore) | set-datastore -storageIOControlEnable $ds2iocontrol | Out-Null
         }
      }

      if ($checkCompleted -ge 6) {
         $msgText = "Changing cluster properties to previous State"
         Format-output -Text $msgText -Level "INFO" -Phase "Cluster properties"
         $drsMapXml = Join-Path $variableFolder 'drsMap.xml'
         if (Test-Path $drsMapXml) {
            $drsMap = Import-CliXml $drsMapXml
         }

         $clustersXml = Join-Path $variableFolder 'clusters.xml'
         if (Test-Path $clustersXml) {
            $tempClus = Import-CliXml $clustersXml
            if ($tempClus.Name -ne $null) {
               $clusters = Get-Cluster -Name $tempClus.Name
            }
         }

         if ($clusters -and $drsMap) {
            foreach ($clus in $clusters) {
               Set-Cluster -Cluster $clus -DrsAutomationLevel $drsMap[$clus.Name] -Confirm:$false | Out-Null
            }
         }
      }

      Format-output -Text "Rollback completed successfully" -Level "INFO" -Phase "Rollback successful"
      Zip-Logs -logdir $variableFolder
      Remove-Item $variableFolder -recurse
      Remove-Item $checkFile
      $errorActionPreference = 'continue'
      Return
   }

   #check 1
   $tempDsItems = Get-DatastoreItems -Datastore $TemporaryDatastore
   try {
      if ($checkCompleted -lt 1) {
         if ($tempDsItems -ne $null -and !$RollBackOption -and !$Resume) {
            Format-output -Text "$TemporaryDatastore is not Empty:$tempDsItems this operation could cause damage to files in $TemporaryDatastore. Returning" -Level "Error" -Phase "Querying Temporary datastore"
            Return
         }

         $checkCompleted = 1
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Querying Temporary datastore"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "Error" -Phase "Querying Temporary datastore"
      Return
   }

   # check 2
   # Check if hosts connected to DS are upgraded
   try {
      if ($checkCompleted -lt 2) {
         $hostConnectedToDs = Get-VMHost -Datastore $Datastore
         $hostObjects = Get-View -VIObject $hostConnectedToDs
         $status = CheckHostVersion -HostObjects $hostObjects -Version $targetServerVersion
         if ($status -eq $false) {
            Format-output -Text "Hosts are not upgraded to $targetServerVersion. Returning " -Level "INFO" -Phase "Preflight Check"
            Return
         }

         # All hosts connected to DS should be also connected to temp DS
         $hostConnectedToTempDs = Get-VMHost -Datastore $TemporaryDatastore
         Format-output -Text "checking if the Target Datastore is accessbile to all the Hosts, as of Source" -Level "INFO" -Phase "Preflight Check"
         if (Compare-Object $hostConnectedToDs $hostConnectedToTempDs -PassThru) {
            $msg1= "Temporary datastore $TemporaryDatstore is not accessible from one or more host(s)"
            $msg2= "Ensure the Hosts connected to Source and Temporary Datastores are same."
            Format-output -Text "$msg1,$msg2" -Level "ERROR" -Phase "Preflight Check" 
            Return
         }

         $checkCompleted = 2
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Querying Hosts"
      $msg1= "Unable to proceed, try running the commandlet again with -Resume option"
      $msg2= "Or Source datastore might be re-created with VMFS-6 filesystem"
      Format-output -Text "$msg1, $msg2" -Level "Error" -Phase "Querying Hosts"
      Return
   }

   # Check if the Temporary DS size is >= Size of DS requiring Vmfs6 upgrade
   $tmpDs = $TemporaryDatastore
   $tmpDsSize = [math]::Round($tmpDs.CapacityMB)

   # Check 3
   try {
      if ($checkCompleted -lt 3) {
         if ($tmpDs.Type.Equals('VMFS')) {
            Format-output -Text "checking if Temporary Datastore is of VMFS-5 type" -Level "INFO" -Phase "Preflight Check"
            if ($tmpDs.FileSystemVersion -lt 6 -and $tmpDs.FileSystemVersion -gt 4.999) {
               $msgText = "$TemporaryDatastore is of VMFS 5 type"
               Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
            } else {
               $msgText = "$TemporaryDatastore is not of VMFS 5 type, Returning."
               Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
               Return
            }
         } else {
            $msgText = "$TemporaryDatastore is not of VMFS 5 type, Returning.."
            Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
            Return
         }

         $checkCompleted = 3
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Querying Temporary datastore"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "Error" -Phase "Querying Temporary datastore"
      Return
   }

   # Check 4
   try {
      if ($checkCompleted -lt 4){
         $datastoreObj1 = Get-Datastore -Name $DatastoreName
         $dsSize = [math]::Round($datastoreObj1.CapacityMB)
         Format-output -Text "checking Datastores capacity" -Level "INFO" -Phase "Preflight Check"
         if ($tmpDsSize -ge $dsSize) {
            $msgText = "$TemporaryDatastore having Capacity : $tmpDsSize MB Greater or Equal than $DatastoreName capacity : $dsSize MB"
            Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
         } else {
            $msgText = "$TemporaryDatastore having Capacity : $tmpDsSize MB lesser than $DatastoreName capacity : $dsSize MB. Returning.."
            Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
            Return
         }
         $checkCompleted = 4
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Querying Temporary datastore"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "Error" -Phase "Querying Temporary datastore"
      Return
   }

   # Get all the VMs connected
   $VirtualMachineObjects = Get-View -ViewType VirtualMachine

   # Get All the host connected to datastores
   $DatastoreHostMap = Get-HostsConnectedToDatastore

   # For each Connected VM get the Datastores associated
   foreach ($vm in $VirtualMachineObjects) {
      $VmMap +=  Get-VmDatastore -Vm $vm
   }

   $RelocTaskList = @()
   $RelocTaskList1 = @()
   # Iterate through the $VmMap and perform the storage vMotion
   $esxMap = @{}
   $esxUser = @{}
   $esxPass = @{}
   $esxLoc = @{}
   $countesx=0
   #check 5
   try {
      if ($checkCompleted -lt 5) {
         $dsCheck = Get-Datastore -name $DatastoreName
         if ($dsCheck.Type.Equals('VMFS')) {
            if ($dsCheck.FileSystemVersion -lt 6 -and $dsCheck.FileSystemVersion -gt 4.999) {
               $msgText = "$DatastoreName to upgrade is of VMFS 5 type"
               Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
            } else {
               $msgText = "$DatastoreName to upgrade is not of VMFS 5 type, Returning."
               Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
               Return
            }
         } else {
            $msgText = "$DatastoreName to upgrade is not of VMFS 5 type, Returning.."
            Format-output -Text $msgText -Level "INFO" -Phase "Preflight Check"
            Return
         }
         $checkCompleted = 5
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Querying datastore version"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "Error" -Phase "Querying datastore version"
      Return
   }

   # Setting DRS automation level to manual of cluster.
   $drsAutoLevel = $null
   try {
      # $dsCluster = Get-DatastoreCluster -datastore $DatastoreName
      $drsMap = @{}
      $clusters = @()
      # check 6
      if ($checkCompleted -lt 6) {
         #$clusters=get-cluster
         $clusters = Get-Datastore -Name  $DatastoreName |Get-VMHost|Get-Cluster
         $datastoreCluster = Get-DatastoreCluster -datastore $DatastoreName
         $msgText = "Changing DrsAutomationLevel of clusters to manual. Will be reverted to original once operation is completed."		  
         foreach ($clus in $clusters) {
            $drsMap[$clus.Name]=$clus.DrsAutomationLevel
         }
         if ($drsMap -ne $null) {
            $drsMap | Export-CliXml (Join-Path $variableFolder 'drsMap.xml')
         }
         if ($datastoreCluster-ne $null) {
            $datastoreCluster | Export-CliXml (Join-Path $variableFolder 'sdrsCluster.xml')
         }
         if ($clusters -ne $null) {
            $clusters | Export-CliXml (Join-Path $variableFolder 'clusters.xml')
         }
         foreach ($clus in $clusters) {
            if ($clus.DrsEnabled) {
               Format-output -Text $msgText -Level "INFO" -Phase "DRS Cluster Settings"
               Set-Cluster -Cluster $clus -DrsAutomationLevel Manual -confirm:$false | Out-Null
            }
         }
         $checkCompleted = 6
         $checkCompleted | out-file $checkFile
      } else {
         $drsMapXml = Join-Path $variableFolder 'drsMap.xml'
         if (Test-Path $drsMapXml) {
            $drsMap = Import-CliXml $drsMapXml
         } else {
            Format-output -Text "Unable to find the configuration files no changes done to DRS cluster." -Level "INFO" -Phase "Querying DRS"
         }

         $sdrsClusterXml = Join-Path $variableFolder 'sdrsCluster.xml'
         if (Test-Path $sdrsClusterXml) {
            $datastoreCluster = Import-CliXml $sdrsClusterXml
         } else {
            Format-output -Text "Unable to find the configuration files no changes will be done SDRS cluster." -Level "INFO" -Phase "Querying SDRS"
         }

         $clustersXml = Join-Path $variableFolder 'clusters.xml'
         if (Test-Path $clustersXml) {
            $tempClus = Import-CliXml $clustersXml
            if ($tempClus.Name -ne $null) {
               $clusters = get-cluster -Name $tempClus.Name
            }
         } else {
            Format-output -Text "Unable to find the DRS and SDRS configuration files, No action will be take on these clusters." -Level "INFO" -Phase "Querying DRS and SDRS config"
         }
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Capturing settings."
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "Error" -Phase "Capturing settings."
   }

   #check 7 : getting and setting storageIOControlEnabled
   $ds1iocontrol = $false
   $ds2iocontrol = $false
   try {
      if ($checkCompleted -lt 7) {
         # $dsCluster = Get-DatastoreCluster -datastore $DatastoreName
         $msgText = "Changing storageIOControlEnabled to false. It will be reverted to original once operation is complete."		  
         $ds1iocontrol=(Get-Datastore -Name $DatastoreName).StorageIOControlEnabled
         $ds2iocontrol=(Get-Datastore -Name $TemporaryDatastore).StorageIOControlEnabled
         $ds1iocontrol | Export-CliXml (Join-Path $variableFolder 'ds1iocontrol.xml')
         $ds2iocontrol | Export-CliXml (Join-Path $variableFolder 'ds2iocontrol.xml')
         if ($ds1iocontrol) {
            Format-output -Text $msgText -Level "INFO" -Phase "StorageIOControl"
            (Get-Datastore -Name $DatastoreName) | set-datastore -storageIOControlEnabled $false | Out-Null
         }
         if ($ds2iocontrol) {
            Format-output -Text $msgText -Level "INFO" -Phase "StorageIOControl"
            (Get-Datastore -Name $TemporaryDatastore) | set-datastore -storageIOControlEnabled $false | Out-Null
         }
         $checkCompleted = 7
         $checkCompleted | out-file $checkFile
      } else {
         $ds1iocontrolXml = Join-Path $variableFolder 'ds1iocontrol.xml'
         if (Test-Path $ds1iocontrolXml) {
            $ds1iocontrol = Import-CliXml $ds1iocontrolXml
         }

         $ds2iocontrolXml = Join-Path $variableFolder 'ds2iocontrol.xml'
         if (Test-Path $ds2iocontrolXml) {
            $ds2iocontrol = Import-CliXml $ds2iocontrolXml
         }
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "StorageIOControl."
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "Error" -Phase "StorageIOControl"
      Return
   }

   $tmpDs = Get-Datastore -Name $TemporaryDatastore
   #check 8 : getting and setting stuffs related to datastore cluster
   $datastorecluster = Get-DatastoreCluster -Datastore $tmpDs
   $oldAutomationLevel = 0
   $ioloadbalanced = 0
   try {
      if ($checkCompleted -lt 8) {
         if ($datastorecluster) {
            $msgText = "Save properties of datastore cluster. It will be reverted to original once operation is complete."
            Format-output -Text $msgText -Level "INFO" -Phase "DRS Cluster"
            $oldAutomationLevel = $datastorecluster.SdrsAutomationLevel
            $ioloadbalanced = $datastorecluster.IOLoadBalanceEnabled
            $oldAutomationLevel | Export-CliXml (Join-Path $variableFolder 'oldAutomationLevel.xml')
            $ioloadbalanced | Export-CliXml (Join-Path $variableFolder 'ioloadbalanced.xml')
            Set-DatastoreCluster -DatastoreCluster $datastorecluster -SdrsAutomationLevel Manual -IOLoadBalanceEnabled $false | Out-Null
         }
         $checkCompleted = 8
         $checkCompleted | out-file $checkFile
      } else {
         $sdrsClusterXml = Join-Path $variableFolder 'sdrsCluster.xml'
         if (Test-Path $sdrsClusterXml) {
            $dsClusterExists = Import-CliXml $sdrsClusterXml
         }

         if ($dsClusterExists) {
            $oldAutomationLevelXml = Join-Path $variableFolder 'oldAutomationLevel.xml'
            if (Test-Path $oldAutomationLevelXml) {
               $oldAutomationLevel = Import-CliXml $oldAutomationLevelXml
            }

            $ioloadbalancedXml = Join-Path $variableFolder 'ioloadbalanced.xml'
            if (Test-Path $ioloadbalancedXml) {
               $ioloadbalanced = Import-CliXml $ioloadbalancedXml
            } 
         }  
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Moving datastore to same cluster"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option. If problem persists, move both the datastores to same cluster manually and then try again." -Level "Error" -Phase "Moving datastore to same cluster"
      Return
   }

   # Getting list of VMs present on datastore to migrate.
   $vmList = @()

   #check 9 : Move VMs across datastores
   try {
      if ($checkCompleted -lt 9) {
         # Getting list of VMs present on datastore to migrate.	     
         $vms = Get-Datastore $DatastoreName | Get-VM
         foreach ($eachVM in $vms) {
            $vmList += $eachVM.Name 
         }
         if ($vmList.Count -gt 0) {
            Format-output -Text "Moving list of VMs to temporary datastore." -Level "INFO" -Phase "Preparation"
            Format-output -Text "$vmList" -Level "INFO" -Phase "Preparation"
            $RelocTaskList = Concurrent-SvMotion -session $Server -Source $Datastore -VM $vmList -Destination $TemporaryDatastore -ParallelTasks 2 
            foreach ($eachTask in $RelocTaskList) {
               if ($eachTask["State"] -ne "Success") { 
                  Format-output -Text "VM failed to Migrate try running the commandlet again with -Resume option." -Level "Error" -Phase "Preperation"
                  Return
               }
            }

            # if there are any active VMs left , throw error
            $vms = Get-Datastore $DatastoreName | Get-VM
            if ($vms -ne $null) { 
               $vswapItems = Get-DatastoreItems -Datastore $DatastoreName -Recurse -fileType $vswap
               if ($vswapItems) {
                  $msgText1 = "There are still active  .vswp :$vswapItems files in $DatastoreName, which can't be migrated "
                  $msgText2 = "Please move these files to other datastore then try again with -Resume option "
                  Format-output -Text "$msgText1, $msgText2"  -Level "ERROR" -Phase "Migraton"
                  Return
               }
               Return
            }            
         } else {
            Format-output -Text "No VirtualMachine is running from $DatastoreName" -Level "INFO" -Phase "Preperation"
         }
         $checkCompleted = 9
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Moving Virtual Machines"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option. If problem persists, move all the VMs from $DatastoreName to $TemporaryDatastore manually and then try again." -Level "Error" -Phase "Moving Virtual Machines"
      Return
   }

   $tagList = $null
   # check 10 : Datastore Tag
   if ($checkCompleted -lt 10) {
      # Save Tags attached to the Source Datastore
      $msgText = "Getting list of tags assigned to datastore. These tags will be applied to final VMFS 6 datastore."
      try {
         $tagList = Get-TagAssignment -Entity $DatastoreName | Select -ExpandProperty Tag
         if ($tagList) { 
            Format-output -Text $msgText -Level "INFO" -Phase "Datastore Tagging"
            $tagList | Export-CliXml (Join-Path $variableFolder 'TagList.xml')
         }
      } catch {
         $errName = $_.Exception.GetType().FullName
         $errMsg = $_.Exception.Message
         Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Datastore Tagging"
         Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "Error" -Phase "Datastore Tagging"
         Return
       } 
       $checkCompleted = 10
       $checkCompleted | out-file $checkFile
   }
	
   # check 11 : move orphaned data to temporary datastore
   $SrcTemplateMap = @{}
   if ($checkCompleted -lt 11) {
      try{
         $vswap = ".vswp"
         $snapShotDelta = "-delta.vmdk"
         $vswapItems = Get-DatastoreItems -Datastore $DatastoreName -Recurse -fileType $vswap
         $snapShotDeltaItems = Get-DatastoreItems -Datastore $DatastoreName -Recurse -fileType $snapShotDelta
         if ($vswapItems -or $snapShotDeltaItems ) {
            $msgText1 = "SnapShot delta disks:$snapShotDeltaItems (or) .vswp :$vswapItems files can't be moved "
            $msgText2 = "Please move these files to other datastore then try again with -Resume option "
            Format-output -Text "$msgText1, $msgText2"  -Level "ERROR" -Phase "Copying Orphaned Items"
            Format-output -Text "SnapShot delta disks:$snapShotDeltaItems (or) .vswp :$vswapItems" -Level "ERROR" -Phase "Copying Orphaned data"
            Return
         }

         $templates = Get-Template -Datastore $DatastoreName
         #Cache template VM DS PathName and respective Host
         $SrcTemplateMapXml = Join-Path $variableFolder 'SrcTemplateMap.xml'
         if ($Resume -and (Test-Path $SrcTemplateMapXml)) {
            $SrcTemplateMap = Import-Clixml $SrcTemplateMapXml
         }

         foreach ( $eachtemplate in $templates) {                       
            $hostId=$eachTemplate.HostId
            $hostRef = Get-VMHost -Id $hostId
            $templateVmPath = $eachTemplate.ExtensionData.Config.Files.VmPathName
            $SrcTemplateMap[$templateVmPath] = $hostRef.Name
            Remove-Template  $eachtemplate
            Format-output -Text "Template $eachtemplate unregistered from host $hostRef" -Level "INFO" -Phase "Copying Orphaned data"
            $SrcTemplateMap | Export-CliXml (Join-Path $variableFolder 'SrcTemplateMap.xml')
         }  
      } catch [Exception] {
         $errName = $_.Exception.GetType().FullName
         $errMsg = $_.Exception.Message
         Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Copying orphaned data"
         Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option. If problem persists, move all the orphaned data from $DatastoreName to $TemporaryDatastore manually and then try again." -Level "ERROR" -Phase "Copying orphaned data."
         Return
      }
      $dsItems = Get-DatastoreItems -Datastore $DatastoreName
      if (($dsItems -ne $null) -and ($dsItems.Count  -gt 0)) {
         # Copy all the orphaned items
         Format-output -Text "copying Orphaned items to $TemporaryDatastore" -Level "INFO" -Phase "Copying Orphaned data"
         $result = Copy-DatastoreItems -SourceDatastore $DatastoreName -DestinationDatastore $TemporaryDatastore
         if (!$result) {
            Format-output -Text "Try again with -Resume option" -Level "ERROR" -Phase "Copying orphaned data"
            Return
         }
      }
      $checkCompleted = 11
      $checkCompleted | out-file $checkFile
   }

   $hostConnected = @()
   $LunCanonical = @()
   #check 12 : Unmount datastore 
   if ($checkCompleted -lt 12) {
      $msgText = "Unmounting  datastore from all Hosts"
      Format-output -Text $msgText -Level "INFO" -Phase "Unmount Datastore"
      try {
         $hostConnected = Get-VMHost -Datastore $DatastoreName
         $LunCanonical = Get-ScsiLun -Datastore $DatastoreName | select -ExpandProperty CanonicalName |select -Unique
         #ExportCLI
         $hostConnected  | Export-CliXml (Join-Path $variableFolder 'srcHosts.xml')
         $LunCanonical   | Export-CliXml (Join-Path $variableFolder 'srcLunCanonical.xml')
         # Unmount the Source datastore from all the host
         Format-output -Text "Unmounting datastore $DSName..." -Level "INFO" -Phase "Unmount Datastore"
         Unmount-Datastore $DatastoreName     
      } catch [Exception] {
         $errName = $_.Exception.GetType().FullName
         $errMsg = $_.Exception.Message
         Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Unmount Datastore"
         Format-output -Text "Caught the exception while unmounting the datastore. Try again with -Resume option." -Level "ERROR" -Phase "Unmount Datastore"
         Return
      }
      $checkCompleted = 12
      $checkCompleted | out-file $checkFile
   }

   #check 13 : delete datastore 
   #Get the Lun
   if ($checkCompleted -lt 13) {
      $msgText = "Deleting and recreating VMFS-6 Filesystem."
      Format-output -Text $msgText -Level "INFO" -Phase "Delete  Datastore"
      try {
         #Delete the Source datastore from all the host       
         Format-output -Text "Deleting datastore $DSName from hosts..." -Level "INFO" -Phase "Delete  Datastore"
         Delete-Datastore $DatastoreName
      } catch [Exception] {
         $errName = $_.Exception.GetType().FullName
         $errMsg = $_.Exception.Message
         Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Delete  Datastore"
         Format-output -Text "Caught the exception while  deleting the datastore. Try again with -Resume option." -Level "ERROR" -Phase "Delete  Datastore"
         Return
      }
      $checkCompleted = 13
      $checkCompleted | out-file $checkFile
   }

   #check 14 : Create datastore and create new one with VMFS 6
   #Get the Lun
   if ($checkCompleted -lt 14) {
      $msgText = " Creating VMFS-6 Filesystem"
      Format-output -Text $msgText -Level "INFO" -Phase "Create VMFS-6"
      try {
         if ($Resume) {
            #Read $host $luncan
            $hostConnected = Import-CliXml (Join-Path $variableFolder 'srcHosts.xml')
            $LunCanonical  = Import-CliXml (Join-Path $variableFolder 'srcLunCanonical.xml')
         }  
         Format-output -Text "Creating Datastore..." -Level "INFO" -Phase "Datastore Create"
         Create-Datastore -LunCanonical $LunCanonical -hostConnected $hostConnected    
      } catch [Exception] {
         $errName = $_.Exception.GetType().FullName
         $errMsg = $_.Exception.Message
         Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Datastore Create"
         Format-output -Text "Caught the exception creating new datastore. Try again with -Resume option." -Level "ERROR" -Phase "Datastore Create"
         Return
      }
      $checkCompleted = 14
      $checkCompleted | out-file $checkFile	   
   }

   #check 15 : move the created datastore to cluster 
   #Move Ds to its respective cluster
   try {
      $msgText = "Moving newly created datastore to its original datastore cluster."
      if ($checkCompleted -lt 15) {
         $sdrsClusterXml = Join-Path $variableFolder 'sdrsCluster.xml'
         if ($Resume -and (Test-Path $sdrsClusterXml)) {
            $datastorecluster = Import-CliXml $sdrsClusterXml
         }
         if ($datastorecluster) {
            Format-output -Text $msgText -Level "INFO" -Phase "SDRS Cluster"
            $datastoreObj = get-datastore $DatastoreName
            Move-Datastore $datastoreObj -Destination $datastorecluster | Out-Null
         }  
         $checkCompleted = 15
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Moving datastore"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option. If problem persists, move the newly created datastore to the same cluster as $TemporaryDatastore" -Level "Error" -Phase "Moving datastore."
      Return
   }

   Format-output -Text "Entering restoration phase.." -Level "INFO" -Phase "Restoring VMs"
   # Getting list of VMs present on temporary datastore.
   $vmList = @()
   $dsArray = @()
   $vms = Get-Datastore $TemporaryDatastore | Get-VM
   foreach ($eachVM in $vms ) {
      $vmList += $eachVM.Name 
   }

   # check 16 : move the vms back to original datastore.
   try {
      $msgText = "Moving VMs back to original datastore, if present"	   
      if ($checkCompleted -lt 16) {
         Format-output -Text $msgText -Level "INFO" -Phase "Migration"
         if ($vmList.Count -gt 0) {
            $RelocTaskList = Concurrent-SvMotion -session $Server -Source $TemporaryDatastore -VM $vmList -Destination $DatastoreName -ParallelTasks 2
            foreach ($eachTask in $RelocTaskList) {
               if ($eachTask["State"] -ne "Success") { 
                  Format-output -Text "VM failed to Migrate try running the commandlet again with -Resume option." -Level "Error" -Phase "Migration"
                  Return
               }
            }
         }
         # if there are any active VMs left , throw error
         $vms = Get-Datastore $TemporaryDatastore | Get-VM
         if($vms -ne $null){ 
            Format-output -Text "VM(s)-$vms still left in Datastore $TemporaryDatastore,Try w/ Resume again" -Level "Error" -Phase "Migraton"
            Return
         }
         $checkCompleted = 16
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Moving Virtual Machines"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option. If problem persists, move all the VMs from $TemporaryDataStore to $DatastoreName manually and then try again." -Level "Error" -Phase "Moving Virtual Machines"
      Return
   }

   # Attaching tags back to original datastore
   if ($checkCompleted -lt 17) {
      # Attach Tags to the datastore
      $TagListXml = Join-Path $variableFolder 'TagList.xml'
      if ($Resume -and (Test-Path $TagListXml)) {
         $tagList = Import-CliXml $TagListXml
      }
 
      $msgText = "Attaching Tags back to original datastore."
      try {
         foreach ($tag in $tagList) {
            $tagObj = $null
            $tagObj = Get-Tag -Name $tag.Name -Category $tag.Category.Name
            $msgText = "Adding back the Tags to Datastore :$DatastoreName"
            Format-output -Text $msgText -Level "INFO" -Phase "Datastore Tags"
            $newTag = New-TagAssignment -Tag $tagObj -Entity $DatastoreName
         }
      } catch {
         $errName = $_.Exception.GetType().FullName
         $errMsg = $_.Exception.Message
         Format-output -Text "$errName, $errMsg" -Level "Error" -Phase "Datastore Tag"
         Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "Error" -Phase "Datastore Tag"
         Return
      }
      $checkCompleted = 17
      $checkCompleted | out-file $checkFile
   }

   # check 17 : move the orphaned data back to original datastore.
   try {
      $msgText = "Moving orphaned data back to original datastore, if present."
      $dsItems = Get-DatastoreItems -Datastore $TemporaryDatastore 
      if ($checkCompleted -lt 18) {
         Format-output -Text $msgText -Level "INFO" -Phase "Restoring Orphan data"
         if (($dsItems -ne $null) -and ($dsItems.Count) -gt 0) {
            Format-output -Text "Copying Orphaned items to $DatastoreName" -Level "INFO" -Phase "Copying Orphaned Items"
            $result = Copy-DatastoreItems -SourceDatastore $TemporaryDatastore -DestinationDatastore $DatastoreName
            if (!$result) {
               Format-output -Text "Try again with -Resume option" -Level "ERROR" -Phase "Copying orphaned data"
               Return
            }
            $tempds = Get-Datastore -Name $TemporaryDatastore
            New-PSDrive -Location $tempds -Name tempds -PSProvider VimDatastore -Root "/" | Out-Null
            # Remove contents from temporary Datastore
            Remove-Item tempds:/* -Recurse
         } 

         # Register templateVM(s) back in the respective hosts
         $SrcTemplateMapXml = Join-Path $variableFolder 'SrcTemplateMap.xml'
         if ($Resume -and (Test-Path $SrcTemplateMapXml)) {
            $SrcTemplateMap = Import-Clixml $SrcTemplateMapXml
         }

         foreach ($templatePath in $SrcTemplateMap.Keys) {            
            try {
               $register = New-Template –VMHost $SrcTemplateMap[$templatePath] -TemplateFilePath $templatePath
               $esxHost= $SrcTemplateMap[$templatePath]
               Format-output -Text "Template VM registered in host $esxHost " -Level "INFO" -Phase "Template Register"
            } catch {
               $errName = $_.Exception.GetType().FullName
               if ( $errName -match  "AlreadyExists") {
                  Format-output -Text "$templatePath :Template already registered" -Level "INFO" -Phase "Template Register"
               } else {
                  throw  $_.Exception
               }
            }
         }     
      }
      $checkCompleted = 18
      $ceckCompleted | out-file $checkFile
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Moving orphaned data"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option. If problem persists, move all the orphaned data from $TemporaryDataStore to $DatastoreName manually and then try again." -Level "ERROR" -Phase "Moving orphaned data."
      Return
   }

   # check 18 : Update SRDS properties of cluster.-SDRS
   try {
      if ($checkCompleted -lt 19) {
         $sdrsClusterXml = Join-Path $variableFolder 'sdrsCluster.xml'
         if ($Resume -and (Test-Path $sdrsClusterXml)) {
            $datastorecluster = Import-CliXml $sdrsClusterXml
         }

         if ($datastorecluster) {
            $msgText = "Setting datastore-cluster properties to previous State."
            Format-output -Text "$msgText : $oldAutomationLevel" -Level "INFO" -Phase "SDRS Cluster"
            if ($Resume) {
               $oldAutomationLevel = Import-CliXml (Join-Path $variableFolder 'oldAutomationLevel.xml')
               $ioloadbalanced = Import-CliXml (Join-Path $variableFolder 'ioloadbalanced.xml')
            }
            Set-DatastoreCluster -DatastoreCluster $datastorecluster -SdrsAutomationLevel $oldAutomationLevel -IOLoadBalanceEnabled $ioloadbalanced | Out-Null
         }
         $checkCompleted = 19
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Reverting to original datastore settings"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "ERROR" -Phase "Reverting to original datastore settings."
      Return
   }
	
   try { 
      # check 20 : set datastore storageIOControlEnabled to previous value.
      if ($checkCompleted -lt 20) {
         $msgText = "Setting datastore properties to previous State."
         $ds1iocontrolXml = Join-Path $variableFolder 'ds1iocontrol.xml'
         if ($Resume -and (Test-Path $ds1iocontrolXml)) {
            $ds1iocontrol = Import-CliXml $ds1iocontrolXml
         }

         $ds2iocontrolXml = Join-Path $variableFolder 'ds2iocontrol.xml'
         if ($Resume -and (Test-Path $ds2iocontrolXml)) {
            $ds2iocontrol = Import-CliXml $ds2iocontrolXml
         }

         Format-output -Text $msgText -Level "INFO" -Phase "Datastore Settings"
         (Get-Datastore -Name $DatastoreName) | set-datastore -storageIOControlEnabled $ds1iocontrol | Out-Null
         (Get-Datastore -Name $TemporaryDatastore) | set-datastore -storageIOControlEnable $ds2iocontrol | Out-Null

         $checkCompleted = 20
         $checkCompleted | out-file $checkFile
      }

      # check 21 : set cluster DrsAutomationLevel to previous value. -DRS
      if ($checkCompleted -lt 21) {
         $msgText = "Setting cluster properties to previous State."
         Format-output -Text $msgText -Level "INFO" -Phase "DRS Cluster"
         foreach ($clus in $clusters) {
            if ($clus.DrsEnabled) {
               $drsMapXml = Join-Path $variableFolder 'drsMap.xml'
               if ($Resume -and (Test-Path $drsMapXml)) {
                  $drsMap = Import-Clixml $drsMapXml
               }

               Set-Cluster -Cluster $clus -DrsAutomationLevel $drsMap[$clus.Name] -Confirm:$false | Out-Null
            }
         }
         $checkCompleted = 21
         $checkCompleted | out-file $checkFile
      }
   } catch {
      $errName = $_.Exception.GetType().FullName
      $errMsg = $_.Exception.Message
      Format-output -Text "$errName, $errMsg" -Level "ERROR" -Phase "Reverting to original datastore and datastore cluster settings"
      Format-output -Text "Unable to proceed, try running the commandlet again with -Resume option." -Level "ERROR" -Phase "Reverting to original datastore and datastore-cluster settings."
      Return
   }

   Format-output -Text "Datastore upgraded successfully" -Level "INFO" -Phase "Upgrade successful"
   Format-output -Text "Zip the log directory " -Level "INFO" -Phase "Upgrade successful"
   Zip-Logs -logdir $variableFolder
   Remove-Item $variableFolder -Recurse
   Remove-Item $checkFile
   $errorActionPreference = 'continue'
}
# SIG # Begin signature block
# MIIdUQYJKoZIhvcNAQcCoIIdQjCCHT4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUSHk/+hRlmuA2DpbENTM2rslX
# I2egghhkMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggTMMIIDtKADAgECAhBdqtQcwalQC13tonk09GI7MA0GCSqGSIb3DQEBCwUAMH8x
# CzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0G
# A1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMg
# Q2xhc3MgMyBTSEEyNTYgQ29kZSBTaWduaW5nIENBMB4XDTE4MDgxMzAwMDAwMFoX
# DTIxMDkxMTIzNTk1OVowZDELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNhbGlmb3Ju
# aWExEjAQBgNVBAcMCVBhbG8gQWx0bzEVMBMGA1UECgwMVk13YXJlLCBJbmMuMRUw
# EwYDVQQDDAxWTXdhcmUsIEluYy4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCuswYfqnKot0mNu9VhCCCRvVcCrxoSdB6G30MlukAVxgQ8qTyJwr7IVBJX
# EKJYpzv63/iDYiNAY3MOW+Pb4qGIbNpafqxc2WLW17vtQO3QZwscIVRapLV1xFpw
# uxJ4LYdsxHPZaGq9rOPBOKqTP7JyKQxE/1ysjzacA4NXHORf2iars70VpZRksBzk
# niDmurvwCkjtof+5krxXd9XSDEFZ9oxeUGUOBCvSLwOOuBkWPlvCnzEqMUeSoXJa
# vl1QSJvUOOQeoKUHRycc54S6Lern2ddmdUDPwjD2cQ3PL8cgVqTsjRGDrCgOT7Gw
# ShW3EsRsOwc7o5nsiqg/x7ZmFpSJAgMBAAGjggFdMIIBWTAJBgNVHRMEAjAAMA4G
# A1UdDwEB/wQEAwIHgDArBgNVHR8EJDAiMCCgHqAchhpodHRwOi8vc3Yuc3ltY2Iu
# Y29tL3N2LmNybDBhBgNVHSAEWjBYMFYGBmeBDAEEATBMMCMGCCsGAQUFBwIBFhdo
# dHRwczovL2Quc3ltY2IuY29tL2NwczAlBggrBgEFBQcCAjAZDBdodHRwczovL2Qu
# c3ltY2IuY29tL3JwYTATBgNVHSUEDDAKBggrBgEFBQcDAzBXBggrBgEFBQcBAQRL
# MEkwHwYIKwYBBQUHMAGGE2h0dHA6Ly9zdi5zeW1jZC5jb20wJgYIKwYBBQUHMAKG
# Gmh0dHA6Ly9zdi5zeW1jYi5jb20vc3YuY3J0MB8GA1UdIwQYMBaAFJY7U/B5M5ev
# fYPvLivMyreGHnJmMB0GA1UdDgQWBBTVp9RQKpAUKYYLZ70Ta983qBUJ1TANBgkq
# hkiG9w0BAQsFAAOCAQEAlnsx3io+W/9i0QtDDhosvG+zTubTNCPtyYpv59Nhi81M
# 0GbGOPNO3kVavCpBA11Enf0CZuEqf/ctbzYlMRONwQtGZ0GexfD/RhaORSKib/AC
# t70siKYBHyTL1jmHfIfi2yajKkMxUrPM9nHjKeagXTCGthD/kYW6o7YKKcD7kQUy
# BhofimeSgumQlm12KSmkW0cHwSSXTUNWtshVz+74EcnZtGFI6bwYmhvnTp05hWJ8
# EU2Y1LdBwgTaRTxlSDP9JK+e63vmSXElMqnn1DDXABT5RW8lNt6g9P09a2J8p63J
# GgwMBhmnatw7yrMm5EAo+K6gVliJLUMlTW3O09MbDTCCBVkwggRBoAMCAQICED14
# 1/l2SWCyYX308B7KhiowDQYJKoZIhvcNAQELBQAwgcoxCzAJBgNVBAYTAlVTMRcw
# FQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3Qg
# TmV0d29yazE6MDgGA1UECxMxKGMpIDIwMDYgVmVyaVNpZ24sIEluYy4gLSBGb3Ig
# YXV0aG9yaXplZCB1c2Ugb25seTFFMEMGA1UEAxM8VmVyaVNpZ24gQ2xhc3MgMyBQ
# dWJsaWMgUHJpbWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIEc1MB4XDTEz
# MTIxMDAwMDAwMFoXDTIzMTIwOTIzNTk1OVowfzELMAkGA1UEBhMCVVMxHTAbBgNV
# BAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVz
# dCBOZXR3b3JrMTAwLgYDVQQDEydTeW1hbnRlYyBDbGFzcyAzIFNIQTI1NiBDb2Rl
# IFNpZ25pbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCXgx4A
# Fq8ssdIIxNdok1FgHnH24ke021hNI2JqtL9aG1H3ow0Yd2i72DarLyFQ2p7z518n
# TgvCl8gJcJOp2lwNTqQNkaC07BTOkXJULs6j20TpUhs/QTzKSuSqwOg5q1PMIdDM
# z3+b5sLMWGqCFe49Ns8cxZcHJI7xe74xLT1u3LWZQp9LYZVfHHDuF33bi+VhiXjH
# aBuvEXgamK7EVUdT2bMy1qEORkDFl5KK0VOnmVuFNVfT6pNiYSAKxzB3JBFNYoO2
# untogjHuZcrf+dWNsjXcjCtvanJcYISc8gyUXsBWUgBIzNP4pX3eL9cT5DiohNVG
# uBOGwhud6lo43ZvbAgMBAAGjggGDMIIBfzAvBggrBgEFBQcBAQQjMCEwHwYIKwYB
# BQUHMAGGE2h0dHA6Ly9zMi5zeW1jYi5jb20wEgYDVR0TAQH/BAgwBgEB/wIBADBs
# BgNVHSAEZTBjMGEGC2CGSAGG+EUBBxcDMFIwJgYIKwYBBQUHAgEWGmh0dHA6Ly93
# d3cuc3ltYXV0aC5jb20vY3BzMCgGCCsGAQUFBwICMBwaGmh0dHA6Ly93d3cuc3lt
# YXV0aC5jb20vcnBhMDAGA1UdHwQpMCcwJaAjoCGGH2h0dHA6Ly9zMS5zeW1jYi5j
# b20vcGNhMy1nNS5jcmwwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMDMA4G
# A1UdDwEB/wQEAwIBBjApBgNVHREEIjAgpB4wHDEaMBgGA1UEAxMRU3ltYW50ZWNQ
# S0ktMS01NjcwHQYDVR0OBBYEFJY7U/B5M5evfYPvLivMyreGHnJmMB8GA1UdIwQY
# MBaAFH/TZafC3ey78DAJ80M5+gKvMzEzMA0GCSqGSIb3DQEBCwUAA4IBAQAThRoe
# aak396C9pK9+HWFT/p2MXgymdR54FyPd/ewaA1U5+3GVx2Vap44w0kRaYdtwb9oh
# BcIuc7pJ8dGT/l3JzV4D4ImeP3Qe1/c4i6nWz7s1LzNYqJJW0chNO4LmeYQW/Ciw
# sUfzHaI+7ofZpn+kVqU/rYQuKd58vKiqoz0EAeq6k6IOUCIpF0yH5DoRX9akJYmb
# BWsvtMkBTCd7C6wZBSKgYBU/2sn7TUyP+3Jnd/0nlMe6NQ6ISf6N/SivShK9DbOX
# Bd5EDBX6NisD3MFQAfGhEV0U5eK9J0tUviuEXg+mw3QFCu+Xw4kisR93873NQ9Tx
# TKk/tYuEr2Ty0BQhMIIFmjCCA4KgAwIBAgIKYRmT5AAAAAAAHDANBgkqhkiG9w0B
# AQUFADB/MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYD
# VQQDEyBNaWNyb3NvZnQgQ29kZSBWZXJpZmljYXRpb24gUm9vdDAeFw0xMTAyMjIx
# OTI1MTdaFw0yMTAyMjIxOTM1MTdaMIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMO
# VmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsx
# OjA4BgNVBAsTMShjKSAyMDA2IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6
# ZWQgdXNlIG9ubHkxRTBDBgNVBAMTPFZlcmlTaWduIENsYXNzIDMgUHVibGljIFBy
# aW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgLSBHNTCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAK8kCAgpejWeYAyq50s7Ttx8vDxFHLsr4P4pAvlX
# CKNkhRUn9fGtyDGJXSLoKqqmQrOP+LlVt7G3S7P+j34HV+zvQ9tmYhVhz2ANpNje
# +ODDYgg9VBPrScpZVIUm5SuPG5/r9aGRwjNJ2ENjalJL0o/ocFFN0Ylpe8dw9rPc
# EnTbe11LVtOWvxV3obD0oiXyrxySZxjl9AYE75C55ADk3Tq1Gf8CuvQ87uCL6zeL
# 7PTXrPL28D2v3XWRMxkdHEDLdCQZIZPZFP6sKlLHj9UESeSNY0eIPGmDy/5HvSt+
# T8WVrg6d1NFDwGdz4xQIfuU/n3O4MwrPXT80h5aK7lPoJRUCAwEAAaOByzCByDAR
# BgNVHSAECjAIMAYGBFUdIAAwDwYDVR0TAQH/BAUwAwEB/zALBgNVHQ8EBAMCAYYw
# HQYDVR0OBBYEFH/TZafC3ey78DAJ80M5+gKvMzEzMB8GA1UdIwQYMBaAFGL7CiFb
# f0NuEdoJVFBr9dKWcfGeMFUGA1UdHwROMEwwSqBIoEaGRGh0dHA6Ly9jcmwubWlj
# cm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY3Jvc29mdENvZGVWZXJpZlJv
# b3QuY3JsMA0GCSqGSIb3DQEBBQUAA4ICAQCBKoIWjDRnK+UD6zR7jKKjUIr0VYbx
# HoyOrn3uAxnOcpUYSK1iEf0g/T9HBgFa4uBvjBUsTjxqUGwLNqPPeg2cQrxc+BnV
# YONp5uIjQWeMaIN2K4+Toyq1f75Z+6nJsiaPyqLzghuYPpGVJ5eGYe5bXQdrzYao
# 4mWAqOIV4rK+IwVqugzzR5NNrKSMB3k5wGESOgUNiaPsn1eJhPvsynxHZhSR2LYP
# GV3muEqsvEfIcUOW5jIgpdx3hv0844tx23ubA/y3HTJk6xZSoEOj+i6tWZJOfMfy
# M0JIOFE6fDjHGyQiKEAeGkYfF9sY9/AnNWy4Y9nNuWRdK6Ve78YptPLH+CHMBLpX
# /QG2q8Zn+efTmX/09SL6cvX9/zocQjqh+YAYpe6NHNRmnkUB/qru//sXjzD38c0p
# xZ3stdVJAD2FuMu7kzonaknAMK5myfcjKDJ2+aSDVshIzlqWqqDMDMR/tI6Xr23j
# VCfDn4bA1uRzCJcF29BUYl4DSMLVn3+nZozQnbBP1NOYX0t6yX+yKVLQEoDHD1S2
# HmfNxqBsEQOE00h15yr+sDtuCjqma3aZBaPxd2hhMxRHBvxTf1K9khRcSiRqZ4yv
# jZCq0PZ5IRuTJnzDzh69iDiSrkXGGWpJULMF+K5ZN4pqJQOUsVmBUOi6g4C3IzX0
# drlnHVkYrSCNlDGCBFcwggRTAgEBMIGTMH8xCzAJBgNVBAYTAlVTMR0wGwYDVQQK
# ExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3Qg
# TmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMgQ2xhc3MgMyBTSEEyNTYgQ29kZSBT
# aWduaW5nIENBAhBdqtQcwalQC13tonk09GI7MAkGBSsOAwIaBQCggYowGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFCuvInfiOmkrvWGlAK+UrK//gwKZMCoGCisGAQQB
# gjcCAQwxHDAaoRiAFmh0dHA6Ly93d3cudm13YXJlLmNvbS8wDQYJKoZIhvcNAQEB
# BQAEggEArOoWx3LIgaoYfcfiygCvzCZbe3QUq03YGJ2bbXgnqNDvgvkFnZpB5C0r
# YAvN8BxUPsX6NV4TRFcKIHnalGN8SEyv+de0Neq4EYiR8KKU8ld1jeMjzAkraGv3
# 9ZBP/vqsmvfFcULrIPnCkb4fVhTxwN3a2FtpMvqm3pgi4ApfCxMVK6lHDZmNybSe
# fawe2HFgs/fyCDbLN0sqB2xionXu4Aspp4dOHQdp0XUxDLZvEIbSOx1Vl4iR2jLa
# DAnF+Fuhh82NJNcdLoFIUsNGSgGUqne9DVT4Y7aQL9mZgWuJe847Qi2uaoXDO724
# nuxuHHdnq3CaAERPPTwGas4xdzYOw6GCAgswggIHBgkqhkiG9w0BCQYxggH4MIIB
# 9AIBATByMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyAhAOz/Q4yP6/NW4E2GqYGxpQMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0B
# CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xODEwMDkxMzI0MzlaMCMG
# CSqGSIb3DQEJBDEWBBREKLfZ1hSvJycrvYmm0X6YHHO8bTANBgkqhkiG9w0BAQEF
# AASCAQAtoo71fcZfpBUdVSxapD8m/eFJ3JLXut74fjYX/r8aHw/bqHta0zjyvCQ9
# gINdWAD5/+Q9YrwXu6MnWbYo6Vvb0sAQmIyyMWnAXys05GJNTff39z+kOtBgTwlE
# ocQdufmYlEiyz6xd3vBNeQ5e3N9AbHsQTxYOYLvK0w0JFrU26TmnkI0yk1tQTEr8
# NDc8obbaUcVxBMsyAW5U10WieptKt+KqerqsGY6srMMEwyfopOTNlUi/86OwYg70
# KX/uwFnpD6wbfi+dIdlwKM04RV+0dRTTX+M5K1KwPLk10lpvnt/aFUreJqdiWopK
# uqaJrDSJ1ThWunTAuoQveJHhzDPi
# SIG # End signature block
