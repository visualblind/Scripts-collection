$name = “pdiscordia”
(New-Object System.Security.Principal.NTAccount($name)).Translate([System.Security.Principal.SecurityIdentifier]).value

or

$objUser = New-Object System.Security.Principal.NTAccount("aws", "odg_pdiscordia")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value
