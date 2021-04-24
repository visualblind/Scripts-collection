Invoke-Command -cn SERVER1 -Scriptblock {Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | fl }

Get-ADGroup -Identity 'SE-ISA' -Properties Members | Select-Object Members | out-string -Width 9999

$FormatEnumerationLimit=-1

Get-ADGroupMember 'SE-ISA' -Verbose | select name, objectGUID, samAccountName | Out-GridView

Get-AdUser -Identity "PHart" -Properties MemberOf | select SamAccountName, MemberOf | ft | out-string -Width 999

$PSVersionTable.PSVersion

Install-Module ISESteroids -Scope CurrentUser

Get-Module -Verbose


Get-Help PS-Get -Online

Start-Steroids