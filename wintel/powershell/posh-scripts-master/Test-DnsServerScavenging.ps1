# Test-DnsServerScavenging v1.0 (c) Chris Redit

<#
.SYNOPSIS
    Run a test DNS server scavenging event.
.DESCRIPTION
    The Test-DnsServerScavenging cmdlet will run a test scavenging event and return DNS resource records that are candidates for removal and considered stale.

    By default the aging intervals of the DNS zone will be used, however a duration for the intervals can be chosen by passing a [TimeSpan] object to the -NoRefreshInterval and -RefreshInterval parameters.

    Records that fall within either of the two intervals can be returned using the -Type parameter. The keyword "Stale" can be used to return records that fall outside both interval durations. This is the default behaviour.
.PARAMETER ZoneName
    Specifies the DNS zone to query.
.PARAMETER RRType
    Specifies the type of resource record.
.PARAMETER NoRefreshInterval
    Specifies the period for the no-refresh interval, this must be at least 1 hour. The default is the current server setting.
.PARAMETER RefreshInterval
    Specifies the period for the refresh interval, this must be at least 1 hour. The default is the current server setting.
.PARAMETER Type
    Specifies which resource records will be returned, acceptable values are: NoRefresh, Refresh and Stale. The default is "Stale".
.PARAMETER ComputerName
    Runs the cmdlet on the specified computer. The default is the local computer.
.OUTPUTS
    $null or an array of [CimInstance] objects on success.
    A non-terminiating error if the DNS zone name is invalid.
    A terminiating error in all other cases.
.EXAMPLE
    ./Test-DnsServerScavenging -ZoneName 'lan.example.com'
.EXAMPLE
    ./Test-DnsServerScavenging -ZoneName 'lan.example.com' -NoRefreshInterval (New-TimeSpan -Days 3) -RefreshInterval (New-TimeSpan -Days 7)
#>

[CmdletBinding()]
Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [String]$ZoneName,
    [String]$RRType = '',
    [Nullable[TimeSpan]]$NoRefreshInterval = $null,
    [Nullable[TimeSpan]]$RefreshInterval = $null,
    [ValidateSet('NoRefresh','Refresh','Stale')]
    [String]$Type = 'Stale',
    [String]$ComputerName = $env:COMPUTERNAME
)

Begin
{
    # import the modules we need if they are not already
    if (-not (Get-Module -Name ActiveDirectory)) {Import-Module ActiveDirectory -EA Stop}
    if (-not (Get-Module -Name DnsServer)) {Import-Module DnsServer -EA Stop}
}

Process
{
    try
    {
        # DNS records are time stamped with the date accurate to the current hour, get the current date here in the same format for calculation later
        $Now = (Get-Date(Get-Date -Format 'yyyy-MM-dd HH:00:00'))
        
        $Aging = Get-DnsServerZoneAging -Name $ZoneName -ComputerName $ComputerName -EA Stop
        if ($Aging.AgingEnabled -eq $false)
        {
            Write-Warning "Aging is not enabled for the zone $ZoneName, resource record timestamps will not be replicated."
        }

        if ($NoRefreshInterval -eq $null) {$NoRefreshInterval = $Aging.NoRefreshInterval}
        if ($RefreshInterval -eq $null) {$RefreshInterval = $Aging.RefreshInterval}
        if ($NoRefreshInterval.TotalHours -lt 1 -or $RefreshInterval.TotalHours -lt 1)
        {
            throw "The No-refresh and Refresh intervals must be at least 1 hour."
        }
 
        # stale records will be those older than the No-refresh and Refresh intervals combined
        $StaleThreshold = ($NoRefreshInterval + $RefreshInterval)

        $DnsParams = @{
            'ComputerName' = $ComputerName;
            'ZoneName' = $ZoneName;
            'ErrorAction' = 'Stop'
        }
        if ($RRType) {$DnsParams['RRType'] = $RRType}

        # return an array of DNS records filtered by the type requested
        switch ($Type)
        {
            'NoRefresh' {Get-DnsServerResourceRecord @DnsParams | Where-Object {$_.TimeStamp -is [DateTime] -and $_.Timestamp -ge $Now.AddHours('-'+$NoRefreshInterval.TotalHours)}}
            'Refresh' {Get-DnsServerResourceRecord @DnsParams | Where-Object {$_.TimeStamp -is [DateTime] -and $_.Timestamp -ge $Now.AddHours('-'+$StaleThreshold.TotalHours) -and $_.Timestamp -lt $Now.AddHours('-'+$NoRefreshInterval.TotalHours)}}
            'Stale' {Get-DnsServerResourceRecord @DnsParams | Where-Object {$_.TimeStamp -is [DateTime] -and $_.Timestamp -lt $Now.AddHours('-'+$StaleThreshold.TotalHours)}}
        }
    }
    catch [Microsoft.Management.Infrastructure.CimException]
    {
        # there appear to be some standard message IDs in the CimException objects
        if ($_.Exception.MessageId -eq 'WIN32 9601')
        {
            # raise a non-terminating error for an invalid zone name
            Write-Error "The DNS zone $ZoneName was not found. $($_.Exception.Message)"
        }
        elseif ($_.Exception.MessageId -eq 'WIN32 1722' -or $_.Exception.MessageId -eq 'WIN32 1753')
        {
            # raise a terminating error for an invalid computer name
            throw "Computer $ComputerName is not a DNS server or is not responding. $($_.Exception.Message)"
        }
        else
        {
            # raise a terminating error for any other CimException exceptions 
            throw $_.Exception.Message
        }
    }
}
