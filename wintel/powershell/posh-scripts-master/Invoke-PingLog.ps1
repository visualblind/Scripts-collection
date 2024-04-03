<#
.SYNOPSIS
    Test and monitor network connectivity using ICMP echo packets.
.DESCRIPTION
    The Inkove-Pinglog cmdlet tests and monitors network connectivity using ICMP echo packets. Behavior is similar to the Windows ping command and essentially wraps the Win32_PingStatus WMI class.

    Failure and success responses can be filtered by a chosen threshold to aid monitoring of connections, and logging to a CSV format file is possible. Logs are not effected by filtering.

    If a domain name resolves to both an IPv4 and an IPv6 address then the IPv6 address will be preferred, this is a behaviour of the Win32_PingStatus class with no option to force either protocol.
.PARAMETER Address
    Specifies the host to send ICMP echo packets to.
.PARAMETER Count
    Specifies the number of ICMP echo packets to send, default is 0 (unlimited).
.PARAMETER Timeout
    Specifies the time to wait in seconds before no response is assumed, default is 4.
.PARAMETER BufferSize
    Specifies the number of data bytes to be sent in the ICMP echo packet, this does not include the 8 byte ICMP header or the IP header (typically 20 bytes), default is 32.
.PARAMETER TimeToLive
    Specifies the TTL (time to live) value for the IP packet which is effectively a maximum hop count, the TTL field will be decremented by each router the packet passes through, default is 128.
.PARAMETER WriteThreashold
    Specifies the number of "success" or "failure" responses to output before silencing them base on the -WriteType parameter, default is 4.
.PARAMETER WriteType
    Specifies which responses are output, "Both" with output all responses, "Failed" will output only failed responses, "Success" only successful responses, default is "Both".
.PARAMETER ResolveAddress
    Include this parameter to enable IP address to domain name resolution attempts for the address specified.
.PARAMETER NoFragmentation
    Include this parameter to set the "Do not fragment" bit in the IP header, this will trigger "Packet too big" ICMP responses if the -BufferSize parameter causes the total packet size to exceed the MTU of the first hop.
.PARAMETER DisableFormat
    Include this parameter to remove the custom formatting for the "Win32_Pingstatus" object, this will also stop formatting data for all the .NET types being reloaded when the script exits.
.PARAMETER EnableLog
    Include this parameter to enable CSV logging to a file, default is the console working directory.
.PARAMETER LogPath
    Specifies the location to save the CSV log file to, default is the console working directory.
.PARAMETER ComputerName
    Runs the cmdlet on the specified computer using remote WMI (DCOM), default is the local computer.
.OUTPUTS
    System.Management.ManagementObject#Win32_PingStatus on success.
    A non-terminating error when a W32_PingStatus object can not be created.
    A terminating error when the log file can not be written to.
.EXAMPLE
    .\Invoke-Pinglog.ps1 8.8.8.8 -ResolveAddress -Count 4
.EXAMPLE
    .\Invoke-Pinglog.ps1 google.com -WriteType Failed -EnableLog -LogPath "C:\Users\Administrator\Documents"
#>
Param(
    [Parameter(Position=0,Mandatory=$true)]
    [String]$Address,
    [Int]$Count = 0,
    [Int]$Timeout = 4,
    [Int]$BufferSize = 32,
    [Int]$TimeToLive = 128,
    [Int]$WriteThreashold = 4,
    [ValidateSet('Both','Failed','Success')]
    [String]$WriteType = 'Both',
    [Switch]$ResolveAddress,
    [Switch]$NoFragmentation,
    [Switch]$DisableFormat,
    [Switch]$EnableLog,
    [String]$LogPath = '.',
    [String]$ComputerName = $env:COMPUTERNAME
)

