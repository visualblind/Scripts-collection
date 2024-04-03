Uninstall-ADDSDomainController -localadministratorpassword (convertto-securestring "password" -asplaintext -force) -removednsdelegation $true -removeapplicationpartitions -norebootoncompletion:$false
Uninstall-ADDSDomainController -localadministratorpassword (convertto-securestring "password" -asplaintext -force) -removeapplicationpartitions -norebootoncompletion:$false

Uninstall-WindowsFeature -Name CertificateServices

Uninstall-AdcsCertificationAuthority -Force
Remove-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Remove -WhatIf