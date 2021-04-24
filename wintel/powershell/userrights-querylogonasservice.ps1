Import-Module .\UserRights.ps1
Get-AccountsWithUserRight -Right SeServiceLogonRight | select Account