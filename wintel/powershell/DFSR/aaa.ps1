Set-ExecutionPolicy 0
Import-Module Activedirectory
cd "\\Domain.int\dfs\NetAdmin\Quarterly SAS Audit"
$file_1 = (Get-Date).toString('yy - MMM') + " 1.csv"
$file_2 = (Get-Date).toString('yy - MMM') + " 2.csv"

Get-ADUser -Filter { enabled -eq $true } -SearchBase "OU=Users,OU=Clients,OU=Root,DC=Domain,DC=com" -SearchScope Subtree -Properties description,sAMAccountName | Sort-Object -Property description,name,sAMAccountName | Select-Object description,name,sAMAccountName | Export-CSV $file_1
Get-ADUser -Server ComputerName -Filter { (enabled -eq $true) } -SearchBase "OU=Users,OU=Clients,OU=Root,DC=AWS,DC=Domain,DC=com" -SearchScope Subtree -Properties distinguishedname,description,sAMAccountName | ? {$_.DistinguishedName -notlike "*FTP*"} | Sort-Object -Property description,name,sAMAccountName | Select-Object description,name,sAMAccountName | Export-CSV $file_2

$timestamp = (Get-Date).toString(‘MM-dd-yyyy’)
$timestamp2 = (Get-Date).toString('MMMM yyyy')
$merged_filename = (Get-Date).toString('yy - MMM') + " Citrix Users.csv"

#dir \\FileServer\dev\NetworkScripts -Filter *.csv | ? {$_.basename -like 'ctx*'} | Import-Csv | sort description,name,sAMAccountName | Export-Csv -Path $filename  -NoTypeInformation
Get-ChildItem -name | ? {$_ -eq $file_1 -or $_ -eq $file_2} | Import-Csv | sort description,name,sAMAccountName | Export-Csv -Path $merged_filename -NoTypeInformation

#[string[]]$recipients = "aaa", "bbb"
Send-MailMessage -from "NetAdmin <netadmin@Domain.net>" `
                       -to "<user1@Domain.net>","<user2@Domain.net>","<user3@Domain.net>" `
                       -cc "<netadmin@Domain.net>" `
                       -subject "Citrix User Report - $timestamp2" `
                       -body "Automated Citrix client user report`n`nContact netadmin@Domain.net if there is a problem" `
                       -Attachment $merged_filename -smtpServer EmailServer