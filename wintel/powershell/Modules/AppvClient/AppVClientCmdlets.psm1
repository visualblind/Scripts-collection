# .ExternalHelp Microsoft.AppV.AppVClientPowerShell.dll-Help.xml

function Get-AppvVirtualProcess
{
[CmdletBinding(DefaultParameterSetName='Name')]
param(
    [Parameter(ParameterSetName='Name', Position=0, ValueFromPipelineByPropertyName=$true)]
    [Alias('ProcessName')]
    [ValidateNotNullOrEmpty()]
    [System.String[]]
    ${Name},

    [Parameter(ParameterSetName='Id', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('PID')]
    [System.Int32[]]
    ${Id},

    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Alias('Cn')]
    [ValidateNotNullOrEmpty()]
    [System.String[]]
    ${ComputerName},

    [ValidateNotNull()]
    [Switch]
    ${Module},

    [Alias('FV','FVI')]
    [ValidateNotNull()]
    [Switch]
    ${FileVersionInfo},

    [Parameter(ParameterSetName='InputObject', Mandatory=$true, ValueFromPipeline=$true)]
    [System.Diagnostics.Process[]]
    ${InputObject})

begin
{            
    try {
        $comConsumer = New-Object Microsoft.AppV.AppvClientFacade.ClientComConsumer
        $processList = $null 
        try {
            $processList = $comConsumer.GetAllVirtualProcesses()
        } catch {
            $processList = $comConsumer.GetUserVirtualProcesses()
        }    

        if ($FileVersionInfo)
        {
            $PSBoundParameters['FileVersionInfo'] = $false
        }
    
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Get-Process', [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = {& $wrappedCmd @PSBoundParameters | foreach { 
                            if ($processList.ContainsKey($_.Id)) {
                                Add-Member -InputObject $_ -MemberType NoteProperty -Name AppvPackageData -Value ($processList.Item($_.Id))
                                if ($FileVersionInfo) {
                                    $_.MainModule.FileVersionInfo
                                } else {
                                    $_
                                }
                            }
                        }}
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process
{    
    try {
        $steppablePipeline.Process($_) 
    } catch {
        throw
    }
}

end
{
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
}
}

# .ExternalHelp Microsoft.AppV.AppVClientPowerShell.dll-Help.xml

function Start-AppvVirtualProcess
{
[CmdletBinding(DefaultParameterSetName='Default')]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [Alias('PSPath')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${FilePath},

    [Parameter(Position=1)]
    [Alias('Args')]
    [ValidateNotNullOrEmpty()]
    [System.String[]]
    ${ArgumentList},

    [Parameter(ParameterSetName='Default')]
    [Alias('RunAs')]
    [ValidateNotNullOrEmpty()]
    [System.Management.Automation.PSCredential]
    ${Credential},

    [ValidateNotNullOrEmpty()]
    [System.String]
    ${WorkingDirectory},

    [Parameter(ParameterSetName='Default')]
    [Alias('Lup')]
    [Switch]
    ${LoadUserProfile},

    [Parameter(ParameterSetName='Default')]
    [Alias('nnw')]
    [Switch]
    ${NoNewWindow},

    [Switch]
    ${PassThru},

    [Parameter(ParameterSetName='Default')]
    [Alias('RSE')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${RedirectStandardError},

    [Parameter(ParameterSetName='Default')]
    [Alias('RSI')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${RedirectStandardInput},

    [Parameter(ParameterSetName='Default')]
    [Alias('RSO')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${RedirectStandardOutput},

    [Parameter(ParameterSetName='UseShellExecute')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${Verb},

    [Switch]
    ${Wait},

    [Parameter(ParameterSetName='UseShellExecute')]
    [ValidateNotNullOrEmpty()]
    [System.Diagnostics.ProcessWindowStyle]
    ${WindowStyle},

    [Parameter(ParameterSetName='Default')]
    [Switch]
    ${UseNewEnvironment},
    
    [Parameter(Mandatory=$true)]
    ${AppvClientObject})

begin
{
    try {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Start-Process', [System.Management.Automation.CommandTypes]::Cmdlet)

        if($AppvClientObject -is [Microsoft.AppV.AppvClientPowerShell.AppvClientPackage])
        {       
            if (-not (Get-AppvClientPackage -PackageId $AppvClientObject.PackageId -VersionId $AppvClientObject.VersionId) ) 
            {
                $message = [Microsoft.AppV.AppvClientPowerShell.ResourceRetriever]::GetString("VirtProcessCannotStartBecausePackageNotFound")
                throw $message
            }
            
            $PSBoundParameters['ArgumentList'] += "/AppvVe:$($AppvClientObject.PackageId)_$($AppvClientObject.VersionId)"            
        }
        elseif($AppvClientObject -is [Microsoft.AppV.AppvClientPowerShell.AppvClientConnectionGroup])
        {
            if (-not (Get-AppvClientConnectionGroup -GroupId $AppvClientObject.GroupId -VersionId $AppvClientObject.VersionId) ) 
            {
                $message = [Microsoft.AppV.AppvClientPowerShell.ResourceRetriever]::GetString("VirtProcessCannotStartBecauseGroupNotFound")
                throw $message
            }
            
            $PSBoundParameters['ArgumentList'] += "/AppvVe:$($AppvClientObject.GroupId)_$($AppvClientObject.VersionId)"            
        }
        else
        {
            $message = [Microsoft.AppV.AppvClientPowerShell.ResourceRetriever]::GetString("InvalidObjectTypeForStartVirtProcess")
            throw $message
        }
            
        [Void]$PSBoundParameters.Remove("AppvClientObject")
        $scriptCmd = {& $wrappedCmd @PSBoundParameters }
        
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process
{
    [Void][Microsoft.AppV.SharedPerformance.Tracing.PROVIDER_MICROSOFT_APPV_CLIENT_SHAREDPERFORMANCEEVENTS]::Write_ClientProgrammability_StartStartAppvVirtualProcess($FilePath)
    
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
    finally {
        [Void][Microsoft.AppV.SharedPerformance.Tracing.PROVIDER_MICROSOFT_APPV_CLIENT_SHAREDPERFORMANCEEVENTS]::Write_ClientProgrammability_StopStartAppvVirtualProcess($FilePath)
    }
}

end
{
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
}
}
