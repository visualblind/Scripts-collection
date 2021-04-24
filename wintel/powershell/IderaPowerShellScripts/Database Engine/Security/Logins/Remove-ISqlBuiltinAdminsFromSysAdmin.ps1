<#
	.SYNOPSIS
		Remove-ISqlBuiltinAdminsFromSysAdmin
	.DESCRIPTION
		Remove Login from a Database Role in all Databases excluding System DBs
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Remove-ISqlBuiltinAdminsFromSysAdmin -serverInstance MyServer\SQL2012 
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])"
)

begin {
}
process {
	try {
		$messages = @()
		$cn = new-object System.Data.SqlClient.SqlConnection "server=$serverInstance;database=master;Integrated Security=sspi"
		$cn.Open()
		$sql = $cn.CreateCommand()
		$sql.CommandText = "EXEC master..sp_dropsrvrolemember @loginame = N'BUILTIN\Administrators', @rolename = N'sysadmin';"
		$rdr = $sql.ExecuteNonQuery()
		$messages += "Login BUILTIN\Administrators dropped from sysadmin role."
		
		Write-Output $messages 
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