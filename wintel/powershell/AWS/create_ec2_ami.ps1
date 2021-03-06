import-module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"

$timestamp = (get-date).toString(‘MM-dd-yyyy-HH-mm’)

$s1_name = $timestamp + "-Auto-SERVER1"
$s2_name = $timestamp + "-Auto-SERVER2"
$s3_name = $timestamp + "-Auto-SERVER3"
$s4_name = $timestamp + "-Auto-SERVER4"
$s5_name = $timestamp + "-Auto-SERVER5"
$s6_name = $timestamp + "-Auto-SERVER6"
$s7_name = $timestamp + "-Auto-SERVER7"
$s8_name = $timestamp + "-Auto-SERVER8"
$s9_name = $timestamp + "-Auto-SERVER9"
$s10_name = $timestamp + "-Auto-SERVER10"
$s12_name = $timestamp + "-Auto-SERVER11"
$s11_name = $timestamp + "-Auto-SERVER12"

$s1_id = "i-0cb41366"
$s2_id = "i-79008806"
$s3_id = "i-88aa64f7"
$s4_id = "i-3162fd57"
$s5_id = "i-f2917e8b"
$s6_id = "i-8ce13ae9"
$s7_id = "i-c37172a2"
$s8_id = "i-9c1344fb"
$s9_id = "i-9b9f15fd"
$s10_id = "i-bea5d8ce"
$s11_id = "i-9842f1fe"
$s12_id = "i-a70a5fc0"

New-EC2Image -InstanceId $s1_id -Name $s1_name -Description "Automation SERVER1 AMI" -NoReboot $True
New-EC2Image -InstanceId $s2_id -Name $s2_name -Description "Automation SERVER2 AMI" -NoReboot $True
New-EC2Image -InstanceId $s3_id -Name $s3_name -Description "Automation SERVER3 AMI" -NoReboot $True
New-EC2Image -InstanceId $s4_id -Name $s4_name -Description "Automation SERVER4 AMI" -NoReboot $True
New-EC2Image -InstanceId $s5_id -Name $s5_name -Description "Automation SERVER5 AMI" -NoReboot $True
New-EC2Image -InstanceId $s6_id -Name $s6_name -Description "Automation SERVER6 AMI" -NoReboot $True
New-EC2Image -InstanceId $s7_id -Name $s7_name -Description "Automation SERVER7 AMI" -NoReboot $True
New-EC2Image -InstanceId $s8_id -Name $s8_name -Description "Automation SERVER8 AMI" -NoReboot $True
New-EC2Image -InstanceId $s9_id -Name $s9_name -Description "Automation SERVER9 AMI" -NoReboot $True
New-EC2Image -InstanceId $s10_id -Name $s10_name -Description "Automation SERVER10 AMI" -NoReboot $True
New-EC2Image -InstanceId $s11_id -Name $s11_name -Description "Automation SERVER12 AMI" -NoReboot $True
New-EC2Image -InstanceId $s12_id -Name $s12_name -Description "Automation SERVER11 AMI" -NoReboot $True