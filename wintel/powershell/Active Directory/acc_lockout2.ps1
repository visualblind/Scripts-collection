$Event = Get-EventLog -LogName Security -InstanceId 4740 -Newest 1
$MailBody= $Event.Message + "`r`n`t" + $Event.TimeGenerated

$MailSubject= "User Account locked out"
$SmtpClient = New-Object system.net.mail.smtpClient
$SmtpClient.host = "sb01exc1.Domain.int"
$MailMessage = New-Object system.net.mail.mailmessage
$MailMessage.from = "AcctLockNotify@Domain.int"
$MailMessage.To.add("netadmin@Domain.net")
$MailMessage.IsBodyHtml = 0
$MailMessage.Subject = $MailSubject
$MailMessage.Body = $MailBody
$SmtpClient.Send($MailMessage)
