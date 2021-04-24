Import-Module ActiveDirectory
Get-ADUser -filter * | foreach {
	$user = [ADSI]"LDAP://$($_.DistinguishedName)"
	Write-Host $user.sAMAccountName
	if ($user.TerminalServicesProfilePath -isnot [System.Management.Automation.PSMethod])
	{
		 #$user.psbase.invokeSet("TerminalServicesHomeDirectory","")
 		 $user.psbase.invokeSet("TerminalServicesProfilePath","\\FileServer\tsprofiles$\" + $user.sAMAccountName)
 		 #$user.psbase.invokeSet("TerminalServicesHomeDrive","")
		 $user.setinfo()
	}

}


AND

Import-Module ActiveDirectory
$Filter = { (enabled -eq $true) }
$SearchBase = "OU=M3,OU=Users,OU=Clients,DC=AWS,DC=Domain,DC=com"
$Path = "\\SI04FTP1\TSProfiles$\"
Get-ADUser -Filter $Filter -SearchBase $SearchBase  -SearchScope Subtree  | ForEach-Object {
    $ADSI = [ADSI]('LDAP://{0}' -f $_.DistinguishedName)
    try {
        $ADSI.InvokeSet('TerminalServicesProfilePath',$Path + $ADSI.sAMAccountName)
        $ADSI.SetInfo()
    }
    catch {
        Write-Error $Error[0]
    }
}
