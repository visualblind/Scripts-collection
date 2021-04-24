Import-Module ActiveDirectory

$Filter = { (enabled -eq $true) }
$SearchBase = "OU=M3,OU=Users,OU=Clients,DC=AWS,DC=Domain,DC=com"
$Path = "\\SI04FTP1\TSProfiles$\"
Get-ADUser -Filter $Filter -SearchBase $SearchBase  -SearchScope Subtree  | ForEach-Object {


	$user = [ADSI]"LDAP://$($_.DistinguishedName)"
	if ($user.TerminalServicesProfilePath -isnot [System.Management.Automation.PSMethod])
	{
		 #$user.psbase.invokeSet("TerminalServicesHomeDirectory","")
 		 $user.psbase.invokeSet("TerminalServicesProfilePath","")
 		 #$user.psbase.invokeSet("TerminalServicesHomeDrive","")
		 $user.setinfo()
	}
}
