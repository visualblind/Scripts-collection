###########################################################################
# Common code for built-in Composite Resources
###########################################################################

Set-StrictMode -version Latest

#
# Builds a string with all common parameters shared across all 
# resource nodes.
#
function BuildResourceCommonParameters
{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $KeyParamName,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.Array]
    $OptionalParams,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.Hashtable]
    $PSBoundParams)

    [System.Text.StringBuilder] $pb = new-object System.Text.StringBuilder

    #build optional parameters for invoking the inbuilt resource
    foreach($paramName in $($PSBoundParams.keys)) 
    {
        #If the param name is the 'Key' then continue
        if ($paramName -eq $KeyParamName)
        {
            continue
        }
        if ($paramName -in $OptionalParams)
        {
            $value = $PSBoundParams[$paramName]
            if ($value -eq $null)
            {
                continue
            }

            if ($value -is [System.String])
            {
                $pb.AppendFormat('{0} = "{1}"', $paramName, $value) | Out-Null
                $pb.AppendLine() | Out-Null
            }
            else
            {
                $pb.Append($paramName + ' = $' + $paramName) | Out-Null
                $pb.AppendLine() | Out-Null
            }
        }
    }

    return $pb.ToString()
}

#
# Builds a string with all resource nodes based on the key parameter along with 
# the other optional parameters provided in the composite configuration. 
# For e.g. While installing multiple features using WindowsFeature resource,
# output of this method would be:
#
# $KeyParam = @("Telnet-client","web-server")
# WindowsFeature Resource0
# {
#   Name = "Telnet-client" #Name provided in the composite configuration
#   Ensure = "Present"
#   IncludeAllSubFeature = True
# }  
#
# WindowsFeature Resource1
# {
#   Name = "Web-Server" #Name provided in the composite configuration
#   Ensure = "Present"
#   IncludeAllSubFeature = True
# }
#
#
function BuildResourceString
{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $KeyParam, 
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $KeyParamName,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $CommonParams,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ResourceName,

    [ValidateNotNullOrEmpty()]
    [string]
    $ModuleName="PSDesiredStateConfiguration",

    [ValidateNotNullOrEmpty()]
    [string]
    $DefaultParams
    )

    [System.Text.StringBuilder] $sb = new-object System.Text.StringBuilder

    $sb.AppendFormat('Import-DscResource -Name {0} -ModuleName {1}', $ResourceName, $ModuleName) | Out-Null
    $sb.AppendLine() | Out-Null

    # add the resource nodes and their common parameters
    [int] $count = 0
    foreach ($key in $KeyParam)
    {
        $sb.AppendFormat('{0} Resource{1}', $ResourceName, $count) | Out-Null
        $sb.AppendLine() | Out-Null
        $sb.AppendLine('{') | Out-Null
        $sb.AppendFormat($KeyParamName + ' = "{0}"', $key) | Out-Null
        $sb.AppendLine() | Out-Null
        $sb.AppendLine($CommonParams) | Out-Null
        
        if($DefaultParams)
        {
            $sb.AppendLine($DefaultParams) | Out-Null
        }

        $sb.AppendLine('}') | Out-Null
        $count++
    }

    return $sb.ToString()
}

Export-ModuleMember -Function BuildResourceCommonParameters, BuildResourceString
