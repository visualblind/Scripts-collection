# PasswordNotifyTask.ps1 v1.1 (c) Chris Redit

$ErrorActionPreference = 'Stop'

try
{
    Import-Module ActiveDirectory
}
catch
{  
    $ErrorText = "Error loading module: $($_.Exception.Message)"
    if ([Diagnostics.EventLog]::SourceExists("PasswordNotifyTask"))
    {
        Write-EventLog -LogName Application -Source 'PasswordNotifyTask' -Message $ErrorText -EventId 1942 -EntryType 'Error'
    }
    throw
}

## README
# The commented variables below are used to configure the script. To log information and errors to the event log create an
# event source named 'PasswordNotifyTask'.
# Please see https://github.com/chrisred/posh-scripts#passwordnotifytaskps1 for the full README.

# Domain Controller to run user and group cmdlets against, default uses the DNSRoot property to automatically resolve a server
$AD_SERVER = (Get-AdDomain).DNSRoot
# Number of full days before the password expires to start notifying the user, default is 4
$NOTIFY_BEFORE = 4
# The group name users must be a member of to receive a notification, if this is set NOTIFY_OU is ignored, default is $null
$NOTIFY_GROUP = $null
# The OU users must be a member of to receive a notification, default is the whole directory via the "Default Naming Context"
$NOTIFY_OU = (Get-ADRootDSE).DefaultNamingContext
# The property of the user object to reference for the user's name in the notification email, options are Name,GivenName,Surname,DisplayName, default is Name
$NOTIFY_NAME = 'Name'
# Mail server address for Send-MailMessage
$EMAIL_SERVER = 'mail.example.com'
# Mail server port for Send-MailMessage (only supported in PSv3 and greater), default is 25
$EMAIL_PORT = 25
# SSL option for Send-MailMessage enable with $true, default is $false
$EMAIL_SSL = $false
# PSCredential object for Send-MailMessage, setting $null will use the account running the script, default is an anonymous user
$EMAIL_CREDENTIAL = (New-Object Management.Automation.PSCredential('anonymous', (ConvertTo-SecureString -String 'anonymous' -AsPlainText -Force)))
# Redirect all notification emails to this address when testing, default is $null
$EMAIL_TEST = $null
# From address that appears in the notification email
$EMAIL_FROM = 'notify@example.com'
# Subject of the the notification email, '{0}' displays the time to expiry text
$EMAIL_SUBJECT = 'Your password will expire {0}'
# Body of the notification email, '{0}' displays the account Name '{1}' displays the time to expiry text
$EMAIL_BODY = @"
Dear {0},

Your password will expire {1}

Regards,
IT
"@

