#***************************************************************************************************************************
# Web Application Proxy data collection functions

#Constants
Set-Variable CertificateAboutToExpireDays -option Constant -value 60
Set-Variable WAPPollingIntervalHighParameter -Option Constant -Value 120
#Additional Errors
Set-Variable NonDomainJoinedAndIWA -option Constant -value "NonDomainJoinedAndIWA"
Set-Variable CantRetrieveConfPermanent -option Constant -value "CantRetrieveConfPermanent"
Set-Variable CantRetrieveConfTemporary -option Constant -value "CantRetrieveConfTemporary"
Set-Variable CantApplyConfCert -option Constant -value "CantApplyConfCert"
Set-Variable CantApplyConfHttpSys -option Constant -value "CantApplyConfHttpSys"
Set-Variable IwaFailed -option Constant -value "IwaFailed"
Set-Variable ServiceStopped -option Constant -value "ServiceStopped"
Set-Variable ServiceNotAuto -option Constant -value "ServiceNotAuto"
Set-Variable ADFSServiceStopped -option Constant -value "ADFSServiceStopped"
Set-Variable ADFSServiceNotAuto -option Constant -value "ADFSServiceNotAuto"
Set-Variable UrlTranslationDis -option Constant -value "UrlTranslationDis"
Set-Variable PollingIntervalHigh -option Constant -value "PollingIntervalHigh"
Set-Variable ServerNotInCluster -option Constant -value "ServerNotInCluster"
Set-Variable DAWithWAPCluster -option Constant -value "DAWithWAPCluster"
#Certificate Error
Set-Variable Missing -option Constant -value "Missing"
Set-Variable Expired -option Constant -value "Expired"
Set-Variable AboutToExpire -option Constant -value "AboutToExpire"
Set-Variable NotBefore -option Constant -value "NotBefore"
Set-Variable NoPrivateKey -option Constant -value "NoPrivateKey"


#########################################################################################
# Function Name : Get-WAPInstalled
# Arguments     : None
#
# Description   : Detects if Web Application Proxy role service is installed
# Return value  : Boolean
#########################################################################################

Function Get-WAPInstalled()
{
    #try to retrieve the install state
    $InstallValue = $null
    $InstallValue = (Get-WindowsFeature Web-Application-Proxy -ErrorAction Ignore).Installed #Note: feature name is case sensitive

    #decide on the result 
    if ($InstallValue -eq $true) 
    {
        return $true 
    }
    else 
    {
        return $false
    }
}



#########################################################################################
# Function Name : Get-WAPConfigured
# Arguments     : None
#
# Description   : Detects if Web Applicaiton Proxy was configured. Meaning that its
#                 post-install cmdlet (Install-WebApplicaitonProxy) was executed directly
#                 or via UI.
# Return value  : Boolean
#########################################################################################

Function Get-WAPConfigured()
{
    #try to retrieve the post-install registry key
    $RegValue = (Get-ItemProperty hklm:\software\microsoft\adfs -ErrorAction Ignore).ProxyConfigurationStatus

    #decide on result based key value: 0 = configuration failed; 1 = not configured; 2 = configured
    if ($RegValue -eq 2) 
    {
        return $true 
    }
    else 
    {
        return $false
    }
}

#########################################################################################
# Function Name : Get-WAPCertErrorObject
# Arguments     : ErrorType as a string
#
# Description   : Helper function to create objects to be used by Get-WAPCertificateErrors
# Return value  : Single object with two fields: ErrorType and Applicaiton name. Both fields 
#                 are simple strings.
#########################################################################################

Function Get-WAPCertErrorObject($ErrorType,$AppName)
{
        $CertError = New-Object System.Object
        $CertError | Add-Member -type NoteProperty -Name AppName -value $AppName
        $CertError | Add-Member -type NoteProperty -Name CertError -value $ErrorType
        return $certError
}

#########################################################################################
# Function Name : Get-WAPCertificateErrors
# Arguments     : None
#
# Description   : Go over all the Applications that are published by Web Applicaiton Proxy 
#                 and check their certificates. Each certificate is checked for known 
#                 errors. 
# Return value  : Array of objects with two fields: AppName and CertError. Both fields 
#                 are simple strings.
#########################################################################################

Function Get-WAPCertificateErrors()
{
    $CertErrors = @()
	$TodaysDate = [System.DateTime]::Now
    $WAPApps = Get-WebApplicationProxyApplication -ErrorAction Ignore

    $CertificatesDictionary = @{}
    Get-ChildItem Cert:\LocalMachine\My | ForEach-Object { $CertificatesDictionary[$_.Thumbprint] = $_ }

	foreach ($App in $WAPApps)
	{
		$CurrentCert = $CertificatesDictionary[$App.ExternalCertificateThumbprint]
		
		#Certificate is missing
		if ($CurrentCert -eq $null)
		{
			$CertErrors += Get-WAPCertErrorObject $Missing $App.Name
		}
		else
		{
			#Check if certificate is exprired
            if($CurrentCert.NotAfter -le $TodaysDate)
            {
                $CertErrors += Get-WAPCertErrorObject $Expired $App.Name
            }
            else
            {
                #check if certificate is about to be expired
                if($CurrentCert.NotAfter -le $TodaysDate.AddDays($CertificateAboutToExpireDays))
                {
                    $CertErrors += Get-WAPCertErrorObject $AboutToExpire $App.Name
                }
                #check if certificate is not yet valid to use
                if($CurrentCert.NotBefore -ge $TodaysDate)
                {
                    $CertErrors += Get-WAPCertErrorObject $NotBefore $App.Name
                }
            }

            #check private key existance
            if(!$CurrentCert.HasPrivateKey)
            {
                $CertErrors += Get-WAPCertErrorObject $NoPrivateKey $App.Name
            }
		}
	}

    return $CertErrors
}


