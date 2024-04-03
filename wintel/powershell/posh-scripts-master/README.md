# Scripts #

Miscellaneous standalone scripts.

## Invoke-ChoiceMenu.ps1 ##

Invokes a Yes/No/Cancel choice menu to allow end users to easily run a script and verify the result.

Code to be executed should be placed in the try block of the first case (0) in the switch statement. If a user chooses "Yes" to the choice the code is executed. Choosing "No" will skip the choice, choosing "Cancel" will exit the script. Any exceptions raised by executed code will be caught by the choice option they were executed from and the user will have the option to continue with any remaining choices.

Invoke-ChoiceMenu works best when using the `Invoke-ChoiceMenu.bat` file to provide a file for the user to click on to launch the script ([credit](http://blog.danskingdom.com/allow-others-to-run-your-powershell-scripts-from-a-batch-file-they-will-love-you-for-it/)).

Under Windows 10 when running from a `.bat` file the font size properties of `cmd.exe` (which are a couple of points larger than `powershell.exe`) seem to be copied to the Powershell session, which results in it being larger than default.

### Example ###

`.\Invoke-ChoiceMenu.ps1 -WindowTitle 'My Title' -Transcript`

## Update-ExcelExternalRefs.ps1 ##

Modifies the path to external files referenced from an Excel Workbook. These would be linked spreadsheets which can be found under the "Data" > "Edit Links" option in the application.

For example, if files are migrated from a local folder to a remote folder (`C:\` to `P:\`) any linked spreadsheets will break if their path is also changed, and a prefix section of the path will need to be updated to the correct location. Excel must be installed on the machine the script is executed on.

### Example ###

`.\Update-ExcelExternalRefs.ps1 -SearchPath 'C:\Users\User1\Documents\' -Find 'C:\Users\User1\Documents\Accounts\' -Replace 'P:\Shared\Accounts\'`

## Get-MailboxDatabaseLogFile.ps1 ##

Gets the log files associated with an Exchange database. By default only the log files committed to the Exchange database are returned. These are log files that can be moved or deleted in a situation where free space on the volume hosting the database is running out. Exchange 2010 and greater is supported only.

Log files with a sequence number are matched using the ESE Utilites binary (`eseutil.exe`) included with Exchange, these are files with a prefix then 8 digits of hexadecimal (`E000000001A.log`). The active log file is not matched.

The correct way to purge log files is to run a backup, this ensures that a valid copy of the database exists and therefore log files older than the backup date are no longer needed to complete a restore. If log files after the last backup date are deleted, and database corruption occurs, then data since the last backup is lost. When log files are still available they can be replayed into a restored database to reduce the data loss.

### Example ###

`.\Get-MailboxDatabaseLogFile.ps1 -LogFolderPath 'D:\ExchangeDB1\' -LogFilePrefix 'E00'`

`Get-MailboxDatabase -Name ExchangeDB1 | . \Get-MailboxDatabaseLogFile.ps1 | Select-Object -Last 20 | Remove-Item`

`Get-MailboxDatabase -Name ExchangeDB1 | . \Get-MailboxDatabaseLogFile.ps1 | Move-Item -Destination "C:\CommitedLogs"`

## Test-DnsServerScavenging.ps1 ##

Runs a test scavenging event and returns DNS resource records that are candidates for removal and considered stale. There are two parts to DNS scavenging, the aging interval settings which are configured per zone, and the scavenging event or task that is typially configured on one DNS server only.

By default the aging settings of the DNS zone will be used (the default is 7 days for both no refresh and refresh). However a duration for the intervals can be chosen by passing a `[TimeSpan]` object to the `-NoRefreshInterval` and `-RefreshInterval` parameters.

Records that fall within either of the two intervals can be returned using the `-Type` parameter with the `NoRefresh` or `Refresh` keywords. The keyword `Stale` can be used to return records that fall outside both interval durations. This is the default behaviour.

For DNS resource record timestamps to be replicated aging must be enabled on the zone, if it is not enabled timestamp attributes will only be updated on the server that the client chose to report in to. This will usually be the primary DNS server for the site or subnet the client is a member of. The `-ComputerName` parameter can be used to choose which server to run the cmdlet against.

### Example ###

`./Test-DnsServerScavenging -ZoneName 'lan.example.com'`

`./Test-DnsServerScavenging -ZoneName 'lan.example.com' -Type Refresh -ComputerName 'lab-hq-dc1'`

`./Test-DnsServerScavenging -ZoneName 'lan.example.com' -NoRefreshInterval (New-TimeSpan -Days 3) -RefreshInterval (New-TimeSpan -Days 7)`

## PasswordNotifyTask.ps1 ##

Sends a customizable message to user accounts that are configured with an email address and a password that can expire. This is best used as a scheduled task and can be configured by editing variables in the script.

### Configuration ###

To run the script on a domain member server the `ActiveDirectory` PowerShell module is required, this can be installed with `Install-WindowsFeature RSAT-AD-PowerShell`.

The following variables are available for configuration in the script file. `$AD_SERVER`, `$NOTIFY_BEFORE`, `$NOTIFY_GROUP`, `$NOTIFY_OU`, `$NOTIFY_NAME`, `$EMAIL_TEST`, `$EMAIL_SERVER`, `$EMAIL_PORT`, `$EMAIL_SSL`, `$EMAIL_CREDENTIAL`, `$EMAIL_FROM`, `$EMAIL_SUBJECT`, `$EMAIL_BODY`.

To log information and errors to the "Application" event log an event source named `PasswordNotifyTask` must be registered. This can be done with the following command on the server running the script.

`New-EventLog -LogName 'Application' -Source 'PasswordNotifyTask'`

### Permissions ###

When running the script under a "Domain User" account the permissions below are required where appropriate.

The account must have read access to the objects in the `Password Settings Container` that define fine grained password policies. This can be done by applying `List contents`, `Read all properties` and `Read` permissions to the `Descendant msDS-PasswordSettings` and `Descendant msDS-PasswordSettingsContainer` object classes on the `Password Settings Container`.

If run on a Domain Controller with UAC enabled, objects required by the script may be filtered by UAC if an account without Domain Admin permissions is used. To avoid this issue the variable `$AD_SERVER` can be configured in the script to run commands on a specified Domain Controller. A remote connection will not be subject to UAC filtering.

## Invoke-PingLog.ps1 ##

Tests and monitors network connectivity using ICMP echo packets. Behavior is similar to the Windows ping command and essentially wraps the `Win32_PingStatus` WMI class.

Failure and success responses can be filtered by a chosen threshold to aid monitoring of connections, and logging to a CSV format file is possible. Logs are not effected by filtering. 

If a domain name resolves to both an IPv4 and an IPv6 address then the IPv6 address will be preferred, this is a behaviour of the `Win32_PingStatus` class with no option to force either protocol.

### Example ###

`.\Invoke-Pinglog.ps1 8.8.8.8 -ResolveAddress -Count 4`

`.\Invoke-Pinglog.ps1 google.com -WriteType Failed -EnableLog -LogPath "C:\Users\Administrator\Documents"`

## OutlookSignatureScript.ps1 ##

A log on script which generates Outlook signatures and can embed user details from Active Directory such as an email address or phone number. The signatures are generated from templates in Word format (`.doc`/`.docx`) and copied to the user profile location that Outlook checks for signature files. 

How often the generation and copy takes place is defined by two conditions:
1. If the template file is modified the signature will be updated the next time the script runs.
2. The `$UpdateThreashold` value must have expired for an update to take place. The purpose of the `$UpdateThreashold` value is to prevent updates happening too often (eg. on every log in) as there can be an impact on log on speed due to Word and Outlook processes being started.

Checking the `whenChanged` User object attribute to hint at when to update the template (eg. if the mobile number was updated) appears a good idea, but in practice there are a couple of issues: `whenChanged` is not a replicated attribute so it is different on each domain controller; and there are many actions that can update this attribute (any log on event for example), not just editing of the attributes of interest here.

### Configuration ###

The script would typically be configured as a log on script via Group Policy, however to debug it can be run in a Powershell console, this is the easiest way to troubleshoot issues. A file log can be enabled which will log to the `AppData\Local` folder, and Event Log entries will be generated if the event source `OutlookSignature` is registered on the client. Registering an event source requires Administrator permissions.

Multiple templates can be placed in the `$TemplatePath` folder, they will all be processed by the script, however sub-folders will not be searched.

To embed details from an AD User object into a template file the attribute name must be wrapped in `{}` to create a "tag". For example `{mail}` will embed the users email address and `{telephoneNumber}` the phone number. The tag name must match the attribute name (`LDAP-Display-Name` to be exact) as it appears in AD, these can be found under the properties of a User object in the "Attribute Editor" tab, or a useful selection listed [here](https://support.exclaimer.com/hc/en-gb/articles/360028968151-Which-Active-Directory-attributes-can-be-used-in-Exclaimer-Cloud-Signatures-for-Office-365-).

It is also possible to assign a template as the default "new" or "reply" signature, and to delete a signature by using an "action". The format is `Signature_Name-Action.docx`, eg. `Full-New.docx` will create a signature named "Full" and make it default for new mail messages, adding "Delete" instead (`Full-Delete.docx`) will delete the "Full" signature completley. The four actions are `New`, `Reply` `Both` and `Delete`.

Using any action except `Delete` will cause an `outlook.exe` process to be started as this is required to change the default signature settings. The actions will only run if there is a default Outlook profile already present, otherwise the script would be blocked by the "Add New Account" wizard dialog.

The following variables are available for configuration: `$TemplatePath`, `$UpdateThreashold`, `$SettingsKeyName`, `$EnableLogFile`, `$EnableDeleteEmptyTagLine`, `$EnableMailToLink`, `$LogPath`. These are described in more detail in the script file.

There is also `$EnableMachineSignatureFolderName`, this will search an alternative Local Machine registry location for the key that holds the name of the "Signatures" folder. There are certain configurations where this location may hold the correct folder name (possibly when the Windows and Office languges differ and for Office 2016+). When enabled it will replace the value from the Current User location that is read by default. If the Local Machine key does not exist the default value is used.

## LogCleanTask.ps1 ##

Removes files from a list of folders based on the last modified time of the files, usually to clean stale log files generated by an application. This is best used as a scheduled task and can be configured by editing variables in the script.

### Configuration ###

The `$Paths` variable contains the retention period in days and the path to a folder containing files to be deleted. The last modified time of the file must be older than the retention period at the time the script is run for it to be deleted. A retention period can be set per folder. Only files are deleted, and sub-folders will not be processed. 

The following additional variables are available for configuration in the script file. `$ForceRemove`, `$WhatIf`, `$EnableLogFile`, `$LogPath`.

To log information and errors to the "Application" event log an event source named `LogClean` must be registered. This can be done with the following command on the server running the script.

`New-EventLog -LogName 'Application' -Source 'LogClean'`