# internal functions for WaitForX

# Fallback message strings in en-US
DATA localizedData
{
    # culture = "en-US"
    ConvertFrom-StringData @'
        InvalidInputParam = Invalid input parameters!
        InvalidInputThrottle = Invalid input throttle limit!
        CheckRemoteState = Checking remote resource '{0}' state ...
        RemoteResourceNotReady = Remote resource '{0}' is not ready.
        RemoteResourceNotReadyAndRetry = Remote resource '{0}' is not ready. Retrying after {1} second(s)
        RemoteResourceReady = Remote resource '{0}' is ready
        RemoteConfigNotReady = Resource '{0}' on machine(s) '{1}' is not ready.
        RemoteConfigNotReadyWithRetry = Resource '{0}' on machine(s) '{1}' is not ready after '{2}' retries with retry interval of '{3}' second(s).
        NodeNameHasDuplicates = NodeName contains duplicate machine names! Check the NodeName and expected MinimalNumberOfMachineInState parameters.
        RemoteConnectivityFailure = Cannot create remote session to machine '{0}'
'@
}
Import-LocalizedData  LocalizedData -filename PSDSCxMachine.strings.psd1

$script:NodeInDesiredState = @()
$script:NodeNameIsDuplicated = $false

function Get-_InternalPSDscXMachineTR
{
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $RemoteResourceId,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]] $RemoteMachine,
        
        [Uint32] $MinimalNumberOfMachineInState = $RemoteMachine.Length,

        [ValidateRange(1,[Uint64]::MaxValue)]
        [Uint64] $RetryIntervalSec = 1, 

        [Uint32] $RetryCount = 0, 
        
        [Uint32] $ThrottleLimit = 32
    )

    return @{
        ResourceName = $RemoteResourceId
        NodeName = $RemoteMachine
        RetryIntervalSec = $RetryIntervalSec
        RetryCount = $RetryCount
        ThrottleLimit = $ThrottleLimit
    }
}

function IsAccessDeniedIssue
{
   param ( $er)
   
   $ci = $er.CategoryInfo
   [xml]$xml = $er.Exception.Message
   return ($ci.TargetName -ilike "*MSFT_DscProxy") -and ($er.Exception.HResult -eq 0x80131509 ) -and ( -not (($xml.ChildNodes.Count -gt 0) -and ($xml.ChildNodes[0].Code -eq 5)))
}

function Set-_InternalPSDscXMachineTR
{
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $RemoteResourceId,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]] $RemoteMachine,
        
        [Uint32] $MinimalNumberOfMachineInState = $RemoteMachine.Length,

        [ValidateRange(1,[Uint64]::MaxValue)]
        [Uint64] $RetryIntervalSec = 1, 

        [Uint32] $RetryCount = 0, 
        
        [Uint32] $ThrottleLimit = 32
    )

    if ($MinimalNumberOfMachineInState -gt $remoteMachine.Count)
    {
        throw $localizedData.InvalidInputParam
    }

    if ($ThrottleLimit -eq 0)
    {
        throw $localizedData.InvalidInputThrottle
    }

    $bState = $false
    $retry = 0

    Write-Debug -Message ($localizedData.CheckRemoteState -f $RemoteResourceId)
    for ($retry = 0; $retry -lt $RetryCount; $retry++)
    {
        Write-Verbose -Message ($localizedData.RemoteResourceNotReadyAndRetry -f $RemoteResourceId, $RetryIntervalSec)
        Sleep -Seconds $RetryIntervalSec

        $Iterations = [math]::Ceiling($RemoteMachine.Count / $ThrottleLimit)
        $initialItr = $retry * $Iterations
        for ($itr = $initialItr; $itr -lt $initialItr+$Iterations; $itr++)
        {
            try
            {
                $machinesToConnect = Get-MachinesToEnsureConnection -remoteMachine $remoteMachine -iteration $itr -throttleLimit $ThrottleLimit
                if ($machinesToConnect.Count -eq 0)
                {
                    $bState = $true;
                }
                else
                {
                    $bState = Get-RemoteResourceState -remoteMachine $machinesToConnect -RemoteResourceId $RemoteResourceId -MinimalNumberOfMachineInState $MinimalNumberOfMachineInState
                }
            }
            catch
            {
                if (IsAccessDeniedIssue -er $_) 
                {
                    Write-Debug -Message "Exception: $_"
                }
                else
                {
                    Write-Verbose -Message "Exception: $_"
                }
            }

            if ($bState)
            {
                Write-Verbose -Message ($localizedData.RemoteResourceReady -f $RemoteResourceId)
                return
            }
        }
    }
    if ($script:NodeNameIsDuplicated)
    {
        # reset $NodeNameIsDuplicated
        $script:NodeNameIsDuplicated = $false
        throw $localizedData.NodeNameHasDuplicates
    }
    else
    {
        if ($RetryCount -gt 0)
        {
           throw ($localizedData.RemoteConfigNotReadyWithRetry -f $RemoteResourceId, "$($RemoteMachine)", $RetryCount, $RetryIntervalSec )
        }
        else
        {
           throw ($localizedData.RemoteConfigNotReady -f $RemoteResourceId, "$($RemoteMachine)")
        }
    }
}

