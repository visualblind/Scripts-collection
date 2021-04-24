Import-Module ActiveDirectory
Get-ADUser -filter * | foreach {
	$user = [ADSI]"LDAP://$($_.DistinguishedName)"
	if ($user.TerminalServicesProfilePath -isnot [System.Management.Automation.PSMethod])
	{
		 #$user.psbase.invokeSet("TerminalServicesHomeDirectory","")
 		 $user.psbase.invokeSet("TerminalServicesProfilePath","")
 		 #$user.psbase.invokeSet("TerminalServicesHomeDrive","")
		 $user.setinfo()
	}
}
