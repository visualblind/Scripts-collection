Import-Module "$PSScriptRoot\..\CompositeResourceHelper.psm1"

Configuration WindowsOptionalFeatureSet
{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.String[]]
    $Name,

    [Parameter(Mandatory=$true)]
    [ValidateSet('Enable','Disable')]
    [System.String]
    $Ensure,

    [ValidateNotNullOrEmpty()]
    [System.String[]]
    $Source,

    [System.Boolean]
    $RemoveFilesOnDisable,

    [ValidateNotNullOrEmpty()]
    [System.String]
    $LogPath,

    [System.Boolean]
    $NoWindowsUpdateCheck,

    [ValidateSet('ErrorsOnly','ErrorsAndWarning','ErrorsAndWarningAndInformation')]
    [System.String]
    $LogLevel
    )
    
    $psboundParams = $PSBoundParameters
    $optionalParameters = @("Ensure","Source","RemoveFilesOnDisable","LogPath","NoWindowsUpdateCheck","LogLevel")
    $keyParamName = "Name"
    $resourceName = "WindowsOptionalFeature"

    #build common parameters for all WindowsOptionalFeature resource nodes
    [string] $commonParameters = BuildResourceCommonParameters -KeyParamName $keyParamName -OptionalParams $optionalParameters -PSBoundParams $psboundParams
    
    #build WindowsOptionalFeature resource string
    [string] $resourceString = BuildResourceString -KeyParam $Name -KeyParamName $keyParamName -CommonParams $commonParameters -ResourceName $resourceName

    $configScript = [scriptblock]::Create($resourceString)
    . $configScript
}