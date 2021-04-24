#############################################################################
# Get-ExchangeUpdateRollups.ps1
# Gets the Exchange Server 2007 and Exchange 2010 Update Rollups installed
# Writes output to CSV file in same folder where script is called from
#
# Created by 
# Bhargav Shukla
# http://www.bhargavs.com
# 
# DISCLAIMER
# ==========
# THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
# RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#############################################################################

# Store header in variable
$headerLine = 
@"
 
Server Name,Rollup Update Description,Installed Date,ExSetup File Version
"@
 
# Write header to file
$headerLine | Out-File .\results.csv -Encoding ASCII -Append
 
function getRU([string]$Server)
{
# Set server to connect to
	$Server = $Server.ToUpper()
 
# Check if server is running Exchange 2007 or Exchange 2010

	$ExchVer = (Get-ExchangeServer $Server | ForEach {$_.AdminDisplayVersion})
	
# Set appropriate base path to read Registry
# Exit function if server is not running Exchange 2007 or Exchange 2010
	if ($ExchVer -match "Version 14")
	{
		$REG_KEY = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\UserData\\S-1-5-18\\Products\\AE1D439464EB1B8488741FFA028E291C\\Patches"
		$Reg_ExSetup = "SOFTWARE\\Microsoft\\ExchangeServer\\v14\\Setup"
	}
	elseif	($ExchVer -match "Version 8")
	{
		$REG_KEY = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\UserData\\S-1-5-18\\Products\\461C2B4266EDEF444B864AD6D9E5B613\\Patches"
		$Reg_ExSetup = "SOFTWARE\\Microsoft\\Exchange\\Setup"
	}
	else
	{
		return
	}
	
# Read Rollup Update information from servers
# Set Registry constants
	$VALUE1 = "DisplayName"
	$VALUE2 = "Installed"
	$VALUE3 = "MsiInstallPath"

# Open remote registry
	$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Server)

# Set regKey for MsiInstallPath
	$regKey= $reg.OpenSubKey($REG_ExSetup)

# Get Install Path from Registry and replace : with $
	$installPath = ($regkey.getvalue($VALUE3) | foreach {$_ -replace (":","`$")})
	
# Set ExSetup.exe path
	$binFile = "Bin\ExSetup.exe"
	
# Get ExSetup.exe file version
	$exSetupVer = ((Get-Command "\\$Server\$installPath$binFile").FileVersionInfo | ForEach {$_.FileVersion})

# Create an array of patch subkeys
	$regKey= $reg.OpenSubKey($REG_KEY).GetSubKeyNames() | ForEach {"$Reg_Key\\$_"}

# Walk through patch subkeys and store Rollup Update Description and Installed Date in array variables
	$dispName = [array] ($regkey | %{$reg.OpenSubKey($_).getvalue($VALUE1)})
	$instDate = [array] ($regkey | %{$reg.OpenSubKey($_).getvalue($VALUE2)})

# Loop Through array variables and output to a file
	$countmembers = 0
	
	if ($regkey -ne $null)
	{
		while ($countmembers -lt $dispName.Count)
		{
		$server+","+$dispName[$countmembers]+","+$instDate[$countmembers].substring(0,4)+"/"+$instDate[$countmembers].substring(4,2)+"/"+$instDate[$countmembers].substring(6,2)+","+$exsetupver | Out-File .\results.csv -Encoding ASCII -Append
		$countmembers++
		}
	}
	else
	{
		$server+",No Rollup Updates are installed,,"+$exsetupver | Out-File .\results.csv -Encoding ASCII -Append
	}
}

# Get Exchange 2007/2010 servers and write Rollup Updates to results file
$Servers = (Get-ExchangeServer | Where-Object {($_.AdminDisplayVersion -match "Version 8" -OR $_.AdminDisplayVersion -match "Version 14") -AND $_.ServerRole -ne "ProvisionedServer" -and $_.ServerRole -ne "Edge"} | ForEach {$_.Name})
$Servers | ForEach {getRU $_}
Write-Output "Results are stored in $(Get-Location)\results.csv"