<#
	.SYNOPSIS
		New-IsqlSQLServerAlias
	.DESCRIPTION
		Adds a SQL Server alias to a client
		These aliases can be used with connection strings or as a substitute for the actual server
	.PARAMETER Name
		Specifies the name of the alias
	.PARAMETER SQLServerName
		Specifies the name of the SQL Server
	.PARAMETER Port
		Specifies the port
	.EXAMPLE
		New-IsqlSQLServerAlias -Name "SHPDB" -SQLServerName "SRV-CTG-SQL01" -Port 1433
	.NOTES
		Requires elevated Admin privileges
		This assumes that TCP Protocol has been enabled on the SQL Server instance
		You can check changes by running CLICONFG.EXE in the following locations:
			C:\WINDOWS\SYSTEM32
			C:\WINDOWS\SYSWOW64 
		To work properly for both 32-bit and 64-bit applications the settings are applied 2x for each platform type
		When using an alias for Azure specify the full DNS as the server name, 
			then use this login pattern - {username}@{part1 of the DNS}
		For example, if you were aliasing myserver.database.windows.net and the login was xyz then you would login as:
			wyz@myserver
	.LINK
#>
 
param(
    [string]$Name = "$(Read-Host 'Alias Name' [e.g. myserver\inst1])",
    [string]$SQLServerName = "$(Read-Host 'SQL Server Name' [e.g. 10.0.0.241])",
    [string]$Port = "$(Read-Host 'Port' [e.g. 1433])"
)	

begin {
	$x64ConnectTo = "HKLM:\Software\Microsoft\MSSQLServer\Client\ConnectTo"
	$x86ConnectTo = "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo"
	
	$x64TCP = "HKLM:\Software\Microsoft\MSSQLServer\Client\SuperSocketNetLib"
	$x86TCP = "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\SuperSocketNetLib"

	$TCPAlias = "DBMSSOCN,$SQLServerName,$Port"

	# Check if hive locations are present and create them if not
	# If you have never run CLICONFG.EXE they may not be present
	if (!(Test-Path $x86TCP)) {
		New-Item -Path "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client" -Name "SuperSocketNetLib"
		New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\SuperSocketNetLib" -Name "Encrypt" -PropertyType DWord
		New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\SuperSocketNetLib" -Name "ProtocolOrder" -PropertyType MultiString
	}
	
	if (!(Test-Path $x86ConnectTo)) {
		New-Item -Path "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client" -Name "ConnectTo"
	}
	
	if (!(Test-Path $x64TCP)) {
		New-Item -Path "HKLM:\Software\Microsoft\MSSQLServer\Client" -Name "SuperSocketNetLib"
		New-ItemProperty -Path "HKLM:\Software\Microsoft\MSSQLServer\Client\SuperSocketNetLib" -Name "Encrypt" -PropertyType DWord
		New-ItemProperty -Path "HKLM:\Software\Microsoft\MSSQLServer\Client\SuperSocketNetLib" -Name "ProtocolOrder" -PropertyType MultiString
	}
	
	if (!(Test-Path $x64ConnectTo)) {
		New-Item -Path "HKLM:\Software\Microsoft\MSSQLServer\Client" -Name "ConnectTo"
	}
}
process {
	try {
		#If TCP not set, then add it to the protocolorder value
		$val = Get-ItemProperty -Path $x86TCP -Name "ProtocolOrder" -ErrorAction SilentlyContinue
		if($val.ProtocolOrder -notcontains "tcp") {
			$newval = $val.ProtocolOrder + "tcp"
			Set-ItemProperty -Path $x86TCP -Name "ProtocolOrder" -value $newval -type MultiString -Force
		}
		
		$val = Get-ItemProperty -Path $x64TCP -Name "ProtocolOrder" -ErrorAction SilentlyContinue
		if($val.ProtocolOrder -notcontains "tcp") {
			$newval = $val.ProtocolOrder + "tcp"
			Set-ItemProperty -Path $x64TCP -Name "ProtocolOrder" -value $newval -type MultiString
		}
		
		#If alias exist, then remove them
		if(Get-ItemProperty -Path $x86ConnectTo -Name $Name -ErrorAction SilentlyContinue) {
			Remove-Item -Path $x86ConnectTo
		}
		
		if(Get-ItemProperty -Path $x64ConnectTo -Name $Name -ErrorAction SilentlyContinue) {
			Remove-Item -Path $x64ConnectTo
		}
		
		#Create alias
		New-Item $x86ConnectTo -ErrorAction SilentlyContinue
		New-Item $x64ConnectTo -ErrorAction SilentlyContinue
		
		#Creating TCP/IP Aliases
		New-ItemProperty -Path $x86ConnectTo -Name $Name -PropertyType String -Value $TCPAlias
		New-ItemProperty -Path $x64ConnectTo -Name $Name -PropertyType String -Value $TCPAlias
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