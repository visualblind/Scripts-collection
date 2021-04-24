<#
	.SYNOPSIS
		New-ISqlTableUsingSMO
	.DESCRIPTION
		Create an empty database
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER dbName
		Database name
	.EXAMPLE
		.\New-ISqlTableUsingSMO -server MyServer -dbName SMOTestDB
	.INPUTS
	.OUTPUTS
		Formatted table with database name and creation date
	.NOTES
		Adapted from Allen White script
	.LINK
#>

param (
	[string]$server = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$dbName = "$(Read-Host 'Database Name' [e.g. SMOTestDB])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		# Get a server object for the server instance
		Write-Verbose "Creating SMO Server object for $server"
		$namedInstance = New-Object Microsoft.SqlServer.Management.Smo.Server ($server)

		# Connect to the server with Windows Authentication 
		if ($namedInstance.Databases[$dbName] -ne $null) {
			Throw "Database ($dbName) already exists on $server. Can not create it."
		} else {
			# Instantiate a database object
			Write-Verbose "Creating SMO server, database and filegroup objects..."
			$database = new-object Microsoft.SqlServer.Management.Smo.Database ($namedInstance, $dbName)
			$filegroup = new-object Microsoft.SqlServer.Management.Smo.FileGroup ($database, "PRIMARY")

			# Add the PRIMARY filegroup to the database
			$database.FileGroups.Add($filegroup)

			# Instantiate the data file object and add it to the PRIMARY filegroup
			$dbfile = $dbName + "_Data"
			$dbdfile = new-object Microsoft.SqlServer.Management.Smo.DataFile ($filegroup, $dbfile)
			$filegroup.Files.Add($dbdfile)

			Write-Verbose "Set properties of the data and log file."

			# Set the properties of the data file
			$masterDBPath = $namedInstance.Information.MasterDBPath
			$dbdfile.FileName = $masterDBPath + "\" + $dbfile + ".mdf"
			$dbdfile.Size = [double](25.0 * 1024.0)
			$dbdfile.GrowthType = "Percent"
			$dbdfile.Growth = 25.0
			$dbdfile.MaxSize = [double](100.0 * 1024.0)

			#Instantiate the log file object and set its properties
			$masterDBLogPath = $namedInstance.Information.MasterDBLogPath
			$logfile = $dbName + "_Log"
			$dblfile = new-object Microsoft.SqlServer.Management.Smo.LogFile ($database, $logfile)
			$dblfile.FileName = $masterDBLogPath + "\" + $logfile + ".ldf"
			$dblfile.Size = [double](10.0 * 1024.0)
			$dblfile.GrowthType = "Percent"
			$dblfile.Growth = 25.0
			$database.LogFiles.Add($dblfile)

			# Create the new database on the server
			$database.Create()
		}

		# List the database on the server that was just added to confirm that it was added
		$output = $namedInstance.Databases | Where-Object {$_.name -eq "$dbName"} | Select-Object name, createdate
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