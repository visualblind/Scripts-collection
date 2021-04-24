Set-ExecutionPolicy 0
Import-Module Activedirectory
Set-Location -Path "\\Domain.int\dfs\NetAdmin\Quarterly SAS Audit"

$LastMonth = (Get-Date).AddMonths(-1)
$FirstDayofLastMonth = Get-Date -year $LastMonth.year -month $LastMonth.month -day 1 -format d
$timestamp2 = (Get-Date).toString('MMMM yyyy')

$file_sb01_deleted = (Get-Date).toString('yy - MMM') + " sb01 Deleted.csv"
$file_si03_deleted = (Get-Date).toString('yy - MMM') + " SI03 Deleted.csv"
$file_sb01_created = (Get-Date).toString('yy - MMM') + " sb01 Created.csv"
$file_si03_created = (Get-Date).toString('yy - MMM') + " SI03 Created.csv"
$merged_filename = (Get-Date).toString('yy - MMM') + " Citrix Changes.csv"

#Query Changed Deleted Users
Get-ADObject -server si03dc2.aws.Domain.int –SearchBase “CN=Deleted Objects,DC=aws,DC=Domain,DC=com” -Filter {isdeleted -eq $true -and (name -ne "Deleted Objects" -and samAccountName -notlike "*test*" -and ObjectClass -eq "user")} -IncludeDeletedObjects -Properties description,DisplayName,samAccountName,Deleted,whenChanged,whenCreated | ? {$_.whenChanged -ge $FirstDayofLastMonth} | Sort-object description,DisplayName,samAccountName | Select-Object description,DisplayName,samAccountName,Deleted,whenCreated | Export-CSV $file_si03_deleted -NoTypeInformation
Get-ADObject -server sb01dc0.Domain.int –SearchBase “CN=Deleted Objects,DC=Domain,DC=com” -Filter {isdeleted -eq $true -and (name -ne "Deleted Objects" -and samAccountName -notlike "*test*" -and ObjectClass -eq "user")} -IncludeDeletedObjects -Properties description,DisplayName,samAccountName,Deleted,whenChanged,whenCreated | ? {$_.whenChanged -ge $FirstDayofLastMonth} | Sort-object description,DisplayName,samAccountName | Select-Object description, DisplayName, samAccountName, Deleted, whenCreated | Export-CSV $file_sb01_deleted -NoTypeInformation

#Query Changed Active Users
Get-ADUser -Server sb01dc0.Domain.int -Filter {enabled -eq $true -and (samAccountName -notlike "*test*" -and ObjectClass -eq "user")} -SearchBase "OU=Users,OU=Clients,DC=Domain,DC=com" -SearchScope Subtree -Properties description,DisplayName,sAMAccountName,Deleted,whenCreated | ? {$_.whenCreated -ge $FirstDayofLastMonth} | Sort-Object -Property description,DisplayName,sAMAccountName | Select-Object Description,DisplayName,sAMAccountName,Deleted,whenCreated | Export-CSV $file_sb01_created -NoTypeInformation
Get-ADUser -Server si03dc2.aws.Domain.int -Filter {enabled -eq $true -and (samAccountName -notlike "*test*" -and ObjectClass -eq "user")} -SearchBase "OU=Users,OU=Clients,DC=AWS,DC=Domain,DC=com" -SearchScope Subtree -Properties description,DisplayName,sAMAccountName,Deleted,whenCreated | ? {$_.DistinguishedName -notlike "*FTP*" -and $_.whenCreated -ge $FirstDayofLastMonth} | Sort-Object -Property description,DisplayName,sAMAccountName | Select-Object Description,DisplayName,sAMAccountName,Deleted,whenCreated | Export-CSV $file_si03_created -NoTypeInformation

Get-ChildItem -name | ? {$_ -eq $file_sb01_deleted -or $_ -eq $file_si03_deleted -or $_ -eq $file_sb01_created -or $_ -eq $file_si03_created} | Import-Csv | Sort-Object @{expression="Deleted";Descending=$true},@{expression="description";Ascending=$true},@{expression="DisplayName";Ascending=$true},@{expression="samAccountName";Ascending=$true} | Export-Csv -Path $merged_filename -NoTypeInformation

Send-MailMessage -from "NetAdmin <netadmin@Domain.net>" `
                       -to "<SRitz@Domain.net>","<VEndy@Domain.net>","<BKleinhample@Domain.net>" `
                       -cc "<netadmin@Domain.net>" `
                       -subject "Citrix User *Changes* Report - $timestamp2" `
                       -body "Automated Citrix client user *changes* report`n`nContact trunyard@Domain.net if there is a problem" `
                       -Attachment $merged_filename -smtpServer sb01exc1.Domain.int
