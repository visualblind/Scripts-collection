# Update-ExcelExternalRefs.ps1 v1.0 (c) Chris Redit

<#
.SYNOPSIS
    Modify the path to external files referenced from an Excel Workbook.
.DESCRIPTION
    The Update-ExcelExternalRefs cmdlet modifies the path to external files referenced from an Excel Workbook. These would be linked spreadsheets which can be found under the "Data" > "Edit Links" option in the application.
    
    For example, if files are migrated from a local folder to a remote folder (C:\ to P:\) any linked spreadsheets will break if their path is also changed, and a prefix section of the path will need to be updated to the correct location. Excel must be installed on the machine the script is executed on.
.PARAMETER SearchPath
    Specifies a root folder to search for Excel files under (*.xls *.xlsx extensions only).
.PARAMETER Find
    Matches a section of the path from the current externally referenced files available in the Workbook (matches from the beginning only)
.PARAMETER Replace
    Specifies the string that should replace the section matched with the -Find parameter
.PARAMETER LogPath
    Specifies a folder to save the log file to (created in the same location as the script by default)
.PARAMETER Visible
    Include this parameter to force the Excel processes to open in the foreground
.OUTPUTS
    None on success.
    A terminating error.
.EXAMPLE
    .\Update-ExcelExternalRefs.ps1 -SearchPath 'C:\Users\User1\Documents\' -Find 'C:\Users\User1\Documents\Accounts\' -Replace 'P:\Shared\Accounts\'
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [String]$SearchPath,
    [Parameter(Mandatory=$true)]
    [String]$Find,
    [Parameter(Mandatory=$true)]
    [String]$Replace,
    [String]$LogPath = '',
    [Switch]$Visible
)

Add-Type -AssemblyName Microsoft.Office.Interop.Excel
$ErrorActionPreference = 'Stop'

$ScriptTime = Get-Date -Format yyMMddHHmm
$ScriptName = $MyInvocation.MyCommand.Name
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

Function Write-Log
{
    Param (
        [String]$Value
    )

    if (-not ($LogPath)) {$LogPath = $ScriptPath}
    Add-Content (Join-Path -Path $LogPath -ChildPath "$($ScriptName)-$($ScriptTime).log") -Value $Value
}

Write-Log '--------------------------------------------------------------------------------'
Write-Log "Start Time: $((Get-Date).ToString())"

$XLEXCELLINKS = [Microsoft.Office.Interop.Excel.XlLink]::xlExcelLinks

try
{
    # get all the excel files under the search path, return as an array
    $Files = @(Get-ChildItem -Path $SearchPath -Include '*.xlsx','*.xls' -Recurse -File)
    
    Write-Log "Search Path: $SearchPath"
    Write-Log "Find String: $Find"
    Write-Log "Replace String: $Replace"
    Write-Log ''
    
    $FileCount = $Files.Count
    for ($i = 0; $i -lt $FileCount; $i++)
    {
        $Excel = New-Object -ComObject Excel.Application
        $Excel.Visible = $Visible
        $Excel.AskToUpdateLinks = $false
        $Excel.DisplayAlerts = $false

        # show a progress bar, add 1 as $i is a 0 indexed array for $Files
        $PercentComplete = [Math]::Floor((($i+1) / $FileCount) * 100)
        Write-Progress -Activity 'Processing Excel Files' -Status "$($i+1)/$FileCount $($PercentComplete)% Complete" -PercentComplete $PercentComplete

        $Workbook = $Excel.Workbooks.Open($Files[$i].FullName)
        Write-Host "    Opened: $($Files[$i].FullName)"
        Write-Log "    Opened: $($Files[$i].FullName)"
        
        $Links = $Workbook.LinkSources($XLEXCELLINKS)

        # if there are external links in this speadsheet process them
        if ($Links -gt 0)
        {
            Write-Log "    $($Links.Length) links found!"
            $SkipCount = 0
            foreach ($Link in $Links)
            {
                # check for the "find" string, this matches the beginning of the string only
                if ($Link.StartsWith($Find))
                {
                    Write-Log "        Matched link: $Link"
                    # a link was found, update it with the "replace" string and update the link in excel
                    $NewLink = $Link.Replace($Find,$Replace)
                    $Workbook.ChangeLink($Link,$NewLink,$XLEXCELLINKS)
                    Write-Log "        Changed to  : $NewLink"
                }
                else
                {
                    Write-Log "        Skipped link: $Link"
                    $SkipCount += 1
                }
            }
            
            # if the number of skipped links is less than the total links we changed one, save the file
            if ($SkipCount -lt $Links.Length)
            {
                # close and save
                $WorkBook.Close($true, $Files[$i].FullName)
                Write-Host "    Saved: $($Files[$i].Name)"
                Write-Log "    Saved: $($Files[$i].Name)"
            }
            else
            {
                # close and dont save
                $WorkBook.Close($false)
                Write-Host "    Closed: No matches in $($Files[$i].Name)"
                Write-Log "    Closed: No matches in $($Files[$i].Name)"
            }
        }
        else
        {
            # close and dont save
            $WorkBook.Close($false)
            Write-Host "    Closed: No links in $($Files[$i].Name)"
            Write-Log "    Closed: No links in $($Files[$i].Name)"
        }
        
        Start-Sleep -Milliseconds 200

        # quit the excel process and make sure it closes fully
        $Excel.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null
        Remove-Variable -Name Excel
        Write-Log ''
    }
}
catch
{
    Write-Log "    Stop: $($_.Exception.Message)"
    Write-Log ''
    throw
}
finally
{
    Write-Log "End Time: $((Get-Date).ToString())"
    Write-Log  '--------------------------------------------------------------------------------'
    Write-Log  ''
}
