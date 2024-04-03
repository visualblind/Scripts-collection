# OutlookSignatureScript.ps1 v1.3 (c) Chris Redit

## README
# The commented variables below are used to configure the script.
# Please see https://github.com/chrisred/posh-scripts#outlooksignaturescriptps1 for the full README.

## Settings
# Path where signature templates are located, should be a read-only location for all users, sub-folders are not scanned.
$TemplatePath = '\\example.com\NETLOGON\Signatures'
# Time in minutes to wait before attempting to update the signature files, default 24hrs.
$UpdateThreashold = (24*60)
# Registry key name for storing settings under the users profile, default 'OutlookSignatureScript'.
$SettingsKeyName = 'OutlookSignatureScript'
# Enable alternate method for discovering the 'Signature' folder name, this will search the Local Machine registry location, default $false.
$EnableMachineSignatureFolderName = $false
# Enable deletion of lines in a signature template which contain an empty tag, occurs when a property in Active Directory is not populated for a user, default $false.
$EnableDeleteEmptyTagLine = $false
# Enable "mailto:" formatting for email addresses, default $true.
$EnableMailToLink = $true
# Enable the log file (for event log logging a source named 'OutlookSignature' must be registered), default $false
$EnableLogFile = $false
# Path to write the log file to, default is 'AppData\Local\OutlookSignatureScript'.
$LogPath = $env:LOCALAPPDATA+'\OutlookSignatureScript'

$LogTime = Get-Date -Format 'yyMMddHHmm'
Function Write-Log ([String]$Message, [Nullable[Int]]$EventId = $null, [String]$EventType = 'Information')
{
    if ($EnableLogFile)
    {
        if (-not (Test-Path -Path $LogPath)) {New-Item -ItemType Directory -Path $LogPath}
        Out-File -InputObject $Message -FilePath (Join-Path -Path $LogPath -ChildPath "sigscript-$($LogTime).log") -Append    
    }
    
    try
    {
        # Using "[Diagnostics.EventLog]::SourceExists" requires admin permissions, so it is simpler to just catch
        # the excpetion as this will be handled the same way when executed with or without admin permissions.
        if ($EventId -ne $null)
        {
            Write-EventLog -LogName Application -Source 'OutlookSignature' -Message $Message -EventId $EventId -EntryType $EventType
        }
    }
    catch
    {
        Write-Warning "Event log: $($_.ToString())"
    }
}

try
{
    Add-Type -AssemblyName 'Microsoft.Office.Interop.Word'
}
catch
{
    $ErrorText = "The assembly 'Microsoft.Office.Interop.Word' could not be loaded, Microsoft Word must be installed.`r`n"
    $ErrorText += $_.ToString()+"`r`n"
    $ErrorText += $_.InvocationInfo.PositionMessage
    Write-Log $ErrorText -EventId 1943 -EventType 'Error'
    throw
}

# create registry key for script settings
$SettingsKey = "HKCU:\Software\$SettingsKeyName"
if (-not (Test-Path $SettingsKey))
{
    New-Item -Path 'HKCU:\Software\' -Name $SettingsKeyName
}

# get DirectoryEntry object for logged on user
$Searcher = New-Object System.DirectoryServices.DirectorySearcher
$Searcher.Filter = "(&(objectCategory=User)(samAccountName=$env:USERNAME))"
$User = $Searcher.FindOne().GetDirectoryEntry()

# get all the .doc/.docx files in the template folder
$Templates = @(Get-Item -Path (Join-Path -Path $TemplatePath -ChildPath '*') -Include '*.docx','*.doc' | Where-Object {-not $_.PSIsContainer})

if ($Templates.Length -eq 0)
{
    # if no template files are found the script will terminate
    $ErrorText = "No templates files found at $TemplatePath. Templates must be in .doc(x) format and readable by all users."
    Write-Log $ErrorText -EventId 1943 -EventType 'Error'
    throw $ErrorText
}

