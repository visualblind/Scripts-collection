<#
	.SYNOPSIS
		New-ISqlTableUsingSMO
	.DESCRIPTION
		Create a new table using SMO
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER dbName
		Database name
	.PARAMETER tblName
		Table name
	.EXAMPLE
		.\New-ISqlTableUsingSMO -serverInstance MyServer -dbName SMOTestDB -tblName SMOTable
	.INPUTS
	.OUTPUTS
		Create a demo table on specified database
	.NOTES
		Adapted from Allen White script
	.LINK
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. Server01\SQL2012]')",
	[string]$dbName = "$(Read-Host 'Database Name [e.g. SMOTestDB]')",
	[string]$tblName = "$(Read-Host 'Table Name [e.g. SMOTable]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		# Instantiate a server object for the default instance
		$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		# Disable connection pooling
		$server.ConnectionContext.Set_NonPooledConnection($True)

		# Explicitly connect because connection pooling is disabled
		$server.ConnectionContext.Connect()

		# Connect to the server with Windows Authentication and create a table
		if ($server.Databases[$dbName] -eq $null) {
			Throw "Database does not exist, table not created."
		} else {
			# Instantiate a table object
			$database = $server.Databases[$dbName]

			Write-Verbose "Creating table: $tblName"
			$table = new-object Microsoft.SqlServer.Management.Smo.Table ($database, $tblName)

			# Add Field1 column 
			$colField1 = New-Object Microsoft.SqlServer.Management.Smo.Column ($table, "Field1")
			$colField1.DataType = [Microsoft.SqlServer.Management.Smo.Datatype]::Int
			$table.Columns.Add($colField1)

			# Add Field2 column
			$colField2 = New-Object Microsoft.SqlServer.Management.Smo.Column ($table, "Field2")
			$colField2.DataType = [Microsoft.SqlServer.Management.Smo.Datatype]::NVarchar(25)
			$table.Columns.Add($colField2)

			# Add Field3 column
			$colField3 = New-Object Microsoft.SqlServer.Management.Smo.Column ($table, "Field3")
			$colField3.DataType = [Microsoft.SqlServer.Management.Smo.Datatype]::NVarchar(50)
			$table.Columns.Add($colField3)

			# Create the table on the server
			$table.Create()
			$Output = "Table: $tblName created on $database."
		}

		# Explicitly disconnect because connection pooling is disabled
		Write-Verbose "Disconnecting..."
		$server.ConnectionContext.Disconnect()
		
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