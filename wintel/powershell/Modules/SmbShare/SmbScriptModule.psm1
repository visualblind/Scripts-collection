 data _system_translations 
 {
    ConvertFrom-StringData @'

    # Fallback text
    # Copy all the strings in the psd1 file here

    msg_ad_forest = SMB Delegation cmdlets require the Active Directory forest to be in Windows Server 2012 forest functional level.

    msg_ad_cmdlets = SMB Delegation cmdlets require the installation of the Active Directory module for Windows PowerShell.

'@
}
 
Import-LocalizedData -BindingVariable _system_translations -fileName SmbLocalization.psd1

 function Set-SmbPathAcl
 {
     [CmdletBinding()]
     param(
        [Parameter(Mandatory=$true)]
        [string]
        $ShareName,

        [Parameter()]
        [string]
        $ScopeName = $null
    )

    if( ($null -ne $ScopeName ) -and ( "" -ne $ScopeName) )
    {
        (Get-SmbShare -Name $ShareName -ScopeName $ScopeName ).PresetPathACL | Set-Acl
    }
    else
    {
        (Get-SmbShare -Name $ShareName ).PresetPathACL | Set-Acl
    }

 }

function CheckDelegationPrerequisites
{
    if( $null -eq (Get-Command -Module ActiveDirectory) )
    {
        Write-Error $_system_translations.msg_ad_cmdlets

        return $false
    }

    #
    # Forest mode should be greater than or equal to Windows2012Forest
    #
    if( (Get-AdForest).ForestMode.ToInt32($null) -lt [Microsoft.ActiveDirectory.Management.AdForestMode]::Windows2012Forest.ToInt32($null) )
    {
        Write-Error $_system_translations.msg_ad_forest

        return $false
    }

    return $true
}

 function Get-SmbDelegation
 {
     [CmdletBinding()]
     param(
        [Parameter(Mandatory=$true)]
        [string]
        $SmbServer
    )

    $check = CheckDelegationPrerequisites

    if( -not $check )
    {
        return
    }

    $result = @()

    $fsAD = Get-ADComputer -filter {Name -Like $SmbServer} -Properties 'msds-allowedtoactonbehalfofotheridentity'
    
    foreach ($AllowedAccount in $fsAD."msDS-AllowedToActOnBehalfOfOtherIdentity".Access) 
    { 
        $samAccountName = $AllowedAccount.IdentityReference.Value 
        $samAccountName = $samAccountName.Remove(0, ($samAccountName.IndexOf("\")+1))

        $result += Get-ADComputer -Filter {SamAccountName -Like $samAccountName} 
    }

    $result.Name
 }

 function Enable-SmbDelegation
 {
     [CmdletBinding()]
     param(
        [Parameter(Mandatory=$true)]
        [string]
        $SmbClient,

        [Parameter(Mandatory=$true)]
        [string]
        $SmbServer
    )

    $check = CheckDelegationPrerequisites

    if( -not $check )
    {
        return
    }

    $delegationPrinciples = @() 
    $fsAD = Get-ADComputer -Filter {Name -Like $SmbServer} -Properties msDS-AllowedToActOnBehalfOfOtherIdentity

    foreach ($AllowedAccount in $fsAD."msDS-AllowedToActOnBehalfOfOtherIdentity".Access) 
    { 
        $samAccountName = $AllowedAccount.IdentityReference.Value 
        $samAccountName = $samAccountName.Remove(0, ($samAccountName.IndexOf("\")+1))

        $delegationPrinciples += Get-ADComputer -Filter {SamAccountName -Like $samAccountName} 
    }

    $delegationPrinciples += Get-ADComputer -Identity $SmbClient 
    $fsAD | Set-ADComputer -PrincipalsAllowedToDelegateToAccount $delegationPrinciples 
 }


 function Disable-SmbDelegation
 {
     [CmdletBinding()]
     param(
        [Parameter()]
        [string]
        $SmbClient,

        [Parameter(Mandatory=$true)]
        [string]
        $SmbServer,

        [System.Management.Automation.SwitchParameter]
        [bool]
        $Force = $false
    )

    $check = CheckDelegationPrerequisites

    if( -not $check )
    {
        return
    }

    $delegationPrinciples = @() 
    $fsAD = Get-ADComputer -Filter {Name -Like $SmbServer} -Properties msDS-AllowedToActOnBehalfOfOtherIdentity

    if( ($null -ne $SmbClient) -and ("" -ne $SmbClient) )
    {
        foreach ($AllowedAccount in $fsAD."msDS-AllowedToActOnBehalfOfOtherIdentity".Access) 
        { 
            $samAccountName = $AllowedAccount.IdentityReference.Value 
            $samAccountName = $samAccountName.Remove(0, ($samAccountName.IndexOf("\")+1))

            $adc = Get-ADComputer -Filter {SamAccountName -Like $samAccountName} 

            if( $adc.Name -ne $SmbClient )
            {
                $delegationPrinciples += $adc
            }
        }
    }

    $fsAD | Set-ADComputer -PrincipalsAllowedToDelegateToAccount $delegationPrinciples 
 }

 Set-Alias -Name ssmbp -Value Set-SmbPathAcl
 Set-Alias -Name gsmbd -Value Get-SmbDelegation
 Set-Alias -Name esmbd -Value Enable-SmbDelegation
 Set-Alias -Name dsmbd -Value Disable-SmbDelegation


 Export-ModuleMember -Function Set-SmbPathAcl -Alias ssmbp
 Export-ModuleMember -Function Get-SmbDelegation -Alias gsmbd
 Export-ModuleMember -Function Enable-SmbDelegation -Alias esmbd
 Export-ModuleMember -Function Disable-SmbDelegation -Alias dsmbd