try
{
    $VerbosePreference = 'Continue'
    $Today = Get-Date
    $MaxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
    $Notified = [System.Collections.ArrayList]@()
    
    if($NOTIFY_GROUP -ne $null)
    {
        # get users based on membership of a specified group, this will recurse nested groups
        $Users = @(Get-AdGroupMember -Server $AD_SERVER -Identity $NOTIFY_GROUP -Recursive | Where-Object {$_.ObjectClass -eq 'user'} | Get-AdUser -Server $AD_SERVER -Properties PasswordNeverExpires,PasswordExpired,PasswordLastSet,EmailAddress,DisplayName | Where-Object {$_.Enabled -eq $true -and $_.PasswordNeverExpires -eq $false -and $_.PasswordExpired -eq $false})
    }
    else
    {
        # get users based on the -SearchBase, the whole directory by default
        $Users = @(Get-ADUser -Server $AD_SERVER -SearchBase $NOTIFY_OU -Filter {(Enabled -eq $true) -and (PasswordNeverExpires -eq $false)} -Properties PasswordNeverExpires,PasswordExpired,PasswordLastSet,EmailAddress,DisplayName | Where-Object {$_.PasswordExpired -eq $false})
    }

    foreach($User in $Users)
    {
        $FineGrainedPassword = Get-AdUserResultantPasswordPolicy -Server $AD_SERVER -Identity $User.SamAccountName
        if ($FineGrainedPassword -ne $null)
        {
            $MaxPasswordAge = $FineGrainedPassword.MaxPasswordAge.Days
        }

        # New-Timespan -Start is set to midnight so full days to expiry are calcuated, apart from the day of expiry
        $ExpiryTime = $User.PasswordLastSet.AddDays($MaxPasswordAge)
        $TimeToExpiry = New-TimeSpan -Start $Today.Date -End $ExpiryTime

        if ($TimeToExpiry.Days -le $NOTIFY_BEFORE)
        {
            if ($TimeToExpiry.Days -eq 0) {$ExpiryText = 'today.'}
            if ($TimeToExpiry.Days -eq 1) {$ExpiryText = 'tomorrow.'}
            if ($TimeToExpiry.Days -ge 2) {$ExpiryText = "in $($TimeToExpiry.Days) days."}
            
            $EmailParams = @{
                'From' = $EMAIL_FROM;
                'To' = $User.EmailAddress;
                'Subject' = ($EMAIL_SUBJECT -f $ExpiryText);
                'Body' = ($EMAIL_BODY -f $User.$NOTIFY_NAME, $ExpiryText);
                'Encoding' = [Text.Encoding]::UTF8;
                'SmtpServer' = $EMAIL_SERVER;
                'UseSsl' = $EMAIL_SSL
            }

            # PSv2 does not support the -Port parameter
            if ((Get-Host).Version.Major -gt 2) {$EmailParams['Port'] = $EMAIL_PORT}
            # only set the -Credential parameter if a PSCredential object is passed
            if ($EMAIL_CREDENTIAL -is [Management.Automation.PSCredential]) {$EmailParams['Credential'] = $EMAIL_CREDENTIAL}
            # if a test email is set overwrite the user email
            if ($EMAIL_TEST -ne $null) {$EmailParams['To'] = $EMAIL_TEST }

            $i = $Notified.Add(@{
                'SamAccountName' = $User.SamAccountName;
                'EmailAddress' = $User.EmailAddress;
                'MaxPasswordAge' = $MaxPasswordAge;
                'ExpiryTime' = $ExpiryTime
            })

            try
            {
                Send-MailMessage @EmailParams
                $Notified[$i]['Message'] = 'Email sent successfuly.'
            }
            catch
            {
                 $Notified[$i]['Message'] = $_.Exception.Message               
            }
        }
    }

    # there maybe errors from failed emails, log an error event to the event log so this can be tracked
    if ($Error.Count -gt 0)
    {
        $ErrorText = "There were $($Error.Count) errors while sending notification emails. Check event ID 1941 for more details on affected accounts."
        if ([Diagnostics.EventLog]::SourceExists("PasswordNotifyTask"))
        {
            Write-EventLog -LogName Application -Source 'PasswordNotifyTask' -Message $ErrorText -EventId 1942 -EntryType 'Error'
        }
    }
}
catch
{
    # write a short version of the exception details to the event log and rethrow
    $ErrorText = $_.ToString(); $ErrorText += $_.InvocationInfo.PositionMessage
    if ([Diagnostics.EventLog]::SourceExists("PasswordNotifyTask"))
    {
        Write-EventLog -LogName Application -Source 'PasswordNotifyTask' -Message $ErrorText -EventId 1942 -EntryType 'Error'
    }
    throw
}
finally
{
    $NotifyText = $Notified | ForEach-Object {$_.SamAccountName+', '+$_.EmailAddress+', '+$_.ExpiryTime+', '+$_.MaxPasswordAge+', '+$_.Message} | Out-String
    $LogText = `
@"
$($Notified.Count) user accounts processed. Emails will be sent from $EMAIL_FROM.

SamAccountName, EmailAddress, ExpiryTime, MaxPasswordAge, Message
$NotifyText
"@

    Write-Verbose $LogText

    if ([Diagnostics.EventLog]::SourceExists("PasswordNotifyTask"))
    {
        Write-EventLog -LogName Application -Source 'PasswordNotifyTask' -Message $LogText -EventId 1941 -EntryType Information
    }
}
