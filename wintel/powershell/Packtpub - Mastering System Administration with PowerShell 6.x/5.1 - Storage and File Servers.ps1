Set-Location C:\
Clear-Host

#Find all disks on the system, including USB, Iscsi, etc. 
Get-Disk
Get-VirtualDisk
Test-Path S:


#Find all physical disks on the system. Also useful for identifying disks able to be pooled
Get-PhysicalDisk
Get-PhysicalDisk -CanPool $true
$PoolableDisks = Get-PhysicalDisk -CanPool $true

#Examples of storage subsystems are Windows Storage, Storage Spaces
Get-PhysicalDisk | Get-StorageSubSystem


#Create a storage pool
New-StoragePool -PhysicalDisks $PoolableDisks -StorageSubSystemFriendlyName "Windows Storage*" -FriendlyName "DataPool"

#Creating the virtual disk

Get-StoragePool "Datapool" | New-VirtualDisk -UseMaximumSize -FriendlyName "DataDisk" 

$SourceDataDisk = Get-VirtualDisk -FriendlyName "DataDisk"

#Initialize the disk
$SourceDataDisk | Initialize-Disk -PartitionStyle MBR

#Create and format the partition and 
Get-Disk
Get-PhysicalDisk
Get-Disk -FriendlyName "DataDisk" | New-Partition -UseMaximumSize -DriveLetter 's'
Format-Volume -FileSystem ReFS -NewFileSystemLabel "SourceData" -DriveLetter 's'

#Create a folder on the new partition
New-Item -ItemType Directory -Path "S:\Software"

#Create a new SMB share that allows read-access to everyone
New-SmbShare -Path "S:\Software" -Name "Software" -ReadAccess "Everyone"

Push-Location \\localhost\Software
Pop-Location