#########################################################################################
# Function Name : Get-WAPAdditionalErrorObject
# Arguments     : ErrorType and ErrorValue
#
# Description   : Helper function to create objects to be used by Get-WAPAdditionalErrors
# Return value  : Single object with two fields: ErrorType and ErrorValue. Both fields 
#                 are simple strings.
#########################################################################################

Function Get-WAPAdditionalErrorObject($ErrorType)
{
        $ErrorObj = New-Object System.Object
        $ErrorObj | Add-Member -type NoteProperty -Name ErrorType -value $ErrorType
        return $ErrorObj
}


#########################################################################################
# Function Name : Get-WAPAdditionalErrors
# Arguments     : None
#
# Description   : Find additional errors. Run various tests to find configuration errors
#                 If errors found, return an object that represents them.
#				  This function assumes that WAP is installed and configured.
# Return value  : Array of objects with two fields: ErrorType and ErrorValue. Both fields 
#                 are simple strings.
#########################################################################################

Function Get-WAPAdditionalErrors()
{
    $AdditionalErrors = @()

    #Check for applications related errors
    $AdditionalErrors += Check-ApplicationsRelatedErrors

    #Check for configurations related errors
    $AdditionalErrors += Check-ConfigurationsRelatedErrors
	
	#Check for event related errors
    $AdditionalErrors += Check-EventRelatedErrors
	
	#Check for service related errors
    $AdditionalErrors += Check-ServiceRelatedErrors
    
	#Return final object
    return $AdditionalErrors
    
}

#########################################################################################
# Function Name : Check-ApplicationsRelatedErrors
# Arguments     : None
#
# Description   : Find errors that exists in the currently published web applications. 
#  				  If errors found, return an object that represents them.
#				  This function assumes that WAP is installed and configured.
# Return value  : Array of objects with two fields: ErrorType and ErrorValue. Both fields 
#                 are simple strings.
#########################################################################################
Function Check-ApplicationsRelatedErrors()
{
	$ApplicationsRelatedErrors = @()
	
    #Check if any Application's BackendServerURL is different from its ExternalURL and it's translation is disabled
	$UrlTranslationDisApps = Get-WebApplicationProxyApplication | where {($_.ExternalUrl -ne $_.BackendServerUrl) -and 
        ($_.DisableTranslateUrlInResponseHeaders -eq $true -or $_.DisableTranslateUrlInRequestHeaders -eq $true)} | measure
    if ($UrlTranslationDisApps.count -gt 0)
    {
		$ApplicationsRelatedErrors += Get-WAPAdditionalErrorObject $UrlTranslationDis
    }

    #check if not domain joined and there is IWA app
    if ((Get-WmiObject win32_computersystem).partofdomain -eq $false) #Not domain joined
    {
		$IWAApps = Get-WebApplicationProxyApplication | where {$_.BackendServerAuthenticationMode -eq "IntegratedWindowsAuthentication"} | measure
        if ($IWAApps.count -gt 0)
        {
			$ApplicationsRelatedErrors += Get-WAPAdditionalErrorObject $NonDomainJoinedAndIWA
        }
    }
	
	#Return Applications related errors
	return $ApplicationsRelatedErrors
}

#########################################################################################
# Function Name : Check-ConfigurationsRelatedErrors
# Arguments     : None
#
# Description   : Find errors related to WAP configurations, If errors found, return an object that 
#  				  represents them.
#				  This function assumes that WAP is installed and configured.
# Return value  : Array of objects with two fields: ErrorType and ErrorValue. Both fields 
#                 are simple strings.
#########################################################################################
Function Check-ConfigurationsRelatedErrors()
{
	$ConfigurationsRelatedErrors = @()

	#Check if the configured polling interval is too high
	$CurrentConfigurations = Get-WebApplicationProxyConfiguration
    if ($CurrentConfigurations.ConfigurationChangesPollingIntervalSec -gt $WAPPollingIntervalHighParameter)
    {
		$ConfigurationsRelatedErrors += Get-WAPAdditionalErrorObject $PollingIntervalHigh
    }

    #Check if the current server isn't one of the connected servers
    $sysinfo = Get-WmiObject -Class Win32_ComputerSystem
    if ((Get-WmiObject win32_computersystem).partofdomain -eq $true)
    {
        $CurrentFqdn = “{0}.{1}” -f $sysinfo.Name, $sysinfo.Domain
    }
    else
    {
        $CurrentFqdn = $sysinfo.Name
    }
    if ($CurrentConfigurations.ConnectedServersName -notcontains $CurrentFqdn)
    {
        $ConfigurationsRelatedErrors += Get-WAPAdditionalErrorObject $ServerNotInCluster
    }

    #Check if a cluster of Web Application Proxy servers is deployed and DirectAccess is also installed
    $RemoteAccess = Get-RemoteAccess
    $DAConfigured = get-DirectAccessConfigured $RemoteAccess
    if (($CurrentConfigurations.ConnectedServersName.Count -gt 1) -and ($DAConfigured -eq $true))
    {
        $ConfigurationsRelatedErrors += Get-WAPAdditionalErrorObject $DAWithWAPCluster
    }
       
	#Return configurations related errors
	return $ConfigurationsRelatedErrors
}