$PingStatusFormat = @"
<?xml version="1.0" encoding="utf-8" ?>
<Configuration>
    <ViewDefinitions>
        <View>
            <Name>System.Management.ManagementObject#root\cimv2\Win32_PingStatus</Name>   
	        <ViewSelectedBy>
		        <TypeName>System.Management.ManagementObject#root\cimv2\Win32_PingStatus</TypeName>
	        </ViewSelectedBy>
            <TableControl>
                <TableHeaders>
                    <TableColumnHeader>
                        <Width>20</Width>
                    </TableColumnHeader>
                    <TableColumnHeader>
                        <!--<AutoSize/>-->
                    </TableColumnHeader>
                    <TableColumnHeader>
                        <Width>10</Width>
                    </TableColumnHeader>
                    <TableColumnHeader>
                        <Width>12</Width>
                    </TableColumnHeader>
                    <TableColumnHeader>
                        <Label>ResponseTTL</Label>
                        <Width>12</Width>
                    </TableColumnHeader>
                    <TableColumnHeader>
                        <Width>30</Width>
                    </TableColumnHeader>
                </TableHeaders>
                <TableRowEntries>
                    <TableRowEntry>
                        <TableColumnItems>
                            <TableColumnItem>
                                <PropertyName>Timestamp</PropertyName>
                            </TableColumnItem>
                            <TableColumnItem>
                                <PropertyName>ProtocolAddress</PropertyName>
                            </TableColumnItem>
                            <TableColumnItem>
                                <PropertyName>ReplySize</PropertyName>
                            </TableColumnItem>
                            <TableColumnItem>
                                <PropertyName>ResponseTime</PropertyName>
                            </TableColumnItem>
                            <TableColumnItem>
                                <PropertyName>ResponseTimeToLive</PropertyName>
                            </TableColumnItem>
                            <TableColumnItem>
                                <PropertyName>Status</PropertyName>
                            </TableColumnItem>                            
                        </TableColumnItems>
                    </TableRowEntry>
                </TableRowEntries>
            </TableControl>        
        </View>
    </ViewDefinitions>
</Configuration>
"@

$StatusCodeText = @{
    0 = 'Success'
    11001 = 'Buffer Too Small'
    11002 = 'Destination Net Unreachable'
    11003 = 'Destination Host Unreachable'
    11004 = 'Destination Protocol Unreachable'
    11005 = 'Destination Port Unreachable'
    11006 = 'No Resources'
    11007 = 'Bad Option'
    11008 = 'Hardware Error'
    11009 = 'Packet Too Big'
    11010 = 'Request Timed Out'
    11011 = 'Bad Request'
    11012 = 'Bad Route'
    11013 = 'TimeToLive Expired Transit'
    11014 = 'TimeToLive Expired Reassembly'
    11015 = 'Parameter Problem'
    11016 = 'Source Quench'
    11017 = 'Option Too Big'
    11018 = 'Bad Destination'
    11032 = 'Negotiating IPSEC'
    11050 = 'General Failure'
}

Function Write-Log ($Value)
{
    if ($EnableLog)
    {
        Out-File -InputObject $Value -FilePath (Join-Path -Path $LogPath -ChildPath "pinglog-$($ScriptTime).csv") -Append
    }
}

$ScriptTime = Get-Date -Format yyMMddHHmm
$TimeoutMilliseconds = $Timeout * 1000
$SuccessTotal = 0
$SuccessCurrent = 0
$FailedTotal = 0
$FailedCurrent = 0
$ResponseMaximum = $null
$ResponseMinimum = $null
$ResponseSum = 0

