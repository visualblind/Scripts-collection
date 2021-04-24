connect-viserver IDCISVC01
Get-VM IDCYPVDLP02 | Get-AdvancedSetting -Name tools.deployPkg.fileName | fl
Get-VM IDCYPVDLP02 | Get-AdvancedSetting |fl
Get-VM | Sort