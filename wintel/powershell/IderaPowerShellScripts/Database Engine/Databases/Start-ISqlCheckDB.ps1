<#
	.SYNOPSIS
		Start-ISqlCheckDB
	.DESCRIPTION
		Run a DBCC against specified server instance and database
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER dbName
		Database name
	.EXAMPLE
		.\Start-ISqlCheckDB -serverInstance Server01\SQL2012 -dbName AdventureWorks
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param (
	[string]$ServerInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])", 
	[string]$dbName = "$(Read-Host 'Database Name' [e.g. AdventureWorks2012])"
)

process {
	Write-Verbose "Run a DBCC against specified server instance and database..." 

	try {
		$connStr = "Data Source=$serverInstance;Integrated Security=SSPI;Initial Catalog=$dbName"
		$query = "DBCC CHECKDB($dbName) WITH TABLERESULTS"
		
		$cn = new-object System.Data.SqlClient.SqlConnection ($connStr)
		$ds = new-object System.Data.DataSet "dsCheckDB"
		$da = new-object System.Data.SqlClient.SqlDataAdapter ($query, $cn)
		
		$da.Fill($ds)

		$dtCheckDB = new-object System.Data.DataTable "dsCheckDB"
		$dtCheckDB = $ds.Tables[0]
		$output = $dtCheckDB | Select-Object Error, Level, State, MessageText
		Write-Output $output
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