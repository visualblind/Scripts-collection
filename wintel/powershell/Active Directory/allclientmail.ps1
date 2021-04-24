Set-ExecutionPolicy 0
Import-Module Activedirectory

Get-ADUser -Filter { memberOf -RecursiveMatch "CN=Citrix_Print,OU=Security,OU=Groups,OU=Clients,DC=Domain,DC=com" -or memberOf -RecursiveMatch "CN=Citrix,Domain,OU=Security,OU=Groups,OU=Clients,DC=Domain,DC=com" -and enabled -eq $true } -SearchBase "OU=Users,OU=Clients,DC=Domain,DC=com" -SearchScope Subtree -Properties mail | Sort-Object -Property name,mail | Select-Object name,mail | Export-CSV \\Domain.int\ADreports\client_mail.csv

Get-ADUser -Server server-name.Domain.int -Filter { enabled -eq $true } -SearchBase "OU=Users,OU=Clients,DC=com" -SearchScope Subtree -Properties mail | Sort-Object -Property name,mail | Select-Object name,mail | Export-CSV \\Domain.int\ADreports\client_mail.csv

dir \\Domain.int\ADreports -Filter *.csv | ? {$_.basename -like 'mail*'} | Import-Csv | sort name,mail | Export-Csv -Path \\Domain.int\ADreports\AllClientMail.csv -NoTypeInformation
