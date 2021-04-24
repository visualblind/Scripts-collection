# First lets create a text file, where we will later save the Service Health info
$ServiceHealthFileName = "ServiceHealth.htm"
$serverlist = "yourserverlist.txt"
$warning = "Stopped"
New-Item -ItemType file $ServiceHealthFileName -Force

# Function to write the HTML Header to the file
Function writeHtmlHeader
{
param($fileName)
$date = ( get-date ).ToString('yyyy/MM/dd')
Add-Content $fileName "<html>"
Add-Content $fileName "<head>"
Add-Content $fileName "<meta http-equiv='Content-Type' content='text/html;    charset=iso-8859-1'>"
Add-Content $fileName '<title> Server Health</title>'
add-content $fileName '<STYLE TYPE="text/css">'
add-content $fileName  "<!--"
add-content $fileName  "td {"
add-content $fileName  "font-family: Tahoma;"
add-content $fileName  "font-size: 11px;"
add-content $fileName  "border-top: 1px solid #999999;"
add-content $fileName  "border-right: 1px solid #999999;"
add-content $fileName  "border-bottom: 1px solid #999999;"
add-content $fileName  "border-left: 1px solid #999999;"
add-content $fileName  "padding-top: 0px;"
add-content $fileName  "padding-right: 0px;"
add-content $fileName  "padding-bottom: 0px;"
add-content $fileName  "padding-left: 0px;"
add-content $fileName  "}"
add-content $fileName  "body {"
add-content $fileName  "margin-left: 5px;"
add-content $fileName  "margin-top: 5px;"
add-content $fileName  "margin-right: 0px;"
add-content $fileName  "margin-bottom: 10px;"
add-content $fileName  ""
add-content $fileName  "table {"
add-content $fileName  "border: thin solid #000000;"
add-content $fileName  "}"
add-content $fileName  "-->"
add-content $fileName  "</style>"
Add-Content $fileName "</head>"
Add-Content $fileName "<body>"
add-content $fileName  "<table width='100%'>"
add-content $fileName  "<tr bgcolor='#CCCCCC'>"
add-content $fileName  "<td colspan='7' height='25' align='center'>"
add-content $fileName  "<font face='tahoma' color='#003399' size='4'><strong> Server Health - $date</strong></font>"
add-content $fileName  "</td>"
add-content $fileName  "</tr>"
add-content $fileName  "</table>"

}

# Function to write the HTML Header to the file
Function writeTableHeader
{
param($fileName)

Add-Content $fileName "<tr bgcolor=#CCCCCC>"
Add-Content $fileName "<td width='10%' align='center'>Name</td>"
Add-Content $fileName "<td width='50%' align='center'>ProcessId</td>"
Add-Content $fileName "<td width='10%' align='center'>State</td>"
Add-Content $fileName "<td width='10%' align='center'>StartMode</td>"
Add-Content $fileName "<td width='10%' align='center'>ExitCode</td>"
Add-Content $fileName "<td width='10%' align='center'>Status</td>"
Add-Content $fileName "</tr>"
}

Function writeHtmlFooter
{
param($fileName)

Add-Content $fileName "</body>"
Add-Content $fileName "</html>"
}

Function writeServiceInfo
{
param($fileName,$SvcName,$SvcPID,$SvcSM,$SvcExCd,$ServiceState,$SvcStatus)
$SvcName= $Item.Name
$SvcPID= $Item.ProcessId
$SvcSM= $Item.StartMode
$SvcExCd= $Item.ExitCode
$ServiceState= $Item.State
$SvcStatus= $Item.Status
#You can add multiple elseif statements if you wish to display certain events. I have server state of STOPPED in Red.
if ($ServiceState -eq $warning)
{
Add-Content $fileName "<tr>"
Add-Content $fileName "<td>$SvcName</td>"
Add-Content $fileName "<td>$SvcPID</td>"
Add-Content $fileName "<td bgcolor='#FF4C4C'  align=center>$ServiceState</td>"
#FF4C4C RED #FBB917 ORANGE
Add-Content $fileName "<td>$SvcSM</td>"
Add-Content $fileName "<td>$SvcExCd</td>"
Add-Content $fileName "<td>$SvcStatus</td>"
Add-Content $fileName "</tr>"
}
else
{
Add-Content $fileName "<tr>"
Add-Content $fileName "<td>$SvcName</td>"
Add-Content $fileName "<td>$SvcPID</td>"
Add-Content $fileName "<td>$ServiceState</td>"
Add-Content $fileName "<td>$SvcSM</td>"
Add-Content $fileName "<td>$SvcExCd</td>"
Add-Content $fileName "<td>$SvcStatus</td>"
Add-Content $fileName "</tr>"
}
}

#The function for the sendemail at the end.

#Function sendEmail 
#{ param($from,$to,$subject,$smtphost,$htmlFileName) 
#$body = Get-Content $htmlFileName 
#$smtp= New-Object System.Net.Mail.SmtpClient $smtphost 
#$msg = New-Object System.Net.Mail.MailMessage $from, $to, $subject, $body 
#$msg.isBodyhtml = $true
#$smtp.send($msg) 



writeHtmlHeader $ServiceHealthFileName
foreach ($server in Get-Content $serverlist)
{
 #This adds the Uptime for the server you will need $Display in your add-content.
 $hostname = get-wmiobject win32_computersystem -computername $server | fl model
 $os = Get-WmiObject win32_operatingsystem -ComputerName $server
 $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
 $Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"

 #This builds the header for each server and include the name and uptime.
 Add-Content $ServiceHealthFileName "<table width='100%'><tbody>"
 Add-Content $ServiceHealthFileName "<tr bgcolor='#CCCCCC'>"
 Add-Content $ServiceHealthFileName "<td width='100%' align='center' colSpan=6><font face='tahoma' color='#003399' size='2'><strong> $server $Display </strong></font></td>"
 Add-Content $ServiceHealthFileName "</tr>"

 #This writes the header and builds the body of each server health
 writeTableHeader $ServiceHealthFileName
 $store = @()
 $store += Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name LIKE 'yourservice'"
 $store += Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name LIKE 'yourservice'"
 $store += Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name LIKE 'yourservice'"
 $store += Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name LIKE 'yourservice'"
 $store += Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name LIKE 'yourservice'"
 $store += Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name LIKE 'yourservice'"
 $store += Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name LIKE 'yourservice'"
 $store += Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name LIKE 'yourservice'"

 #This write the body of each header in the order you defined
 foreach ($item in $store)
 {
 #If you dont want on screen read out as the script progresses; comment out the write-host line.
 #Write-Host  $server $item.Name $item.ProcessId $item.State
 writeServiceInfo $ServiceHealthFileName $item.Name $item.ProcessId    $item.State $item.StartMode $Item.ExitCode $Item.Status
 }
 }
#This writes the footer
writeHtmlFooter $ServiceHealthFileName
$date = ( get-date ).ToString('yyyy/MM/dd')
#Use the below line to setup an email of the report,

#sendEmail emailaddress emailaddress "Server Status Report - $Date" EmailServer $ServiceHealthFileName