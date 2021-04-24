<#
	.SYNOPSIS
		Invoke-ISqlCycleLogs
	.DESCRIPTION
		Cycles error log on a server instance
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Invoke-ISqlCycleLogs -serverInstance MyServer\SQL2012
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
		$cnStr = "Data Source=$serverInstance;Integrated Security=SSPI;Initial Catalog=$dbname"
		$cn = new-object System.Data.SqlClient.SqlConnection($cnStr)
		$cn.Open()
		$query = "Exec Sp_Cycle_Errorlog"
		$cmd = new-object System.Data.SqlClient.SqlCommand $query, $cn
		$cmd.ExecuteNonQuery() | out-null
		$cn.Close()

		Write-Output "Recycled error logs on $serverInstance."
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