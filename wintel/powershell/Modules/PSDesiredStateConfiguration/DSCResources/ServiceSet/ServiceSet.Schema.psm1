Import-Module "$PSScriptRoot\..\CompositeResourceHelper.psm1"

Configuration ServiceSet
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.String[]]
    $Name,

    [ValidateSet('Automatic','Manual','Disabled')]
    [System.String]
    $StartupType,

    [ValidateSet('LocalSystem','LocalService','NetworkService')]
    [System.String]
    $BuiltInAccount,

    [ValidateSet('Running','Stopped')]
    [System.String]
    $State,

    [ValidateSet('Present','Absent')]
    [System.String]
    $Ensure,

    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    $Credential
    )  
    
    $psboundParams = $PSBoundParameters
    $optionalParameters = @("StartupType","BuiltInAccount","State","Ensure","Credential")
    $keyParamName = "Name"
    $resourceName = "Service"

    #build common parameters for all Service resource nodes
    [string] $commonParameters = BuildResourceCommonParameters -KeyParamName $keyParamName -OptionalParams $optionalParameters -PSBoundParams $psboundParams
    
    #build Service resource string
    [string] $resourceString = BuildResourceString -KeyParam $Name -KeyParamName $keyParamName -CommonParams $commonParameters -ResourceName $resourceName

    $configScript = [scriptblock]::Create($resourceString)
    . $configScript
}