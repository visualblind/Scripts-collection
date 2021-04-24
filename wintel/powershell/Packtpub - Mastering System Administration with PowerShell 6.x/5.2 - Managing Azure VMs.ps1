Set-Location C:\
Clear-Host

Find-Module *Azure*Core*

Install-Module "AzureRM.Netcore" -Verbose -Force -Scope CurrentUser

Login-AzureRMAccount

Get-Command -Module AzureRM*Netcore | Measure-Object

Get-Command -Noun AzureRmVM -Module AzureRM*Netcore

Get-Command -Noun "AzureRMVM"

Get-Command -Noun "AzureRMVM*"
# If you know the name of the resource group
Get-AzureRMVM -ResourceGroupName MasteringPowerShell6
#If you want to get ALL the VMs in a subscription and work from a list
Get-AzureRMVM
#If you want to get all of the VMs in a resource group but you can't remember the RG name
Get-AzureRMResourceGroup
$VMs = Get-AzureRMVM -ResourceGroup "MasteringPowerShell6-Part2"
$VMs

$VMs | Get-Member -MemberType *Property
$VMs[3] | Select-Object -Property *
$VMs[3].HardwareProfile.VmSize
$VMs[3].LicenseType
$VMs[3].OSProfile.ComputerName
$VMs[3].ProvisioningState
$Vms[3].StatusCode
$Vms[3].ToPSVirtualMachine()

#Difference between Get-AzureRMVM and Get-AzureRMVM -Status
$VMsWithStatusInfo = Get-AzureRMVM -ResourceGroup "MasteringPowerShell6-Part2" -Status

$VMsWithStatusInfo
$VMsWithStatusInfo | Where-Object PowerState -EQ "VM deallocated" | Select-Object -First 1 | Start-AzureRMVM
$VMsWithStatusInfo | Where-Object PowerState -EQ "VM deallocated" | Select-Object -Skip 1 | Start-AzureRMVM -AsJob

Get-Job

$VMsWithStatusInfo | Where-Object Name -eq "Ubuntu17-Srv00" | Stop-AzureRMVM -AsJob -Force



$VMs | Get-AzureRmVMSize 

Get-AzureRMVMSize -ResourceGroupName $VMs[1].ResourceGroupName -VMName $VMs[1].Name | Measure-Object
$VMs[1] | Get-AzureRMVMSize | Measure-Object
Get-AzureRMVMSize -ResourceGroupName $VMs[1].ResourceGroupName -VMName $VMs[1].Name | Where-Object {$_.NumberOfCores -eq 2}
$VMs[1].HardwareProfile.VmSize
$VMs[1].HardwareProfile.VmSize = "Standard_D2s_v3"
Update-AzureRMVM -ResourceGroupName $VMs[1] -VM $VMs[1]