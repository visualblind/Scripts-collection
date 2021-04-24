#Requires -Version 4


function Log
{
<# 
 .Synopsis
  Function to log input string to file and display it to screen

 .Description
  Function to log input string to file and display it to screen. Log entries in the log file are time stamped. Function allows for displaying text to screen in different colors.

 .Parameter String
  The string to be displayed to the screen and saved to the log file

 .Parameter Color
  The color in which to display the input string on the screen
  Default is White
  Valid options are
    Black
    Blue
    Cyan
    DarkBlue
    DarkCyan
    DarkGray
    DarkGreen
    DarkMagenta
    DarkRed
    DarkYellow
    Gray
    Green
    Magenta
    Red
    White
    Yellow

 .Parameter LogFile
  Path to the file where the input string should be saved.
  Example: c:\log.txt
  If absent, the input string will be displayed to the screen only and not saved to log file

 .Example
  Log -String "Hello World" -Color Yellow -LogFile c:\log.txt
  This example displays the "Hello World" string to the console in yellow, and adds it as a new line to the file c:\log.txt
  If c:\log.txt does not exist it will be created.
  Log entries in the log file are time stamped. Sample output:
    2014.08.06 06:52:17 AM: Hello World

 .Example
  Log "$((Get-Location).Path)" Cyan
  This example displays current path in Cyan, and does not log the displayed text to log file.

 .Example 
  "$((Get-Process | select -First 1).name) process ID is $((Get-Process | select -First 1).id)" | log -color DarkYellow
  Sample output of this example:
    "MDM process ID is 4492" in dark yellow

 .Example
  log "Found",(Get-ChildItem -Path .\ -File).Count,"files in folder",(Get-Item .\).FullName Green,Yellow,Green,Cyan .\mylog.txt
  Sample output will look like:
    Found 520 files in folder D:\Sandbox - and will have the listed foreground colors

 .Link
  https://superwidgets.wordpress.com/category/powershell/

 .Notes
  Function by Sam Boutros
  v1.0 - 08/06/2014
  v1.1 - 12/01/2014 - added multi-color display in the same line

#>
	
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
	Param (
		[Parameter(Mandatory = $true,
				   ValueFromPipeLine = $true,
				   ValueFromPipeLineByPropertyName = $true,
				   Position = 0)]
		[String[]]$String,
		[Parameter(Mandatory = $false,
				   Position = 1)]
		[ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "White", "Yellow")]
		[String[]]$Color = "Green",
		[Parameter(Mandatory = $false,
				   Position = 2)]
		[String]$LogFile,
		[Parameter(Mandatory = $false,
				   Position = 3)]
		[Switch]$NoNewLine
	)
	
	if ($String.Count -gt 1)
	{
		$i = 0
		foreach ($item in $String)
		{
			if ($Color[$i]) { $col = $Color[$i] }
			else { $col = "White" }
			Write-Host "$item " -ForegroundColor $col -NoNewline
			$i++
		}
		if (-not ($NoNewLine)) { Write-Host " " }
	}
	else
	{
		if ($NoNewLine) { Write-Host $String -ForegroundColor $Color[0] -NoNewline }
		else { Write-Host $String -ForegroundColor $Color[0] }
	}
	
	if ($LogFile.Length -gt 2)
	{
		"$(Get-Date -format "yyyy.MM.dd hh:mm:ss tt"): $($String -join " ")" | Out-File -Filepath $Logfile -Append
	}
	else
	{
		Write-Verbose "Log: Missing -LogFile parameter. Will not save input string to log file.."
	}
}


