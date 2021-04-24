$Event=get-eventlog -log security | where {$_.eventID -eq 4740} | Sort-Object index -Descending | select -first 1
$MailBody= $Event.message

$MailSubject= "User Account locked out"
$SmtpClient = New-Object system.net.mail.smtpClient
$SmtpClient.host = "sb01exc1.Domain.int"
$MailMessage = New-Object system.net.mail.mailmessage
$MailMessage.from = "AcctLockNotify@Domain.int"
$MailMessage.To.add("netadmin@Domain.net")
$MailMessage.IsBodyHtml = 1
$MailMessage.Subject = $MailSubject
$MailMessage.Body = $MailBody
$SmtpClient.Send($MailMessage)
