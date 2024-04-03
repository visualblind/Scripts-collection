Import-Module "$PSScriptRoot\..\CompositeResourceHelper.psm1"

Configuration ProcessSet
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.String[]]
    $Path,

    [ValidateNotNullOrEmpty()]
    [System.Management.Automation.PSCredential]
    $Credential,

    [ValidateSet('Present','Absent')]
    [System.String]
    $Ensure,

    [System.String]
    $StandardOutputPath,

    [System.String]
    $StandardErrorPath,

    [System.String]
    $StandardInputPath,

    [System.String]
    $WorkingDirectory
    )

    $psboundParams = $PSBoundParameters
    $optionalParameters = @("Credential","Ensure","StandardOutputPath","StandardErrorPath","StandardInputPath","WorkingDirectory")
    $keyParamName = "Path"
    $resourceName = "WindowsProcess"

    #build common parameters for all WindowsProcess resource nodes
    [string] $commonParameters = BuildResourceCommonParameters -KeyParamName $keyParamName -OptionalParams $optionalParameters -PSBoundParams $psboundParams
    
    #Arguments is a key parameter in WindowsProcess resource. Adding it as default parameter with an empty value string
    $defaultParam = 'Arguments = ""'

    #build WindowsProcess resource string
    [string] $resourceString = BuildResourceString -KeyParam $Path -KeyParamName $keyParamName -CommonParams $commonParameters -ResourceName $resourceName -DefaultParams $defaultParam

    $configScript = [scriptblock]::Create($resourceString)
    . $configScript
}