function Get-FileShares
{
<# 
 .SYNOPSIS
  Script to provide file share information

 .DESCRIPTION
  Function to provide file share information from one or more Windows file servers.
  This is intended to run from a domain joined Windows 8.1 workstation against one or more file servers in the same domain.
  However, the source file servers can be Windows 2003 and up as long as Powershell 2.0 or up is installed, and Powershell remoting is configured.
  For more infomration on Powershell for Windows 2003 see https://superwidgets.wordpress.com/2014/12/31/powershell-remoting-to-windows-2003-from-server-2012-r2-or-windows-8-1/
  The function returns information including server name, share name, description, count of currently connected users, and amount of free space on the drive where the share is located.
  The function also obtains and saves the registry entries for file shares on the source server(s), and provides link(s) to file(s) location.
  Function output is displayed to screen and saved to log file.

 .PARAMETER ComputerName
  One or more computer names separated by commas. These are the file servers to report on.

 .PARAMETER LogFile
  Path to the file where the input string should be saved.
  Example: c:\log.txt
  If absent, the script will use a name on the target server

 .PARAMETER ShowConnectedUsers
  This switch defaults to false. If set to true, the script lists all users currently connected to server shares.

 .PARAMETER PassThru
  This switch defaults to false. If set to true, the script returns a PS object containing the properties listed under OUTPUTS below.

 .EXAMPLE
  Get-FileShares -ComputerName MyFileServer1
  The script will return list of drives of MyFileServer1, list of file shares, their path and description, count of currently connected users to each share, share permissions on each share, then comiles all that information in one table.
  The information is displayed on the screen and saved to log file in logs subfolder.

 .EXAMPLE
  $Shares = Get-FileShares -ComputerName MyFileServer1 -Passthru
  The script will return list of drives of MyFileServer1, list of file shares, their path and description, count of currently connected users to each share, share permissions on each share, then comiles all that information in one table.
  The information is displayed on the screen and saved to log file in logs subfolder.
  It also returns a PS object that's now saves in the $Shares vairable. 
  $Shares | Out-Gridview # shows information in tablular format in PS ISE
  $Shares | Export-Csv .\MyFileServer1.csv -NoType # Exports information to CSV for review/edit in Excel (may not display properly - complex object).
  $Shares | Export-Clixml .\MyFileServer1.xml # Good for storing complex objects for later comparisons using Import-Clixml and Compare-Object

 .EXAMPLE
  Get-FileShares -ComputerName MyFileServer1,MyFileServer2
  The script will return list of drives of listed servers, list of file shares, their path and description, count of currently connected users to each share, share permissions on each share, then comiles all that information in one table.
  The information is displayed on the screen and saved to log file in logs subfolder.

 .EXAMPLE
  Get-FileShares -ComputerName MyFileServer1 -ShowConnectedUsers
  The script will return list of drives of MyFileServer1, list of file shares, their path and description, count of currently connected users to each share, share permissions on each share, then comiles all that information in one table.
  It also listed each connected user to each share, on each of the listed computers. For each connected user the script lists ShareName, UserName, (client) ComputerName (or IP address), ActiveTime (seconds).
  The information is displayed on the screen and saved to log file in logs subfolder.

 .OUTPUTS 
  If the PassThru switch is set to true, the script reurns a PS object with the following properties:
    ServerName  
    ShareName       
    Path            
    Description     
    ConnectedUsers  
    'DriveTotal(GB)'
    'DriveUsed(GB)' 
    'DriveFree(GB)' 
    'DriveFree(%)'  
    ShareUser       
    SharePerms      
    ShareAccess     

 .LINK
  https://superwidgets.wordpress.com/category/powershell/

 .NOTES
  Function by Sam Boutros
  v1.0 - 02/09/2015

#>
	
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[String[]]$ComputerName,
		[Parameter(Mandatory = $false, Position = 1)]
		[String]$LogFile = ".\logs\Get-FileShare_$ComputerName-$(Get-Date -format yyyy-MM-dd_hh-mm-sstt).txt",
		[Parameter(Mandatory = $false, Position = 2)]
		[Switch]$ShowConnectedUsers = $false,
		[Parameter(Mandatory = $false, Position = 3)]
		[Switch]$PassThru = $false
	)
	
	if (-not (Test-Path '.\logs')) { New-Item -Path '.\logs' -ItemType Directory -Force | Out-Null }
	
	foreach ($Server in $ComputerName)
	{
		
		# Attempt to open Powershell session to Source Server
		Get-PSSession | Remove-PSSession # Remove any old sessions
		try { $Session = New-PSSession -ComputerName $Server -EA 1 }
		catch
		{
			log 'Failed to establish remote Powershell session to Source Server', $Server Magenta, Yellow $LogFile
			break
		}
		log 'Connected to Source Server', $Server Green, Cyan $LogFile
		
		
		log 'Getting share information from source server registry' -LogFile $LogFile
		$LanMan = Invoke-Command -Session $Session -ScriptBlock {
			if ($env:windir.IndexOf(' ') -gt 0)
			{
				try { New-Item -Path 'c:\Sandbox' -ItemType Directory -Force -Confirm:$false -EA 1 }
				catch
				{
					Return "Failed to create folder 'c:\Sandbox' on computer '$env:COMPUTERNAME'"
				}
				$Temp = 'c:\Sandbox\Shares.reg'
			}
			else
			{
				$Temp = "$env:windir\Shares.reg"
			}
			REG export HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Shares $Temp /y | Out-Null
			$Temp
		}
		$SharesReg = "\\$Server\$($LanMan.Replace(':', '$'))"
		if (Test-Path -Path $SharesReg)
		{
			log 'Got file share information on server', $Server Green, Cyan $LogFile
			log 'Information is saved in file', $SharesReg  Green, Cyan $LogFile
			# & notepad $SharesReg
		}
		else { log $LanMan Magenta $LogFile; break }
		
		
		log 'Identifing file shares: drive letter, share name, size, connected users' -LogFile $LogFile
		$SourceDrives = Invoke-Command -Session $Session -ScriptBlock {
			Get-PSDrive | where { $_.Free }
		}
		$SourceDrives = $SourceDrives | select @{ N = 'Drive'; E = { $_.Root } },
											   Used,
											   @{ N = 'Used(GB)'; E = { [Math]::Round($_.Used/1GB, 2) } },
											   Free,
											   @{ N = 'Free(GB)'; E = { [Math]::Round($_.Free/1GB, 2) } },
											   @{ N = 'Free(%)'; E = { [Math]::Round((100 * $_.Free/($_.Used + $_.Free)), 2) } },
											   @{ N = 'Total'; E = { $_.Used + $_.Free } },
											   @{ N = 'Total(GB)'; E = { [Math]::Round(($_.Used + $_.Free)/1GB, 2) } }
		log 'Drive information on source server', $Server Green, Cyan $LogFile
		log ($SourceDrives | select 'Drive', 'Used(GB)', 'Free(GB)', 'Total(GB)', 'Free(%)' | FT -Auto | Out-String).Trim() -LogFile $LogFile
		
		$FileShares = Invoke-Command -Session $Session -ScriptBlock {
			Get-WmiObject -Class Win32_Share
		} | select Name, Path, Description
		$FileShares = $FileShares |
		where { -not $_.Description.StartsWith('Default') -and $_.Path } |
		sort Path # Not need default shares
		log 'File Shares information on source server', $Server Green, Cyan $LogFile
		log ($FileShares | FT -Auto | Out-String).Trim() -LogFile $LogFile
		
		log 'Getting summary of currently connected users to file shares on server', $Server Green, Cyan $LogFile
		$ConnectedUsers = Invoke-Command -Session $Session -ScriptBlock {
			Get-WmiObject -Class Win32_ServerConnection -Namespace 'root\CIMV2'
		} | select ShareName, UserName, ComputerName, ActiveTime # in seconds
		if ($ShowConnectedUsers) { log ($ConnectedUsers | sort ShareName | FT -AutoSize | Out-String) -LogFile $LogFile }
		$Groups = $ConnectedUsers | group -Property ShareName | Sort Count -Descending | select Name, Count
		log ($Groups | FT -AutoSize | Out-String).Trim() -LogFile $LogFile
		
		# Get share permissions
		log 'Getting share permissions for shares on server', $Server Green, Cyan $LogFile
		$SharePerms = @()
		foreach ($SharedFolderSec in (Get-WmiObject -Class Win32_LogicalShareSecuritySetting -ComputerName $ComputerName))
		{
			foreach ($DACL in ($SharedFolderSec.GetSecurityDescriptor()).Descriptor.DACL)
			{
				$Props = [ordered]@{
					ShareName = $SharedFolderSec.Name
					SecurityPrincipal = $(if ($DACLDomain) { "$($DACL.Trustee.Domain)\$($DACL.Trustee.Name)" }
					else { $DACL.Trustee.Name })
					FileSystemRights = ($DACL.AccessMask -as [Security.AccessControl.FileSystemRights])
					AccessType = [Security.AccessControl.AceType]$DACL.AceType
				}
				$SharePerms += New-Object -TypeName PSObject -Property $Props
			}
		}
		log ($SharePerms | sort ShareName | FT -AutoSize | Out-String).Trim() -LogFile $LogFile
		
		
		# Assemble the gathered information in a PS object
		$ShareInfo = @()
		$FileShares | % {
			$ShareName = $_.Name
			$DriveLetter = $_.Path[0]
			$Props = [ordered]@{
				ServerName = $Server
				ShareName = $_.Name
				Path = $_.Path
				Description = $_.Description
				ConnectedUsers = $(($Groups | where { $_.Name -eq $ShareName }).Count)
				'DriveTotal(GB)' = $(($SourceDrives | where { $_.Drive[0] -eq $DriveLetter }).'Total(GB)')
				'DriveUsed(GB)' = $(($SourceDrives | where { $_.Drive[0] -eq $DriveLetter }).'Used(GB)')
				'DriveFree(GB)' = $(($SourceDrives | where { $_.Drive[0] -eq $DriveLetter }).'Free(GB)')
				'DriveFree(%)' = $(($SourceDrives | where { $_.Drive[0] -eq $DriveLetter }).'Free(%)')
				ShareUser = $(($SharePerms | where { $_.ShareName -eq $ShareName }).SecurityPrincipal)
				SharePerms = $(($SharePerms | where { $_.ShareName -eq $ShareName }).FileSystemRights)
				ShareAccess = $(($SharePerms | where { $_.ShareName -eq $ShareName }).AccessType)
			}
			$ShareInfo += New-Object -TypeName PSObject -Property $Props
		}
		log ($ShareInfo | Sort ConnectedUsers -Descending | FT -AutoSize | Out-String) -LogFile $LogFile
		
		$Session | Remove-PSSession
		
	} # foreach server
	
	if ($PassThru) { $ShareInfo }
	
} 