function Test-_InternalPSDscXMachineTR
{
    param
    (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $RemoteResourceId,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]] $RemoteMachine,
        
        [Uint32] $MinimalNumberOfMachineInState = $RemoteMachine.Length,

        [ValidateRange(1,[Uint64]::MaxValue)]
        [Uint64] $RetryIntervalSec = 1, 

        [Uint32] $RetryCount = 0, 
        
        [Uint32] $ThrottleLimit = 32
    )

    if ($MinimalNumberOfMachineInState -gt $remoteMachine.Count)
    {
        throw $localizedData.InvalidInputParam
    }

    if ($ThrottleLimit -eq 0)
    {
        throw $localizedData.InvalidInputThrottle
    }

    $bState = $false
    
    Write-Debug -Message ($localizedData.CheckRemoteState -f $RemoteResourceId)

    $script:NodeInDesiredState = @()
    
    $TotalRetryCount = 1
    $MaxRetryCount = 5
    for ($retry = 0; $retry -lt $TotalRetryCount; $retry++)   
    {
        if ($retry -gt 0) { Sleep -Milliseconds 200 }

        # according to algorithm described in Get-MachinesToEnusreConnection, the number of iterations to cover all machines at least once is calculated as stoping condition in following for loop
        for ($iteration = 0; $iteration -lt [math]::Ceiling($RemoteMachine.Count / $ThrottleLimit); $iteration++)
        {
            try
            {
                $machinesToConnect = Get-MachinesToEnsureConnection -remoteMachine $remoteMachine -iteration $iteration -throttleLimit $ThrottleLimit
                $bState = Get-RemoteResourceState -remoteMachine $machinesToConnect -RemoteResourceId $RemoteResourceId -MinimalNumberOfMachineInState $MinimalNumberOfMachineInState
            }
            catch
            {
                if (IsAccessDeniedIssue -er $_) 
                {
                    Write-Debug -Message "Exception: $_"
                    $TotalRetryCount = $MaxRetryCount
                }
                else
                {
                    Write-Verbose -Message "Exception: $_"
                    $TotalRetryCount = $retry   # stop TotalRetryCount as non-connectivity issue.
                }
            }

            if ($bState)
            {
                Write-Verbose -Message ($localizedData.RemoteResourceReady -f $RemoteResourceId)
                return $true
            }
        }
    }

    Write-Verbose -Message ($localizedData.RemoteResourceNotReady -f $RemoteResourceId)

    return $false
}

