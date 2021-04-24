import-module ActiveDirectory
Get-ADUser -Filter {memberof -eq "CN=Internal_Users,OU=Security,OU=Groups,OU=City,DC=Domain,DC=com"} -SearchBase " DC=Domain, DC=com" | Set-ADUser -Clear msNPAllowDialIn





get-aduser -Filter {

Get-ADUser -Filter {ObjectClass } -Properties msNPAllowDialin | Where { $_.msNPAllowDialin -match “False” } | fl Name, msNPAllowDialin
