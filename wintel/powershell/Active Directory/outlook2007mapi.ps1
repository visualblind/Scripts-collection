# Travis Runyard 3.26.2013
# Auto-create Outlook MAPI Profiles for Citrix and TS environments
# Requires PowerShell v2.0+

$memberOf = ([ADSISEARCHER]"samaccountname=$($env:USERNAME)").Findone().Properties.memberof -replace '^CN=([^,]+).+$','$1'
$group1 = "OC_TechSupport"
$group2 = "Internal_Users"
if(($memberOf -contains $group1) -or ($memberOf -contains $group2))
{
$path = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook"
If(-not(Test-Path -Path $path))
  {
Start-Process "C:\Program Files (x86)\Microsoft Office\Office12\Outlook.exe" -ArgumentList "/importprf c:\scripts$\Outlook2007mapi.prf" -WindowStyle Minimized
Start-Sleep -s 5
Get-Process outlook | % { $_.CloseMainWindow() }
#If that did not close Outlook then kill it
Stop-Process -ProcessName Outlook -Force
  }
}