function Get-MachinesToEnsureConnection
{
    param(
        [ValidateNotNullOrEmpty()][string[]] $remoteMachine,
        [int] $iteration,
        [int] $throttleLimit
    )

    $allMachines = @()
    foreach ($machine in $remoteMachine)
    {
        if ($machine -notin $script:NodeInDesiredState)
        {
            $allMachines += $machine
        }
    }

    <# the algorithm works like this:
        suppose we have 10 machines (0-9) and throttle limit is 3
        following is the machines alively connected in each iteration
        iteration    machines
        0            0,1,2
        1            3,4,5
        2            6,7,8
        3            9,0,1
        4            2,3,4
        ...
    #>

    if ($throttleLimit -ge $allMachines.Count)
    {
        return $allMachines
    }
    else
    {
        $machinesToConnect = @()
        $start = ($iteration * $throttleLimit) % ($allMachines.Count)
        
        $count = 0
        for ($i = $start; $i -lt $allMachines.Count -and $count -lt $throttleLimit; $i++)
        {
            $machinesToConnect += $allMachines[$i]
            $count++
        }

        if ($count -lt $throttleLimit)
        {
            for ($i = 0; $i -lt ($throttleLimit - $count); $i++)
            {
                $machinesToConnect += $allMachines[$i]
            }
        }
        return $machinesToConnect
    }
}

function Get-RemoteResourceState
{
    param (
        
        [ValidateNotNullOrEmpty()][string[]] $remoteMachine,
        [ValidateNotNullOrEmpty()][string] $RemoteResourceId,
        [Uint32] $MinimalNumberOfMachineInState = $remoteMachine.Count
    )

    Write-Debug "Get-RemoteResourceState ..."

    if ($script:NodeInDesiredState.Count -eq $MinimalNumberOfMachineInState)
    {
        return $true
    }

    $remoteMachineException = $null

    foreach ($machine in $remoteMachine)
    {
        Write-Debug "Get resource state on remoteMachine: $machine"
        #Remove duplicate machine names from $remoteMachine list
        if ($script:NodeInDesiredState -contains $machine)
        {
            $script:NodeNameIsDuplicated = $true
            continue
        }
        try
        {
            if (Get-RemoteResourceStateOnMachine -RemoteResourceId $RemoteResourceId -MachineName $machine)
            {
                $script:NodeInDesiredState += $machine

                if ($script:NodeInDesiredState.Count -eq $MinimalNumberOfMachineInState)
                {
                    return $true
                }
            }
            else
            {
                Write-Debug "Resource $RemoteResourceId on machine $machine is not ready"
            }
        }
        catch
        {
               # continue here to iterate every machine from $remoteMachine list
              $remoteMachineException = $_
        }
    }
    # re-throw the original exception once browsing  all the machines is complete
    if($remoteMachineException -ne $null)
    {
        throw $remoteMachineException
    }

    $false
}

function Get-RemoteResourceStateOnMachine
{
    param (
       [ValidateNotNullOrEmpty()][string] $RemoteResourceId, 
       [ValidateNotNullOrEmpty()][string] $MachineName
    )

    Write-Debug "Get-RemoteResourceStateOnMachine on machine: $MachineName and resource: $RemoteRecourceId..."

    $buf = [Text.Encoding]::Unicode.GetBytes($RemoteResourceId)
    $data = [System.Convert]::ToBase64String($buf)

    $result = Invoke-WSManAction -ResourceURI http://schemas.microsoft.com/wbem/wsman/1/wmi/root/microsoft/windows/DesiredStateConfigurationProxy/MSFT_DscProxy `
                    -action GetResourceState -ComputerName $MachineName -valueset @{ConfigurationData = "$data" } `
                    -Authentication None
    $retV = $result.State

    Write-Debug "Get state ($retV) on machine: $MachineName and resource: $RemoteRecourceId"

    return $retV -ieq 'true'
}

Export-ModuleMember -Function *-_InternalPSDscXMachineTR