try
{
    # get the version of Outlook installed, if there are multiple versions this is likely the last one used
    $CurVer = ((Get-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Outlook.Application\CurVer").'(Default)')
    [Int]$OutlookVersion = $CurVer.SubString($CurVer.Length-2)
    
    if ($OutlookVersion -le 14)
    {
        $OutlookProfiles = @(Get-Item -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\*") 
    }
    else
    {
        # Office 2013 and above support side-by-side installes of different versions so require per-version settings
        $OutlookProfiles = @(Get-Item -Path "HKCU:\Software\Microsoft\Office\$OutlookVersion.0\Outlook\Profiles\*")
    }
    
    # defines whether there is a prompt for choosing Outlook profile at launch, 0 = no prompt, 1 = prompt
    $PickLogonProfile = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Exchange\Client\Options' -EA SilentlyContinue).PickLogonProfile
    if ($null -eq $PickLogonProfile)
    {
        # if Outlook profile options have never been changed the reg key will not exisit and the setting is effectivly 0
        $PickLogonProfile = 0
    }
    
    # Outlook must have at least 1 profile created, and have it set to open without prompting to allow
    # interaction with the process later to set new or reply signature options.
    $ProfileText = 'No default profile found, new/reply actions will not be saved.'
    $OutlookDefaultProfile = $false
    if ($OutlookProfiles.Length -gt 0 -and $PickLogonProfile -eq 0)
    {
        $ProfileText = 'Default profile found.'
        $OutlookDefaultProfile = $true
    }
    
    # get the localised name for the "Signatures" folder from user profile registry location
    $SignatureFolderName = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$OutlookVersion.0\Common\General").Signatures
    
    if ($EnableMachineSignatureFolderName)
    {
        # In some cases the localised name of the "Signatures" folder is set at a local machine registry location,
        # this may be when Windows and Office were installed/configured with different language settings.
        $MachineSignatureFolderName64 = (Get-ItemProperty -Path `
            "HKLM:\SOFTWARE\Microsoft\Office\$OutlookVersion.0\User Settings\Mso_CoreReg\Create\Software\Microsoft\Office\14.0\Common\General"
        ).Signatures
        
        $MachineSignatureFolderName32 = (Get-ItemProperty -Path `
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Office\$OutlookVersion.0\User Settings\Mso_CoreReg\Create\Software\Microsoft\Office\14.0\Common\General"
        ).Signatures
        
        if ($null -ne $MachineSignatureFolderName64)
        {
            $SignatureFolderName = $MachineSignatureFolderName64
        }
        elseif ($null -ne $MachineSignatureFolderName32)
        {
            $SignatureFolderName = $MachineSignatureFolderName32
        }
    }
    
    if ($null -eq $SignatureFolderName)
    {
        throw '"Signature" folder name not found, use $EnableMachineSignatureFolderName to try an alternative method.'
    }
    
    $OutlookSignaturePath = $env:APPDATA+'\Microsoft\'+$SignatureFolderName
    
    $Events = [System.Collections.ArrayList]@()
    $Word = $null
    # main loop to generate files required for an Outlook signature from the template(s)
    foreach ($File in $Templates)
    {
        # Regex will match Template_Name-Action, the template (Word file) name cannot start with
        # a "-". If no valid action is matched the second match group will be an empty string.
        $Regex = [Regex]'(?i)\A([^-]+)(?:-(new|reply|both|delete))?'
        $Tokens = ($Regex.Match($File.BaseName))
        
        # the friendly template name, basically the file name with the "action" and the file extension removed
        $TemplateName = $Tokens.Groups[1].Value
        # the registry settings for this template file
        $TemplateSettingsKey = $SettingsKey+'\'+$TemplateName
        # the template file name minus the "action"
        $TemplateFileName = $TemplateName+$File.Extension
        # the template action if one is specified in the template file name
        if ($Tokens.Groups[2].Value -eq '')
        {
            $TemplateAction = 'None'
        }
        else
        {
            $TemplateAction = $Tokens.Groups[2].Value
        }
        
        $i = $Events.Add(@{
            'Template' = $File.Name;
            'Action' = $TemplateAction;
            'BadTags' = 0;
            'Status' = 'None';
        })
        
        # if the regex can't match a template name update the event log and terminate iteration
        if ($TemplateName -eq '')
        {
            $Events[$i]['Status'] = "Error: Template name is invalid."
            Write-Error "Error: Template name ($TemplateName) is invalid."
            continue
        }
        
        # delete reg keys and local signature files and then terminate iteration
        if ($TemplateAction -eq 'delete')
        {
            Remove-Item -LiteralPath $TemplateSettingsKey -Recurse -Force -EA 'SilentlyContinue'
            Remove-Item -LiteralPath (Join-Path -Path $OutlookSignaturePath -ChildPath ($TemplateName+'_files')) -Recurse -Force -EA 'SilentlyContinue'
            Remove-Item -LiteralPath (Join-Path -Path $OutlookSignaturePath -ChildPath ($TemplateFileName)) -Force -EA 'SilentlyContinue'
            Remove-Item -LiteralPath (Join-Path -Path $OutlookSignaturePath -ChildPath ($TemplateName+'.htm')) -Force -EA 'SilentlyContinue'
            Remove-Item -LiteralPath (Join-Path -Path $OutlookSignaturePath -ChildPath ($TemplateName+'.rtf')) -Force -EA 'SilentlyContinue'
            Remove-Item -LiteralPath (Join-Path -Path $OutlookSignaturePath -ChildPath ($TemplateName+'.txt')) -Force -EA 'SilentlyContinue'

            $Events[$i]['Status'] = 'Deleted.'
            Write-Host "Local signature files deleted for template $TemplateName"
            continue
        }
        
        # create settings key for template if it does not exist yet
        if (-not (Test-Path $TemplateSettingsKey))
        {
            New-Item -Path $SettingsKey -Name $TemplateName | Out-Null
            New-ItemProperty -Path $TemplateSettingsKey -Name TemplateModifiedTime -Value '1970-01-01 00:00:00' | Out-Null
            New-ItemProperty -Path $TemplateSettingsKey -Name LastUpdateTime -Value '1970-01-01 00:00:00' | Out-Null
        }
        
        # get dates and convert from string for values stored in registry
        $TemplateString = (Get-ItemProperty -Path $TemplateSettingsKey).TemplateModifiedTime
        $UpdateString = (Get-ItemProperty -Path $TemplateSettingsKey).LastUpdateTime
        $TemplateRegistryTime = [DateTime]::ParseExact($TemplateString, 'yyyy-MM-dd HH:mm:ss', $null)
        $UpdateRegistryTime = [DateTime]::ParseExact($UpdateString, 'yyyy-MM-dd HH:mm:ss', $null)
        # timestamp in registry is stored without ticks, so set ticks to 0 for the file timestamp
        $TemplateModifiedTime = $File.LastWriteTime.AddTicks(-($File.LastWriteTime.Ticks) % ([TimeSpan]::TicksPerSecond))
        
        # if the template has been modified or update threashold is expired, then generate new sig files
        if ($TemplateModifiedTime -gt $TemplateRegistryTime -or (Get-Date).AddMinutes(-$UpdateThreashold) -gt $UpdateRegistryTime)
        {
            if (-not (Test-Path $OutlookSignaturePath))
            {
                New-Item -Path $OutlookSignaturePath -ItemType Directory
            }
            
            # copy the template to the local profile using $TemplateFileName, terminating error as if this fails we cant continue
            Copy-Item -Path $File.FullName -Destination (Join-Path -Path $OutlookSignaturePath -ChildPath $TemplateFileName) -Force -EA Stop
            
            # create word.exe process if one is not already running
            if ($null -eq $Word)
            {
                $Word = New-Object -TypeName 'Microsoft.Office.Interop.Word.ApplicationClass'
            }

            # open the template file and find the tags via a regex
            #$Word.Visible = $true
            $Word.DisplayAlerts = [Microsoft.Office.Interop.Word.WdAlertLevel]::wdAlertsNone
            $Document = $Word.Documents.Open((Join-Path -Path $OutlookSignaturePath -ChildPath $TemplateFileName))
            $Regex = [regex]'{([a-zA-Z0-9]+)}'
            $Tags = ($Regex.Matches($Document.Content.Text))
            
            # A tag in the template must be a property that exists on a User DirectoryEntry object,
            # find and replace in Word is run using this propery name. If the tag is {emailAddress}
            # this is replaced with $User.emailAddress.
            $BadTagCount = 0
            foreach($Tag in $Tags)
            {
                try
                {
                    # add "mailto:" hyperlink for the email address field
                    if ($Tag.Value -eq '{mail}' -or $Tag.Value -eq '{emailAddress}' -and $EnableMailToLink -eq $true)
                    {
                        $Word.Selection.Find.Execute($Tag.Value) | Out-Null
                        $Word.ActiveDocument.Hyperlinks.Add($Word.Selection.Range, 'mailto:'+$User.mail.ToString(), $null, $null, $User.mail.ToString(), $null) | Out-Null
                    }
                    else
                    {
                        $UserPropertyValue = $User.($Tag.Groups[1].Value).ToString()
                        if ($UserPropertyValue -eq '' -and $EnableDeleteEmptyTagLine -eq $true)
                        {
                            # https://msdn.microsoft.com/en-us/library/office/microsoft.office.interop.word.find.execute.aspx
                            $Word.Selection.Find.Execute(
                                $Tag.Value, # FindText string
                                $false,     # MatchCase bool
                                $true,      # MatchWholeWord bool
                                $false,     # MatchWildcards bool
                                $false,     # MatchSoundsLike bool
                                $false,     # MatchAllWordForms bool
                                $true,      # Forward bool
                                [Microsoft.Office.Interop.Word.WdFindWrap]::wdFindContinue # Wrap enum
                            ) | Out-Null
                            $Word.Selection.Expand([Microsoft.Office.Interop.Word.WdUnits]::wdLine)
                            $Word.Selection.Delete()
                        }
                        else
                        {
                            $Word.Selection.Find.Execute(
                                $Tag.Value, # FindText string
                                $false,     # MatchCase bool
                                $true,      # MatchWholeWord bool
                                $false,     # MatchWildcards bool
                                $false,     # MatchSoundsLike bool
                                $false,     # MatchAllWordForms bool
                                $true,      # Forward bool
                                [Microsoft.Office.Interop.Word.WdFindWrap]::wdFindContinue, # Wrap enum
                                $false,     # Format bool
                                $UserPropertyValue,                                     # ReplaceWith string
                                [Microsoft.Office.Interop.Word.WdReplace]::wdReplaceOne # Replace enum
                            ) | Out-Null
                        }
                    }
                }
                catch
                {
                    $BadTagCount += 1
                    Write-Warning "Invalid tag $($Tag.Value) in template $TemplateName."
                }            
            }
            
            $Events[$i]['BadTags'] = $BadTagCount
            
            try
            {
                # save the signature template files in html/rtf/txt formats
                [String]$SavePath = $OutlookSignaturePath+'\'+$TemplateName+'.htm'
                $Word.ActiveDocument.SaveAs([Ref]$SavePath, 8) #wdFormatHTML
                
                [String]$SavePath = $OutlookSignaturePath+'\'+$TemplateName+'.rtf'
                $Word.ActiveDocument.SaveAs([Ref]$SavePath, 6) #wdFormatRTF
                
                [String]$SavePath = $OutlookSignaturePath+'\'+$TemplateName+'.txt'
                $Word.ActiveDocument.SaveAs([Ref]$SavePath, 2) #wdFormatText
            }
            catch [Management.Automation.MethodException]
            {
                # with certain versions of Word/Windows passing the WdSaveFormat constant as a "ref" is required
                # Argument: '2' should be a System.Management.Automation.PSReference. Use [ref].
                if ($_.FullyQualifiedErrorId -eq 'NonRefArgumentToRefParameterMsg')
                {
                    [String]$SavePath = $OutlookSignaturePath+'\'+$TemplateName+'.htm'
                    $Word.ActiveDocument.SaveAs([Ref]$SavePath, [Ref]8)
                    
                    [String]$SavePath = $OutlookSignaturePath+'\'+$TemplateName+'.rtf'
                    $Word.ActiveDocument.SaveAs([Ref]$SavePath, [Ref]6)
                    
                    [String]$SavePath = $OutlookSignaturePath+'\'+$TemplateName+'.txt'
                    $Word.ActiveDocument.SaveAs([Ref]$SavePath, [Ref]2)
                }
                else
                {
                    throw
                }
            }
            finally
            {
                $Word.ActiveDocument.Close()
            }
            
            # if there is a default profile available then the new or reply options can be set
            if ($OutlookDefaultProfile)
            {
                # Set the template as the default new or reply sig, this will launch or access an outlook.exe process to
                # make the change. When the word.exe process is killed the outlook.exe process should die as well unless it
                # was already running.
                if ($TemplateAction -eq 'new' -or $TemplateAction -eq 'both')
                {
                    $Word.EmailOptions.EmailSignature.NewMessageSignature = $TemplateName
                    if ($TemplateAction -ne 'both' -and $Word.EmailOptions.EmailSignature.ReplyMessageSignature -eq $TemplateName)
                    {
                        # make sure new is the only signature setting for this template
                        $Word.EmailOptions.EmailSignature.ReplyMessageSignature = ''
                    }
                }

                if ($TemplateAction -eq 'reply' -or $TemplateAction -eq 'both')
                {
                    $Word.EmailOptions.EmailSignature.ReplyMessageSignature = $TemplateName
                    if ($TemplateAction -ne 'both' -and $Word.EmailOptions.EmailSignature.NewMessageSignature -eq $TemplateName)
                    {
                        $Word.EmailOptions.EmailSignature.NewMessageSignature = ''
                    }
                }
            }
            else
            {
                Write-Warning $ProfileText
            }
    
            # update registry with modified times
            Set-ItemProperty -Path $TemplateSettingsKey -Name TemplateModifiedTime -Value (Get-Date $TemplateModifiedTime -Format ('yyyy-MM-dd HH:mm:ss')) | Out-Null
            Set-ItemProperty -Path $TemplateSettingsKey -Name LastUpdateTime -Value (Get-Date -Format ('yyyy-MM-dd HH:mm:ss')) | Out-Null
            $Events[$i]['Status'] = 'Updated'
        }
        else
        {
            $Events[$i]['Status'] = 'Skipped'
        }
    }
}
catch
{
    $ErrorText = $_.ToString()+"`r`n"
    $ErrorText += $_.InvocationInfo.PositionMessage
    $Events[$i]['Status'] = "Error: $($_.ToString())"
    Write-Log $ErrorText -EventId 1943 -EventType 'Error'
    throw
}
finally
{
    $EventText = $Events | ForEach-Object {$_.Template+', '+$_.Action+', '+$_.BadTags+', '+$_.Status} | Out-String
    $LogText = `
@"

$($Templates.Length) template(s) found at: $TemplatePath
Outlook profile status: $ProfileText

Template, Action, Invalid Tags, Status 
$EventText

"@
    Write-Host $LogText
    Write-Log $LogText -EventId 1944
    
    if ($null -eq $Word)
    {
        # quit Word process if it was created and release from memory
        $Word.Quit() | Out-Null
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Word) | Out-Null
        Remove-Variable -Name Word
    }
}