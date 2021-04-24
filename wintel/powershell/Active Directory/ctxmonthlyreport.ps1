Set-ExecutionPolicy 0
Import-Module Activedirectory
cd "\\Domain.int\dfs\NetAdmin\Quarterly SAS Audit"
$file_sb01 = (Get-Date).toString('yy - MMM') + " sb01.csv"
$file_si03 = (Get-Date).toString('yy - MMM') + " SI03.csv"

Get-ADUser -Filter { enabled -eq $true } -SearchBase "OU=Users,OU=Clients,DC=Domain,DC=com" -SearchScope Subtree -Properties description,sAMAccountName | Sort-Object -Property description,name,sAMAccountName | Select-Object description,name,sAMAccountName | Export-CSV $file_sb01
Get-ADUser -Server si03dc2.aws.Domain.int -Filter { (enabled -eq $true) } -SearchBase "OU=Users,OU=Clients,DC=AWS,DC=Domain,DC=com" -SearchScope Subtree -Properties distinguishedname,description,sAMAccountName | ? {$_.DistinguishedName -notlike "*FTP*"} | Sort-Object -Property description,name,sAMAccountName | Select-Object description,name,sAMAccountName | Export-CSV $file_si03

$timestamp = (Get-Date).toString(‘MM-dd-yyyy’)
$timestamp2 = (Get-Date).toString('MMMM yyyy')
$merged_filename = (Get-Date).toString('yy - MMM') + " Citrix Users.csv"

#dir \\FileServer\dev\NetworkScripts -Filter *.csv | ? {$_.basename -like 'ctx*'} | Import-Csv | sort description,name,sAMAccountName | Export-Csv -Path $filename  -NoTypeInformation
Get-ChildItem -name | ? {$_ -eq $file_sb01 -or $_ -eq $file_si03} | Import-Csv | sort description,name,sAMAccountName | Export-Csv -Path $merged_filename -NoTypeInformation

#[string[]]$recipients = "aaa", "bbb"
Send-MailMessage -from "NetAdmin <netadmin@Domain.net>" `
                       -to "<SRitz@Domain.net>","<VEndy@Domain.net>","<BKleinhample@Domain.net>" `
                       -cc "<netadmin@Domain.net>" `
                       -subject "Citrix User Report - $timestamp2" `
                       -body "Automated Citrix client user report`n`nContact trunyard@Domain.net if there is a problem" `
                       -Attachment $merged_filename -smtpServer sb01exc1.Domain.int
