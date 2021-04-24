# ADName.psm1
# Written by Bill Stewart (bstewart@iname.com)
#
# Implements the NameTranslate and Pathname COM objects as easy-to-use
# PowerShell functions.
#
# Version history:
#
# 1.0.0.0 (2017-04-06)
# * Initial version. Based on my articles Translate-ADName.ps1 and
# Get-ADPathname.ps1 that I published in Windows IT Pro. I refactored and
# cleaned up the code and made it (I hope) easier to read.
#
# 1.0.0.2 (2017-07-25)
# * Renamed Edit-ADName to Get-ADName.

#requires -version 3

#------------------------------------------------------------------------------
# IADsNameTranslate enumeration values
#------------------------------------------------------------------------------
$ADS_NAME_INITTYPE_ENUM = @{
  "Domain" = 1
  "Server" = 2
  "GC"     = 3
}
$ADS_NAME_TYPE_ENUM = @{
  "1779"             = 1
  "DN"               = 1
  "X500DN"           = 1
  "Canonical"        = 2
  "NT4"              = 3
  "Display"          = 4
  "DomainSimple"     = 5
  "EnterpriseSimple" = 6
  "GUID"             = 7
  "Unknown"          = 8
  "UPN"              = 9
  "CanonicalEx"      = 10
  "SPN"              = 11
  "SIDorSIDhistory"  = 12
}
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# IADsPathname enumeration values
#------------------------------------------------------------------------------
$ADS_SETTYPE_ENUM = @{
  "Full" = 1
  "DN"   = 4
}
$ADS_FORMAT_ENUM = @{
  "Windows"         = 1
  "WindowsNoServer" = 2
  "WindowsDN"       = 3
  "WindowsParent"   = 4
  "X500"            = 5
  "X500NoServer"    = 6
  "X500DN"          = 7
  "DN"              = 7
  "1779"            = 7
  "X500Parent"      = 8
  "Parent"          = 8
  "Server"          = 9
  "Provider"        = 10
  "Leaf"            = 11
}
$ADS_ESCAPE_MODE_ENUM = @{
  "Default" = 1
  "On"      = 2
  "Off"     = 3
  "OffEx"   = 4
}
$ADS_DISPLAY_ENUM = @{
  "Full"       = 1
  "ValuesOnly" = 2
}
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Wrapper methods for the COM objects
#------------------------------------------------------------------------------
function Invoke-Method {
  param(
    [__ComObject] $object,
    [String] $method,
    $parameters
  )
  $output = $object.GetType().InvokeMember($method, "InvokeMethod", $null, $object, $parameters)
  if ( $output ) { $output }
}
function Set-Property {
  param(
    [__ComObject] $object,
    [String] $property,
    $parameters
  )
  [Void] $object.GetType().InvokeMember($property, "SetProperty", $null, $object, $parameters)
}
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Create the COM objects
#------------------------------------------------------------------------------
$NameTranslate = New-Object -ComObject "NameTranslate"
$Pathname = New-Object -ComObject "Pathname"
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Writes a custom error to the error stream
#------------------------------------------------------------------------------
function Write-CustomError {
  param(
    [Exception] $exception,
    $targetObject,
    [String] $errorID,
    [Management.Automation.ErrorCategory] $errorCategory="NotSpecified",
    [Switch] $terminatingError
  )
  $errorRecord = New-Object Management.Automation.ErrorRecord($exception,$errorID,$errorCategory,$targetObject)
  if ( $terminatingError ) {
    $PSCmdlet.ThrowTerminatingError($errorRecord)
  }
  else {
    $PSCmdlet.WriteError($errorRecord)
  }
}
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
function Convert-ADName {
  <# 
  .SYNOPSIS 
  Converts Active Directory names between various formats. 
 
  .DESCRIPTION 
  Converts Active Directory (AD) names between various formats by using the NameTranslate COM object. The NameTranslate COM object implements the IADsNameTranslate interface (see RELATED LINKS). The NameTranslate object converts AD names by binding to a global catalog or to a specific domain or server name. 
 
  .PARAMETER OutputType 
  Specifies the output type for the name(s), which must be one of the following: 
    DN Distinguished name; e.g.: CN=Ken Dyer,CN=Users,DC=... 
    1779 Same as DN 
    X500DN Same as DN 
    Canonical Canonical name; e.g.: fabrikam.com/Users/Ken Dyer 
    NT4 Domain\username; e.g.: fabrikam\kdyer 
    Display Display name 
    DomainSimple Simple domain name format 
    EnterpriseSimple Simple enterprise name format 
    GUID GUID; e.g.: {95ee9fff-3436-11d1-b2b0-d15ae3ac8436} 
    UPN User principal name; e.g.: kdyer@fabrikam.com 
    CanonicalEx Extended canonical name format 
    SPN Service principal name format 
  This parameter's values correspond to the ADS_NAME_TYPE_ENUM enumeration's values (see RELATED LINKS). 
 
  .PARAMETER Name 
  Specifies one or more AD name(s) to convert. This parameter does not support wildcards. 
 
  .PARAMETER InputType 
  Specifies the input name type. Possible values are the same as the values supported by the -OutputType parameter, with the following additions: 
    Unknown The system will estimate the name format 
    SIDorSIDhistory SDDL string for the object's SID or one in its SID history 
  The default value for this parameter is "Unknown". This parameter's values correspond to the ADS_NAME_TYPE_ENUM enumeration's values (see RELATED LINKS). 
 
  .PARAMETER InitType 
  Specifies how to initialize the NameTranslate object. This parameter must be either "Domain" or "Server". If you omit this parameter, the default is to find and use a global catalog. This parameter's values correspond to the ADS_NAME_INITTYPE_DOMAIN and ADS_NAME_INITTYPE_SERVER values of the ADS_NAME_INITTYPE_ENUM enumeration (see RELATED LINKS). 
 
  .PARAMETER InitName 
  Specifies the name of the domain or server to bind to when the -InitType parameter is set to "Domain" or "Server". 
 
  .PARAMETER ChaseReferrals 
  Specifies whether to chase referrals. (When a server determines that other servers hold relevant data, in part or as a whole, it may refer the client to another server to obtain the result. Referral chasing is the action taken by a client to contact the referred-to server to continue the directory search.) 
 
  .PARAMETER Credential 
  Specifies credentials to use when binding to a global catalog, server, or domain. If you omit this parameter, the current credentials are used. 
 
  .INPUTS 
  System.String 
 
  .OUTPUTS 
  System.String 
 
  .EXAMPLE 
  PS C:\> Convert-ADName Canonical "CN=Ken Dyer,OU=Engineers,DC=fabrikam,DC=com" 
  This command outputs the specified DN as a canonical name. 
 
  .EXAMPLE 
  PS C:\> Convert-ADName -OutputType DN -Name fabrikam\kdyer 
  This command outputs the specified domain\username as a distinguished name. 
 
  .EXAMPLE 
  PS C:\> Convert-ADName DN fabrikam\kdyer -InitType Server -InitName dc1 
  This command uses the server dc1 to convert the specified name. 
 
  .EXAMPLE 
  PS C:\> Convert-ADName Display fabrikam\kdyer -InitType Domain -InitName fabrikam 
  This command uses the fabrikam domain to convert the specified name. 
 
  .EXAMPLE 
  PS C:\> Convert-ADName DN "fabrikam.com/Engineers/Ken Dyer" -Credential (Get-Credential) 
  Prompts for credentials, then uses those credentials to convert the specified name. 
 
  .EXAMPLE 
  PS C:\> Get-Content DNs.txt | Convert-ADName -OutputType Display -InputType DN 
  Outputs the display names for each of the distinguished names in the file DNs.txt. 
 
  .LINK 
  IADsNameTranslate Interface - http://msdn.microsoft.com/en-us/windows/aa706046.aspx 
  ADS_NAME_TYPE_ENUM Enumeration - http://msdn.microsoft.com/en-us/windows/aa772267.aspx 
  ADS_NAME_INITTYPE_ENUM Enumeration - http://msdn.microsoft.com/en-us/windows/aa772266.aspx 
  #>
  [CmdletBinding(DefaultParameterSetName="GC")]
  param(
    [Parameter(ParameterSetName="GC",            Position=0,Mandatory=$true)]
    [Parameter(ParameterSetName="DomainOrServer",Position=0,Mandatory=$true)]
      [String]
      [ValidateSet("DN","1779","X500DN","Canonical","NT4","Display","DomainSimple","EnterpriseSimple","GUID","UPN","CanonicalEx","SPN")]
      $OutputType,
    [Parameter(ParameterSetName="GC",            Position=1,Mandatory=$true,ValueFromPipeline=$true)]
    [Parameter(ParameterSetName="DomainOrServer",Position=1,Mandatory=$true,ValueFromPipeline=$true)]
      [String[]]
      $Name,
    [Parameter(ParameterSetName="GC")]
    [Parameter(ParameterSetName="DomainOrServer")]
      [String]
      [ValidateSet("1779","DN","X500DN","Canonical","NT4","Display","DomainSimple","EnterpriseSimple","GUID","Unknown","UPN","CanonicalEx","SPN","SIDorSIDhistory")]
      $InputType="Unknown",
    [Parameter(ParameterSetName="DomainOrServer",Mandatory=$true)]
      [String]
      [ValidateSet("Domain","Server")]
      $InitType,
    [Parameter(ParameterSetName="DomainOrServer",Mandatory=$true)]
      [String]
      $InitName,
    [Parameter(ParameterSetName="GC")]
    [Parameter(ParameterSetName="DomainOrServer")]
      [Switch]
      $ChaseReferrals,
    [Parameter(ParameterSetName="GC")]
    [Parameter(ParameterSetName="DomainOrServer")]
      [Management.Automation.PSCredential] $Credential
  )

  begin {
    # Use global catalog by default (use separate variable because $InitType
    # uses ValidateSet)
    if ( $PSCmdlet.ParameterSetName -eq "GC" ) {
      $InitTypeName = "GC"
    }
    else {
      $InitTypeName = $InitType
    }

    # If -Credential, use InitEx
    if ( $Credential ) {
      $networkCredential = $Credential.GetNetworkCredential()
      try {
        Invoke-Method $NameTranslate "InitEx" (
          $ADS_NAME_INITTYPE_ENUM[$InitTypeName],
          $InitName,
          $networkCredential.UserName,
          $networkCredential.Domain,
          $networkCredential.Password
        )
      }
      catch [Management.Automation.MethodInvocationException] {
        Write-CustomError `
          -exception $_.Exception.InnerException `
          -targetObject $null `
          -errorID (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name `
          -errorCategory NotSpecified `
          -terminatingError
      }
      finally {
        Remove-Variable networkCredential
      }
    }
    else {
      try {
        Invoke-Method $NameTranslate "Init" (
          $ADS_NAME_INITTYPE_ENUM[$InitTypeName],
          $InitName
        )
      }
      catch [Management.Automation.MethodInvocationException] {
        Write-CustomError `
          -exception $_.Exception.InnerException `
          -targetObject $null `
          -errorID (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name `
          -errorCategory NotSpecified `
          -terminatingError
      }
    }

    # If -ChaseReferrals, set the object's ChaseReferral property to
    # ADS_CHASE_REFERRALS_ALWAYS (0x60 - only supported value); otherwise use
    # 0 (ADS_CHASE_REFERRALS_NEVER)
    if ( $ChaseReferrals ) {
      Set-Property $NameTranslate "ChaseReferral" @(0x60)
    }
    else {
      Set-Property $NameTranslate "ChaseReferral" @(0)
    }

    function NameTranslate {
      param(
        [String] $name,
        [Int] $inputType,
        [Int] $outputType
      )
      try {
        Invoke-Method $NameTranslate "Set" @($inputType, $name)
        Invoke-Method $NameTranslate "Get" @($outputType)
      }
      catch [Management.Automation.MethodInvocationException] {
        Write-CustomError `
          -exception $_.Exception.InnerException `
          -targetObject $name `
          -errorID (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name `
          -errorCategory NotSpecified
      }
    }
  }

  process {
    foreach ( $nameItem in $Name ) {
      NameTranslate $nameItem $ADS_NAME_TYPE_ENUM[$InputType] $ADS_NAME_TYPE_ENUM[$OutputType]
    }
  }
}
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
function Get-ADName {
  <# 
  .SYNOPSIS 
  Outputs Active Directory path names in various formats. 
 
  .DESCRIPTION 
  Outputs Active Directory (AD) path names in various formats using the Pathname COM object. The Pathname COM object implements the IADsPathname interface (see RELATED LINKS). This is a more robust means of handling AD path names than string parsing because it supports escaping of special characters. 
 
  .PARAMETER Name 
  Specifies one or more AD path names, in distinguished name (DN) format; e.g.: "CN=Ken Dyer,DC=fabrikam,DC=com". If using the Full type (see -Type parameter), include the provider and/or server; e.g.: "LDAP://CN=Ken Dyer,DC=fabrikam,DC=com" or "LDAP://server/CN=Ken Dyer,DC=fabrikam,DC=com". This parameter does not accept wildcards. 
 
  .PARAMETER Format 
  Specifies the format in which to output the AD path name(s), and must be one of the following values: 
    DN Distinguished name (DN) format 
    X500DN Same as DN 
    1779 Same as DN 
    X500 DN format with provider 
    X500NoServer DN format with provider but without server 
    Parent DN format, parent only 
    Leaf Leaf only 
    Provider Provider only (e.g., "LDAP") 
    X500Parent Same as Parent 
    Server Server name only 
    Windows Windows format (rarely used) 
    WindowsNoServer Windows format without server (rarely used) 
    WindowsDN Windows format, distinguished name only (rarely used) 
    WindowsParent Windows format, parent only (rarely used) 
  The default value for this parameter is "DN". This parameter's values correspond to the ADS_FORMAT_ENUM enumeration's values (see RELATED LINKS). 
 
  .PARAMETER Type 
  Specifies the type of the AD path name(s). This parameter must be one of the following values: "DN" or "Full". If you specify "Full", include the provider and/or server. 
 
  .PARAMETER Retrieve 
  Outputs the AD path name(s) using the format specified by the -Format parameter. This is the default parameter. 
 
  .PARAMETER AddLeafElement 
  Adds the specified leaf element(s) to the AD path name(s) and outputs the new AD path name(s) using the format specified by the -Format parameter. 
 
  .PARAMETER RemoveLeafElement 
  Removes the final leaf element from the AD path name(s) and outputs the new AD path name(s) using the format specified by the -Format parameter. 
 
  .PARAMETER Split 
  Outputs a list of the elements in the AD path name(s). 
 
  .PARAMETER GetEscapedElement 
  Outputs one or more AD path name element(s) with escape ("\") characters inserted in the correct places. 
 
  .PARAMETER EscapedMode 
  Specifies how escape characters are output for the AD path name(s). This parameter must be one of the following values: "Default", "On", "Off", or "OffEx". The default value for this parameter is "Default". This parameter's values correspond to the ADS_ESCAPE_MODE_ENUM enumeration's values (see RELATED LINKS). 
 
  .PARAMETER ValuesOnly 
  Specifies how elements in an AD path name are output. If this parameter is absent, name elements are output using both attributes and values (e.g., "CN=Ken Dyer"). If this parameter is present, name elements are output with values only (e.g., "Ken Dyer"). 
 
  .INPUTS 
  System.String 
 
  .OUTPUTS 
  System.String 
 
  .EXAMPLE 
  PS C:\> Get-ADName "LDAP://CN=Ken Dyer,CN=Users,DC=fabrikam,DC=com" -Type Full 
  Outputs "CN=Ken Dyer,CN=Users,DC=fabrikam,DC=com". The -Type parameter indicates that the AD path name contains a provider (LDAP). 
 
  .EXAMPLE 
  PS C:\> Get-ADName "CN=Ken Dyer,CN=Users,DC=fabrikam,DC=com" -RemoveLeafElement 
  This command removes the leaf element ("CN=Ken Dyer") from the AD path name and outputs "CN=Users,DC=fabrikam,DC=com". 
 
  .EXAMPLE 
  PS C:\> Get-ADName "CN=Ken Dyer,CN=Users,DC=fabrikam,DC=com" -Format Parent 
  This command outputs only the parent of the AD path name; e.g.: "CN=Users,DC=fabrikam,DC=com". 
 
  .EXAMPLE 
  PS C:\> Get-ADName "CN=Jeff Smith,CN=H/R,DC=fabrikam,DC=com" -Format X500 
  This commands outputs the AD path element in X500 format "LDAP://CN=Jeff Smith,CN=H\/R,DC=fabrikam,DC=com". Note that the X500 format automatically includes escape characters (i.e., it is not necessary to use -EscapedMode On). 
 
  .EXAMPLE 
  PS C:\> Get-ADName "CN=H/R,DC=fabrikam,DC=com" -AddLeafElement "CN=Jeff Smith" -EscapedMode On 
  This command outputs "CN=Jeff Smith,CN=H\/R,DC=fabrikam,DC=com" with necessary escape characters inserted. 
 
  .EXAMPLE 
  PS C:\> Get-ADName "CN=Ken Dyer,CN=Users,DC=fabrikam,DC=com" -Split 
  This command splits the AD path name and outputs a list of the elements: "CN=Ken Dyer", "CN=Users", "DC=fabrikam", and "DC=com". 
 
  .EXAMPLE 
  PS C:\> Get-Content DistinguishedNames.txt | Get-ADName -EscapedMode On 
  This command outputs all of the AD path names listed in the file DistinguishedNames.txt with the needed escape characters. 
 
  .EXAMPLE 
  PS C:\> Get-ADName -GetEscapedElement "OU=H/R" 
  This command inserts the needed escape characters into the name element and outputs "OU=H\/R". 
 
  .LINK 
  IADsPathname Interface - http://msdn.microsoft.com/en-us/library/windows/desktop/aa706070.aspx 
  ADS_FORMAT_ENUM Enumeration - http://msdn.microsoft.com/en-us/library/windows/desktop/aa772261.aspx 
  ADS_ESCAPE_MODE_ENUM Enumeration - http://msdn.microsoft.com/en-us/library/windows/desktop/aa772257.aspx 
  #>
  [CmdletBinding(DefaultParameterSetName="Retrieve")]
  param(
    [Parameter(ParameterSetName="Retrieve",         Position=0,Mandatory=$true,ValueFromPipeline=$true)]
    [Parameter(ParameterSetName="AddLeafElement",   Position=0,Mandatory=$true,ValueFromPipeline=$true)]
    [Parameter(ParameterSetName="RemoveLeafElement",Position=0,Mandatory=$true,ValueFromPipeline=$true)]
    [Parameter(ParameterSetName="Split",            Position=0,Mandatory=$true,ValueFromPipeline=$true)]
    [Alias("Path")]
      [String[]]
      $Name,
    [Parameter(ParameterSetName="Retrieve",         Position=1)]
    [Parameter(ParameterSetName="AddLeafElement",   Position=1)]
    [Parameter(ParameterSetName="RemoveLeafElement",Position=1)]
    [Alias("OutputType")]
      [String]
      [ValidateSet("DN","X500DN","1779","X500","X500NoServer","Parent","Leaf","Provider","X500Parent","Server","Windows","WindowsNoServer","WindowsDN","WindowsParent")]
      $Format="DN",
    [Parameter(ParameterSetName="Retrieve")]
    [Parameter(ParameterSetName="AddLeafElement")]
    [Parameter(ParameterSetName="RemoveLeafElement")]
    [Parameter(ParameterSetName="Split")]
    [Alias("InputType")]
      [String]
      [ValidateSet("DN","Full")]
      $Type="DN",
    [Parameter(ParameterSetName="Retrieve")]
      [Switch]
      $Retrieve,
    [Parameter(ParameterSetName="AddLeafElement",Mandatory=$true)]
      [String[]]
      $AddLeafElement,
    [Parameter(ParameterSetName="RemoveLeafElement",Mandatory=$true)]
      [Switch]
      $RemoveLeafElement,
    [Parameter(ParameterSetName="Split",Mandatory=$true)]
      [Switch]
      $Split,
    [Parameter(ParameterSetName="Retrieve")]
    [Parameter(ParameterSetName="AddLeafElement")]
    [Parameter(ParameterSetName="RemoveLeafElement")]
    [Parameter(ParameterSetName="Split")]
      [String]
      [ValidateSet("Default","On","Off","OffEx")]
      $EscapedMode,
    [Parameter(ParameterSetName="Retrieve")]
    [Parameter(ParameterSetName="AddLeafElement")]
    [Parameter(ParameterSetName="RemoveLeafElement")]
    [Parameter(ParameterSetName="Split")]
      [Switch]
      $ValuesOnly,
    [Parameter(ParameterSetName="GetEscapedElement",Mandatory=$true)]
      [String[]]
      $GetEscapedElement
  )

  begin {
    if ( $EscapedMode ) {
      Set-Property $Pathname "EscapedMode" $ADS_ESCAPE_MODE_ENUM[$EscapedMode]
    }
    else {
      Set-Property $Pathname "EscapedMode" $ADS_ESCAPE_MODE_ENUM["Default"]
    }
    if ( $ValuesOnly ) {
      Invoke-Method $Pathname "SetDisplayType" $ADS_DISPLAY_ENUM["ValuesOnly"]
    }
    else {
      Invoke-Method $Pathname "SetDisplayType" $ADS_DISPLAY_ENUM["Full"]
    }
    function Retrieve {
      param(
        [String] $name,
        [Int] $inputType,
        [Int] $outputFormat
      )
      try {
        Invoke-Method $Pathname "Set" @($name,$inputType)
        Invoke-Method $Pathname "Retrieve" $outputFormat
      }
      catch [Management.Automation.MethodInvocationException] {
        Write-CustomError `
          -exception $_.Exception.InnerException `
          -targetObject $name `
          -errorID (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name `
          -errorCategory NotSpecified
      }
    }
    function AddLeafElement {
      param(
        [String] $name,
        [Int] $inputType,
        [String] $element,
        [Int] $outputFormat
      )
      try {
        Invoke-Method $Pathname "Set" @($name,$inputType)
        Invoke-Method $Pathname "AddLeafElement" $element
        Invoke-Method $Pathname "Retrieve" $outputFormat
      }
      catch [Management.Automation.MethodInvocationException] {
        Write-CustomError `
          -exception $_.Exception.InnerException `
          -targetObject $name `
          -errorID (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name `
          -errorCategory NotSpecified
      }
    }
    function RemoveLeafElement {
      param(
        [String] $name,
        [Int] $inputType,
        [Int] $outputFormat
      )
      try {
        Invoke-Method $Pathname "Set" @($name,$inputType)
        Invoke-Method $Pathname "RemoveLeafElement"
        Invoke-Method $Pathname "Retrieve" $outputFormat
      }
      catch [Management.Automation.MethodInvocationException] {
        Write-CustomError `
          -exception $_.Exception.InnerException `
          -targetObject $name `
          -errorID (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name `
          -errorCategory NotSpecified
      }
    }
    function Split {
      param(
        [String] $name,
        [Int] $inputType
      )
      try {
        Invoke-Method $Pathname "Set" @($name,$inputType)
        $numElements = Invoke-Method $Pathname "GetNumElements"
        for ( $i = 0; $i -lt $numElements; $i++ ) {
          Invoke-Method $Pathname "GetElement" $i
        }
      }
      catch [Management.Automation.MethodInvocationException] {
        Write-CustomError `
          -exception $_.Exception.InnerException `
          -targetObject $name `
          -errorID (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name `
          -errorCategory NotSpecified
      }
    }
    function GetEscapedElement {
      param(
        [String] $element
      )
      try {
        Invoke-Method $Pathname "GetEscapedElement" @(0,$element)
      }
      catch [Management.Automation.MethodInvocationException] {
        Write-CustomError `
          -exception $_.Exception.InnerException `
          -targetObject $element `
          -errorID (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name `
          -errorCategory NotSpecified
      }
    }
  }

  process {
    switch ( $PSCmdlet.ParameterSetName ) {
      "Retrieve" {
        foreach ( $nameItem in $Name ) {
          Retrieve $nameItem $ADS_SETTYPE_ENUM[$Type] $ADS_FORMAT_ENUM[$Format]
        }
      }
      "AddLeafElement" {
        foreach ( $nameItem in $Name ) {
          foreach ( $addLeafElementItem in $AddLeafElement ) {
            AddLeafElement $nameItem $ADS_SETTYPE_ENUM[$Type] $addLeafElementItem $ADS_FORMAT_ENUM[$Format]
          }
        }
      }
      "RemoveLeafElement" {
        foreach ( $nameItem in $Name ) {
          RemoveLeafElement $nameItem $ADS_SETTYPE_ENUM[$Type] $ADS_FORMAT_ENUM[$Format]
        }
      }
      "Split" {
        foreach ( $nameItem in $Name ) {
          Split $nameItem $ADS_SETTYPE_ENUM[$Type]
        }
      }
      "GetEscapedElement" {
        foreach ( $getEscapedElementItem in $GetEscapedElement ) {
          GetEscapedElement $getEscapedElementItem
        }
      }
    }
  }
}
#------------------------------------------------------------------------------