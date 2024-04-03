Import-Module "$PSScriptRoot\..\CompositeResourceHelper.psm1"

Configuration GroupSet
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.String[]]
    $GroupName,

    [ValidateSet('Present','Absent')]
    [System.String]
    $Ensure,

    [System.String[]]
    $MembersToInclude,

    [System.String[]]
    $MembersToExclude,

    [ValidateNotNullOrEmpty()]
    [System.Management.Automation.PSCredential]
    $Credential
    )

    $psboundParams = $PSBoundParameters
    $optionalParameters = @("Ensure","MembersToInclude","MembersToExclude","Credential")
    $keyParamName = "GroupName"
    $resourceName = "Group"

    #build common parameters for all Group resource nodes
    [string] $commonParameters = BuildResourceCommonParameters -KeyParamName $keyParamName -OptionalParams $optionalParameters -PSBoundParams $psboundParams
    
    #build Group resource string
    [string] $resourceString = BuildResourceString -KeyParam $GroupName -KeyParamName $keyParamName -CommonParams $commonParameters -ResourceName $resourceName

    $configScript = [scriptblock]::Create($resourceString)
    . $configScript
}