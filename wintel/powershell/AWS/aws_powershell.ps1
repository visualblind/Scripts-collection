import-module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
Set-AWSCredentials -AccessKey (Add your key here) -SecretKey (Add your key here) -StoreAs email@address.com
Initialize-AWSDefaults -StoredCredentials email@address.com -Region us-east-1



Initialize-AWSDefaults -AccessKey (Add your key here) -SecretKey (Add your key here) -Region us-east-1

Initialize-AWSDefaults -StoredCredentials email@address.com -Region us-east-1

Function logstamp{
(get-date).toString(‘yyyyMMddhhmm’)
}


$server1 = "i-0cb41366"
New-EC2Image -InstanceId $server1 -Name "server1" + logstamp -Description "Automation server1 AMI (base: $baseAMI). Created: ($currTimeStamp)" -NoReboot True



get-date
get-time


$now=get-Date
$yr=$now.Year.ToString()
$mo=$now.Month.ToString()
$dy=$now.Day.ToString()
$hr=$now.Hour.ToString()
$mi=$now.Minute.ToString()
if ($mo.length -lt 2) {
$mo="0"+$mo #pad single digit months with leading zero
}
if ($dy.length -lt 2) {
$dy="0"+$dy #pad single digit day with leading zero
}
if ($hr.length -lt 2) {
$hr="0"+$hr #pad single digit hour with leading zero
}
if ($mi.length -lt 2) {
$mi="0"+$mi #pad single digit minute with leading zero
}
write-output $yr$mo$dy$hr$mi


(get-date).toString(‘yyyyMMddhhmm’)