#########################################################################################
# Function Name : Check-EventRelatedErrors
# Arguments     : None
#
# Description   : Find errors related to events, If errors found, return an object that 
#  				  represents them.
#				  This function assumes that WAP is installed and configured.
# Return value  : Array of objects with two fields: ErrorType and ErrorValue. Both fields 
#                 are simple strings.
#########################################################################################
Function Check-EventRelatedErrors()
{
	$EventRelatedErrors = @()

	#prepare object for events related rules
	$Yesterday = (Get-Date) - (New-TimeSpan -Day 1)
    $WAPEventsCountHash = @{};
    Get-WinEvent -FilterHashTable @{LogName='Microsoft-Windows-WebApplicationProxy/Admin'; StartTime=$Yesterday} | Group-Object -Property Id -NoElement | ForEach-Object { $WAPEventsCountHash.Add($_.Name,$_.Count) }

    #Now look for events
    if ($WAPEventsCountHash.Get_Item("12000") -ge 0) 
	{
        $EventRelatedErrors += Get-WAPAdditionalErrorObject $CantRetrieveConfPermanent
	}    
	else
    {
		if ($WAPEventsCountHash.Get_Item("12025") -ge 0) 
		{
			$EventRelatedErrors += Get-WAPAdditionalErrorObject $CantRetrieveConfTemporary
		}
    }
	
    if ($WAPEventsCountHash.Get_Item("12021") -ge 0)
	{
		$EventRelatedErrors += Get-WAPAdditionalErrorObject $CantApplyConfCert
    }
	
	if (($WAPEventsCountHash.Get_Item("12019") -ge 0) -or ($WAPEventsCountHash.Get_Item("12020") -ge 0))
	{
		$EventRelatedErrors += Get-WAPAdditionalErrorObject $CantApplyConfHttpSys
    }
	
	if ($WAPEventsCountHash.Get_Item("12008") -ge 0) 
	{
		$EventRelatedErrors += Get-WAPAdditionalErrorObject $IwaFailed
	}
	
	#Return event related errors
	return $EventRelatedErrors
}

#########################################################################################
# Function Name : Check-ServiceRelatedErrors
# Arguments     : None
#
# Description   : Find errors related to service, If errors found, return an object that 
#  				  represents them.
#				  This function assumes that WAP is installed and configured.
# Return value  : Array of objects with two fields: ErrorType and ErrorValue. Both fields 
#                 are simple strings.
#########################################################################################
Function Check-ServiceRelatedErrors()
{
	$ServiceRelatedErrors = @()
	
	#Check for service related tests
    if ((Get-Service 'appproxysvc').Status -ne 'Running')
	{
        $ServiceRelatedErrors += Get-WAPAdditionalErrorObject $ServiceStopped
	}     
	
	if ((Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name='appproxysvc'").StartMode -ne 'Auto')
    {
		$ServiceRelatedErrors += Get-WAPAdditionalErrorObject $ServiceNotAuto
	}
	
	if ((Get-Service 'adfssrv').Status -ne 'Running')
	{
		$ServiceRelatedErrors += Get-WAPAdditionalErrorObject $ADFSServiceStopped
	}
	
	if ((Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name='adfssrv'").StartMode -ne 'Auto')
	{
		$ServiceRelatedErrors += Get-WAPAdditionalErrorObject $ADFSServiceNotAuto
	}
	
	#Return service related errors
	return $ServiceRelatedErrors
}
#***************************************************************************************************************************
# Collect and populate Web Application Proxy data

$WAP_status = Get-WAPInstalled # = if role service is installed
$RRasConfig.SetWAPInstallStatus($WAP_status);

if ($WAP_status -eq $true)
{
    $WAP_Config_Status = Get-WAPConfigured # = if post-install was executed by UI or PSH
    $RRasConfig.SetWAPConfiguredStatus($WAP_Config_Status)

    if ($WAP_Config_Status -eq $true)
    {
        #set certificate data
        foreach ($certError in Get-WAPCertificateErrors)
        {
            $RRasConfig.AddWAPCertificateError($certError.CertError,$certError.AppName)
        }

        #set additional errors data
        foreach ($AdditionalError in Get-WAPAdditionalErrors)
        {
            $RRasConfig.AddWAPAdditionalErrors($AdditionalError.ErrorType)
        }
    }

}

