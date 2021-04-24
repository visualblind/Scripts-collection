Add-PSSnapin VMware.VimAutomation.Core

#Connect to vcenter server  
connect-viserver <vcenter name>  
  
#Import vm name from csv file  
Import-Csv deploy.csv |  
foreach {  
    $strNewVMName = $_.name  
      
    #Update VMtools without reboot  
    Get-Cluster <cluster name> | Get-VM $strNewVMName | Update-Tools –NoReboot  
  
   write-host "Updated $strNewVMName ------ "  
       
    $report += $strNewVMName  
}  
  
write-host "Sleeping ..."  
Sleep 120  
  
#Send out an email with the names  
$emailFrom = "<sender email id>"  
$emailTo = "<recipient email id>"  
$subject = "VMware Tools Updated"  
$smtpServer = "<smtp server name>"  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$smtp.Send($emailFrom, $emailTo, $subject, $Report)  