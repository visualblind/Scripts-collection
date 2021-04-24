#Set-PowerCLIConfiguration -InvalidCertificateAction Ignore

# Connect to vSphere vCenter Server
Try{
    Connect-VIServer Server1
}
Catch{
    Write-Host "Failed Connecting to VSphere Server."
    Break
}

Pushd $env:USERPROFILE\Documents

get-snapshot -VM * | Select Created, Name, VM, @{Name="Snapshot Size (GB)";Expression={[math]::Round($_.SizeGB)}}, Description, ParentSnapshot, Parent, VMId, PowerState | ft -AutoSize | Tee-Object -file snapshots-prod.txt
get-snapshot -VM * | Select Created, Name, VM, @{Name="Snapshot Size (GB)";Expression={[math]::Round($_.SizeGB)}}, Description, ParentSnapshot, Parent, VMId, PowerState | ft -AutoSize

VM | Sort-Object MemoryGB -Descending
VM -Name Server1 | Format-List

Get-View -ViewType VIrtualMachine -Property Name , SnapShot, LayoutEx -Filter @{"Snapshot.CurrentSnapshot" = "snapshot"  } | ? { $_.name -match "$VM" } |
Select @{"N"="VM" ;  E={$_.Name}},
@{N= "vCenter"      ; E=  { $_.Client.ServiceUrl.Split("/")[2].split(":")[0]  }},
@{N= "Snapshots"    ; E = { (($_.LayoutEx.Snapshot | % { $_.Key }) | measure).count  }  },
@{N= "SnapsSizeGB"  ; E = { (($_.LayoutEx.File | ? { $_.Type -match "snapshotdata" } | measure -Property size -Sum ).sum *3 / 1gb ).ToString("#,0.00")   }  } ,
@{N= "OldestSnapshot"  ; E = { $_.Snapshot.RootSnapshotList | sort createtime | select -F 1  createtime | % { $_.CreateTime } } },
@{N= "DaysOld"  ; E = { $_.Snapshot.RootSnapshotList | sort createtime | select -F 1  createtime | % { ((Get-Date) - $_.CreateTime ).Days } } } | ft | sort -desc DaysOld



Get-View -ViewType VIrtualMachine -Property Name , SnapShot, LayoutEx -Filter @{"Snapshot.CurrentSnapshot" = "snapshot"  } |
Select @{"N"="VM" ;  E={$_.Name}},
@{N= "vCenter"      ; E=  { $_.Client.ServiceUrl.Split("/")[2].split(":")[0]  }},
@{N= "Snapshots"    ; E = { (($_.LayoutEx.Snapshot | % { $_.Key }) | measure).count  }  },
@{N= "SnapsSizeGB"  ; E = { (($_.LayoutEx.File | ? { $_.Type -match "snapshotdata" } | measure -Property size -Sum ).sum *3 / 1gb ).ToString("#,0.00")   }  } ,
@{N= "OldestSnapshot"  ; E = { $_.Snapshot.RootSnapshotList | sort createtime | select -F 1  createtime | % { $_.CreateTime } } },
@{N= "DaysOld"  ; E = { $_.Snapshot.RootSnapshotList | sort createtime | select -F 1  createtime | % { ((Get-Date) - $_.CreateTime ).Days } } } | ft | sort -desc DaysOld