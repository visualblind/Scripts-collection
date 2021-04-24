<#
	.SYSNOPSIS
    	Get-ISqlLoginAdGroups
  	.DESCRIPTION
    	Using AD groups instead of single user account is a good and easy instrument to manage SQL Server security.
    	IT deparment can add new users to the AD group to give them predefined permission rights to SQL Server, without
    	that IT must have security admin permission in SQL Server itself.

		This Powershell script queries all AD groups from SQL server having access rights and list then all members
    	of the group from ADS.
  	.PARAMETERS serverInstance
  		SQL Server instance
  	.EXAMPLE
  		PS> .\Get-ISqlLoginAdGroups -serverInstance server01\sql2012
  	.NOTES
    	Attributed to Olaf Helper
    	Works only with AD groups, not for local groups.
    	Works only in a domain enviroment.
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])"
)

begin {
	Add-Type -AssemblyName System.DirectoryServices.AccountManagement
}
process {
	try {

		$connString = "Data Source=$serverInstance;Initial Catalog=master;Integrated Security=True;"
		$con = New-Object Data.SqlClient.SqlConnection $connString
		$con.open()

		# Select-Statement for AD group logins
		$sql = @"
SELECT [loginname]
FROM sys.syslogins
WHERE [isntgroup] = 1
AND [hasaccess] = 1
AND [loginname] <> 'BUILTIN\Administrators'
ORDER BY [loginname]
"@

		$cmd = New-Object Data.SqlClient.SqlCommand
		$cmd.Connection = $con
		$cmd.CommandText = $sql
		$rd = $cmd.ExecuteReader()

		$ads = [System.DirectoryServices.AccountManagement.ContextType]::Domain

		while ($rd.Read())
		{
			$groupName = $rd.GetString(0)
			$group = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($ads, $groupName)
			if ($group)
			{
				Write-Output "Members of AD Group: $groupName"
				$group.GetMembers($true) | 
				Sort-Object UserPrincipalName | 
				Select-Object UserPrincipalName, DisplayName, EmailAddress
			}
		}
	}
	catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
}