Get-ADUser -Filter { memberOf -RecursiveMatch "CN=Citrix,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" } -SearchBase "OU=Users,OU=Clients,OU=OrgUnit1,DC=Company,DC=com"

Get-ADUser -Filter { memberOf -RecursiveMatch "CN=Citrix,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -or memberOf -RecursiveMatch "CN=Citrix_Application,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" } -SearchBase "OU=Users,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -Properties mail | Sort-Object name,mail

Get-ADUser -Filter { memberOf -RecursiveMatch "CN=Citrix,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -or memberOf -RecursiveMatch "CN=Citrix_Application,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" } -SearchBase "OU=Users,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -Properties mail | Sort-Object -Property name,mail -ascending | Format-Table -Property name,mail


Get-ADUser -Filter { memberOf -RecursiveMatch "CN=Citrix,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -or memberOf -RecursiveMatch "CN=Citrix_Application,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -and enabled -eq $true } -SearchBase "OU=Users,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -Properties mail | Sort-Object -Property name,mail | Format-Table -Property name,mail | Export-CSV test.csv

Get-ADUser -Filter { memberOf -RecursiveMatch "CN=Citrix,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -or memberOf -RecursiveMatch "CN=Citrix_Application,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -and enabled -eq $true } -SearchBase "OU=Users,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -Properties mail | Sort-Object -Property name,mail | Select-Object name,mail | Export-CSV test.csv

Get-ADUser -Filter { memberOf -RecursiveMatch "CN=Citrix,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -or memberOf -RecursiveMatch "CN=Citrix_Application,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -and enabled -eq $true } -SearchBase "OU=Users,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -SearchScope Subtree -Properties mail | Sort-Object -Property name,mail | Select-Object name,mail | Export-CSV sb01_client_mail.csv

Get-ADUser -Server dc1.domain.org -Filter { memberof -RecursiveMatch "CN=Xen-M3,OU=Groups,OU=Clients,OU=Company,DC=aws,DC=Company,DC=com" -and enabled -eq $true } -SearchBase "OU=M3,OU=Users,OU=Clients,OU=Company,DC=AWS,DC=Company,DC=com" -SearchScope Subtree -Properties mail | Sort-Object -Property name,mail | Select-Object name,mail | Export-CSV test.csv
#
Get-ADUser -Filter { memberOf -RecursiveMatch "CN=Citrix,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -or memberOf -RecursiveMatch "CN=Citrix_Application,OU=Security,OU=Groups,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -and enabled -eq $true } -SearchBase "OU=Users,OU=Clients,OU=OrgUnit1,DC=Company,DC=com" -SearchScope Subtree -Properties mail | Sort-Object -Property name,mail | Select-Object name,mail | Export-CSV \\File-Server\share\client_mail.csv

Get-ADUser -Server dc1.domain.org -Filter { enabled -eq $true } -SearchBase "OU=M3,OU=Users,OU=Clients,OU=Company,DC=AWS,DC=Company,DC=com" -SearchScope Subtree -Properties mail | Sort-Object -Property name,mail | Select-Object name,mail | Export-CSV \\File-Server\dev\NetworkScripts\si03_client_mail.csv

dir \\File-Server\dev\NetworkScripts -Filter *.csv | ? {$_.basename -like 'si*'} | Import-Csv | sort name,mail | Export-Csv -Path \\File-Server\share\AllClientMail.csv -NoTypeInformation


memberof -RecursiveMatch "CN=Citrix,OU=Groups,OU=Clients,DC=Company,DC=com"
