$Event = Get-EventLog -LogName Security -InstanceId 4740 -Newest 1

$Usr = $Event.Message -split [char]13
# [#] is the line number in the output
$Usr = $Usr[10]
# (#) is the substring of that line
$Usr = $Usr.substring(17)

#$OU = Get-ADUser $Usr -Properties distinguishedname,cn | select @{n='ParentContainer: ';e={$_.distinguishedname -replace '^.+?,(CN|OU.+)','$1'}}
$OU2 = Get-ADUser $Usr -Properties distinguishedname,cn | select @{n='ParentContainer';e={$_.distinguishedname -replace "CN=$($_.cn),",''}}
$Email = Get-ADUser $Usr -Properties mail

$MailBody= $Event.Message + "`r`n`t" + $Event.TimeGenerated + "`r`n`t" + $OU2 + "`r`n`t" + $Email.mail
$MailSubject= "User Account locked out: " + $Usr
$SmtpClient = New-Object system.net.mail.smtpClient
$SmtpClient.host = "sb01exc1.Domain.int"
$MailMessage = New-Object system.net.mail.mailmessage
$MailMessage.from = "AcctLockNotify@Domain.int"
$MailMessage.To.add("netadmin@Domain.net")
$MailMessage.IsBodyHtml = 0
$MailMessage.Subject = $MailSubject
$MailMessage.Body = $MailBody
$SmtpClient.Send($MailMessage)
