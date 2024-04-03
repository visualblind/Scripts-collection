#
# Function Description:
#
#  This function will add the Server Manager module so that Roles
#  can be queried
#
# Arguments:
#
#  None
#
# Return Value:
#
#  None
#
function Setup
{
    Import-Module ServerManager
    import-module failoverclusters
}

#
# Function Description:
#
#  This function will remove the Server Manager module after the Roles
#  have been queried
#
# Arguments:
#
#  None
#
# Return Value:
#
#  None
#
function TearDown
{
    Remove-Module ServerManager
    Remove-Module failoverclusters
}

#
# Function Description:
#
#  check the status of specifed service
#  have been queried
#
# Arguments:
#
#  $computer - computer name
#  $serviceName - service name
#
# Return Value:
#
#  $true - if the service is running
#  $false - otherwise
#
function Check-ServiceStatus($computerName, $serviceName)
{
    $service = get-service -computername $computerName -name $serviceName
    if($service -ne $null -and ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]"Running"))
    {
        $true
    }
    else
    {
        $false
    }
}

#
# Function Description:
#  Creates the Document element for the Xml Document
#
# Arguments:
#  $ns - Namespace Name
#  $name - Name of the document element
#
# Return Value:
#  returns the created document element
#
function Create-DocumentElement( $ns, $name )
{
    [xml] "<$name xmlns='$ns'></$name>"
}

#
# Function Description:
#
#  This function will check to see if the specified feature is installed
#
# Arguments:
#
#  $featureName - Id of the Role 
#
# Return Value:
#
#  $true - If Role is Installed
#  $false - If Role is not Installed
#
function Check-FeatureInstallStatus ( $featureName )
{
    $featureInstalled = $false
    
    #
    # Use the Server Manager CmdLet to obtain detail about Feature
    #
    $Feature = Get-WindowsFeature $featureName
    if ( $Feature -ne $null ) 
    {
        $featureInstalled = $Feature.Installed
    }

    $featureInstalled
}

#
# Function Description:
#  Check whether the role service installation is consistent in cluster
#
# Arguments:
#  $serviceName - Role Service Name
#
# Return Value:
#  "true" - if it is consistent in cluster
#  "false" - if it is not consistent in cluster
#  "NA" - if the status is NA due to some reasons like some cluster nodes are not reachable
function Check-ServiceInstalationOnCluster($serviceName)
{   
    $isInCluster =  Get-ServerInClusterStatus
    if($isInCluster -ne $true)
    {
        "true"
        $null
        return
    }
    
    # need to check cluster service first otherwise the cluster cmdlet may run indefinitely and never return
    $clusvc = get-service -name clussvc
    if($clusvc -and $clusvc.Status -eq [System.ServiceProcess.ServiceControllerStatus]"Running")
    {
        $svcInstalledList = new-object "System.Collections.ObjectModel.Collection``1[System.String]"
        $svcNotInstalledList = new-object "System.Collections.ObjectModel.Collection``1[System.String]"
        $notReachableNodeList = new-object "System.Collections.ObjectModel.Collection``1[System.String]"
        
        $nodes = get-clusternode        
        foreach($node in $nodes)
        {
            $cmpSvc = get-wmiobject -class win32_serverfeature -computername $node.Name | where { $_.Name -eq $serviceName}
            if(!$?)
            {
                throw $errors[0]
            }
            trap
            {
                [void]$notReachableNodeList.Add($node.Name)
                continue
            }
            if($cmpSvc)
            {
                $svcInstalledList.Add($node.Name)
            }
            else
            {
                $svcNotInstalledList.Add($node.Name)            
            }
        }
        
        if($notReachableNodeList.Count -gt 0)
        {
            "NA"
        }
        else
        {
            if($svcInstalledList.Count -eq 0 -or $svcNotInstalledList.Count -eq 0)
            {
                # the service is either installed or uninstalled on all nodes.
                "true"
            }
            else
            {
                write-warning "make sure to install $serviceName on all cluster nodes"
                "false"
            }
        }   
        $notReachableNodeString = ""
        if($notReachableNodeList.Count -gt 0)
        {
            $notReachableNodeArray = new-object -type string[] -argumentlist $notReachableNodeList.Count
            $notReachableNodeList.CopyTo($notReachableNodeArray, 0)
            $notReachableNodeString = [string]::Join(",", $notReachableNodeArray)            
        }
        $notReachableNodeString
    }
}


#
# Function Description:
#  Check whether the current node is in cluster
#
# Arguments:
#  none
#
# Return Value:
#  $true - if it is in cluster
#  $false - if it is not in cluster
#
function Get-ServerInClusterStatus()
{
    $result = $false
    $clusvc = get-service -name clussvc
    if($clusvc -and $clusvc.Status -eq [System.ServiceProcess.ServiceControllerStatus]"Running")
    {
        $nodes = get-clusternode
        $computerName = [System.Net.Dns]::GetHostName()
        foreach($node in $nodes)
        {
            if($node.Name -eq $computername)
            {
                $result = $true
                break
            }
        }        
    }
    $result
}

#
# Function Description:
#  Create XmlElement and append it into the specified parent
#
# Arguments:
#  $doc - XmlDocument manipulated
#  $parent - parent node
#  $ns - namespace used for the element
#  $elementName - element name
#  $elementValue - element value
#
# Return Value:
#   none
#
function Append-XmlElement($doc, $parent, $ns, $elementName, $elementValue)
{
    $element = $doc.CreateElement($elementName, $ns)
    $element.set_InnerText($elementValue)
    [void]$parent.AppendChild($element)
}

#
# Function Description:
#  formalize the text of the boolean value
#
# Arguments:
#  $value - boolean value
#
# Return Value:
#  "true" - if $value -eq $true
#  "false" - if $value -eq $false
#
function Formalize-BoolValue($value)
{
    if($value)
    {
        "true"
    }
    else
    {
        "false"
    }
}

#
# Function Description:
#  formalize the text of the boolean value
#
# Arguments:
#  $code - C# code
#  $Reference - reference assembley
#
# Return Value:
#  none
#
function Compile-Csharp ([string] $code, [Array]$References)
{
    # Get an instance of the CSharp code provider
    $cp = New-Object Microsoft.CSharp.CSharpCodeProvider
    $refs = New-Object Collections.ArrayList
    $refs.AddRange( @("System.dll",
                    "System.Windows.Forms.dll",
                    "System.Data.dll",
                    "System.XML.dll"))
    if ($References -and ($References.Count -ge 1))
    {
        $refs.AddRange($References)
    }

    # Build up a compiler params object...
    $cpar = New-Object System.CodeDom.Compiler.CompilerParameters
    $cpar.GenerateInMemory = $true
    $cpar.GenerateExecutable = $false
    $cpar.IncludeDebugInformation = $false
    $cpar.CompilerOptions = "/target:library"
    $cpar.ReferencedAssemblies.AddRange($refs)
    $cr = $cp.CompileAssemblyFromSource($cpar, $code)

    if ( $cr.Errors.Count)
    {
        $codeLines = $code.Split("`n");
        foreach ($ce in $cr.Errors)
        {
            write-host "Error: $($codeLines[$($ce.Line - 1)])"
            $ce | out-default
        }
    Throw "INVALID DATA: Errors encountered while compiling code"
    }
}