Import-Module ActiveDirectory
#get max password age policy
$maxPwdAge=(Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days

#expiring in 30 days
$7days=(get-date).AddDays($maxPwdAge).ToShortDateString()

Get-ADUser -SearchBase "OU=Service Accounts,OU=DomainOU,DC=ADDOMAIN,DC=org" -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0} -Properties * | where {($_.PasswordLastSet).ToShortDateString() -lt $7days} | Select-Object -Property samAccountName,@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Out-Gridview
Get-ADUser -SearchBase "OU=TEST,OU=Users,OU=Admins,DC=ADDOMAIN,DC=org" -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0} –Properties * | where {($_.PasswordLastSet).ToShortDateString() -eq $7days} | select *




Get-ADUser -SearchBase "OU=Service Accounts,OU=DomainOU,DC=ADDOMAIN,DC=org" -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "SamAccountName","PasswordLastSet","msDS-UserPasswordExpiryTimeComputed" | 
where {($_.PasswordLastSet).ToShortDateString() -gt $7days} |  Select-Object -Property "SamAccountName", @{Name="Password Expiry Date"; Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
    Format-Table


Get-ADUser -SearchBase "DC=ADDOMAIN,DC=org" -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "SamAccountName","Name","msDS-UserPasswordExpiryTimeComputed" | 
where {
$diff = New-TimeSpan ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")) (Get-Date)  
$diff.Days -le 60 -and $diff.Days -gt 0
} |
  Select-Object -Property "SamAccountName", "Name", @{Name="Password Expiry Date"; Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
    Format-Table



$maxPWAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
$Users = Get-ADUser -SearchBase "OU=Service Accounts,OU=DomainOU,DC=ADDOMAIN,DC=org" -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties msDS-UserPasswordExpiryTimeComputed, PasswordLastSet, CannotChangePassword
#$Jsers | select Name, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, PasswordLastSet
 
foreach($u in $Users){
     if( [datetime]::FromFileTime($u.'msDS-UserPasswordExpiryTimeComputed').addDays($maxPWAge) -lt (Get-Date)) {
         $u. DistinguishedName; $u.PasswordLastSet -replace "`n|`r","" 
     }
 }


 foreach($u in $Users){
     if( [datetime]::FromFileTime($u.'msDS-UserPasswordExpiryTimeComputed').addDays($maxPWAge) -lt (Get-Date)) {
         $u. DistinguishedName; $u.PasswordLastSet -replace "`n|`r","" 
     }
 }


 Get-ADUser -SearchBase "DC=ADDOMAIN,DC=org" -filter * -properties Name, PasswordNeverExpires, PasswordExpired, PasswordLastSet | where {$_.Enabled -eq "True"} | where {$_.PasswordNeverExpires -eq $false} | where {$_.passwordexpired -eq $true} | where { 
$diff = New-TimeSpan ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")) (Get-Date)  
$diff.Days -le 99 -and $diff.Days -ge 0
} | select "SamAccountName", "DisplayName", "msDS-UserPasswordExpiry", "TimeComputed",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}



Get-ADUser -SearchBase "OU=Service Accounts,OU=DomainOU,DC=ADDOMAIN,DC=org" -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
 where {
$diff = New-TimeSpan ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")) (Get-Date)  
$diff.Days -le 99 -and $diff.Days -ge 0
} | Select-Object "samAccountName";@{Name="ExpiryDate";Expression={[datetime]::FromFileTime("msDS-UserPasswordExpiryTimeComputed")}}



Get-ADUser -SearchBase "OU=Tustin,DC=ADDOMAIN,DC=org" -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "SamAccountName", "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | where {  
$diff = New-TimeSpan ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")) (Get-Date)
$diff.Days -le 999 -and $diff.Days -ge 0
} | select "SamAccountName", "DisplayName", "msDS-UserPasswordExpiry", "TimeComputed",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Export-csv -