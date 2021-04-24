$Event = Get-EventLog -LogName Security -InstanceId 4740 -Newest 1
$Usr = $Event.Message -split [char]13
$Usr = $Usr[10]
$Usr = $Usr.substring(17)
$Usr = Get-ADUser $Usr
$OU = Get-ADUser $Usr -Properties distinguishedname,cn | select @{n='AD OU: ';e={$_.distinguishedname -replace '^.+?,(CN|OU.+)','$1'}}


$EmailUsr = $Usr.mail
$EmailHD = “trunyard@Domain.net”
$OfficePhone = $Usr.officephone
$Username = $Usr.username
$MailBodyHD = $Event.Message + “`r`n`t” + $Event.TimeGenerated + “`r`n`t” + $OU + “`r`n`t” + $Usr.mail + “`r`n`t” + “Direct: $TelephoneNumber” + “`r`n`t” + “`r`n`t” + “*ATTENTION* Do not automatically unlock the user’s account, please follow up with them first”
$MailBodyUsr = "Your Wesley WiFi & PC logon account (" + $Username + ") has been locked out. Please contact the IT Department at (302) 736-4199, or come to the IT Department to have your Wesley account unlocked."

$MailSubjectHD = “User Account Locked Out: ” + $Usr.username
$MailSubjectUser = “Wesley College Account Locked Out.”
$MailServer = “sb01exc1.Domain.int”
#$MailServer = “newport.wesley.int”
#$MailSender = “AcctLockNotify@wesley.edu”
$MailSender = “AcctLockNotify@Domain.int”
#$MailHelpdesk = “helpdesk@wesley.edu”
$MailHD = “trunyard@Domain.net”

# Send mail to the helpdesk
Send-MailMessage -From $MailSender
        -To $EmailHD
        -Subject $MailSubjectHD
        -Body $MailBodyHD  
        -SmtpServer $MailServer
        
#Send mail to the user
Send-MailMessage -From $MailSender
        -To $EmailUsr
        -Subject $MailSubjectUser
        -Body $MailBodyUsr  
        -SmtpServer $MailServer
