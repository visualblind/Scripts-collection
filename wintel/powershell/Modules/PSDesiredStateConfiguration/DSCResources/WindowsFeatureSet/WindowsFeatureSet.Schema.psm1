Import-Module "$PSScriptRoot\..\CompositeResourceHelper.psm1"

Configuration WindowsFeatureSet
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.String[]]
    $Name,

    [ValidateSet('Present','Absent')]
    [System.String]
    $Ensure,

    [ValidateNotNullOrEmpty()]
    [System.String]
    $Source,

    [System.Boolean]
    $IncludeAllSubFeature,

    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    $Credential,

    [ValidateNotNullOrEmpty()]
    [System.String]
    $LogPath
    )

    $psboundParams = $PSBoundParameters
    $optionalParameters = @("Ensure","Source","IncludeAllSubFeature","Credential","LogPath")
    $keyParamName = "Name"
    $resourceName = "WindowsFeature"

    #build common parameters for all WindowsFeature resource nodes
    [string] $commonParameters = BuildResourceCommonParameters -KeyParamName $keyParamName -OptionalParams $optionalParameters -PSBoundParams $psboundParams
    
    #build WindowsFeature resource string
    [string] $resourceString = BuildResourceString -KeyParam $Name -KeyParamName $keyParamName -CommonParams $commonParameters -ResourceName $resourceName

    $configScript = [scriptblock]::Create($resourceString)
    . $configScript
}