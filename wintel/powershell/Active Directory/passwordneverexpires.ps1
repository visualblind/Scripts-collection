Import-Module ActiveDirectory
Get-ADUser -SearchBase “OU=Users,OU=Clients,DC=Domain,DC=com” -Filter {PasswordNeverExpires -eq $false -and enabled -eq $true -and pwdlastset -ne 0} -ResultSetSize 5000 | Set-ADUser -PasswordNeverExpires $true
