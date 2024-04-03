# Invoke-ChoiceMenu.ps1 v1.0 (c) Chris Redit

<#
.SYNOPSIS
    Invoke a Yes/No/Cancel choice menu.
.DESCRIPTION
    The Invoke-ChoiceMenu cmdlet invokes a Yes/No/Cancel choice menu to allow end users to easily run a script and verify the result.

    Code to be executed should be placed in the try block of the first case (0) in the switch statement. If a user chooses "Yes" to the choice the code is executed. Choosing "No" will skip the choice, choosing "Cancel" will exit the script. Any exceptions raised by executed code will be caught by the choice option they were executed from and the user will have the option to continue with any remaining choices.

    Invoke-ChoiceMenu works best when using the Invoke-ChoiceMenu.bat file to provide a file for the user to click on to launch the script.
.PARAMETER BufferHeight
    Specifies the hight of the console buffer
.PARAMETER BufferWidth
    Specifies the width of the console buffer
.PARAMETER WindowHeight
    Specifies the hight of the console window
.PARAMETER WindowWidth
    Specifies the width of the console window
.PARAMETER WindowTitle
    Specifies the title of the console window
.PARAMETER Transcript
    Starts a transcript log using the Start-Transcript cmdlet and saves the log to the directory the script is located in
.PARAMETER TranscriptPath
    Specifies a path to save the transcript log to, defaults to the directory the script is located in
.OUTPUTS
    N/A
.EXAMPLE
    .\Invoke-ChoiceMenu.ps1 -WindowTitle 'My Title' -Transcript
#>
[CmdletBinding()]
Param(
    [Int]$BufferHeight = 3000,
    [Int]$BufferWidth = 120,
    [Int]$WindowWidth = 120,
    [Int]$WindowHeight = 50,
    [String]$WindowTitle = 'Windows Powershell',
    [String]$TranscriptPath = '',
    [Switch]$Transcript
)

# if running in the console, wait for input before closing
Function Start-Exit {
    if ($Host.Name -eq "ConsoleHost")
    {
        Write-Host ''
        Write-Host 'Press any key to continue...'
        $Host.UI.RawUI.FlushInputBuffer()
        $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyUp') | Out-Null
        # stop the transcript cleanly if it is running
    }

    if ($Transcript) {Stop-Transcript}
}

# Console settings
[Console]::WindowWidth = $WindowWidth
[Console]::WindowHeight = $WindowHeight
[Console]::BufferHeight = $BufferHeight
[Console]::BufferWidth = $BufferWidth
[Console]::Title = $WindowTitle

$ScriptTime = Get-Date -Format yyMMddHHmm
$ScriptName = $MyInvocation.MyCommand.Name
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

if ($Transcript)
{
    # Start-Transcript does not like capturing the output from "UI.PromptForChoice" in PS versions since 2.0
    # A bug with Write-Host also exists here https://support.microsoft.com/en-us/kb/3014136 for 2012/8.1
    if (-not ($TranscriptPath)) {$TranscriptPath = $ScriptPath}
    Start-Transcript -Path (Join-Path -Path $TranscriptPath -ChildPath "$env:COMPUTERNAME-$($ScriptTime).log") -Append
}

Write-Host '
---- ---- --- -- -- -- - - - - -  -   -    -        -          -               -
  Instructions:
  
    Details for the user here.
  
---- ---- --- -- -- -- - - - - -  -   -    -        -          -               -'

# Defaults for the choice menus
$ChoiceYes = New-Object System.Management.Automation.Host.ChoiceDescription('&Yes', 'Continues with this operation.')
$ChoiceNo = New-Object System.Management.Automation.Host.ChoiceDescription('&No', 'Skips this operation only.')
$ChoiceCancel = New-Object System.Management.Automation.Host.ChoiceDescription('&Cancel', 'Skips this and all subsequent operations and exits the script.')
$ChoiceOptions = [System.Management.Automation.Host.ChoiceDescription[]]($ChoiceYes, $ChoiceNo, $ChoiceCancel)
$ChoiceTitle = ' '

$ChoiceMessage = 'Choice 1?'
$ChoiceResult = $Host.UI.PromptForChoice($ChoiceTitle, $ChoiceMessage, $ChoiceOptions, 0) 

switch ($ChoiceResult)
{
    0 {
        try
        {
            # user chose to execute this option

            # include an external script (here from the same directory as this script) with dot sourcing
            #. (Join-Path -Path $ScriptPath -ChildPath 'Include.ps1')

            Write-Host 'Option 1 was executed.'
        }
        catch [Exception]
        {
            Write-Error $_.Exception.Message
            Write-Warning "This option has terminated with errors, it maybe in an incomplete state."
        }
    }
    1 {
        # user chose to skip this option
        Write-Host ''; Write-Host 'This option has been skipped.'; break
    }
    2 {
        # user chose to exit the script
        Write-Warning 'The script has been stopped and will now exit.'; Start-Exit; exit
    }
}

$ChoiceMessage = 'Choice 2?'
$ChoiceResult = $Host.UI.PromptForChoice($ChoiceTitle, $ChoiceMessage, $ChoiceOptions, 0) 

switch ($ChoiceResult)
{
    0 {
        try
        {
            throw "This option raised an exception"
        }
        catch [Exception]
        {
            Write-Error $_.Exception.Message
            Write-Warning "This option has terminated with errors, it maybe in an incomplete state."
        }
    }
    1 {
        Write-Host ''; Write-Host 'This option has been skipped.'; break
    }
    2 {
        Write-Warning 'The script has been stopped and will now exit.'; Start-Exit; exit
    }
}

$ChoiceMessage = 'Choice 3?'
$ChoiceResult = $Host.UI.PromptForChoice($ChoiceTitle, $ChoiceMessage, $ChoiceOptions, 0) 

switch ($ChoiceResult)
{
    0 {
        try
        {
            # if an option needs more input from the user simply use Read-Host
            $InfoPrompt1 = Read-Host -Prompt 'Please provide your name for this option'
            $InfoPrompt2 = Read-Host -Prompt 'Please provide your age for this option'
            Write-Host "$InfoPrompt1 is $InfoPrompt2 years old."
        }
        catch [Exception]
        {
            Write-Error $_.Exception.Message
            Write-Warning "This option has terminated with errors, it maybe in an incomplete state."
        }
    }
    1 {
        Write-Host ''; Write-Host 'This option has been skipped.'; break
    }
    2 {
        Write-Warning 'The script has been stopped and will now exit.'; Start-Exit; exit
    }
}

Start-Exit