
Set-Location WSMan:\localhost\Client
Get-ChildItem

Set-Item wsman:\localhost\Client\TrustedHosts -Value Win2016-Srv01
Set-Item wsman:\localhost\Client\TrustedHosts -Value *.some-domain.local
Set-Item wsman:\localhost\Client\TrustedHosts -Value *

$RemoteCredential = Get-Credential "Win2016-Srv01\MSimmons"