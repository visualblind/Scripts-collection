#
# Configure pshare salting options
# - Enables / Disables the salting. 
#

$reboot = 0
$enable = 0
$disable = 0
if ($args.count -gt 0) {
   $vCenter = $args[ 0 ]
   for ( $i = 1; $i -lt $args.count; $i++ ) {
      if ($args[ $i ] -eq "-s") {
         $enable = 1
      }
      if ($args[ $i ] -eq "-o") {
         $disable = 1
      }
   }
   # override
   if ($enable -eq 1) {
      $disable = 0
   }
}

# we should specify either -s or -o
if ($enable -eq 0 ) {
  if ($disable -eq 0 ) {
     Write-Host "Usage: ./pshare-salting.ps1 <vcenter IP/hostname> <-s/-o>"
     Write-Host "-s: turn-on pshare salting (default)"
     Write-Host "-o: turn-off pshare salting\n"
     return
   }
}

Connect-VIServer $vCenter

$esxHosts = Get-VMHost | Sort Name
foreach($esx in $esxHosts){
      # Revert ShareScaGHz to default
      Set-VMHostAdvancedConfiguration -VMHost $esx -Name Mem.ShareScanGHz -Value 4 -Confirm:$false    
   if ($enable -eq 1) {
      Write-Host "Enabling PageShare Salting on $esx"
      $val = (Get-VMHostAdvancedConfiguration -VMHost $esx -Name Mem.ShareForceSalting).Values
      Set-VMHostAdvancedConfiguration -VMHost $esx -Name Mem.ShareForceSalting -Value 2 -Confirm:$false    
   } else {
      Write-Host "Disabling PageShare Salting on $esx"
      $val = (Get-VMHostAdvancedConfiguration -VMHost $esx -Name Mem.ShareForceSalting.).Values
      Set-VMHostAdvancedConfiguration -VMHost $esx -Name Mem.ShareForceSalting -Value 0 -Confirm:$false      
   }
}