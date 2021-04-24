import-module activedirectory
Get-ADUser -SearchBase 'OU=Users,OU=Company,DC=Company,DC=com' -Filter 'samAccountName -like "pgi*"' | % { Add-ADGroupMember -Server dc2.aws.Company.int 'Xen-AppAWS' -Members $_ -WhatIf }
