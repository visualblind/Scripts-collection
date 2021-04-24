<#
	.SYNOPSIS
		Get-ISqlDBUsingADO
	.DESCRIPTION
		Show all databases for a given server instance
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlDBUsingADO -serverInstance MyServer
	.INPUTS
	.OUTPUTS
		Database IDs and Names
	.NOTES
	.LINK
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. Server01\sql2012]')"
)

process {
	try {
		Write-Verbose "Show all databases for a given server instance..."

		$adoOpenStatic = 3
		$adoLockOptimistic = 3

		# Create ADO connection and recordset objects	
		$adoConnection = New-Object -comobject ADODB.Connection
		$adoRecordset = New-Object -comobject ADODB.Recordset

		Write-Debug "Opening connection..."
		$adoConnection.Open("Provider=SQLOLEDB;Data Source=$serverInstance;Initial Catalog=master;Integrated Security=SSPI")

		# Run query to retrieve database ids and names
		$query = "SELECT dbid, name FROM master.dbo.sysdatabases ORDER BY name"
		$adoRecordset.Open($query, $adoConnection, $adoOpenStatic, $adoLockOptimistic)
		$adoRecordset.MoveFirst()

		Write-Verbose "Retrieving results..."

		$dbs = @()

		do 
		{
			$dbID = $adoRecordset.Fields.Item("dbid").Value
			$dbName = $adoRecordset.Fields.Item("name").Value

			$db = New-Object -TypeName PSObject -Property @{
				DbID = $dbID
				DbName = $dbName
			}
			$dbs += $db

			$adoRecordset.MoveNext()
		} until ($adoRecordset.EOF -eq $TRUE)

		$adoRecordset.Close()
		$adoConnection.Close()

		Write-Output $dbs
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