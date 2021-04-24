param([parameter(Position=0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, mandatory=$true)][string]$Identity, 
      [parameter(Position=1, mandatory=$true)][string]$RemoteForestDomainController, 
      [parameter(Position=2, mandatory=$true)][Management.Automation.PSCredential]$RemoteForestCredential, 
      [string]$LocalForestDomainController,
      [Management.Automation.PSCredential]$LocalForestCredential,
      [string]$TargetMailUserOU,
      [string]$MailboxDeliveryDomain,
      [switch]$LinkedMailUser,
      [switch]$DisableEmailAddressPolicy,
      [switch]$UseLocalObject,
      [switch]$OverwriteLocalObject)

begin
{
    # ---------------------------------------------------------------------------------------------------
    function findADObject($searchRoot, $filter)
    # ---------------------------------------------------------------------------------------------------
    {
        $searcher = new-object System.DirectoryServices.DirectorySearcher($searchRoot)
        $searcher.filter = $filter
        $user = $searcher.findall()

        if ($user -eq $null -or $user.count -eq 0)
        {
            return $null
        }
        elseif ($user.count -gt 1)
        {
            foreach ($usr in $user)
            {
                Write-Warning ("Object Found:" + $usr.GetDirectoryEntry().distinguishedName)
            }
            Write-Host "Tips: For Source object, please check the duplication of distinguishedName, mailNickName, displayName, objectGUID and proxyAddresses. You could parse the objectGUID in the Identity parameter to make it unique instead."
            Write-Host "Tips: For Local object, please check whether the proxyAddresses have duplicated item in these objects. You need to correct the dirty data before you could continue."
            throw "Multiple objects found in AD."
        }
        else
        {
            return $user[0].GetDirectoryEntry()
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function checkUserExist ($OU, $filter)
    # ---------------------------------------------------------------------------------------------------
    {
        $searcher = new-object System.DirectoryServices.DirectorySearcher($OU)
        $searcher.filter = $filter
        $user = $searcher.findone() 
        if ($user -eq $null -or $user.count -eq 0)
        {
            return $false
        }
        else
        {
            return $true
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function getAttributeFriendlyValue ($attribute, $attValue)
    # ---------------------------------------------------------------------------------------------------
    {
        if (($attribute -eq "msExchMailboxGuid") -or ($attribute -eq "msExchArchiveGuid"))
        {
            return ([System.Guid]($attValue)).ToString()
        }
        else
        {
            return $attValue
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function copyIfExist ($target, [array]$attriblist, $propertybag)
    # ---------------------------------------------------------------------------------------------------
    {
        foreach($att in $attriblist)
        {
            if ($propertybag.Contains($att))
            {
                $friendlyValue = getAttributeFriendlyValue $att $propertybag.Item($att).Value
                Write-Verbose "Setting $att to $friendlyValue"
                [void]($target.Put($att, $propertybag.Item($att).Value))
            }
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function getEscapedldapFilterStr ([string]$original)
    # ---------------------------------------------------------------------------------------------------
    {
        $escape = $original.replace("\", "\5c")
        $escape = $escape.replace("(", "\28").replace(")", "\29")
        $escape = $escape.replace("&", "\26").replace("|", "\7c")
        $escape = $escape.replace("=", "\3d").replace(">", "\3e")
        $escape = $escape.replace("<", "\3c").replace("~", "\7e")
        $escape = $escape.replace("*", "\2a").replace("/", "\2f")
        return $escape
    }

    # ---------------------------------------------------------------------------------------------------
    function getEscapedDNStr ([string]$original)
    # ---------------------------------------------------------------------------------------------------
    {
        $escape = $original.replace(",", "\,")
        $escape = $escape.replace("+", "\+")
        $escape = $escape.replace("""", "\""")
        $escape = $escape.replace("#", "\#")
        $escape = $escape.replace(";", "\;")
        return $escape
    }

    # ---------------------------------------------------------------------------------------------------
    function sidToLDAPQuery([byte[]]$sid)
    # ---------------------------------------------------------------------------------------------------
    {
        foreach ($by in $sid)
        {
            $ret += "\" + $by.tostring("X")
        }
        return $ret
    }
    
    # ---------------------------------------------------------------------------------------------------    
    function MasterAccountSidIsSelf ( $srcMbxAttributes )
    # ---------------------------------------------------------------------------------------------------
    {
        if ($srcMbxAttributes.Contains("msExchMasterAccountSid"))
        {
            $master = new-object System.Security.Principal.SecurityIdentifier($srcMbxAttributes.Item("msExchMasterAccountSid").value, 0)
            if ($master.IsWellKnown("SelfSid"))
            {
                return $true
            }
        }
        return $false
    }

    # ---------------------------------------------------------------------------------------------------
    function findLocalObject ($OU, $srcuser)
    # ---------------------------------------------------------------------------------------------------
    {
        $objectClassFilter = "(&(!objectClass=computer)(|(objectClass=user)(objectClass=contact)(objectClass=group)(objectClass=msExchDynamicDistributionList)))"
        $usr = $null
        if ($srcuser.properties.Contains("msExchMasterAccountSid") -and -not (MasterAccountSidIsSelf $srcuser.properties))
        {
            $sourcesid += sidToLDAPQuery $srcuser.properties.Item("msExchMasterAccountSid").Value
            $filter = "(| (ObjectSid=$sourcesid) (msExchMasterAccountSid=$sourcesid) )"
            $filter = "(&($objectClassFilter)($filter))"

            $usr = findADObject $OU $filter
        }
        if ($usr -eq $null)
        {
            $address = $srcuser.Properties.Item("proxyAddresses")
            foreach ($addr in $address)
            {
                if ($addr.startswith("x500:", "OrdinalIgnoreCase") -or $addr.startswith("smtp:", "OrdinalIgnoreCase"))
                {
                    $addr1 = getEscapedldapFilterStr ($addr.Substring(0,4).toUpper() + $addr.Substring(4))
                    $addr2 = getEscapedldapFilterStr ($addr.Substring(0,4).toLower() + $addr.Substring(4))
                    $filterstring += "(proxyAddresses=$addr1) (proxyAddresses=$addr2)"
                }
            }
            
            $filter = "(| $filterstring)"
            $filter = "(&($objectClassFilter)($filter))"

            $usr = findADObject $OU $filter
        }
        return $usr
    }

    # ---------------------------------------------------------------------------------------------------
    function generateUniqueSAM ($ou, $srcMbxAttributes)
    # ---------------------------------------------------------------------------------------------------
    {
        $uniquesam = $srcMbxAttributes.Item('samaccountname').Value
        $retrycount = 30
        if ($uniquesam.Length -lt 20)
        {
            while ($retrycount -gt 0 -and (checkUserExist $ou "(samAccountName=$(getEscapedldapFilterStr $uniquesam))"))
            {
                $uniquesam = $srcMbxAttributes.Item("samaccountname").Value + (random)
                if ($uniquesam.length -gt 20)
                {
                    $uniquesam = $uniquesam.substring(0,20)
                }
                $retrycount = $retrycount - 1
            }
        }
        return $uniquesam
    }

    # ---------------------------------------------------------------------------------------------------
    function generateUniqueUPN ($ou, $srcMbxAttributes, $fallbacks)
    # ---------------------------------------------------------------------------------------------------
    {
        if ($srcMbxAttributes.Contains('userPrincipalName'))
        {
            $uniqueupn = $srcMbxAttributes.Item('userPrincipalName').Value
            if ($uniqueupn -match "^(.*)(@.*)$")
            {
                $postfix = $matches[2]
                $prefix  = $matches[1]
            }
            $preferedupn = ,$uniqueupn + $fallbacks
            foreach ($upn in $preferedupn)
            {
                if ($upn -ne $null)
                {
                    if ($upn.contains("@"))
                    {
                        $testupn = $upn
                    }
                    else
                    {
                        $testupn = "$upn$postfix"
                    }
                    if ($(checkUserExist $ou "(userPrincipalName=$(getEscapedldapFilterStr $testupn))") -eq $false)
                    {
                        return $testupn
                    }
                }
            }
            #try to use prefered upn, if all unsuitable, generate a new one
            while ($(checkUserExist $ou "(userPrincipalName=$(getEscapedldapFilterStr $uniqueupn))"))
            {
                $uniqueupn = "$prefix$(random)$postfix"
            }
        }
        return $uniqueupn
    }

    # ---------------------------------------------------------------------------------------------------
    function copyBasicAttributes ($newuser, $srcAttributes)
    # ---------------------------------------------------------------------------------------------------
    {
        $copyAttributes="displayName",
                        "Mail",
                        "mailNickName",
                        "msExchMailboxGuid",
                        "msExchArchiveGuid",
                        "msExchUserCulture",
                        "msExchArchivename"

        [void](copyIfExist $newuser $copyAttributes $srcAttributes)
    }


    # ---------------------------------------------------------------------------------------------------
    function copyMandatoryAttributes ($newuser, $srcAttributes, $localDC)
    # ---------------------------------------------------------------------------------------------------
    {
        copyBasicAttributes $newuser $srcAttributes

        # Handle proxyAddresses specially (only copied when the local object is created at first).
        [void](copyIfExist $newuser "proxyAddresses" $srcAttributes)

        $specialAttributes = @{  "msExchRecipientDisplayType"=0x80000006;
                                 "msExchRecipientTypeDetails"=0x80;
                                 "msExchVersion"="44220983382016";
                                 "userAccountControl"=0x202 #ACCOUNTDISABLE | NORMAL_ACCOUNT
                               }

        if ($localDC -ne $null)
        {
            $specialAttributes["samaccountname"] = generateUniqueSAM $localDC $srcAttributes
            $specialAttributes["userPrincipalName"] = generateUniqueUPN $localDC $srcAttributes $newuser.cn,$specialAttributes["samaccountname"]
        }

        foreach($att in $specialAttributes.getenumerator())
        {
            if ($att.value -ne $null)
            {
                Write-Verbose "Setting $($att.key) to $($att.value)"
                [void]($newuser.put($att.key, $att.value.tostring()))
            }
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function getTargetAddress ($srcProxyAddresses, $writeErrorIfNotExist)
    # ---------------------------------------------------------------------------------------------------
    {
        foreach ($addr in $srcProxyAddresses)
        {
            if ($addr -match "^(SMTP|smtp):.*@(.*)$")
            {
                #if don't specify authoritative domains, use primary smtp address
                if (([string]::IsNullOrEmpty($MailboxDeliveryDomain) -and $addr.startswith("SMTP")) -or
                    ($matches[2] -eq $MailboxDeliveryDomain))
                {
                    Write-Verbose "Setting targetAddress to $addr"
                    return $addr
                }
            }
        }

        if ($writeErrorIfNotExist)
        {
            $errFixTip = $null
            if ([string]::IsNullOrEmpty($MailboxDeliveryDomain))
            {
                $errFixTip = "PrimaryEmailAddress exists"
            }
            else
            {
                $errFixTip = "some EmailAddress matches MailboxDeliveryDomain $MailboxDeliveryDomain"
            }

            # Terminate if fail to determine targetAddress (necessary for MEU)
            throw "Unable to determine the targetAddress for the newly created MEU. Please ensure that $errFixTip in source object."
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function disableEmailAddressPolicy ($user)
    # ---------------------------------------------------------------------------------------------------
    {
        if ($DisableEmailAddressPolicy)
        {
            Write-Verbose "Disable EmailAddressPolicy."
            try
            {
                $dcParameter = @{};
                if ($LocalForestDomainController -ne $null)
                {
                    $dcParameter = @{DomainController=$LocalForestDomainController}
                }
                Set-MailUser $user.distinguishedName.Value @dcParameter -EmailAddressPolicyEnabled:$false
            }
            catch
            {
                 # Terminate if fail to disable the EAP.
                 throw "Fail to disable the EmailAddressPolicy for MEU($($user.distinguishedName)). Error: $($Error[0])"
            }
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function generateLegacyExchangeDN ($user)
    # ---------------------------------------------------------------------------------------------------
    {
        # Update the LegacyExchangeDN if it doesn't exist.
        if ($user.properties.Contains("LegacyExchangeDN") -eq $false)
        {
            Write-Verbose "Invoke Update-Recipient to Update LegacyExchangeDN."
            try
            {
                Update-Recipient $user.distinguishedName.Value @DomainControllerParameterSet
                #rebind ad object to retrieve new properties set by Update-Recipient
                $user.RefreshCache([array]"legacyExchangeDN")
            }
            catch
            {
                Write-Error "Error updating recipient MEU($($user.DistinguishedName)) to generate the legacyDN. Please fix the error, run the Update-Recipient task to generate the LegacyDN and this script again. Error: $($Error[0])"
                return
            }
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function mergeLegacyDNToProxyAddress ($user, $X500ProxyAddresses, $updateImmediately, $sourceOrLocal)
    # ---------------------------------------------------------------------------------------------------
    {
        # Merge legacyDN to source object
        if ($X500ProxyAddresses.Length -gt 0)
        {
            $userFriendlyName = "Object($($user.distinguishedName))"
            if ([string]::IsNullOrEmpty($user.distinguishedName))
            {
                $userFriendlyName = "New Object" # DN is not available.
            }
            $updateRequired = $false
            foreach ($X500ProxyAddress in $X500ProxyAddresses)
            {
                if ($user.Properties.Item("proxyAddresses").tostring().toupper().Contains($X500ProxyAddress.ToUpper()) -eq $false)
                {
                    Write-Host "Appending $X500ProxyAddress to proxyAddresses of $userFriendlyName in $sourceOrLocal forest." -ForegroundColor Green
                    [void]($user.putex(3, "proxyAddresses", [array]$X500ProxyAddress))
                    $updateRequired = $true
                }
            }
            if ($updateRequired -and $updateImmediately)
            {
                try
                {
                    $user.setinfo() # Might get Access Denied
                }
                catch
                {
                    Write-Error "Error appending $X500ProxyAddress to proxyAddresses of $userFriendlyName in $sourceOrLocal forest. Please update the proxyAddresses manually, or fix the error and run this script again. Error: $($Error[0])"
                    return
                }
            }
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function generateNewCN ($localDC, $oldcn, $oudn)
    # ---------------------------------------------------------------------------------------------------
    {
            $newcn = getEscapedldapFilterStr $oldcn
            $newcn = getEscapedDNStr $newcn
            $tryCnt = 0;
            $oldcnLength = $oldcn.Length;
            $localPath = $localdc.Path;
            # Usage of this script may not provide the LocalForestDomainController parameter, in which case, the $localdc.Path is empty.
            if ([string]::IsNullorEmpty($localPath))
            {
                $localPath = "LDAP:/";
            }
            while ([DirectoryServices.DirectoryEntry]::exists("$localPath/cn=$newcn,$oudn"))
            {
                if ($tryCnt -gt 10)
                {
                    throw "Unable to generate new CN, the script has tried 10 times with random string appended. You could re-run again if you're sure it could be generated.";
                }
                $tryCnt = $tryCnt + 1;

                if ($oldcnLength -ge 64)
                {
                    # if old CN legth is already maximum (64), we can't generate new one.
                    throw "Unable to generate new CN. The original CN $newcn exists and its length >= 64, thus we can't append random string at the end to generate new one.";
                }

                $ranStr = (random).ToString()
                if ($oldcnLength + $ranStr.Length -gt 64)
                {
                    $ranStr = $ranStr.subString(0, 64 - $oldcnLength);
                }
                $newcn = getEscapedldapFilterStr ($oldcn + $ranStr)
                $newcn = getEscapedDNStr $newcn
            }
            return $newcn;
    }

    # ---------------------------------------------------------------------------------------------------
    function createMailUserAccount ($localDC, $ou, $srcMbxAttributes)
    # ---------------------------------------------------------------------------------------------------
    {
        try{
            $newcn = generateNewCN $localDC $srcMbxAttributes.Item("cn").value $ou.distinguishedname

            [void]($newuser = $ou.create("user", "cn=$newcn"))
            
            copyMandatoryAttributes $newuser $srcMbxAttributes $localDC

            #additional operations for proxyaddresses and targetaddress

            if ($srcMbxAttributes.Contains("LegacyExchangeDN"))
            {
                $X500proxyAddr = "x500:" + $srcMbxAttributes.Item("LegacyExchangeDN").value
                mergeLegacyDNToProxyAddress $newuser ([array]$X500proxyAddr) $false "Local"
            }

            $srcProxyAddresses = $srcMbxAttributes.Item("proxyAddresses")
            $targetAddress = getTargetAddress $srcProxyAddresses $true
            if ($targetAddress -ne $null)
            {
                [void]($newuser.put("targetAddress", $targetAddress))
            }

            [void]($newuser.SetInfo())

            $newuser.RefreshCache([array]"distinguishedName")

            return $newuser
        }
        catch
        {
            # Terminate the script if fail to create the new user.
            throw "Error creating mailuser CN=$newcn,$($ou.distinguishedname) in local forest or setting its mandatory attributes. Error: $($Error[0])"
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function copyGalySyncAttributes ($user, $srcMbxAttributes)
    # ---------------------------------------------------------------------------------------------------
    {
        $copyAttributes= "C",
                         "Co",
                         "countryCode",
                         "Company",
                         "Department",
                         "facsimileTelephoneNumber",
                         "givenName",
                         "homePhone",
                         "Info",
                         "Initials",
                         "L",
                         "Mobile",
                         "msExchAssistantName",
                         "msExchHideFromAddressLists",
                         "otherHomePhone",
                         "otherTelephone",
                         "Pager",
                         "physicalDeliveryOfficeName",
                         "postalCode",
                         "Sn",
                         "St",
                         "streetAddress",
                         "telephoneAssistant",
                         "telephoneNumber",
                         "Title"

        copyIfExist $user $copyAttributes $srcMbxAttributes
    }

    # ---------------------------------------------------------------------------------------------------
    function copyE2k7OptionalAttributes ($user, $srcMbxAttributes)
    # ---------------------------------------------------------------------------------------------------
    {
        $copyAttributes= #"Cn",
                         "Comment",
                         "deletedItemFlags",
                         "delivContLength",
                         "departmentNumber",
                         "Description",
                         "Division",
                         "employeeID",
                         "employeeNumber",
                         "employeeType",
                         "homePostalAddress",
                         "internationalISDNNumber",
                         "ipPhone",
                         "Language",
                         "localeID",
                         "mAPIRecipient",
                         "middleName",
                         "msDS-PhoneticCompanyName",
                         "msDS-PhoneticDepartment",
                         "msDS-PhoneticDisplayName",
                         "msDS-PhoneticFirstName",
                         "msDS-PhoneticLastName",
                         "msExchBlockedSendersHash",
                         "msExchELCExpirySuspensionEnd",
                         "msExchELCExpirySuspensionStart",
                         "msExchELCMailboxFlags",
                         "msExchExternalOOFOptions",
                         "msExchMessageHygieneFlags",
                         "msExchMessageHygieneSCLDeleteThreshold",
                         "msExchMessageHygieneSCLJunkThreshold",
                         "msExchMessageHygieneSCLQuarantineThreshold",
                         "msExchMessageHygieneSCLRejectThreshold",
                         "msExchMDBRulesQuota",
                         "msExchPoliciesExcluded",
                         "msExchSafeRecipientsHash",
                         "msExchSafeSendersHash",
                         "msExchUMSpokenName",
                         "O",
                         "otherFacsimileTelephoneNumber",
                         "otherIpPhone",
                         "otherMobile",
                         "otherPager",
                         "preferredDeliveryMethod",
                         "personalPager",
                         "personalTitle",
                         "Photo",
                         "pOPCharacterSet",
                         "pOPContentFormat",
                         "postalAddress",
                         "postOfficeBox",
                         "primaryInternationalISDNNumber",
                         "primaryTelexNumber",
                         "showInAdvancedViewOnly",
                         "Street",
                         "terminalServer",
                         "textEncodedORAddress",
                         "thumbnailLogo",
                         "thumbnailPhoto",
                         "url",
                         "userCert",
                         "userCertificate",
                         "userSMIMECertificate",
                         "wWWHomePage"
        foreach ($i in 1..15)
        {
            $copyAttributes += "extensionAttribute$i";
        }


        copyIfExist $user $copyAttributes $srcMbxAttributes
    }

    # ---------------------------------------------------------------------------------------------------
    function findCorrespondingADObject ($targetOU, $DN, $srcDomain)
    # ---------------------------------------------------------------------------------------------------
    {
        $cn = "$DN".substring(0, "$DN".indexof(",DC="))
        $srcreferenceobject = $srcDomain.children.find($cn)
        $usr = $null
        if ($srcreferenceobject -ne $null)
        {
            if ($srcreferenceobject.Properties.Contains("legacyExchangeDN"))
            {
                $legexch = getEscapedldapFilterStr $srcreferenceobject.Properties.Item("legacyExchangeDN")
                $addrfilter = "(proxyAddresses=x500:$legexch) (proxyAddresses=X500:$legexch)"
            }
            $address = $srcreferenceobject.Properties.Item("proxyAddresses")
            foreach ($addr in $address)
            {
                if ($addr.startswith("x500:", "OrdinalIgnoreCase"))
                {
                    $addrfilter += "(legacyExchangeDN=$(getEscapedldapFilterStr $addr.substring(5)))"
                }
                if ($addr.startswith("smtp:", "OrdinalIgnoreCase") -or $addr.startswith("x500:", "OrdinalIgnoreCase"))
                {
                    $addr1 = getEscapedldapFilterStr ($addr.Substring(0,4).toUpper() + $addr.Substring(4))
                    $addr2 = getEscapedldapFilterStr ($addr.Substring(0,4).toLower() + $addr.Substring(4))
                    $addrfilter += "(proxyAddresses=$addr1) (proxyAddresses=$addr2)"
                }
            }
            if ([string]::IsNullOrEmpty($addrfilter) -eq $false)
            {
                $filter = "(| $addrfilter)"
                $objectClassFilter = "(&(!objectClass=computer)(|(objectClass=user)(objectClass=contact)(objectClass=group)(objectClass=msExchDynamicDistributionList)))"

                $filterWithObjectClass = "(&($objectClassFilter)($filter))"
                $usr = findADObject $targetOU $filterWithObjectClass

                if ($usr -eq $null)
                {
                    #user not found, try find with loose condition. Because link/backlink may be in other object type.
                    $usr = findADObject $targetOU $filter
                }
            }

            return $usr
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function setLinkedAttribute ($attribname, $backlinkname, $targetOU, $user, $srcMbxAttributes, $srcDomain)
    # ---------------------------------------------------------------------------------------------------
    {
        if ($srcMbxAttributes.contains($attribname))
        {
            foreach ($dn in $srcMbxAttributes.item($attribname))
            {
                try
                {
                    $corobj = findCorrespondingADObject $targetOU $dn $srcDomain
                    if ($corobj -eq $null)
                    {
                        Write-Warning "Cannot find corresponding object for $dn in current forest. `'$attribname`' not set."
                    }
                    else
                    {
                        Write-Verbose "Setting $attribname to $($corobj.properties.item('distinguishedname'))"
                        if (($attribname -eq "Manager") -or ($attribname -eq "managedBy") -or ($attribname -eq "altRecipient"))
                        {
                            $user.put($attribname, $($corobj.properties.item('distinguishedname')))
                        }
                        else
                        {
                            $user.putex(3, $attribname, [array]"$($corobj.properties.item('distinguishedname'))")
                        }
                    }
                }
                catch
                {
                    Write-Warning "Error updating $($user.distinguishedName)   Attribute: $attribname! Attribute Not Set! Error: $($Error[0])"
                }
            }
        }
        
        #find backlink from source MBX, set it on corresponding user in target
        if ($srcMbxAttributes.contains($backlinkname))
        {
            foreach ($dn in $srcMbxAttributes.item($backlinkname))
            {
                try
                {
                    $corobj = findCorrespondingADObject $targetOU $dn $srcDomain
                    if ($corobj -eq $null)
                    {
                        Write-Warning "Cannot find corresponding object for $dn in current forest. `'$attribname`' not updated."
                    }
                    else
                    {
                        if (($attribname -eq "Manager") -or ($attribname -eq "managedBy") -or ($attribname -eq "altRecipient"))
                        {
                            $corobj.Put($attribname, $($user.properties.item("distinguishedname")))
                        }
                        else
                        {
                            $corobj.PutEx(3, $attribname, [array]"$($user.properties.item("distinguishedname"))")
                        }
                        $corobj.SetInfo()
                        Write-Host "Updating $($corobj.distinguishedName)   Attribute: $attribname" -ForegroundColor Green
                    }
                }
                catch
                {
                    Write-Warning "Error updating $($corobj.distinguishedName)   Attribute: $attribname! Attribute Not Set! Error: $($Error[0])"
                }
            }
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function setLinkedAttributes ($targetOU, $user, $srcMbxAttributes, $srcDomain)
    # ---------------------------------------------------------------------------------------------------
    {
        setLinkedAttribute "altRecipient" "altRecipientBL" $targetOU $user $srcMbxAttributes $srcDomain
        if ($user.properties.contains("altRecipient") -and $srcMbxAttributes.contains("deliverAndRedirect"))
        {
            $user.put("deliverAndRedirect", "$($srcMbxAttributes.item('deliverAndRedirect'))".toupper())
        }
        
        setLinkedAttribute "Manager" "directReports" $targetOU $user $srcMbxAttributes $srcDomain
        
        setLinkedAttribute "publicDelegates" "publicDelegatesBL"  $targetOU $user $srcMbxAttributes $srcDomain
        
        setLinkedAttribute "member" "memberOf"  $targetOU $user $srcMbxAttributes $srcDomain

        setLinkedAttribute "managedBy" "managedObjects"  $targetOU $user $srcMbxAttributes $srcDomain

        setLinkedAttribute "msExchCoManagedByLink" "msExchCoManagedObjectsBL"  $targetOU $user $srcMbxAttributes $srcDomain
    }

    # ---------------------------------------------------------------------------------------------------
    function copyLinkedMailboxTypeAttributes ($user, $srcMbxAttributes)
    # ---------------------------------------------------------------------------------------------------
    {
        $copyAttributes = @()
        $valuedAttributes = @{ }
        
        $accountenable = ($srcMbxAttributes.Item("UserAccountControl").tostring() -band 0x2) -eq 0
        if (-not $accountenable -and (MasterAccountSidIsSelf $srcMbxAttributes))
        {
            $valuedAttributes["msExchRecipientDisplayType"] = $user.properties.Item("msExchRecipientDisplayType").value -bor 2
        }
        else
        {
            $valuedAttributes["msExchRecipientDisplayType"] = 0xC0000006
            if ($srcMbxAttributes.Contains("msExchMasterAccountSid"))
            {
                $copyAttributes += "msExchMasterAccountSid"
            }
            elseif ($srcMbxAttributes.Contains("objectSid"))
            {
                $valuedAttributes["msExchMasterAccountSid"] = $srcMbxAttributes.Item("objectSid").Value
            }
            #this can also be done by carefully arrange "msExchMasterAccountSid" and "objectSid"
            #in the list, avoid the trouble of nested branching. but it's not worth the maintainence effort
        }
        
        [void](copyIfExist $user $copyAttributes $srcMbxAttributes)
    
        foreach($att in $valuedAttributes.getenumerator())
        {
            Write-Verbose "Setting $($att.key) to $($att.value)"
            [void]($user.put($att.key, $att.value))
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function copySpecialMailboxTypeAttributes ($user, $srcMbxAttributes)
    # ---------------------------------------------------------------------------------------------------
    {
    #Mailbox Type Constants
        $ROOMMAILBOX      = 16
        $EQUIPMENTMAILBOX = 32
    #End Mailbox Type Constants
        $copyAttributes = "msExchResourceCapacity",
                          "msExchResourceDisplay",
                          "msExchResourceMetaData",
                          "msExchResourceSearchProperties"
                          
        $valuedAttributes = @{ }
        
        if ($srcMbxAttributes.Contains("msExchRecipientTypeDetails"))
        {
            $typedetail = $user.ConvertLargeIntegerToInt64($srcMbxAttributes.Item("msExchRecipientTypeDetails").Value)
            if (($typedetail -band $ROOMMAILBOX) -ne 0)
            {
                $valuedAttributes["msExchRecipientDisplayType"] = 0x80000706
            }
            elseif (($typedetail -band $EQUIPMENTMAILBOX) -ne 0)
            {
                $valuedAttributes["msExchRecipientDisplayType"] = 0x80000806
            }
            else
            {
                return
            }

            [void](copyIfExist $user $copyAttributes $srcMbxAttributes)
            
            foreach($att in $valuedAttributes.getenumerator())
            {
                Write-Verbose "Setting $($att.key) to $($att.value)"
                [void]($user.put($att.key, $att.value))
            }
        }
    }

    # ---------------------------------------------------------------------------------------------------
    function createMEUAndCopyAttrs ($localDC, $localOU, $srcDC, $srcObject)
    # ---------------------------------------------------------------------------------------------------
    {
        $srcAttributes = $srcObject.properties
        $newuser = createMailUserAccount $localDC $localOU $srcAttributes

        #mandatory attributes are all set. go with optional attributes
        copyGalySyncAttributes $newuser $srcAttributes
        copyE2k7OptionalAttributes $newuser $srcAttributes
        setLinkedAttributes $localdc $newuser $srcAttributes $srcdc
        copySpecialMailboxTypeAttributes $newuser $srcAttributes

        if ($LinkedMailUser)
        {
            copyLinkedMailboxTypeAttributes $newuser $srcAttributes
        }

        try
        {
            [void]($newuser.SetInfo())
        }
        catch
        {
            Write-Error "Fail to update attributes of local MEU $($newuser.DistinguishedName). $($Error[0])"
            return
        }

        [void](disableEmailAddressPolicy($newuser))
        [void](generateLegacyExchangeDN($newuser))

        #syncback Legacy Exchange DN
        if ($newuser.properties.Contains("LegacyExchangeDN"))
        {
            $X500proxyAddr = "x500:" + $newuser.properties.Item("LegacyExchangeDN")
            mergeLegacyDNToProxyAddress $srcObject ([array]$X500proxyAddr) $true "Source"
        }

        $Global:movecount++
        "Preparation for $Identity done."
    }
    
    # ---------------------------------------------------------------------------------------------------
    function forceMergeObject ($recipienttype, $localOU, $localusr, $localDC, $srcObject, $srcDC)
    # ---------------------------------------------------------------------------------------------------
    {
        $copyAttributes = "msExchMailboxGUID",
                          "msExchArchiveGUID",
                          "msExchArchiveName"

        $X500proxyAddrsToUpdateSrcObj = @()
        $localUserOriginalLegacyDNToX500 = $null
        if ($localusr.Properties.Contains("LegacyExchangeDN"))
        {
            # Original user's legacyDN will be merged to source object.
            $localUserOriginalLegacyDNToX500 = "x500:" + $localusr.Properties.Item("LegacyExchangeDN")
            $X500proxyAddrsToUpdateSrcObj += $localUserOriginalLegacyDNToX500
        }

        $userToUpdate = $null;

        if ($recipienttype -eq 'MailUser')
        {
            [void](disableEmailAddressPolicy($localusr))

            Write-Verbose "Merging Mailbox properties to local MailUser"
            [void](copyIfExist $localusr $copyAttributes $srcObject.properties)
            [void]($localusr.put("msExchVersion", "44220983382016"))
            $logindisabled = ($srcObject.userAccountControl.Value -band 0x2) -ne 0 #AccountDisabled
            if ($LinkedMailUser -and $logindisabled)
            {
                copyLinkedMailboxTypeAttributes $localusr $srcObject.properties
            }

            # Set the proxyAddresses first before merging legacyDN.
            if ($OverwriteLocalObject)
            {
                [void](copyIfExist $localusr "proxyAddresses" $srcObject.properties)
            }

            # Merge source object's legacyDN to local user's proxyAddresses.
            if ($srcObject.properties.Contains("LegacyExchangeDN"))
            {
                $X500proxyAddr = "x500:" + $srcObject.properties.Item("LegacyExchangeDN")
                mergeLegacyDNToProxyAddress $localusr ([array]$X500proxyAddr) $false "Local"
            }

            try
            {
                [void]($localusr.SetInfo())  # Might get Access Denied.
            }
            catch
            {
                Write-Error "Error updating local MEU($($localusr.DistinguishedName)) attributes from source object. Please fix the error and run this script again. Error: $($Error[0])"
            }

            $userToUpdate = $localusr;
        }
        elseif ($recipienttype -eq 'MailContact')
        {
            Write-Verbose "Creating MailUser with same attributes as local MailContact"
            
            $srcMbxAttributes = $srcObject.Properties
            $ContactAttributes = $localusr.Properties

            $newcn = generateNewCN $localDC $srcMbxAttributes.Item("cn").value $localou.distinguishedname
            $newuser = $localOU.create("user", "cn=$newcn")
            
            copyMandatoryAttributes $newuser $ContactAttributes
            copyGalySyncAttributes $newuser $ContactAttributes
            copyE2k7OptionalAttributes $newuser $ContactAttributes
            copySpecialMailboxTypeAttributes $newuser $ContactAttributes

            if ($LinkedMailUser)
            {
                copyLinkedMailboxTypeAttributes $newuser $ContactAttributes
            }
            
            [void](copyIfExist $newuser "targetAddress" $ContactAttributes)

            $srcProxyAddresses = $srcMbxAttributes.Item("proxyAddresses")
            $writeErrorIfTargetAddrNotExist = (-not $ContactAttributes.Contains("targetAddress"))
            $srcMbxTargetAddress = getTargetAddress $srcProxyAddresses $writeErrorIfTargetAddrNotExist
            if ($srcMbxTargetAddress -ne $null)
            {
                [void]$newuser.put("targetAddress", $srcMbxTargetAddress)
            }

            # Create the User first, so that we could update the link/backlink of the user before deleting local user.
            try
            {
                [void]($newuser.setinfo())
            }
            catch
            {
                # Terminiate the script if fail to create the new MEU.
                throw "Error creating MailUser cn=$newcn,$($localOU.distinguishedName) with with attributes from source MBX($($srcObject.distinguishedName)). Error: $($Error[0])"
            }
            $newuser.RefreshCache([array]"distinguishedName")
            Write-Host -ForegroundColor green "New MEU $($newuser.distinguishedname) created successfully."

            # backlink needs to be set after user is creaed correctly.
            setLinkedAttributes $localdc $newuser $ContactAttributes $localdc

            Write-Host -ForegroundColor red "Deleteing $($localusr.distinguishedname)"
            try
            {
                deleteLocalUser($localusr)
            }
            catch
            {
                # Terminate the script if fail to delete the object.
                throw "Error deleting local MailContact($($localusr.distinguishedname)). Error: $($Error[0])"
            }

            Write-Verbose "Updating MailUser with with attributes from source MBX($($srcObject.distinguishedName))."

            if ($LinkedMailUser)
            {
                copyLinkedMailboxTypeAttributes $newuser $srcMbxAttributes
            }

            # Set the proxyAddresses first before merging legacyDN.
            if ($OverwriteLocalObject)
            {
                [void](copyIfExist $newuser "proxyAddresses" $srcMbxAttributes)
            }

            $copyAttributes += "sAMAccountName",
                               "userPrincipalName"
            [void](copyIfExist $newuser $copyAttributes $srcMbxAttributes)
            [void]($newuser.put("msExchVersion", "44220983382016"))

            # Merge source object and original local user's LegacyDN to NEW local user's proxyAddresses.
            $X500proxyAddrsToUpdateLocalObj = @()
            if ($localUserOriginalLegacyDNToX500 -ne $null)
            {
                $X500proxyAddrsToUpdateLocalObj += $localUserOriginalLegacyDNToX500
            }
            if ($srcObject.properties.Contains("LegacyExchangeDN"))
            {
                $srcObjectLegacyDNX500 = "x500:" + $srcObject.properties.Item("LegacyExchangeDN")
                if (($localUserOriginalLegacyDNToX500 -ne $null) -and ($localUserOriginalLegacyDNToX500.ToString().ToUpper() -ne $srcObjectLegacyDNX500.ToString().ToUpper()))
                {
                    $X500proxyAddrsToUpdateLocalObj += $srcObjectLegacyDNX500
                }
            }
            mergeLegacyDNToProxyAddress $newuser $X500proxyAddrsToUpdateLocalObj $false "Local"

            [System.Threading.Thread]::Sleep(500)

            try
            {
                [void]($newuser.setinfo())
            }
            catch
            {
                Write-Error "Error updating MailUser cn=$newcn,$($localOU.distinguishedName). Error: $($Error[0])"
            }

            [void](disableEmailAddressPolicy($newuser))
            [void](generateLegacyExchangeDN($newuser))

            # new user's legacyDN will be merged to source object's proxyAddresses
            if ($newuser.properties.Contains("LegacyExchangeDN"))
            {
                $newUserLegacyDNX500 = "x500:" + $newuser.properties.Item("LegacyExchangeDN")
                if (($localUserOriginalLegacyDNToX500 -ne $null) -and ($localUserOriginalLegacyDNToX500.ToString().ToUpper() -ne $newUserLegacyDNX500.ToString().ToUpper()))
                {
                    $X500proxyAddrsToUpdateSrcObj += $newUserLegacyDNX500
                }
            }

            $userToUpdate = $newuser;
        }

        mergeLegacyDNToProxyAddress $srcObject $X500proxyAddrsToUpdateSrcObj $true "Source"

        # Overwrite local object from source object if -OverwriteLocalObject is specified.
        if ($OverwriteLocalObject)
        {
            Write-Verbose "OverwriteLocalObject specified. Updating MailUser with with attributes from source MBX($($srcObject.distinguishedName))."

            $srcAttributes = $srcObject.properties
            copyBasicAttributes $userToUpdate $srcAttributes
            copyGalySyncAttributes $userToUpdate $srcAttributes
            copyE2k7OptionalAttributes $userToUpdate $srcAttributes
            setLinkedAttributes $localdc $userToUpdate $srcAttributes $srcdc
            copySpecialMailboxTypeAttributes $userToUpdate $srcAttributes

            try
            {
                [void]($userToUpdate.setinfo())
            }
            catch
            {
                Write-Error "Error updating MailUser($($userToUpdate.DistinguishedName)). Error: $($Error[0])"
            }
        }

        "Preparation for $Identity done. Local recipient info Merged."
        $Global:movecount++
    }
    
    # ---------------------------------------------------------------------------------------------------
    # Delete specified local user through S.DS.P instead of ADSI. This is in order to fix bug #270965
    function deleteLocalUser ($localusr)
    # ---------------------------------------------------------------------------------------------------
    {
        $server = getMailContactOriginatingServer $localusr
        $cnx = createLocalLdapConnection $server
        $deleteRequest = [System.DirectoryServices.Protocols.DeleteRequest]($localusr.distinguishedName.ToString())
        [void]($cnx.SendRequest($deleteRequest))
        $cnx.Dispose()
    }

    # ---------------------------------------------------------------------------------------------------
    function getMailContactOriginatingServer($localusr)
    # ---------------------------------------------------------------------------------------------------
    {
        $mailContact = Get-MailContact $localusr.distinguishedName.Value @DomainControllerParameterSet
        $mailContactServer = $mailContact.OriginatingServer
        $server = $LocalForestDomainController
        if (($mailContactServer -ne $null) -and (-not [string]::IsNullOrEmpty($mailContactServer.ToString())))
        {
            $server = $mailContactServer.ToString()
        }
        Write-Verbose "Local MailContact's OriginatingServer is $server"
        return $server
    }

    # ---------------------------------------------------------------------------------------------------
    # Create a LdapConnection to the local server.
    function createLocalLdapConnection($server)
    # ---------------------------------------------------------------------------------------------------
    {
        $directoryId = [System.DirectoryServices.Protocols.LdapDirectoryIdentifier]($server)
        if ($LocalForestCredential -ne $null)
        {
            $cnx = new-object "System.DirectoryServices.Protocols.LdapConnection"($directoryId, $LocalForestCredential.GetNetworkCredential())
        }
        else
        {
            $cnx = new-object "System.DirectoryServices.Protocols.LdapConnection"($directoryId)
        }
            
        $cnx.SessionOptions.AutoReconnect = $true
        $cnx.SessionOptions.ReferralChasing = [System.DirectoryServices.Protocols.ReferralChasingOptions]::None
        $cnx.SessionOptions.Signing = $true
        $cnx.AuthType = [System.DirectoryServices.Protocols.AuthType]::Kerberos
        $cnx.Bind()
        
        return $cnx
    }
    
#=========================================================================================================
#                                         Initialize code
#=========================================================================================================
    [void]([System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols"))

    if ($OverwriteLocalObject -and (-not $UseLocalObject))
    {
        throw "Please specify -UseLocalObject when you specify -OverwriteLocalObject parameter."
    }

    $usr = $RemoteForestCredential.UserName
    $pwd = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($RemoteForestCredential.Password))
    
    if ($LocalForestCredential -ne $null)
    {
        $localusr = $LocalForestCredential.UserName
        $localpwd = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($LocalForestCredential.Password))
    }
    $Global:movecount = 0

    $srcdc   = New-Object DirectoryServices.DirectoryEntry("LDAP://$RemoteForestDomainController", $usr, $pwd)
    $DomainControllerParameterSet = @{}
    if ($srcdc.guid -eq $null)
    {
        #guid not present, consider src unavailable
        throw "Source Domain controller unavailable or authentication failed."
    }

    try {
        if ($LocalForestCredential -eq $null -and [string]::IsNullorEmpty($LocalForestDomainController))
        {
            $localdc = [ADSI]""
        }
        elseif ($LocalForestCredential -ne $null -and $LocalForestDomainController -ne $null)
        {
            $localdc = New-Object DirectoryServices.DirectoryEntry("LDAP://$LocalForestDomainController", $localusr, $localpwd)
            $DomainControllerParameterSet = @{ DomainController=$LocalForestDomainController; Credential=$LocalForestCredential }
        }
        else
        {
            throw "LocalForestCredential and LocalForestDomainController need to be specified at the same time"
        }

        $escapedtargetou = $null
        $filterObjectClass = $null
        if ([string]::IsNullOrEmpty($TargetMailUserOU))
        {
            # By default, the target OU is in Users container
            $escapedtargetou = "Users"
            $filterObjectClass = "Container"
        }
        else
        {
            $escapedtargetou = getEscapedldapFilterStr $TargetMailUserOU
            $filterObjectClass = "organizationalUnit"
        }
        $OUfilter = "(& (ObjectClass=$filterObjectClass)" +
                    "   (| (name=$escapedtargetou)" +
                    "      (distinguishedname=$escapedtargetou)))"
        $localOU =  findADObject $localdc $OUfilter
        if ($localOU -eq $null)
        {
            throw "Cannot find specified OU or Container: $TargetMailUserOU"
        }
    }
    catch
    {
        throw "Error looking up local OU, Error Msg: $($Error[0])"
    }
}

process
{    
    $escapedIdentity = getEscapedldapFilterStr $Identity
    $filterDN =   "(& (objectClass=user)(!objectClass=computer)" +
                  "   (distinguishedName=$escapedIdentity))"

    $filterParm = "(& (objectClass=user)(!objectClass=computer)" +
                  "   ( (| (mailnickname=$escapedIdentity)" + 
                  "        (cn=$escapedIdentity)" +
                  "        (proxyAddresses=SMTP:$escapedIdentity)" +
                  "        (proxyAddresses=smtp:$escapedIdentity)" +
                  "        (proxyAddresses=X500:$escapedIdentity)" +
                  "        (proxyAddresses=x500:$escapedIdentity)" +
                  "        (objectGUID=$escapedIdentity)" +
                  "        (displayname=$escapedIdentity))))"

    try
    {
        $srcObject = findADObject $srcdc $filterParm

        if ($srcObject -eq $null)
        {
            $srcObject = findADObject $srcdc $filterDN
        
            if ($srcObject -eq $null)
            {
                Write-Error "Error looking up source MBX $identity in source forest."
                return
            }
        }
    }
    catch
    {
        Write-Error "Faile to lookup the source object. Error $($Error[0])"
        return
    }
    
    if (-not $srcObject.properties.contains("mailNickName") -or -not $srcObject.properties.contains("msExchHomeServerName"))
    {
        Write-Error "Source Object $($srcObject.distinguishedName) found, but it is not a Mailbox!."
        return
    }
    
    $accountenable = ($srcObject.properties.Item("UserAccountControl").tostring() -band 0x2) -eq 0
    
    if (-not $accountenable -and -not $srcObject.properties.contains("msExchMasterAccountSid"))
    {
        Write-Error "Source Mailbox is invalid because it is disabled but did not set msExchMasterAccountSid."
        return
    }
    
    try
    {
        $localusr = findLocalObject $localdc $srcObject
    }
    catch
    {
        Write-Error "Error processing $identity, Mailbox not ready to move! Error message: $($error[0])"
        return
    }
    if ($localusr -eq $null)
    {
        try
        {
            #local recipient not exist, source object found, proceed the MEU creation process
            createMEUAndCopyAttrs $localdc $localOU $srcDC $srcObject
        }
        catch
        {
            Write-Error "Error while creating MEU. Error:$($Error[0])";
            return
        }
    }
    else
    {
        Write-Verbose "Local ad account with dupplicate proxy addresses found: $($localusr.distinguishedName)"
        try
        {
            $recipienttype = (get-recipient $localusr.distinguishedname.value @DomainControllerParameterSet).RecipientType
            if ($recipienttype -eq 'MailUniversalDistributionGroup' -or $recipienttype -eq 'UserMailbox' -or $recipienttype -eq 'DynamicDistributionGroup')
            {
                    write-error "Cannot create mail enabled user because an existing mailbox user or mail enabled group already has the same proxy addresses/MasterAccountSid."
            }
            elseif ($recipienttype -eq 'MailUser' -or $recipienttype -eq 'MailContact')
            {
                if ($UseLocalObject)
                {
                    forceMergeObject $recipienttype $localOU $localusr $localDC $srcObject $srcDC
                }
                else
                {
                    write-error ("Cannot create mail enabled user because an existing mail enabled user " +
                                 "or contact already has the same proxy addresses/MasterAccountSid. Please rerun the script with " + 
                                 "'-UseLocalObject' if you want to convert the existing email enabled user or contact to " +
                                 "a mail enabled user that is ready for online mailbox move.")
                }
            }
            else
            {
                write-error "Cannot create mail enabled user because an existing object with type $recipienttype already has the same proxy addresses/MasterAccountSid."
            }
        }
        catch
        {
            Write-Error "Fail to prepare local existed (same Proxyaddress or Masteraccoutsid) user $($localusr.distinguishedName) for move request. Error: $($Error[0])"
            return
        }
    }
}

end
{
    Write-Host -ForegroundColor Black -BackgroundColor Green "$movecount mailbox(s) ready to move."
}


# SIG # Begin signature block
# MIIbGAYJKoZIhvcNAQcCoIIbCTCCGwUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDQMHYTYymw+H0v9yYkkM+5DM
# L+6gghXnMIIEhTCCA22gAwIBAgIKYQh3XwAAAAAASjANBgkqhkiG9w0BAQUFADB5
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpN
# aWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQTAeFw0xMDA3MTkyMjUzMTBaFw0xMTEw
# MTkyMjUzMTBaMIGDMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MQ0wCwYDVQQLEwRNT1BSMR4wHAYDVQQDExVNaWNyb3NvZnQgQ29ycG9yYXRpb24w
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMfoB7QfqLtE2ZKUPd5vhS
# 31tCl70zGZzvtdrQwNzo8be+XOEKssI1oH7k89Q4p/IPQnKnupvPHyTeVg2Ec8zT
# Y/cXza9pb2FNTIBPyHccUWTI0wTzFCazuEI/M0Ow2yZZWJO1bYliDwdWW9USoLEJ
# zBYr+YzfYVboBnh/13OIJgNn0aP/NIKsLUzYAuztb7miMcUyTLv2/V9iW17x9mSR
# x4V3Rxz2pytHLQs3VE+2HwSNtexgJ6fzfrZ8oUyRpotx1sY1YUe8wRVL3awzIr4G
# GZZLih5uAOu+HmndWFkhAys8vuYTBRdmNaeGLRrx2TTAAYAa/JpGnW6k50jcNeo3
# AgMBAAGjggECMIH/MBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBTkb1/K
# iflTvvBwVwZQqsJ5DaxWmzAOBgNVHQ8BAf8EBAMCB4AwHwYDVR0jBBgwFoAUV0V0
# HF2w9shDBeCMVC2PMqf+SJYwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5t
# aWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvQ29kZVNpZ1BDQS5jcmwwTQYI
# KwYBBQUHAQEEQTA/MD0GCCsGAQUFBzAChjFodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL0NvZGVTaWdQQ0EuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQCW
# QV09XCukzrgqRS9CAl6hkBxMdCcJzgtUfXAoQXI7pBW80QRSV693dG0LVVeHNxBJ
# Htbm1MJjlLT9pC4t+l/iGVkVhNm3tulSolLeI18gL1nTqxqEfx3jveoP3wGIOSXY
# 7WRhGRt6r6YUSkZQSNlyS9VLkt3wD4R8y9PG8kx4bv28/2YQCvcDXRXqXpgMCdKZ
# jy61IL1h5slvBRQRy3v7Qgi9A/EmV2dNj1mLuETHRdNiBAwtMANYXuxI9G6oFDEE
# /TSiuAQtAt06oQlerWGxj3DAeFUjY6ifWXei27kbcSgc/C7hBI+17zS+SplH42RS
# Fjz6veDo4BQMECI0goIeMIIEyjCCA7KgAwIBAgIKYQPc9gAAAAAADDANBgkqhkiG
# 9w0BAQUFADB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEw
# HwYDVQQDExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EwHhcNMDgwNzI1MTkxMjUw
# WhcNMTEwNzI1MTkyMjUwWjCBszELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNO
# OjE1OUMtQTNGNy0yNTcwMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwO2BFKFed8Bb
# 9HaJYvqtfGgUtPe9NdgTeVoXytlsUUViJnovH9jqwW4BF/nDph9n21GwLN6KF+3/
# IK006pj7pdYq0vFEJwdaLTqT/1ZTsMj18wPyScwW0PUATFj4m/UHJbFmF8C9yNJS
# hY3CKziywza++Yfa9I5dQ9cGv5kFn6TO/quNYWPnOcXzGPbY/DE2aXJaohpMPuqH
# JUKd0T7xl9IYMpNwVVOBHuM7Dei+gnht5vrNmKRv2+5m9JXIzTXJnrs2DYOWlCan
# kOCpNDvVwJ4+8NRHjYYMgqRYMDocduOtlWa0t/0JigVgD6MP4pOWWCKcnSvbopQY
# kJUCvQZAlQIDAQABo4IBGTCCARUwHQYDVR0OBBYEFNLtDR4kuzep2CBqTR3SFtUu
# vp7rMB8GA1UdIwQYMBaAFCM0+NlSRnAK7UD7dvuzK7DDNbMPMFQGA1UdHwRNMEsw
# SaBHoEWGQ2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3Rz
# L01pY3Jvc29mdFRpbWVTdGFtcFBDQS5jcmwwWAYIKwYBBQUHAQEETDBKMEgGCCsG
# AQUFBzAChjxodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY3Jv
# c29mdFRpbWVTdGFtcFBDQS5jcnQwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDgYDVR0P
# AQH/BAQDAgbAMA0GCSqGSIb3DQEBBQUAA4IBAQCcClXIzEQTNAzYYyd2fT76ODKD
# U53yCPky9cVucKHJsWNrGZ0JZ9md64pq22Bm6elSJvM7xmrTwlK+qLnraqp4jMkW
# fZCVoMwhs56Bvc3Biym9YiXvCVfnhk4q7IDKu/whFsQ/TlIZ5g6x2MHCeZBktFBz
# EDVeXRHBuLqqz1L2gJEA5u9RQ0bp0OiU9iwkDYrGsjGKo342bKQFTGcHKru7EKWl
# MBpy0AYgOySTWxXZOZPTcy0axNRsHqEI7PYxuGtL7O5cMwIUMox8ESAvIAN/+Qyd
# uNOeX9YI/IGgmbi7VW7NQks6TYwUK8rIEtNibuoNCp0Jo2bZeU+OGqL/zJgEMIIG
# BzCCA++gAwIBAgIKYRZoNAAAAAAAHDANBgkqhkiG9w0BAQUFADBfMRMwEQYKCZIm
# iZPyLGQBGRYDY29tMRkwFwYKCZImiZPyLGQBGRYJbWljcm9zb2Z0MS0wKwYDVQQD
# EyRNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwHhcNMDcwNDAz
# MTI1MzA5WhcNMjEwNDAzMTMwMzA5WjB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSEwHwYDVQQDExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0Ew
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCfoWyx39tIkip8ay4Z4b3i
# 48WZUSNQrc7dGE4kD+7Rp9FMrXQwIBHrB9VUlRVJlBtCkq6YXDAm2gBr6Hu97IkH
# D/cOBJjwicwfyzMkh53y9GccLPx754gd6udOo6HBI1PKjfpFzwnQXq/QsEIEovmm
# bJNn1yjcRlOwhtDlKEYuJ6yGT1VSDOQDLPtqkJAwbofzWTCd+n7Wl7PoIZd++NIT
# 8wi3U21StEWQn0gASkdmEScpZqiX5NMGgUqi+YSnEUcUCYKfhO1VeP4Bmh1QCIUA
# EDBG7bfeI0a7xC1Un68eeEExd8yb3zuDk6FhArUdDbH895uyAc4iS1T/+QXDwiAL
# AgMBAAGjggGrMIIBpzAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQjNPjZUkZw
# Cu1A+3b7syuwwzWzDzALBgNVHQ8EBAMCAYYwEAYJKwYBBAGCNxUBBAMCAQAwgZgG
# A1UdIwSBkDCBjYAUDqyCYEBWJ5flJRP8KuEKU5VZ5KShY6RhMF8xEzARBgoJkiaJ
# k/IsZAEZFgNjb20xGTAXBgoJkiaJk/IsZAEZFgltaWNyb3NvZnQxLTArBgNVBAMT
# JE1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eYIQea0WoUqgpa1M
# c1j0BxMuZTBQBgNVHR8ESTBHMEWgQ6BBhj9odHRwOi8vY3JsLm1pY3Jvc29mdC5j
# b20vcGtpL2NybC9wcm9kdWN0cy9taWNyb3NvZnRyb290Y2VydC5jcmwwVAYIKwYB
# BQUHAQEESDBGMEQGCCsGAQUFBzAChjhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
# cGtpL2NlcnRzL01pY3Jvc29mdFJvb3RDZXJ0LmNydDATBgNVHSUEDDAKBggrBgEF
# BQcDCDANBgkqhkiG9w0BAQUFAAOCAgEAEJeKw1wDRDbd6bStd9vOeVFNAbEudHFb
# bQwTq86+e4+4LtQSooxtYrhXAstOIBNQmd16QOJXu69YmhzhHQGGrLt48ovQ7DsB
# 7uK+jwoFyI1I4vBTFd1Pq5Lk541q1YDB5pTyBi+FA+mRKiQicPv2/OR4mS4N9wfi
# cLwYTp2OawpylbihOZxnLcVRDupiXD8WmIsgP+IHGjL5zDFKdjE9K3ILyOpwPf+F
# ChPfwgphjvDXuBfrTot/xTUrXqO/67x9C0J71FNyIe4wyrt4ZVxbARcKFA7S2hSY
# 9Ty5ZlizLS/n+YWGzFFW6J1wlGysOUzU9nm/qhh6YinvopspNAZ3GmLJPR5tH4Lw
# C8csu89Ds+X57H2146SodDW4TsVxIxImdgs8UoxxWkZDFLyzs7BNZ8ifQv+AeSGA
# nhUwZuhCEl4ayJ4iIdBD6Svpu/RIzCzU2DKATCYqSCRfWupW76bemZ3KOm+9gSd0
# BhHudiG/m4LBJ1S2sWo9iaF2YbRuoROmv6pH8BJv/YoybLL+31HIjCPJZr2dHYcS
# ZAI9La9Zj7jkIeW1sMpjtHhUBdRBLlCslLCleKuzoJZ1GtmShxN1Ii8yqAhuoFuM
# Jb+g74TKIdbrHk/Jmu5J4PcBZW+JC33Iacjmbuqnl84xKf8OxVtc2E0bodj6L54/
# LlUWa8kTo/0wggaBMIIEaaADAgECAgphFQgnAAAAAAAMMA0GCSqGSIb3DQEBBQUA
# MF8xEzARBgoJkiaJk/IsZAEZFgNjb20xGTAXBgoJkiaJk/IsZAEZFgltaWNyb3Nv
# ZnQxLTArBgNVBAMTJE1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0
# eTAeFw0wNjAxMjUyMzIyMzJaFw0xNzAxMjUyMzMyMzJaMHkxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xIzAhBgNVBAMTGk1pY3Jvc29mdCBDb2Rl
# IFNpZ25pbmcgUENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn43f
# hTeMsQZWZjZO1ArrNiORHq+rjVjpxM/BnzoKJMTExF6w7hUUxfo+mTNrGWly9HwF
# X+WZJUTXNRmKkNwojpAM79WQYa3e3BhwLYPJb6+FLPjdubkw/XF4HIP9yKm5gmcN
# erjBCcK8FpdXPxyY02nXMJCQkI0wH9gm1J57iNniCe2XSUXrBFKBdXu4tSK4Lla7
# 18+pTjwKg6KoOsWttgEOas8itCMfbNUn57d+wbTVMq15JRxChuKdhfRX2htZLy0m
# kinFs9eFo55gWpTme5x7XoI0S23/1O4n0KLc0ZAMzn0OFXyIrDTHwGyYhErJRHlo
# KN8igw24iixIYeL+EQIDAQABo4ICIzCCAh8wEAYJKwYBBAGCNxUBBAMCAQAwHQYD
# VR0OBBYEFFdFdBxdsPbIQwXgjFQtjzKn/kiWMAsGA1UdDwQEAwIBxjAPBgNVHRMB
# Af8EBTADAQH/MIGYBgNVHSMEgZAwgY2AFA6sgmBAVieX5SUT/CrhClOVWeSkoWOk
# YTBfMRMwEQYKCZImiZPyLGQBGRYDY29tMRkwFwYKCZImiZPyLGQBGRYJbWljcm9z
# b2Z0MS0wKwYDVQQDEyRNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3Jp
# dHmCEHmtFqFKoKWtTHNY9AcTLmUwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2Ny
# bC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvbWljcm9zb2Z0cm9vdGNl
# cnQuY3JsMFQGCCsGAQUFBwEBBEgwRjBEBggrBgEFBQcwAoY4aHR0cDovL3d3dy5t
# aWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNyb3NvZnRSb290Q2VydC5jcnQwdgYD
# VR0gBG8wbTBrBgkrBgEEAYI3FS8wXjBcBggrBgEFBQcCAjBQHk4AQwBvAHAAeQBy
# AGkAZwBoAHQAIACpACAAMgAwADAANgAgAE0AaQBjAHIAbwBzAG8AZgB0ACAAQwBv
# AHIAcABvAHIAYQB0AGkAbwBuAC4wEwYDVR0lBAwwCgYIKwYBBQUHAwMwDQYJKoZI
# hvcNAQEFBQADggIBADC8sCCkYqCn7zkmYT3crMaZ0IbELvWDMmVeIj6b1ob46Laf
# yovWO3ULoZE+TN1kdIxJ8oiMGGds/hVmRrg6RkKXyJE31CSx56zT6kEUg3fTyU8F
# X6MUUr+WpC8+VlsQdc5Tw84FVGm0ZckkpQ/hJbgauU3lArlQHk+zmAwdlQLuIlmt
# IssFdAsERXsEWeDYD7PrTPhg3cJ4ntG6n2v38+5+RBFA0r26m0sWCG6kvlXkpjgS
# o0j0HFV6iiDRff6R25SPL8J7a6ZkhU+j5Sw0KV0Lv/XHOC/EIMRWMfZpzoX4CpHs
# 0NauujgFDOtuT0ycAymqovwYoCkMDVxcViNX2hyWDcgmNsFEy+Xh5m+J54/pmLVz
# 03jj7aMBPHTlXrxs9iGJZwXsl521sf2vpulypcM04S+f+fRqOeItBIJb/NCcrnyd
# EfnmtVMZdLo5SjnrfUKzSjs3PcJKeyeY5+JOmxtKVDhqIze+ardI7upCDUkkkY63
# BC6Xb+TnRbuPTf1g2ddZwtiA1mA0e7ehkyD+gbiqpVwJ6YoNvihNftfoD+1leNEx
# X7lm299C5wvMAgeN3/8gBqNFZbSzMo0ukeJNtKnJ+rxrBA6yn+qf3qTJCpb0jffY
# mKjwhQIIWaQgpiwLGvJSBu1p5WQYG+Cjq97KfBRhQ7hl9TajVRMrZyxNGzBMMYIE
# mzCCBJcCAQEwgYcweTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEjMCEGA1UEAxMaTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0ECCmEId18AAAAA
# AEowCQYFKw4DAhoFAKCByDAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUdgYoGPfu
# eieZg0rUI/bbBSn3LnkwaAYKKwYBBAGCNwIBDDFaMFigMIAuAFAAcgBlAHAAYQBy
# AGUALQBNAG8AdgBlAFIAZQBxAHUAZQBzAHQALgBwAHMAMaEkgCJodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vZXhjaGFuZ2UgMA0GCSqGSIb3DQEBAQUABIIBAKfQR0Cc
# wZOWJwBa6b9zX6HYE/sRnjMKZGxtt7Tefo8JWuyytojYAMteysWcGVrcoQOtSq/d
# O1LEdGM+LRDiAYp6GgxDtz9dIS74Czzs7XEbjHVZtshIN84dMCM4GZa/2ENfIOI5
# 4BnPJUY2/g817ZHsb1i33QF5iBMiB8C/Re4SDGzkcvGDtm1F5vxJVYp3LQ9Xbc64
# cXZSU+5McgIKt2ZoOiQN40lHlqVfa1xHpIIqbClAamUlMChyYLmwxhwg+/AMKyXu
# IgI4g9NGtsEdS3DqwnBi5QlvX7ERh2YikeYOy5n+Ohnm6P9ft/eChEyYwIGPJJfP
# Neqbn1yiGBHb6qKhggIdMIICGQYJKoZIhvcNAQkGMYICCjCCAgYCAQEwgYUwdzEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMYTWlj
# cm9zb2Z0IFRpbWUtU3RhbXAgUENBAgphA9z2AAAAAAAMMAcGBSsOAwIaoF0wGAYJ
# KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTEwMjE0MDEw
# OTI0WjAjBgkqhkiG9w0BCQQxFgQUIaYH7izIUrhzWv7vEbbJwYW2y58wDQYJKoZI
# hvcNAQEFBQAEggEASc58Vg70ThbYZG+N2ldHDRgOkcm+O/psTlFAXoXpwHzRZQLR
# 1JPXLs5AOS0De60wU367Sd7HWKDfiwBhd94n1RY6JmZEYEQnPpnu7vFZRYRX+82+
# bCiLvmaTG1c9Ozs/+NSM7CFk15k/UYiFLrwZVimOgRliyTcPeaxrk+qvYSh5qr/b
# LRyAiEVGOPwsveC2lVM9ubngdPrG7HlSq8Dgdficv/0Y1SCJ7hSDO7ueP61ycWy4
# SW2G0ZndJWXO0EsVo3XEzw/rBYPCb6/4JSwCYZNhLhAw4DwOGzBDJbvmKyKnY0fS
# DPUDFGK3/iAesX0sfXMs5EW7cv+Q5BnOjjhdgw==
# SIG # End signature block