try
{
    if (-not $DisableFormat)
    {
        # Create a temporary format data file, and load in to the current session, this works from PSv2 onwards. Using a
        # custom object and "DefaultDisplayPropertySet" which would be an alternative does not work for PSv2 for example.
        $FormatPath = "$($env:Temp)\pinglog.format.ps1xml"
        Set-Content -Value $PingStatusFormat -Path $FormatPath -Encoding 'UTF8' -Force
        # PSv2 raises a non-terminating error about the format data file being "already present"
        Update-FormatData -PrependPath $FormatPath -EA SilentlyContinue
    }

    for ($i=1; $i -le $Count -or $Count -eq 0; $i++)
    {
        if ($ResolveAddress) {$ResolveAddressString = " AND ResolveAddressNames='TRUE'"} else {$ResolveAddressString = ''}
        if ($NoFragmentation) {$NoFragmentationString = " AND NoFragmentation='TRUE'"} else {$NoFragmentationString = ''}
        $PingStatusQuery = "SELECT * FROM Win32_PingStatus WHERE Address='{0}' AND Timeout={1} AND BufferSize={2} AND TimeToLive={3}{4}{5}"
        $PingStatus = Get-WmiObject -ComputerName $ComputerName -Query ($PingStatusQuery -f $Address, $TimeoutMilliseconds, $BufferSize, $TimeToLive, $ResolveAddressString, $NoFragmentationString) -EA Continue

        if ($PingStatus -ne $null)
        {
            if ($PingStatus.PrimaryAddressResolutionStatus -gt 0)
            {
                throw "Invalid IP address or domain name."
            }

            # add TimeStamp and Status properites to the $PingStatus object
            $StatusCode = [Int]$PingStatus.StatusCode
            Add-Member -InputObject $PingStatus -Name 'TimeStamp' -Value (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') -MemberType NoteProperty
            Add-Member -InputObject $PingStatus -Name 'Status' -Value $StatusCodeText[$StatusCode] -MemberType NoteProperty

            # calculate the success/failed min/max/avg totals for display on termination
            if ($StatusCode -lt 1)
            {
                $SuccessTotal++
                $SuccessCurrent++
                $FailedCurrent = 0
                $ResponseSum += $PingStatus.ResponseTime

                if ($i -gt 1)
                {
                    # run the calculations for all except the first iteration
                    if($PingStatus.ResponseTime -gt $ResponseMaximum -or $ResponseMaximum -eq $null) {$ResponseMaximum = $PingStatus.ResponseTime}
                    if($PingStatus.ResponseTime -lt $ResponseMinimum -or $ResponseMinimum -eq $null) {$ResponseMinimum = $PingStatus.ResponseTime}
                    $ResponseAverage = $ResponseSum / $SuccessTotal
                }
                else
                {
                    $ResponseMaximum = $PingStatus.ResponseTime
                    $ResponseMinimum = $PingStatus.ResponseTime
                    $ResponseAverage = $PingStatus.ResponseTime
                }
            }
            else
            {
                $FailedTotal++
                $FailedCurrent++
                $SuccessCurrent = 0
            }

            if ($WriteType -eq 'Both')
            {
                Write-Output $PingStatus
            }
            elseif ($WriteType -eq 'Failed' -and $WriteThreashold -ge $SuccessCurrent)
            {
                Write-Output $PingStatus
                if ($WriteThreashold -eq $SuccessCurrent)
                {
                    Write-Warning "Silencing success messages after $WriteThreashold replies."
                }
            }
            elseif ($WriteType -eq 'Success' -and $WriteThreashold -ge $FailedCurrent)
            {
                Write-Output $PingStatus
                if ($WriteThreashold -eq $FailedCurrent)
                {
                    Write-Warning "Silencing failed messages after $WriteThreashold failures."
                }
            }

            # log to a file in CSV format when logging is enabled
            if ($i -gt 1)
            {
                # skip the header for all except the first iteration
                Write-Log ($PingStatus | select TimeStamp,Address,ProtocolAddress,ReplySize,ResponseTime,ResponseTimeToLive,Status | ConvertTo-Csv -NoTypeInformation | select -Last 1)
            }
            else
            {
                Write-Log ($PingStatus | select TimeStamp,Address,ProtocolAddress,ReplySize,ResponseTime,ResponseTimeToLive,Status | ConvertTo-Csv -NoTypeInformation)
            }

            if ($StatusCode -ne 11010 -or $StatusCode -ne 11003)
            {
                # delay next iteration for 1 second unless the request timed out or host unreachable, these get the timeout applied
                Start-Sleep -Seconds 1
            }
        }
        else
        {
            # hardware/driver error or use of reserved address space if $PingStatus is $null
            Write-Log $Error[0].ToString()
            Start-Sleep -Seconds 1
        }
    }
}
catch
{
    throw
}
finally
{
    if (-not $DisableFormat)
    {
        # reload the built-in format data file to revert the temp file loaded previously
        Update-FormatData -PrependPath "$PSHOME\DotNetTypes.format.ps1xml" -EA SilentlyContinue
    }

    $PacketTotal = $SuccessTotal + $FailedTotal
    if ($PacketTotal -gt 0)
    {
        # display ping-like stats on termination, must have at least one response
        $FailedPercentage = "{0:P0}" -f ($FailedTotal / $PacketTotal)
        if ($PingStatus.ProtocolAddress -eq '') {$AddressText = $Address} else {$AddressText = $PingStatus.ProtocolAddress}
        if ($ResolveAddress) {$ResolveAddressText = " [$($PingStatus.ProtocolAddressResolved)]"} else {$ResolveAddressText = ''}
        Write-Host ""
        Write-Host "Ping statistics for $($AddressText)$($ResolveAddressText):"
        Write-Host "    Packets: Sent = $PacketTotal, Received = $SuccessTotal, Lost = $FailedTotal ($FailedPercentage loss)"
        
        if ($SuccessTotal -gt 0)
        {
            $ResponseAverageFormat = "{0:D1}" -f [Int]$ResponseAverage
            Write-Host "Approximate round trip time in milli-seconds:"
            Write-Host "    Minimum = $($ResponseMinimum)ms, Maximum = $($ResponseMaximum)ms, Average = $($ResponseAverageFormat)ms"
            Write-Host ""
        }
    }
}
