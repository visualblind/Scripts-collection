

#region General Helper functions

function Get-ObjectsInRoutingDomain($Objects, $RoutingDomain)
{
    if($RoutingDomain -eq $Null)
    {
        return @($Objects | ? {$_})
    }
    return @($Objects | ? {$_} | Where RoutingDomain -eq $RoutingDomain)
}

function Test-MultiTenancy
{
    Param(
    [Parameter(Mandatory=$True)]
    $RemoteAccess
    )
    return ($RemoteAccess.VpnMultiTenancyStatus -eq "Installed")
}

function Test-DefaultCapacityKbps
{
    Param(
    [Parameter(Mandatory=$True)]
    $RemoteAccess
    )
    $DefaultCapityKbps = 307200
    return ($RemoteAccess.CapacityKbps -eq $DefaultCapityKbps)
}

function Get-NetIPInterfaceBpa($MultiTenancy)
{
    $Interfaces = @()
    try
    {
        if($MultiTenancy -eq $True)
        {
            $Interfaces = @(Get-NetIPInterface -IncludeAllCompartments -ErrorAction SilentlyContinue)
        }
        else
        {
            $Interfaces = @(Get-NetIPInterface -ErrorAction SilentlyContinue)
        }
    }
    catch
    {}
    return @($Interfaces)
}

function Get-NetIPAddressBpa($Interfaces)
{
    return @($Interfaces | Get-NetIPAddress -ErrorAction SilentlyContinue| Where AddressState -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetIPAddress.AddressState]::Preferred))
}

function Get-NetRouteBpa($Interfaces)
{
    return @($Interfaces | Get-NetRoute -ErrorAction SilentlyContinue)
}

function Get-NetCompartmentBpa()
{
    $Compartments = @()
    try
    {
        $Compartments = @(Get-NetCompartment -ErrorAction SilentlyContinue)
    }
    catch{}
    return @($Compartments)
}

function Get-InterfaceIndexInCompartment($Interfaces, $CompartmentId)
{
    return @(@(($Interfaces | Where CompartmentId -eq $CompartmentId).InterfaceIndex) | sort -Unique)
}

function Get-RoutesInCompartment($Routes, $Interfaces, $CompartmentId)
{
    $InterfaceIndexes = @(Get-InterfaceIndexInCompartment -Interfaces $Interfaces -CompartmentId $CompartmentId)
    return @($Routes | ? {$InterfaceIndexes -contains $_.InterfaceIndex})
}

function Get-InterfaceIPsInCompartment($Interfaces, $InterfaceIPs, $CompartmentId)
{
    $InterfaceIndexes = @(Get-InterfaceIndexInCompartment -Interfaces $Interfaces -CompartmentId $CompartmentId)
    return @(($InterfaceIPs | ? {$InterfaceIndexes -contains $_.InterfaceIndex}).IPAddress | Sort -Unique)
}

# Used to drop % from IPv6 link local addresses
function Drop-PercentageFromIPs($IPs)
{
    $IPsRet = @()
    foreach($IP in $IPs)
    {
        $IPsRet += ($IP.Split("%")[0])
    }
    return @($IPsRet | Sort -Unique)
}

function Get-VpnAuthProtocolBpa
{
    try
    {
        $AuthProtocol = Get-VpnAuthProtocol -ErrorAction SilentlyContinue
        return $AuthProtocol
    }
    catch
    {
        return $Null
    }
}

function Get-RemoteAccessRoutingDomainBpa
{
    try
    {
        return @(Get-RemoteAccessRoutingDomain -ErrorAction SilentlyContinue)
    }
    catch
    {
        return @()
    }
}
#endregion

#region BGP Helper functions

function Get-BgpRouterBpa($MultiTenancy)
{
    try
    {
        if($MultiTenancy -eq $True)
        {
            return @(Get-BgpRouter  -ErrorAction SilentlyContinue)
        }
        else 
        {
            try
            {
               return @(Get-BgpRouter -ErrorAction SilentlyContinue)
            }
            catch
            {
            }
        }
    }
    catch{}
    return @()
}

function Get-BgpPeerBpa($MultiTenancy, $Routers)
{
    $Peers = @()
    try
    {
        if($MultiTenancy -eq $True)
        {
            $RoutingDomains = @($Routers | Where PeerName -ne $Null | Select RoutingDomain)
            $Peers = @($RoutingDomains | Get-BgpPeer -ErrorAction SilentlyContinue)
        }
        else
        {
            try
            {
                $Peers = @(Get-BgpPeer  -ErrorAction SilentlyContinue)
            }
            catch{}
        }
    }
    catch{}
    return @($Peers)
}

function Get-BgpRoutingPolicyBpa($MultiTenancy, $Routers)
{
    $Policies = @()
    try
    {
        if($MultiTenancy -eq $True)
        {
            $RoutingDomains = @($Routers | Where PolicyName -ne $Null | Select RoutingDomain)
            $Policies = @($RoutingDomains | Get-BgpRoutingPolicy -ErrorAction SilentlyContinue)
        }
        else
        {
            try
            {
                $Policies = @(Get-BgpRoutingPolicy  -ErrorAction SilentlyContinue)
            }
            catch{}
        }
    }
    catch{}
    return @($Policies)
}

function Get-BgpCustomRouteBpa($MultiTenancy, $Routers)
{
    $CustomRoutes = @()
    try
    {
        if($MultiTenancy -eq $True)
        {
            $RoutingDomains = $Routers | Select RoutingDomain
            $CustomRoutes = @($RoutingDomains | Get-BgpCustomRoute -ErrorAction SilentlyContinue)
        }
        else
        {
            try
            {
                $CustomRoutes = @(Get-BgpCustomRoute -ErrorAction SilentlyContinue)
            }
            catch{}
        }
    }
    catch{}
    return @($CustomRoutes)
}

function Get-BgpRouteInformationBpa($MultiTenancy, $Routers)
{
    $BgpRoutes = @()
    try
    {
        if($MultiTenancy -eq $True)
        {
            $RoutingDomains = $Routers | Select RoutingDomain
            $BgpRoutes = @($RoutingDomains | Get-BgpRouteInformation -ErrorAction SilentlyContinue)
        }
        else
        {
            try
            {
                $BgpRoutes = @(Get-BgpRouteInformation -ErrorAction SilentlyContinue)
            }
            catch{}
        }
    }
    catch{}
    return @($BgpRoutes)
}

function Get-Intersection($List1, $List2)
{
    $ListRet = @()
    if(($List1 -ne $Null) -and ($List2 -ne $Null))
    {
        $List1 = @(@($List1) | ? { $_ } | sort -Unique)
        $List2 = @(@($List2) | ? { $_ } | sort -Unique)
        $ListRet = $List1 | ?{$List2 -contains $_}
    }
    return @($ListRet)
}

function Get-CommaSeperatedBgpPeerNames($Peers)
{
    return (@($Peers.PeerName) -join ",")
}

function Get-CommaSeperatedBgpPeerNamesInRoutingDomain($Peers, $MultiTenancy, $RoutingDomain)
{
    $PeersInRd = @()
    if($MultiTenancy -eq $True)
    {
       $PeersInRd = @($Peers | Where RoutingDomain -eq $RoutingDomain)
    }
    else
    {
        $PeersInRd = @($Peers)
    }
    $Ret = Get-CommaSeperatedBgpPeerNames -Peers $Peers
    return $Ret
}

function Get-PeersWithoutMaxPrefixPolicy($Peers)
{
    return @($Peers | Where MaxAllowedPrefix -eq $null)
}

function Get-PeersWithLowMaxPrefixPolicy($Peers)
{
    $MaxPrefixPolicyMinValue = 10
    return @($Peers | Where MaxAllowedPrefix -lt $MaxPrefixPolicyMinValue | Where MaxAllowedPrefix -ne $null)
}

function Get-PeersWithZeroHoldTime($Peers)
{
    return @($Peers | Where HoldTimeSec -eq 0)
}

function Get-PeersWithLowHoldTime($Peers)
{
    $HoldTimeMinValue = 20
    return @($Peers | Where HoldTimeSec -lt $HoldTimeMinValue)
}

function Get-PeersWithManualPeeringMode($Peers)
{
    return @($Peers | Where PeeringMode -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PeeringMode]::Manual))
}

function Get-PeersWithHighIdleHoldTime($Peers)
{
    $MaxIdleHoldTimeValue = 10
    return @($Peers | Where IdleHoldTimeSec -gt $MaxIdleHoldTimeValue)
}

function Get-RoutersWithoutLocalIPv6Address($MultiTenancy, $Routers, $Peers)
{
    $RoutersRet = @()
    $IPv4Peers = @($Peers | ? {([System.Net.IPAddress]$_.LocalIPAddress).AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork})
    foreach($Router in $Routers)
    {
        if($Router.IPv6Routing -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.IPv6RoutingState]::Enabled)
        {
            #LocalIPv6Address not specified
            if($Router.LocalIPv6Address -eq $Null)
            {
                if($MultiTenancy -eq $True)
                {
                    $IPv4PeersCount = (@($IPv4Peers | Where RoutingDomain -eq $Router.RoutingDomain)).Count
                    if($IPv4PeersCount -gt 0)
                    {
                        $RoutersRet += $Router
                    }
                }
                else
                {
                    if($IPv4Peers.Count -gt 0)
                    {
                        $RoutersRet += $Router
                    }
                }
            }
        }
    }
    return @($RoutersRet)
}

# Return policies which will drop all the prefixes
function Get-AllRouteDropPolicy($Policies)
{
    $DenyPolicies = @($Policies | Where PolicyType -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyType]::Deny))
    return @($DenyPolicies | Where MatchPrefix -eq $Null | Where IgnorePrefix -eq $Null | Where MatchCommunity -eq $Null | Where MatchASNRange -eq $Null | Where MatchNextHop -eq $Null)
}

function Get-DefaultRouteDropPolicyV4($Policies)
{
    $PoliciesRet = Get-AllRouteDropPolicy -Policies $Policies
    foreach($Policy in $Policies)
    {
        if($Policy.PolicyType -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyType]::Deny)
        {
            $MatchPrefix = $Policy.MatchPrefix
            if($MatchPrefix -ne $null)
            {
                if($MatchPrefix.Contains("0.0.0.0/0") -eq $True)
                {
                    $PoliciesRet += $Policy                
                }
            }
        }
    }
    return @($PoliciesRet | Sort -Unique)
}

function Get-DefaultRouteDropPolicyV6($Policies)
{
    $PoliciesRet = Get-AllRouteDropPolicy -Policies $Policies
    foreach($Policy in $Policies)
    {
        if($Policy.PolicyType -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyType]::Deny)
        {
            $MatchPrefix = $Policy.MatchPrefix
            if($MatchPrefix -ne $null)
            {
                if($MatchPrefix.Contains("::/0") -eq $True)
                {
                    $PoliciesRet += $Policy                
                }
            }
        }
    }
 
    return @($PoliciesRet | Sort -Unique)
}



function Get-PeersWithAllRouteDropPolicy($MultiTenancy, $Routers, $Peers, $Policies, $Direction)
{
    $PeersRet = @()
    $AllRouteDropPolicies = @(Get-AllRouteDropPolicy -Policies $Policies)
    foreach($Router in $Routers)
    {
        $PeersInRd  = @()
        $AllRouteDropPoliciesInRd = @()
        if($MultiTenancy -eq $false)
        {
            $PeersInRd = @($Peers)
            $AllRouteDropPoliciesInRd = ($AllRouteDropPolicies)
        }
        else
        {
            $PeersInRd = @($Peers | Where RoutingDomain -eq $Router.RoutingDomain)
            $AllRouteDropPoliciesInRd = ($AllRouteDropPolicies | Where RoutingDomain -eq $Router.RoutingDomain)
        }

        foreach($Peer in $PeersInRd)
        {
            $DropPolicyList = @(($AllRouteDropPoliciesInRd | Where MatchASN -eq $Null | Where MatchNextHop -eq $Null).PolicyName)
            $PolicyList = @()
            if($Direction -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyDirection]::Ingress))
            {
                $PolicyList  = @($Peer.IngressPolicyList)
            }
            else
            {
                $PolicyList  = @($Peer.EgressPolicyList)
            }

            $PolicyIntersection = Get-Intersection -List1 $DropPolicyList -List2 $PolicyList
            if($PolicyIntersection.Count -gt 0)
            {
                $PeersRet += $Peer
            }
        }
    }
    return @($PeersRet)
}

function Get-PeersWithoutDeafultRouteDropPolicy($MultiTenancy, $Routers, $Peers, $Policies, $Direction)
{
    $PeersRet = @()
    $PolicyDefaultRouteDropV4 = @(Get-DefaultRouteDropPolicyV4 -Policies $Policies)
    $PolicyDefaultRouteDropV6 = @(Get-DefaultRouteDropPolicyV6 -Policies $Policies)
    foreach($Router in $Routers)
    {
        $PeersInRd = @()
        $PolicyDefaultRouteDropV4InRd = @()
        $PolicyDefaultRouteDropV6InRd = @()

        if($MultiTenancy -eq $False)
        {
            # We Would run only once in case MultiTenancy is $False
            $PeersInRd = @($Peers)
            $PolicyDefaultRouteDropV4InRd = @(($PolicyDefaultRouteDropV4).PolicyName)
            $PolicyDefaultRouteDropV6InRd = @(($PolicyDefaultRouteDropV6).PolicyName)
        }
        else
        {
            $PeersInRd = @($Peers | Where RoutingDomain -eq $Router.RoutingDomain)
            $PolicyDefaultRouteDropV4InRd = @(($PolicyDefaultRouteDropV4 | Where RoutingDomain -eq $Router.RoutingDomain).PolicyName)
            $PolicyDefaultRouteDropV6InRd = @(($PolicyDefaultRouteDropV6 | Where RoutingDomain -eq $Router.RoutingDomain).PolicyName)
        }

        foreach($Peer in $PeersInRd)
        {
            $PolicyList = @()
            if($Direction -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyDirection]::Ingress))
            {
                $PolicyList = @($Peer.IngressPolicyList)
            }
            else
            {
                $PolicyList = @($Peer.EgressPolicyList)
            } 

            if(($PolicyList -eq $null) -or ($PolicyList.Count -eq 0))
            {
                $PeersRet += $Peer
            }
            else
            {
                 $IPv4DropPolicy = Get-Intersection -List1 $PolicyList -List2 $PolicyDefaultRouteDropV4InRd
                 $IPv6DropPolicy = Get-Intersection -List1 $PolicyList -List2 $PolicyDefaultRouteDropV6InRd

                 if(($IPv4DropPolicy.Count -eq 0) -or ($IPv6DropPolicy.Count -eq 0))
                 {
                    $PeersRet += $Peer
                 }
            }
        }
    }
    return @($PeersRet)
}

# Per Routing Domain
function Get-PeersWithPeerIpOnInterface($MultiTenancy, $Routers, $Peers, $Interfaces, $InterfaceIPs)
{
    $PeersRet = @()
    foreach($Router in $Routers)
    {
        $InterfaceIPsInRd = @()
        $PeersInRd = @()

        if($MultiTenancy -eq $False)
        {
            $InterfaceIPsInRd = @(@(($InterfaceIPs).IPAddress) | Sort -Unique)
            $PeersInRd = @($Peers)
        }
        else
        {
            $CompartmentId = ($Compartments | Where CompartmentDescription -eq $Router.RoutingDomain).CompartmentId
            $InterfaceIPsInRd = Get-InterfaceIPsInCompartment -Interfaces $Interfaces -InterfaceIPs $InterfaceIPs -CompartmentId $CompartmentId
            $PeersInRd = @($Peers | Where RoutingDomain -eq $Router.RoutingDomain)
        }
        $InterfaceIPsInRd = @(Drop-PercentageFromIPs -IPs $InterfaceIPsInRd)

        $PeersRet = @($PeersInRd | ? {$InterfaceIPsInRd -Contains $_.PeerIPAddress})
    }
    return @($PeersRet)
}

function Get-IPv6PeersWithIPv4CustomRoutes($MultiTenancy,$Routers, $Peers, $CustomRoutes)
{
    $PeersRet = @()
    foreach($Router in $Routers)
    {
        $PeersInRd = @()
        $CustomRoutesInRd = @()
        if($MultiTenancy -eq $False)
        {
            $PeersInRd = $Peers
            $CustomRoutesInRd = $CustomRoutes
        }
        else
        {
            $PeersInRd = $Peers | Where RoutingDomain -eq $Router.RoutingDomain
            $CustomRoutesInRd = $CustomRoutes | Where RoutingDomain -eq $Router.RoutingDomain
        }

        if(($CustomRoutesInRd -ne  $Null) -and ($CustomRoutesInRd.Network -ne $Null))
        {
            $IPv4CustomRoute = $False
            foreach($Network in $CustomRoutesInRd.Network)
            {
                if(([System.Net.IPAddress]$Network.Split("/")[0]).AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork)
                {
                    $IPv4CustomRoute = $True
                    break
                }
            }
            if($IPv4CustomRoute -eq $True)
            {
                foreach($Peer in $PeersInRd)
                {
                    if(([System.Net.IPAddress]$Peer.LocalIPAddress).AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetworkV6)
                    {
                        $PeersRet += $Peer
                    }
                }
            }
        }
    }
    return @($PeersRet)
}


#Returns the MASK in IPAddress format, eg /23 for IPv4 will return 255.255.254.0
function Get-IpFromMask
{
    Param(
            [Parameter(Mandatory=$True)]
            [int]
            $Mask,
            [Parameter(Mandatory=$True)]
            [bool]
            $IPv4
    )

    [System.Byte[]]$maskBytes = @()

    if($IPv4 -eq $True)
    {
        $maskBytes = @(0,0,0,0)
    }
    else
    {
        $maskBytes = @(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    }

    for($i = 0 ; $i -lt $maskBytes.Count ; $i++)
    {
        if($i -lt [Math]::Truncate(($Mask / 8)))
        {
            $maskBytes[$i] = 0xFF
        }    
        else
        {
            if($i -gt [Math]::Truncate(($Mask / 8)))
            {
                $maskBytes[$i] = 0
            }
            else
            {
                [System.Byte]$val = 0
                [System.Byte]$BitMask = 0x80
                for($j =0 ; $j -lt $Mask % 8  ; $j++)
                {
                    $val = $val -bor [System.Byte]($BitMask -shr $j)
                }
                $maskBytes[$i] = $val
            }
        }
    }
    
    return New-Object -TypeName System.Net.IPAddress -ArgumentList (,$maskBytes)
}

# Applies subnet mask on the given IP
function Apply-Mask
{
    Param(
            [Parameter(Mandatory=$True)]
            [IPAddress]
            $Ip,
            [Parameter(Mandatory=$True)]
            [int]
            $Mask
    )

    [System.Net.IPAddress]$MaskIp
    if($Ip.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork)
    {
        $MaskIp = Get-IpFromMask -Mask $Mask -IPv4 $True
    }
    else 
    {
        $MaskIp = Get-IpFromMask -Mask $Mask -IPv4 $False
    }

    $IpBytes = $Ip.GetAddressBytes()
    $MaskBytes = $MaskIp.GetAddressBytes()

    for($i = 0 ; $i -lt $IpBytes.Count ;  $i++)
    {
        $IpBytes[$i] = $IpBytes[$i] -band $MaskBytes[$i]
    }

    return New-Object System.Net.IPAddress -ArgumentList (,$IpBytes)
}

# Returns true if $Prefix1 contains $Prefix2
function Test-Prefix1ContainsPrefix2
{
    Param(
            [Parameter(Mandatory=$True)]
            [String] $Prefix1,
            [Parameter(Mandatory=$True)]
            [String] $Prefix2
    )
    $Ip1 = $Prefix1.Split("/")[0]
    $Ip2 = $Prefix2.Split("/")[0]

    $Mask1 = [int]$Prefix1.Split("/")[1]
    $Mask2 = [int]$Prefix2.Split("/")[1]

    if($Mask1 -le $Mask2)
    {
        $Ip1 = Apply-Mask -Ip $Ip1 -Mask $Mask1
        $Ip2 = Apply-Mask -Ip $Ip2 -Mask $Mask1

        #.Equals on $Ip1 is not working, so using string comparison instead
        return $Ip1.IPAddressToString.Equals($Ip2.IPAddressToString)
    }
    return $False
}

# Return $BgpPrefixes which are not resolvable by $SystemPrefixes
function Get-UnresolvablePrefixes($SystemPrefixes, $BgpPrefixes)
{
    $BgpPrefixesRet = @()
    foreach($BgpPrefix in $BgpPrefixes)
    {
        $Resolvable = $False
        foreach($SystemPrefix in $SystemPrefixes)
        {
            if((Test-Prefix1ContainsPrefix2 -Prefix1 $SystemPrefix -Prefix2 $BgpPrefix) -eq $True)
            {
                $Resolvable = $true
                break
            }   
        }

        if($Resolvable -eq $False)
        {
            $BgpPrefixesRet += $BgpPrefix
        }
    }
    return @($BgpPrefixesRet)
}

function Get-BgpUnresolvableCustomRoutes($MultiTenancy, $Compartments, $Routers, $Peers, $Policies, $CustomRoutes, $Routes, $Interfaces)
{
    $CustomRoutesRet = @()

    foreach($Router in $Routers)
    {
        $CustomRoutesInRd = @()
        $RoutesInRd = @()
        if($MultiTenancy -eq $true)
        {
            $CustomRoutesInRd = @(Get-ObjectsInRoutingDomain -Objects $CustomRoutes -RoutingDomain $Router.RoutingDomain)
            $CompartmentId = ($Compartments | Where CompartmentDescription -eq $Router.RoutingDomain).CompartmentId
            $RoutesInRd = @(Get-RoutesInCompartment -Routes $Routes -Interfaces $Interfaces -CompartmentId $CompartmentId | ? {$_})
        }
        else
        {
            $CustomRoutesInRd = @(Get-ObjectsInRoutingDomain -Objects $CustomRoutes -RoutingDomain $Null)
            $RoutesInRd = @($Routes | ? {$_})
        }

        # Only one object per RD
        if($CustomRoutesInRd.Count -eq 1)
        {
            if($CustomRoutesInRd[0].Network -ne $Null)
            {
                $CustomNetworks = $CustomRoutesInRd[0].Network
                $InterfaceNetworks = @($RoutesInRd.DestinationPrefix) | Sort -Unique

                $UnresolvablePrefixes = @(Get-UnresolvablePrefixes -SystemPrefixes $InterfaceNetworks -BgpPrefixes $CustomNetworks)
                if($UnresolvablePrefixes.Count -gt 0)
                {
                    $CustomRouteObjRet =  New-Object -TypeName PSObject
                    $CustomRouteObjRet | Add-Member -Name "Network" -Value (@($UnresolvablePrefixes)) -MemberType NoteProperty
                    $CustomRouteObjRet | Add-Member -Name "Interface" -Value (@($CustomRoutesInRd.Interface) | ? {$_}) -MemberType NoteProperty
                    $CustomRoutesRet += $CustomRouteObjRet
                }
            }
        }
    }
    return @($CustomRoutesRet)
}

function Get-SamePrefixMultipleNextHopPolicies($MultiTenancy, $Routers, $Policies)
{
    #TODO 
    $NextHopModifyPolicies = @($Policies | Where PolicyType -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyType]::ModifyAttribute) | Where NewNextHop -eq $Null)
    $PoliciesRet = @()
    if($NextHopModifyPolicies.Count -ge 2)
    {
        foreach($Router in $Routers)
        {
            $NextHopModifyPoliciesInRd = @()
            if($MultiTenancy -eq $True)
            {
                $NextHopModifyPoliciesInRd = @(Get-ObjectsInRoutingDomain -Objects $NextHopModifyPolicies -RoutingDomain $Router.RoutingDomain)
            }
            else
            {
                $NextHopModifyPoliciesInRd = @($NextHopModifyPolicies)
            }

            if($NextHopModifyPoliciesInRd.Count -ge 2)
            {
                #TODO: Do the grouping
            }
        }
    }

    return @($PoliciesRet)
}

function Test-MaxPrefixLimitProximity
{
    Param(
    [Parameter(Mandatory=$True)]
    [System.UInt32]$MaxPrefixLimit, 
    [Parameter(Mandatory=$True)]
    [System.UInt32]$RouteCount
    )

    if($MaxPrefixLimit -lt 10)
    {
        return $True
    }
    else
    {
        return ($RouteCount -ge ($MaxPrefixLimit - 10))
    }
}

function Get-PeersWithRoutesNearMaxPrefixLimit($MultiTenancy, $Routers, $Peers, $BgpRoutes)
{
    $PeersRet = @()
    foreach($Router in $Routers)
    {
        $PeersInRd = @()
        $BgpRoutesInRd = @()

        if($MultiTenancy -eq $True)
        {
            $PeersInRd = Get-ObjectsInRoutingDomain -Objects $Peers -RoutingDomain $Router.RoutingDomain
            $BgpRoutesInRd = Get-ObjectsInRoutingDomain -Objects $BgpRoutes -RoutingDomain $Router.RoutingDomain
        }
        else
        {
            $PeersInRd = $Peers
            $BgpRoutesInRd = $BgpRoutes
        }

        foreach($Peer in $PeersInRd)
        {
            $MaxPrefixLimitSet = (Get-PeersWithoutMaxPrefixPolicy -Peers $Peer).Count -eq 0
            if($MaxPrefixLimitSet -eq $True)
            {
                $MaxPrefixLimit = $Peer.MaxAllowedPrefix
                $RoutesLearnedFromPeerCount = (@($BgpRoutesInRd | Where LearnedFromPeer -eq $Peer.PeerName)).Count
                $RouteProximity = Test-MaxPrefixLimitProximity -MaxPrefixLimit $MaxPrefixLimit -RouteCount $RoutesLearnedFromPeerCount
                if($RouteProximity -eq $True)
                {
                    $PeersRet += $Peer
                }
            }
        }
    }
    return @($PeersRet)
}

#endregion BGP Helper functions


#region MT-VPN Helper functions

function Test-IsIPUnicast([System.Net.IPAddress]$IPAddress)
{
    if($IPAddress.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork)
    {
        $Bytes = $IPAddress.GetAddressBytes()
        if($Bytes[0] -eq 0)
        {
            return $False
        }
        elseif($Bytes[0] -eq 127)
        {
            return $False
        }
        elseif(($Bytes[0] -eq 169) -and ($Bytes[1] -eq 254))
        {
            return $False
        }
        elseif($Bytes[0] -ge 224)
        {
            return $False
        }
        else 
        {
            return $True
        }
    }
    else
    {
        $Bytes = $IPAddress.GetAddressBytes()
        if(($Bytes[0] -eq 0x20) -or ($Bytes[0] -eq 0xfc))
        {
            return $True
        }
        else
        {
            return $False
        } 
    }
    return $False
}

function Test-TenantName1ContainsTenantName2($TenantName1, $TenantName2)
{
    foreach($TenantName2Temp in $TenantName2)
    {
        foreach($TenantName1Temp in $TenantName1)
        {
            #  $TenantName1Temp will be a broader regex
            if($TenantName2Temp -Like $TenantName1Temp)
            {
                return $True
            }
        }
    }
    return $False
}

function Get-VPNRoutingDomains($RemoteAccessRoutingDomains)
{
    return @($RemoteAccessRoutingDomains | Where VpnStatus -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.RemoteAccessRoutingDomain.State]::Enabled) | ? {$_}) 
}

function Get-VPNRoutingDomainsWithTenantName($VPNRoutingDomains)
{
    return @($VPNRoutingDomains | Where TenantName -ne $Null | ? {$_})
}

function Get-VPNRoutingDomainsWithTenantNameSubsetOfAnother($VPNRoutingDomainsWithTenantName)
{
    $VPNRoutingDomainsWithTenantNameTemp = $VPNRoutingDomainsWithTenantName
    $RoutingDomainsRet = @()
    foreach($Rd1 in $VPNRoutingDomainsWithTenantName)
    {
        $OtherRdList = @()
        foreach($Rd2 in $VPNRoutingDomainsWithTenantNameTemp)
        {
            if($Rd1.RoutingDomain -ne $Rd2.RoutingDomain)
            {
                $TenantNameSubsetOfAnother = Test-TenantName1ContainsTenantName2 -TenantName1 $Rd2.TenantName -TenantName2 $Rd1.TenantName
                if($TenantNameSubsetOfAnother)
                {
                    $OtherRdList += $Rd2.RoutingDomain
                }
            }
        }

        if($OtherRdList.Count -gt 0)
        {
            $CustomRouteObjRet =  New-Object -TypeName PSObject
            $CustomRouteObjRet | Add-Member -Name "RoutingDomain" -Value ($Rd1.RoutingDomain) -MemberType NoteProperty
            $CustomRouteObjRet | Add-Member -Name "OtherRdList" -Value (@($OtherRdList) | ? {$_}) -MemberType NoteProperty
            $RoutingDomainsRet += $CustomRouteObjRet  
        }
    }
    return $RoutingDomainsRet
}

function Get-VPNRoutingDomainsWithStaticAddressPool($VPNRoutingDomains)
{
    return @($VPNRoutingDomains | ? {($_.IPAddressRange -ne $Null) -or ($_.IPv6Prefix -ne "")} | ? {$_})
}

function Get-VPNRoutingDomainsWithoutUnicastStaticAddressPool($VPNRoutingDomainsWithStaticAddressPool)
{
    $VpnRoutingDomainsRet = @()
    foreach($VPNRoutingDomain in $VPNRoutingDomainsWithStaticAddressPool)
    {
        # Either/Both of these will be true
        if($VPNRoutingDomain.IPAddressRange -ne $Null)
        {
            $IPAddressRange = @($VpnRoutingDomain.IPAddressRange)
            foreach($IPAddress in $IPAddressRange)
            {
                $IsUnicast = Test-IsIPUnicast -IPAddress ([System.Net.IPAddress]::Parse($IPAddress))
                if($IsUnicast -eq $False)
                {
                    $VpnRoutingDomainsRet += $VpnRoutingDomain
                    break
                }
            }
        }
        
        #if($VPNRoutingDomain.IPv6Prefix -ne "")
        #{
        #    $IsUnicast = Test-IsIPUnicast -IPAddress ([System.Net.IPAddress]::Parse($VPNRoutingDomain.IPv6Prefix.Split("/")[0]))
        #    if($IsUnicast -eq $False)
        #    {
        #        $VpnRoutingDomainsRet += $VpnRoutingDomain
        #    }
        #}
    }

    return @($VpnRoutingDomainsRet | Sort -Unique | ? {$_}) 
}

#endregion

#region S2S Helper functions

function Get-CommaSeperatedS2SInterfaceNames($S2SInterfaces)
{
    return (@($S2SInterfaces.Name) -join ",")
}

function Get-VpnS2SInterfaceBpa
{
    $S2SInterfaces = @()
    try
    {
        $S2SInterfaces = @(Get-VpnS2SInterface)
    }
    catch{}
    return @($S2SInterfaces)
}

#Global Constants
$Protocol_PSK = "PSKOnly"
$String_Authentication = "Authentication"


#Encryption Types
#No Encryption
$NoEncryptionPolicies = New-Object -TypeName PSObject
#(ESPCipherTransform,ESPAuthTransform)
$NoEncryptionQMPolicies = @(("None","SHA196"),("None","MD596"))
#(DHGroup,EncryptionMethod,IntegrityCheckMethiod)
$NoEncryptionMMPolicies = @(("Group2","DES3","SHA1"),("Group2","DES3","SHA256"), ("Group2","DES3","SHA384"),("Group2","AES256","SHA1"),("Group2","AES256","SHA256"), ("Group2","AES256","SHA384"), ("Group2","AES128","SHA1"),("Group2","AES128","SHA256"), ("Group2","AES128","SHA384"),("Group2","AES192","SHA1"),("Group2","AES192","SHA256"), ("Group2","AES192","SHA384"))
$NoEncryptionPolicies | Add-Member -Name "QMPolicies" -Value $NoEncryptionQMPolicies -MemberType NoteProperty
$NoEncryptionPolicies | Add-Member -Name "MMPolicies" -Value $NoEncryptionMMPolicies -MemberType NoteProperty

#Require Encryption
$RequireEncryptionPolicies = New-Object -TypeName PSObject
#(ESPCipherTransform,ESPAuthTransform)
$RequireEncryptionQMPolicies = @(("AES128","SHA196"),("DES3","MD596"),("DES3","SHA196"),("DES","SHA196"),("DES","SHA196"))
#(DHGroup,EncryptionMethod,IntegrityCheckMethiod)
$RequireEncryptionMMPolicies = @(("Group2","DES3","SHA1"),("Group2","DES3","SHA256"), ("Group2","DES3","SHA384"),("Group2","AES256","SHA1"),("Group2","AES256","SHA256"), ("Group2","AES256","SHA384"), ("Group2","AES128","SHA1"),("Group2","AES128","SHA256"), ("Group2","AES128","SHA384"),("Group2","AES192","SHA1"),("Group2","AES192","SHA256"), ("Group2","AES192","SHA384"))
$RequireEncryptionPolicies | Add-Member -Name "QMPolicies" -Value $RequireEncryptionQMPolicies -MemberType NoteProperty
$RequireEncryptionPolicies | Add-Member -Name "MMPolicies" -Value $RequireEncryptionMMPolicies -MemberType NoteProperty

#Maximum Encryption
$MaximumEncryptionPolicies = New-Object -TypeName PSObject
#(ESPCipherTransform,ESPAuthTransform)
$MaximumEncryptionQMPolicies = @(("AES256","SHA196"),("DES3","MD596"),("DES3","SHA196"))
#(DHGroup,EncryptionMethod,IntegrityCheckMethiod)
$MaximumEncryptionMMPolicies = @(("Group2","DES3","SHA1"),("Group2","DES3","SHA256"), ("Group2","DES3","SHA384"),("Group2","AES256","SHA1"),("Group2","AES256","SHA256"), ("Group2","AES256","SHA384"))
$MaximumEncryptionPolicies | Add-Member -Name "QMPolicies" -Value $MaximumEncryptionQMPolicies -MemberType NoteProperty
$MaximumEncryptionPolicies | Add-Member -Name "MMPolicies" -Value $MaximumEncryptionMMPolicies -MemberType NoteProperty

#Optional Encryption
$OptionalEncryptionPolicies = New-Object -TypeName PSObject
#(ESPCipherTransform,ESPAuthTransform)
$OptionalEncryptionQMPolicies = @(("AES256","SHA196"), ("AES128","SHA196"),("DES3","MD596"),("DES3","SHA196"),("DES","SHA196"),("DES","SHA196"),("None","SHA196"),("None","MD596"))
#(DHGroup,EncryptionMethod,IntegrityCheckMethiod)
$OptionalEncryptionMMPolicies = @(("Group2","DES3","SHA1"),("Group2","DES3","SHA256"), ("Group2","DES3","SHA384"),("Group2","AES256","SHA1"),("Group2","AES256","SHA256"), ("Group2","AES256","SHA384"), ("Group2","AES128","SHA1"),("Group2","AES128","SHA256"), ("Group2","AES128","SHA384"),("Group2","AES192","SHA1"),("Group2","AES192","SHA256"), ("Group2","AES192","SHA384"))
$OptionalEncryptionPolicies | Add-Member -Name "QMPolicies" -Value $OptionalEncryptionQMPolicies -MemberType NoteProperty
$OptionalEncryptionPolicies | Add-Member -Name "MMPolicies" -Value $OptionalEncryptionMMPolicies -MemberType NoteProperty

#Returns $True if the string is IPAddress
function Is-ValidIP
{
   Param(
            [Parameter(Mandatory=$True)]
            [System.String]
            $IpAddresses
    )
    try
    {
        $IpObj = [System.Net.IPAddress]::Parse($IpAddresses)
    }
    catch
    {
        return $False
    }
    return $True
}

########################################################################################################
# Is-ValidMultiTenantConfiguration - Rule New
# If it is a multi-tenant setup and non- multitenant RRAS installation or vice versa
########################################################################################################
function Is-ValidMultiTenantConfiguration
{
    Param(
            [Parameter(Mandatory=$True)]
            [System.Boolean]
            $MultiTenancy,
            [Parameter(Mandatory=$True)]
            [System.Int64]
            $CompartmentCount
    )
    if((($MultiTenancy -eq $True) -and ($CompartmentCount -le 1)) -or (($MultiTenancy -eq $false) -and ($CompartmentCount -gt 1)))
    {
        return $False
    }
    return $True
}


function Get-IkeV2MachineCertificateEnabledInterfaces
{
    Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $S2SInterfaces
          )
  return @($S2SInterfaces | where AuthenticationMethod -eq "MachineCertificates")
}

function Is-InboundCAConfigured
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $AuthProtocol
    )
    if($AuthProtocol -ne $Null)
    {
        if(($AuthProtocol.UserAuthProtocolAccepted -contains "Certificate") -and ($AuthProtocol.RootCertificateNameToAccept -ne $null))
        {
            return $true
        }
    }
    return $false
}

########################################################################################################
# Get-InterfacesWhoseCertsExpiringSoon - Rule 13
# Get all interfaces whose certificates are expiring in 7 days
########################################################################################################

function get-CertExpireSoon
{
    Param(
    [Parameter(Mandatory=$True)]
    [System.Security.Cryptography.X509Certificates.X509Certificate2]
    $Certificate
    )

    [System.DateTime]$TodaysDate = [System.DateTime]::Now
    if($Certificate.NotAfter -le $TodaysDate.AddDays(7))
    {   
        return $true
    }
    return $false
}

function Get-InterfacesWhoseCertsExpiringSoon
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $S2SInterfaces
    )
    $S2SInterfacesRet = @()
    foreach($S2SInterface in $S2SInterfaces)
    {
        if($S2SInterface.Certificate -ne $null)
        {
            $IsExpiring = get-CertExpireSoon -Certificate $S2SInterface.Certificate
            if($IsExpiring -eq $true)
            {
                $S2SInterfacesRet += $S2SInterface
            }
        }
    }
    return @($S2SInterfacesRet)
}

function Get-RootCertificate
{
    Param(
            [Parameter(Mandatory=$True)]
            [System.Security.Cryptography.X509Certificates.X509Certificate2[]]
            $RootCertList,
            [Parameter(Mandatory=$True)]
            [System.Security.Cryptography.X509Certificates.X509Certificate2] 
            $Certificate
        )
        #cert chain
        $chain = [System.Security.Cryptography.X509Certificates.X509Chain]::Create()
        $temp = $chain.Build($Certificate)

        foreach ($chainElement in $chain.ChainElements)
        {
            foreach($rootCert in $RootCertList)
            {
                if($rootCert.Thumbprint -eq $chainElement.Certificate.Thumbprint)
                {
                    return $rootCert
                }
            }
        }
        return $null
}

########################################################################################################
# Get-InterfacesWhoseRootCertsAreInvalid - Rule 14
# Get all interfaces whose certificates are expiring in 7 days
########################################################################################################
function Get-InterfacesWhoseRootCertsAreInvalid
{
    Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $S2SInterfaces,
            [Parameter(Mandatory=$True)]
            [System.Security.Cryptography.X509Certificates.X509Certificate2[]]
            $RootCertList
    )
    $NoRootCerInterfaces = @()
    $RootCertExpiringInterfaces = @()
    foreach($S2SInterface in $S2SInterfaces)
    {
        if($S2SInterface.Certificate -ne $null)
        {
            $rootCert = Get-RootCertificate -RootCertList $RootCertList -Certificate $S2SInterface.Certificate
            if($rootCert -eq $null)
            {
               $NoRootCerInterfaces += $S2SInterface
            }
            else
            {
                $IsExpiring = get-CertExpireSoon -Certificate $rootCert
                if($IsExpiring -eq $true)
                {
                    $RootCertExpiringInterfaces += $S2SInterface
                }
            }
        }
    }
    $returnValue = New-Object -TypeName PSObject
    $returnValue | Add-Member -Name "S2SInterfacesWithoutRootCertificate" -Value @($NoRootCerInterfaces) -MemberType NoteProperty
    $returnValue | Add-Member -Name "S2SInterfacesWithRootCertificateAboutToExpire" -Value @($RootCertExpiringInterfaces) -MemberType NoteProperty
    return $returnValue
}


########################################################################################################
# Is-ServerCertificateValid - Rule 15, 16
# Server certificate CN must have atleast one IP address
# Server certificate CN must have atleast one public IP address
########################################################################################################
function Is-ServerCertificateValid
{
    Param(
            [Parameter(Mandatory=$True)]
            [System.Security.Cryptography.X509Certificates.X509Certificate2]
            $ServerCertificate
    )
    $returnValue = New-Object -TypeName PSObject
    $hasOneIp = $false
    $hasOnePublicIP = $false
    $allStrings = $ServerCertificate.Subject.Split(",")
    foreach ($tempString in $allStrings)
    {
        if($tempString.Contains("CN="))
        {
            $ResolvableString = $tempString.Split("=")[1]

            $isValidIp = Is-ValidIP -IpAddresses $ResolvableString
            if($isValidIp -eq $true)
            {
                $hasOneIp = $true
                $address = [System.Net.IPAddress]::Parse($ResolvableString)
                if(($address.AddressFamily -eq "InterNetwork") -and ((Is-Publicv4IP -IPAddress $address) -eq $true))
                {
                    $hasOnePublicIP = $true
                }
                elseif(($address.AddressFamily -eq "InterNetworkV6") -and ((Is-Publicv6IP -IPAddress $address) -eq $true))
                {
                    $hasOnePublicIP = $true
                }
                if($hasOnePublicIP -eq $hasOneIp)
                {
                    $returnValue | Add-Member -Name "HasOneIPAtleast" -Value $hasOneIp -MemberType NoteProperty
                    $returnValue | Add-Member -Name "HasOnePublicIPAtleast" -Value $hasOneIp -MemberType NoteProperty
                    return $returnValue
                }
            }

        }
    }
    $returnValue | Add-Member -Name "HasOneIPAtleast" -Value $hasOneIp -MemberType NoteProperty
    $returnValue | Add-Member -Name "HasOnePublicIPAtleast" -Value $hasOneIp -MemberType NoteProperty
    return $returnValue
}


function Is-EAPBasedAuthConfigured
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $AuthProtocol
    )
    return ($AuthProtocol.UserAuthProtocolAccepted -contains "EAP")
}

function Is-LocalRadiusConfigured
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $LocalIpAddresses
    )
    $returnValue = $true
    $radiusObjs = @(Get-RemoteAccessRadius | where Purpose -eq $String_Authentication)

    if($radiusObjs -ne $null)
    {
        $returnValue = $false
        foreach($radiusObj in $radiusObjs)
        {
            #First check if is a valid IP
            if(Is-ValidIP -IpAddresses $radiusObjs.ServerName)
            {
                $returnValue = $LocalIpAddresses | Where IPAddress -eq $radiusObjs.ServerName
                if($returnValue -eq $true)
                {
                    return $returnValue
                }
            }
            else
            {
                #Compare it with the hostname
                $dnsRecords = @(Resolve-DNSName $radiusObjs.ServerName -ErrorAction SilentlyContinue)
                if($dnsRecords -ne $null)
                {
                    #Get all the IP's
                    foreach($dnsRecord in $dnsRecords)
                    {
                        $returnValue = $LocalIpAddresses | Where IPAddress -eq $dnsRecord.IPAddress
                        if($returnValue -eq $true)
                        {
                            return $returnValue
                        }
                    }
                }                
            }
        }
    }
    return $returnValue
}

function Get-AllEnabledDialInLocalAccounts()
{
    return @(Get-WmiObject -Namespace root\cimv2 -ComputerName localhost -Class Win32_UserAccount | ? {($_.LocalAccount -eq $true) -and ($_.Disabled -eq $False) -and ($_.Lockout -eq $False)} | ? {Is-DialInEnabled -UserName $_.Name})
}


function Get-EAPInterfacesWhoseNamesAreInvalid
{
    Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $S2SInterfaces,
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $AllEnabledDialInUserNames
    )
    return @($S2SInterfaces | Where AuthenticationMethod -eq "EAP" | ? {$AllEnabledDialInUserNames -notcontains $_.Name})
}

########################################################################################################
# Get-InterfacesWithDefaultRateLimitingSettings - Rule 19
# Get all interfaces whose destainations are same
########################################################################################################
function Get-InterfacesWithDefaultRateLimitingSettings
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $S2SInterfaces
    )
    $DefaultTxBandwidthKbps = 5120
    $DefaultRxBandwidthKbps = 5120
    return @($S2SInterfaces | ? {($_.RxBandwidthKbps -eq $DefaultRxBandwidthKbps) -and ($_.TxBandwidthKbps -eq $DefaultTxBandwidthKbps)})
}

function Get-InterfacesWithInValidRateLimitingParams
{
    Param(
        [Parameter(Mandatory=$True)]
        [AllowNull()]
        $S2SInterfaces
        )
    
    $S2SInterfacesRet = @()
    foreach($S2SInterface in $S2SInterfaces)
    {
        $LowValue = $S2SInterface.RxBandwidthKbps

        if($LowValue -gt $S2SInterface.TxBandwidthKbps)
        {
            $LowValue = $S2SInterface.TxBandwidthKbps
            $HighValue = $S2SInterface.RxBandwidthKbps
        }
        else
        {
            $HighValue = $S2SInterface.TxBandwidthKbps
        }

        $DiffPercent = ($LowValue * 100) / $HighValue

        if($DiffPercent -lt 30.0)
        {
            $S2SInterfacesRet += $S2SInterfaces;
        }
    }
    return @($S2SInterfacesRet)
}

########################################################################################################
# Get-PSKInterfacesWithSameDestination - Rule 22
# Get all PSK interfaces whose destainations are same
########################################################################################################
function Get-PSKInterfacesWithSameDestination
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $S2SInterfaces
    )
    return  @($S2SInterfaces | where AuthenticationMethod -eq "PSKOnly" | Group-Object Destination | where Count -gt 1)
}


########################################################################################################
# Get-PSKInterfacesWithFQDN - Rule 23
# Get all interfaces who doesnt have IP as their destination
########################################################################################################
function Get-PSKInterfacesWithFQDN
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $S2SInterfaces
    )
    $PSKS2SInterfaces = @($S2SInterfaces | where AuthenticationMethod -eq "PSKOnly")
    $S2SInterfacesRet = @()
    foreach($S2SInterface in $PSKS2SInterfaces)
    {
        $HasValidIP = $false
        foreach ($Destination in $S2SInterface.Destination)
        {
            $HasValidIP = Is-ValidIP -IpAddresses $Destination
            if($HasValidIP -eq $true)
            {
                break
            }
        }
        if($HasValidIP -eq $false)
        {
            $S2SInterfacesRet += $S2SInterface
        }
    }
    return @($S2SInterfacesRet)
}



########################################################################################################
# Is a V4 public IP
########################################################################################################
function Is-Publicv4IP()
{
    Param(
            [Parameter(Mandatory=$True)]
            [string]
            $IPAddress
            )
    $v4Address = [System.Net.IPAddress]$IPAddress
    #Skip the following
    #0.0.0.0/8
    #127/8
    #10/8
    #169.254/8
    #172.16/12
    #192.168/16
    if([System.Net.IPAddress]::IsLoopback($v4Address) -eq $false)
    {
        $AddressBytes = $v4Address.GetAddressBytes()
        if(($AddressBytes[0] -eq 10 -or ($AddressBytes[0] -eq 169 -and $AddressBytes[1] -eq 254) -or ($AddressBytes[0] -eq 172 -and ($AddressBytes[1] -ge 16 -and $AddressBytes[1] -le 31 ) ) -or ($AddressBytes[0] -eq 192 -and $AddressBytes[1] -eq 168) ))
        {
            return $false
        }
    }
    return $True
}

########################################################################################################
# Is a V6 public IP
########################################################################################################
function Is-Publicv6IP()
{
    Param(
            [Parameter(Mandatory=$True)]
            [string]
            $IPAddress
            )
    $v6Address = [System.Net.IPAddress]$address.IPv6Address
    #Discard the following IPv6 addresses
    #V4MappedToV6
    #LinkLocal
    #Multicast
    #SiteLocal
    #Teredo
    #Loopback
    if($v6Address.IsIPv4MappedToIPv6 -eq $false -and $v6Address.IsIPv6LinkLocal -eq $false -and $v6Address.IsIPv6Multicast -eq $false -and $v6Address.IsIPv6SiteLocal -eq $false -and $v6Address.IsIPv6Teredo -eq $false -and [System.Net.IPAddress]::IsLoopback($v6Address) -eq $false)
    {
        return $true
    }
    return $false
}

function Is-PublicIP
{
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $IPAddressString
    )

    $IPAddress = [System.Net.IPAddress]::Parse($IPAddressString)
    if($IPAddress.AddressFamily -eq ([System.Net.Sockets.AddressFamily]::InterNetwork))
    {
        return Is-Publicv4IP -IPAddress $IPAddressString   
    }
    else
    {
        return Is-Publicv6IP -IPAddress $IPAddressString
    }
}

########################################################################################################
# Is MultiplePublicAddressesAvailable- Rule 24
# Test if the default compartment has multiple public addresses
########################################################################################################
function Is-MultiplePublicAddressesAvailable
{
    Param(
    [Parameter(Mandatory=$True)]
    $InterfaceIPs
    )

    #Ignoring all TunnelType interfaces from default compartment
    $DefaultComparrmentInterfaceAliases = @(([System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() | where NetworkInterfaceType -ne "Tunnel" | where NetworkInterfaceType -ne "LoopBack").Name)
    $DefaultCompartmentIPs = @(@($InterfaceIPs | ? {$DefaultComparrmentInterfaceAliases -contains $_.InterfaceAlias}).IPAddress | ? {$_} | sort -Unique)
    $DefaultCompartmentIPs = @(Drop-PercentageFromIPs -IPs $DefaultCompartmentIPs | Sort -Unique)
    $DefaultCompartmentPublicIPs = @($DefaultCompartmentIPs | ? {Is-PublicIP -IPAddressString $_.ToString()})

    return ($DefaultCompartmentPublicIPs.Count -gt 1)
}

function Get-InterfacesWithoutSourceIp
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $S2SInterfaces
    )
    return @($S2SInterfaces | ? {($_.SourceIpAddress -eq $Null) -or ($_.SourceIpAddress -eq "")})
}

########################################################################################################
# Get-InterfacesWhoseCustomPoliciesAreNotSubsetOfGlobalPolicy - Rule 25
# 
########################################################################################################
function Is-SubsetPolicy
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $Interface,
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $GlobalPolicy
     )
     $customPolicyFound = $false
     #first check QMPolicies (CipherTransform,AuthTransform)
     foreach($policy in $GlobalPolicy.QMPolicies)
     {
        if($policy[0] -eq $Interface.CipherTransformConstants.ToString() -and $policy[1] -eq $Interface.AuthenticationTransformConstants.ToString())
        {
            $customPolicyFound = $true
            break
        }
     }

     #Check MMPolicy only if QM is found
     if($customPolicyFound -eq $true)
     {
         foreach($policy in $GlobalPolicy.MMPolicies)
         {
            if($policy[0] -eq $Interface.DHGroup.ToString() -and $policy[1] -eq $Interface.EncryptionMethod.ToString() -and $policy[2] -eq $Interface.IntegrityCheckMethod.ToString() )
            {
                return $true
            }
         }
     }

     return $false
}

function Get-InterfacesWhoseCustomPoliciesAreNotSubsetOfGlobalPolicy
{
     Param(
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $RoutingDomains,
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $InterfaceList,
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $IPSecConfig
        )
    $InvalidInterfaces = @()
    foreach($interface in $InterfaceList)
    {
        #Does interface has custompolicy?
        if($interface.PSObject.Properties.Match('CustomPolicy').Count)
        {
            $routingDomain = $RoutingDomains | where RoutingDomain -eq $interface.RoutingDomain 
            # if routing domain custom policy is available... 
            if($routingDomain -ne $null -and $routingDomain.PSObject.Properties.Match('CustomPolicy').Count)
            {
                if((($interface.AuthenticationTransformConstants.ToString() -eq $routingDomain.AuthenticationTransformConstant.ToString()) -and ($interface.CipherTransformConstants.ToString() -eq $routingDomain.CipherTransformConstant.ToString()) -and ($interface.DHGroup.ToString() -eq $routingDomain.DHGroup.ToString()) -and ($interface.EncryptionMethod.ToString() -eq $routingDomain.EncryptionMethod.ToString()) -and ($interface.IntegrityCheckMethod.ToString() -eq $routingDomain.IntegrityCheckMethod.ToString()) -and ($interface.PFSgroup.ToString() -eq $routingDomain.PFSgroup.ToString())) -eq $false)
                {
                    $InvalidInterfaces = $InvalidInterfaces + $interface
                }
            }
            elseif($IPSecConfig.PSObject.Properties.Match('CustomPolicy').Count)
            {
                #If the custom policy is enabled at the server level
                if((($interface.AuthenticationTransformConstants.ToString() -eq $IPSecConfig.AuthenticationTransformConstants.ToString()) -and ($interface.CipherTransformConstants.ToString() -eq $IPSecConfig.CipherTransformConstants.ToString()) -and ($interface.DHGroup.ToString() -eq $IPSecConfig.DHGroup.ToString()) -and ($interface.EncryptionMethod.ToString() -eq $IPSecConfig.EncryptionMethod.ToString()) -and ($interface.IntegrityCheckMethod.ToString() -eq $IPSecConfig.IntegrityCheckMethod.ToString()) -and ($interface.PFSgroup.ToString() -eq $IPSecConfig.PFSgroup.ToString())) -eq $false)
                {
                    $InvalidInterfaces = $InvalidInterfaces + $interface
                }
            }
            else
            {
                $isSubsetofGlobal = $false
                switch($IPSecConfig.EncryptionType)
                {
                    "MaximumEncryption"  {$isSubsetofGlobal = Is-SubsetPolicy -Interface $interface -GlobalPolicy $MaximumEncryptionPolicies }
                    "NoEncryption"       {$isSubsetofGlobal = Is-SubsetPolicy -Interface $interface -GlobalPolicy $NoEncryptionPolicies }
                    "OptionalEncryption" {$isSubsetofGlobal = Is-SubsetPolicy -Interface $interface -GlobalPolicy $OptionalEncryptionPolicies }
                    "RequireEncryption"  {$isSubsetofGlobal = Is-SubsetPolicy -Interface $interface -GlobalPolicy $RequireEncryptionPolicies }
                }
                if($isSubsetofGlobal -eq $false)
                {
                    $InvalidInterfaces = $InvalidInterfaces + $interface
                }
            }  
        }
    }
    return $InvalidInterfaces
}

########################################################################################################
# Is Port Limit exceeded - Rule 26
# If the number of VPN Connections + S2S Interfaces < SSTP + IKev2 ports or S2SInterfaces < Ikev2 Ports
########################################################################################################
function Is-PortLimitExceeded
{
     Param(
            [Parameter(Mandatory=$True)]
            [int]
            $S2SInterfacesCount,
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $IpSecConfig,
            [Parameter(Mandatory=$True)]
            [AllowNull()]
            $RemoteAccessRoutingDomains
    )
    $VpnConnectionsCount = ($RemoteAccessRoutingDomains | Measure-Object MaximumVpnConnections -Sum).Sum + 0
    $TotalCount = $VpnConnectionsCount + $S2SInterfacesCount + 0
    $TotalPorts = $IpSecConfig.Ikev2Ports + $IpSecConfig.SstpPorts + 0

    if(($TotalPorts -lt $TotalCount) -or ($IpSecConfig.Ikev2Ports -lt $S2SInterfacesCount ))
    {
        return $true
    }
    return $false
}

function Get-S2SInterfacesWithoutTriggeringRoute
{
    Param(
    [Parameter(Mandatory=$True)]
    $S2SInterfaces
    )
    return @($S2SInterfaces | ? {($_.IPv4Subnet -eq $Null) -and ($_.IPv6Subnet -eq $Null)})
}

function Get-MaskFromTriggerSubnet
{
    Param(
    [Parameter(Mandatory=$True)]
    [String]
    $Subnet
    )

    return [System.Int32]$Subnet.Split("/")[1].Split(":")[0]
}

#Returns S2S Interfaces which have triggering route other than /32 or /128
function Get-S2SInterfacesWithoutHostTriggeringRoute
{
    Param(
    [Parameter(Mandatory=$True)]
    $S2SInterfaces
    )
    $S2SInterfacesRet = @()
    foreach($S2SInterface in $S2SInterfaces)
    {
        foreach($IPv4Subnet in $S2SInterface.IPv4Subnet)
        {
            if((Get-MaskFromTriggerSubnet -Subnet $IPv4Subnet) -ne 32)
            {
                $S2SInterfacesRet += $S2SInterface
                break
            }
        }

        foreach($IPv6Subnet in $S2SInterface.IPv6Subnet)
        {
            if((Get-MaskFromTriggerSubnet -Subnet $IPv6Subnet) -ne 128)
            {
                $S2SInterfacesRet += $S2SInterface
                break
            }
        }
    }
    return @($S2SInterfacesRet | ? {$_} | Sort -Unique)
}

function Get-AllRootcerts()
{
   return @(Get-ChildItem -Path Cert:\LocalMachine\Root)
}


function Test-DoesFilterBlockBGPTraffic([String]$Filter, $AddressFamily)
{
    if($AddressFamily -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.RemoteAccessIpFilter.AddressFamily]::IPv4)
    {
        $FilterParts = $Filter.Split(":")
        if($FilterParts.Count -eq 5)
        {
            # "IP/MASK:IP/MASK:Protocol(TCP/UDP/TCPEstablished):SrcPort:DstPort"
            if($FilterParts[2].Contains("TCP") -eq $True) #TODO
            {
                if(($FilterParts[3] -eq 179) -or ($FilterParts[4] -eq 179))
                {
                    return $True
                }
            }
            return $False
        }
        elseif($FilterParts.Count -eq 4)
        {
            # "IP/MASK:IP/MASK:Protocol(Other):ProtocolNo"
            if($FilterParts[3] -eq 6)
            {
                return $True
            }
            else
            {
                return $False
            }
        }
        elseif($FilterParts.Count -eq 3)
        {
            # "IP/MASK:IP/MASK:Any"
            return $True
        }
    }
    elseif($AddressFamily -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.RemoteAccessIpFilter.AddressFamily]::IPv6)
    {
        # We need only last three parts in all cases
        $FilterParts = $Filter.Split(":")
        $FilterParts = @($FilterParts[$FilterParts.Count -3],$FilterParts[$FilterParts.Count - 2],$FilterParts[$FilterParts.Count -1])

    }
    return $False
}


function Get-RemoteAccessIpFiltersWhichBlockBGP($RemoteAccessIPFilters)
{
    $RemoteAccessIPFiltersDeny = $RemoteAccessIPFilters | Where Action -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.RemoteAccessIpFilter.Action]::Deny)
    foreach($RemoteAccessIPFilter in $RemoteAccessIPFiltersDeny)
    {
        foreach($List in $RemoteAccessIPFilter.List)
        {
            Test-DoesFilterBlockBGPTraffic -Filter $List -AddressFamily $RemoteAccessIPFilter.AddressFamily
        }
    }
}

#endregion


#region Function to fill rules for windows server 2012 R2 in $RRASObj in BPA
function Update-RRASConfigForV2
{
    Param(
    [Parameter(Mandatory=$True)]
    [RRASServiceConfig.RRASService]
    [ref]
    $RRASConfig
    )

    if($RRASConfig -ne $Null)
    {       
            
        #TODO: These may return exception, handle them
        $RemoteAccess = Get-RemoteAccess
        $MultiTenancy = Test-MultiTenancy $RemoteAccess
        $RemoteAccessRoutingDomains = @()
        $Compartments = @(Get-NetCompartmentBpa)
        if($MultiTenancy)
        {   
            $RemoteAccessRoutingDomains = @(Get-RemoteAccessRoutingDomainBpa)
        }

        $RRASConfig.MultiTenancyEnabled = $MultiTenancy
        $RRASConfig.RRAS.IsInstallationValid = Is-ValidMultiTenantConfiguration -MultiTenancy $MultiTenancy -CompartmentCount $Compartments.Count

        if($RRASConfig.RRAS.IsInstallationValid -eq $True)
        {
            $S2SInterfaces = @(Get-VpnS2SInterfaceBpa)
            $IpSecConfig = $Null 
            
            try
            {
                $IpSecConfig = Get-VpnServerIPsecConfiguration -ErrorAction SilentlyContinue
            }
            catch{}

            try
            {
                $AuthProtocol = Get-VpnAuthProtocol
                $RootCerts = @(Get-AllRootCerts)

                if($AuthProtocol.CertificateAdvertised -ne $null)
                {

                    $ServerRootCerts = @()
                    if($RootCerts.Count -ge 1)
                    {
                        $ServerRootCerts = @(Get-RootCertificate -RootCertList $RootCerts -Certificate $AuthProtocol.CertificateAdvertised | ? {$_})
                    }

                    if($ServerRootCerts.Count -eq 0)
                    {
                        $RRASConfig.RRAS.ServerCertHasNoRootCertificate = $True
                    }
                    else
                    {
                        $ServerRootCertExpiring = $False
                        foreach($ServerRootCert in $ServerRootCerts)
                        {
                            $ServerRootCertExpiring = get-CertExpireSoon -Certificate $ServerRootCert
                            if($ServerRootCertExpiring)
                            {
                                break
                            }
                        }

                        $RRASConfig.RRAS.ServerRootCertificateAboutToExpire = $ServerRootCertExpiring
                    }

                    $ServerCertExpiring = @(get-CertExpireSoon -Certificate $AuthProtocol.CertificateAdvertised | ? {$_})
                    if($ServerCertExpiring.Count -ne 0)
                    {
                        $RRASConfig.RRAS.ServerCertificateAboutToExpire = $True
                    }

                    $ServerCertValid = @(Is-ServerCertificateValid -ServerCertificate $AuthProtocol.CertificateAdvertised | ? {$_})
                    if($ServerCertValid.Count -eq 1)
                    {
                        $RRASConfig.RRAS.ServerCertificateHasAtleastOneIPInCN = $ServerCertValid[0].HasOnePublicIPAtleast
                    }
                }

                if($AuthProtocol.RootCertificateNameToAccept -ne $null)
                {
                    $RootCertToAccpet = @(get-CertExpireSoon -Certificate $AuthProtocol.RootCertificateNameToAccept | ? {$_})
                    if($RootCertToAccpet.Count -ne 0)
                    {
                        $RRASConfig.RRAS.RootCertificateToAcceptAboutToExpire = $True
                    }
                }

                $RRASConfig.RRAS.IsInboundCAConfigured = Is-InboundCAConfigured -AuthProtocol $AuthProtocol
                $RRASConfig.RRAS.EAPAuthenticationEnabled = Is-EAPBasedAuthConfigured -AuthProtocol $AuthProtocol
                $RRASConfig.RRAS.CertAuthenticationEnabled = $AuthProtocol.UserAuthProtocolAccepted -contains "Certificate"
            }
            catch {}
            
            if($MultiTenancy -eq $True)
            {
                $CompartmentGuids = @(($Compartments | Sort |? {$_.CompartmentDescription -ne "Default Compartment"} | ? {$_}).CompartmentGuid)
                $RemoteAccessRoutingDomainGuids = @(@($RemoteAccessRoutingDomains.RoutingDomainID) | Sort | ? {$_}) 
                $RoutingDomainGuidIntersection = @(Get-Intersection -List1 $CompartmentGuids -List2 $RemoteAccessRoutingDomainGuids)
                if($RoutingDomainGuidIntersection.Count -eq $CompartmentGuids.Count)
                {
                    $RRASConfig.RRAS.AllCompartmentsEnabled = $True
                }
                else
                {
                    $RRASConfig.RRAS.DisabledCompartmentsName = @(@(($Compartments | ? {$_.CompartmentDescription -ne "Default Compartment"} | ? {$RoutingDomainGuidIntersection -notcontains $_.CompartmentGuid}).CompartmentDescription) | ?{$_}) -join ","
                }
            }

            $RRASConfig.RRAS.DefaultCapacityParams = Test-DefaultCapacityKbps -RemoteAccess $RemoteAccess
            $RRASConfig.RRAS.PortLimitExceeded = Is-PortLimitExceeded -S2SInterfacesCount $S2SInterfaces.Count -IpSecConfig $IpSecConfig -RemoteAccessRoutingDomains $RemoteAccessRoutingDomains

            $PskWithSameDestinationGroups = @(Get-PSKInterfacesWithSameDestination -S2SInterfaces $S2SInterfaces)
            if($PskWithSameDestinationGroups.Count -gt 0)
            {
                $RRASConfig.RRAS.PSKBasedS2SInterfacesWithSameDestination = $True
                $RRASConfig.RRAS.PSKBasedS2SInterfacesWithSameDestinationList = @(@($PskWithSameDestinationGroups.Group).Name) -join ","
            }

            $AtleastOnePortExceptPPTP = $False

            foreach($Port in $RRASConfig.RRAS.Port)
            {
                if($Port.Protocol -eq "L2TP")
                {
                    if($IpSecConfig.L2tpPorts -ne $Null)
                    {
                        $Port.PortCount = $IpSecConfig.L2tpPorts
                    }
                }
                elseif($Port.Protocol -eq "SSTP")
                {
                    if($IpSecConfig.SstpPorts -ne $Null)
                    {
                        $Port.PortCount =  $IpSecConfig.SstpPorts
                    }
                }
                elseif($Port.Protocol -eq "IKEv2")
                {
                    if($IpSecConfig.Ikev2Ports -ne $Null)
                    {
                        $Port.PortCount =  $IpSecConfig.Ikev2Ports
                    }
                }

                if($Port.PortCount -gt 0)
                {
                    $AtleastOnePortExceptPPTP = $True
                }
            }

            if($RRASConfig.RRAS.AllPortsDisabledSpecified -eq $True)
            {
                if($RRASConfig.RRAS.AllPortsDisabled -eq $True)
                {
                    $RRASConfig.RRAS.AllPortsDisabled = $AtleastOnePortExceptPPTP -ne $True
                    if($RRASConfig.RRAS.AllPortsDisabled -eq $False)
                    {
                        $RRASConfig.RRAS.AllPortsDisabledSpecified = $False
                    }
                }
            }

            $RoutingDomains = Get-RoutingDomainsBpa -RemoteAccess $RemoteAccess -IpSecConfigObj $IpSecConfig -S2SInterfaces $S2SInterfaces -Compartments $Compartments -RemoteAccessRoutingDomains $RemoteAccessRoutingDomains
            if(($RoutingDomains -ne $Null) -and ($RoutingDomains.Count -ge 1))
            {
                $RRASConfig.RRAS.RoutingDomain = $RoutingDomains
            }

            $DisabledCompartments = @()
            foreach($RoutingDomain in $RRASConfig.RRAS.RoutingDomain)
            {
                if($RoutingDomain.Enabled -eq $False)
                {
                    $DisabledCompartments += $RoutingDomain.Name
                }
            }

            if($DisabledCompartments.Count -gt 0)
            {
                $RRASConfig.RRAS.DeletedCompartments = $True
                $RRASConfig.RRAS.DeletedCompartmentNames = $DisabledCompartments -join ","
            }
        }
    }
}

#endregion

#region Function to generate RoutingDomain objects for BPA


function Get-RoutingDomainsBpa
{
    Param(
    [Parameter(Mandatory=$true)]
    $RemoteAccess, #Output from Get-RemoteAccess
    [Parameter(Mandatory=$True)]
    $IpSecConfigObj,
    [Parameter(Mandatory=$True)]
    $S2SInterfaces,
    [Parameter(Mandatory=$True)]
    $Compartments,
    [Parameter(Mandatory=$True)]
    $RemoteAccessRoutingDomains
    )

    if($RemoteAccess -eq $Null)
    {
        return @()
    }
    else
    {        
        $RoutingDomains = @()
        $RoutingDomainsBpa = @()
        $MultiTenancy = Test-MultiTenancy -RemoteAccess $RemoteAccess
        $RootCerts = @(Get-AllRootcerts)

        if($MultiTenancy -eq $True)
        {
            $RoutingDomains = @($RemoteAccessRoutingDomains.RoutingDomain | ? {$_})
        }
        else
        {
            $RoutingDomains = @($Null)
        }

        #region Fetch All the information at once

        #Fetch System Information
        $Interfaces = @(Get-NetIPInterfaceBpa -MultiTenancy $MultiTenancy)
        $InterfaceIPs = @(Get-NetIPAddressBpa -Interfaces $Interfaces)
        $InterfaceRoutes = @(Get-NetRouteBpa -Interfaces $Interfaces)
        $AllEnabledDialInUserAccounts = @(Get-AllEnabledDialInLocalAccounts)
  

        # BGP information
        $BgpRouters = @(Get-BgpRouterBpa -MultiTenancy $MultiTenancy)
        $BgpPeers = @(Get-BgpPeerBpa -MultiTenancy $MultiTenancy -Routers $BgpRouters)
        $BgpRoutingPolicies = @(Get-BgpRoutingPolicyBpa -MultiTenancy $MultiTenancy -Routers $BgpRouters)
        $BgpCustomRoutes = @(Get-BgpCustomRouteBpa -MultiTenancy $MultiTenancy -Routers $BgpRouters)
        $BgpRoutes = @(Get-BgpRouteInformationBpa -MultiTenancy $MultiTenancy -Routers $BgpRouters)

        #endregion Fetch All the information at once


        #region Evaluate BPA rules for all objects and get the result

        #Evaluate S2S Rules
        #TODO S2SInterfacesWithoutValidCertificate
        $S2SInterfacesWithCertificateAboutToExpire = @(Get-InterfacesWhoseCertsExpiringSoon -S2SInterfaces $S2SInterfaces)
        $ObjForInvalidRootCert = Get-InterfacesWhoseRootCertsAreInvalid -S2SInterfaces $S2SInterfaces -RootCertList $RootCerts
        $S2SInterfacesWithoutRootCertificate = @($ObjForInvalidRootCert.S2SInterfacesWithoutRootCertificate | ? {$_})
        $S2SInterfacesWithRootCertificateAboutToExpire = @($ObjForInvalidRootCert.S2SInterfacesWithRootCertificateAboutToExpire | ? {$_})
        $S2SInterfacesWithInvalidNameForEAP = @(Get-EAPInterfacesWhoseNamesAreInvalid -S2SInterfaces $S2SInterfaces -AllEnabledDialInUserNames (@($AllEnabledDialInUserAccounts.Name)))
        $S2SInterfacesWithDefaultRateLimitingParams = @(Get-InterfacesWithDefaultRateLimitingSettings -S2SInterfaces $S2SInterfaces)
        $S2SInterfacesWithInValidRateLimitingParams = @(Get-InterfacesWithInValidRateLimitingParams -S2SInterfaces $S2SInterfaces)
        $S2SInterfacesWithInvalidDestinationsForPSK = @(Get-PSKInterfacesWithFQDN -S2SInterfaces $S2SInterfaces)
        $S2SInterfacesWithoutSourceIp = @(Get-InterfacesWithoutSourceIp -S2SInterfaces $S2SInterfaces)
        $MultiplePublicIps = Is-MultiplePublicAddressesAvailable -InterfaceIPs $InterfaceIPs
        $S2SInterfacesWithCustomPolicyDiffFromGlobalPolicies = Get-InterfacesWhoseCustomPoliciesAreNotSubsetOfGlobalPolicy -RoutingDomains $RemoteAccessRoutingDomains -InterfaceList $S2SInterfaces -IPSecConfig IpSecConfigObj
        $S2SInterfacesWithoutTriggeringRoutes = @(Get-S2SInterfacesWithoutTriggeringRoute -S2SInterfaces $S2SInterfaces)
        $S2SInterfacesWithoutHostTriggeringRoutes = @(Get-S2SInterfacesWithoutHostTriggeringRoute -S2SInterfaces $S2SInterfaces)

        #Evalue MT-VPN Rules
        $VPNRoutingDomains = @(Get-VPNRoutingDomains -RemoteAccessRoutingDomains $RemoteAccessRoutingDomains)
        $VPNRoutingDomainsWithStaticAddressPool = @(Get-VPNRoutingDomainsWithStaticAddressPool -VPNRoutingDomains $VPNRoutingDomains)
        $VPNRoutingDomainsWithoutUnicastStaticAddressPool = @(Get-VPNRoutingDomainsWithoutUnicastStaticAddressPool -VPNRoutingDomainsWithStaticAddressPool $VPNRoutingDomainsWithStaticAddressPool)
        $VPNRoutingDomainsWithTenantName = @(Get-VPNRoutingDomainsWithTenantName -VPNRoutingDomains $VPNRoutingDomains)
        $VPNRoutingDomainsWithTenantNamePartOfOther = @(Get-VPNRoutingDomainsWithTenantNameSubsetOfAnother -VPNRoutingDomainsWithTenantName $VPNRoutingDomainsWithTenantName)


        #Evaluate BGP rules
        $BgpPeersWithoutDefaultRouteDropEgress = @(Get-PeersWithoutDeafultRouteDropPolicy -MultiTenancy $MultiTenancy -Routers $BgpRouters -Peers $BgpPeers -Policies $BgpRoutingPolicies -Direction ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyDirection]::Egress))
        $BgpPeersWithoutDefaultRouteDropIngress = @(Get-PeersWithoutDeafultRouteDropPolicy -MultiTenancy $MultiTenancy -Routers $BgpRouters -Peers $BgpPeers -Policies $BgpRoutingPolicies -Direction ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyDirection]::Ingress))
        $BgpPeersWithPeerIpOnLocalInterface = @(Get-PeersWithPeerIpOnInterface -MultiTenancy $MultiTenancy -Routers $BgpRouters -Peers $BgpPeers -Interfaces $Interfaces -InterfaceIPs $InterfaceIPs)
        $BgpRoutersIPv6EnabledIPv4PeersNoLocalIPv6Address = @(Get-RoutersWithoutLocalIPv6Address -MultiTenancy $MultiTenancy -Routers $BgpRouters -Peers $BgpPeers)
        $BgpUnreachableCustomRoutes = @(Get-BgpUnresolvableCustomRoutes -MultiTenancy $MultiTenancy -Routers $BgpRouters -Compartments $Compartments -Peers $BgpPeers -Policies $BgpRoutingPolicies -CustomRoutes $BgpCustomRoutes -Routes $InterfaceRoutes -Interfaces $Interfaces)
        $BgpSamePrefixWithMultipleNextHop = @(Get-SamePrefixMultipleNextHopPolicies -MultiTenancy $MultiTenancy -Routers $BgpRouters -Policies $BgpRoutingPolicies)
        $BgpPeersWithZeroHoldTime = @(Get-PeersWithZeroHoldTime -Peers $BgpPeers)
        $BgpPeersWithLowHoldTime = @(Get-PeersWithLowHoldTime -Peers $BgpPeers)
        $BgpPeersAllIngressRoutesDropped = @(Get-PeersWithAllRouteDropPolicy -MultiTenancy $MultiTenancy -Routers $BgpRouters -Peers $BgpPeers -Policies $BgpRoutingPolicies -Direction ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyDirection]::Ingress))
        $BgpPeersAllEgressRoutesDropped = @(Get-PeersWithAllRouteDropPolicy -MultiTenancy $MultiTenancy -Routers $BgpRouters -Peers $BgpPeers -Policies $BgpRoutingPolicies -Direction ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.Bgp.PolicyDirection]::Egress))
        $BgpPeersManualMode = @(Get-PeersWithManualPeeringMode -Peers $BgpPeers)
        $BgpPeersIPv6WithIPv4CustomRoutes = @(Get-IPv6PeersWithIPv4CustomRoutes -MultiTenancy $MultiTenancy -Routers $BgpRouters -Peers $BgpPeers -CustomRoutes $BgpCustomRoutes)
        $BgpPeersHighIdleHoldTime = @(Get-PeersWithHighIdleHoldTime -Peers $BgpPeers)
        $BgpPeersWithoutMaxPrefixLimit = @(Get-PeersWithoutMaxPrefixPolicy -Peers $BgpPeers)
        $BgpPeersWithRoutesNearMaxPrefixLimit = @(Get-PeersWithRoutesNearMaxPrefixLimit -MultiTenancy $MultiTenancy -Routers $BgpRouters -Peers $BgpPeers -BgpRoutes $BgpRoutes)
    

        #endregion Evaluate BPA rules for all objects and get the result

        foreach($RoutingDomain in $RoutingDomains)
        {
            $RoutingDomainBpa = New-Object RRASServiceConfig.RoutingDomain

            # Intialize the $RoutingDomainBpa Object
            # Intialization is specific to MT or ST deployment
            if($MultiTenancy -eq $True)
            {
                $RoutingDomainBpa.Name = $RoutingDomain
                $RemoteAccessRoutingDomain = Get-ObjectsInRoutingDomain -Objects $RemoteAccessRoutingDomains -RoutingDomain $RoutingDomain
                if(($RemoteAccessRoutingDomain -eq $Null) -or ($RemoteAccessRoutingDomain.RoutingDomainStatus -ne "Enabled and Available"))
                {
                    $RoutingDomainBpa.Enabled = $False
                }
                else
                {
                    $RoutingDomainBpa.Enabled = $true
                    $RoutingDomainBpa.S2SEnabled = $RemoteAccessRoutingDomain.VpnS2SStatus -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.RemoteAccessRoutingDomain.State]::Enabled)
                    $RoutingDomainBpa.VpnEnabled = $RemoteAccessRoutingDomain.VpnStatus -eq ([Microsoft.PowerShell.Cmdletization.GeneratedTypes.RemoteAccessRoutingDomain.State]::Enabled)

                    if($RoutingDomainBpa.VpnEnabled -eq $True)
                    {
                        $RoutingDomainBpa.VPN = New-Object RRASServiceConfig.VPN
                        $RoutingDomainBpa.VPN.MTVPN = New-Object RRASServiceConfig.MTVPN

                        $RoutingDomainBpa.VPN.MTVPN.StaticAddressPoolConfigured = (Get-ObjectsInRoutingDomain -Objects $VPNRoutingDomainsWithStaticAddressPool -RoutingDomain $RoutingDomain) -ne $Null
                        if($RoutingDomainBpa.VPN.MTVPN.StaticAddressPoolConfigured)
                        {
                            $RoutingDomainBpa.VPN.MTVPN.StaticAddressPoolIsUnicast = (Get-ObjectsInRoutingDomain -Objects $VPNRoutingDomainsWithoutUnicastStaticAddressPool -RoutingDomain $RoutingDomain) -eq $Null
                        }
                        $RoutingDomainBpa.VPN.MTVPN.TenantNameConfigured = (Get-ObjectsInRoutingDomain -Objects $VPNRoutingDomainsWithTenantName -RoutingDomain $RoutingDomain) -ne $Null
                        $PartOfOtherRd = @(Get-ObjectsInRoutingDomain -Objects $VPNRoutingDomainsWithTenantNamePartOfOther -RoutingDomain $RoutingDomain)
                        if($PartOfOtherRd.Count -gt 0)
                        {
                            $RoutingDomainBpa.VPN.MTVPN.TenantNameSubsetOfAnotherRD = $True
                            $RoutingDomainBpa.VPN.MTVPN.TenantNameSubsetOfAnotherRDList = $PartOfOtherRd[0].OtherRdList
                        }
                    }
                }
            }
            else
            {
                $RoutingDomainBpa.Enabled = $True
                $RoutingDomainBpa.S2SEnabled = $RemoteAccess.VpnS2SStatus -eq "Installed"
                $RoutingDomainBpa.VpnEnabled = $RemoteAccess.VpnStatus -eq "Installed"

                if($RoutingDomainBpa.VpnEnabled -eq $True)
                {
                    #Just for the sake of clarity in sch
                    $RoutingDomainBpa.VPN = New-Object RRASServiceConfig.VPN
                }
            }

            if($RoutingDomainBpa.Enabled -eq $true)
            {
                $BgpConfigured = (Get-ObjectsInRoutingDomain -Objects $BgpRouters -RoutingDomain $RoutingDomain) -ne $Null
                $RoutingProtocolsConfigured = $BgpConfigured
                if($RoutingProtocolsConfigured -eq $True)
                {
                    $RoutingProtocols = New-Object RRASServiceConfig.RoutingProtocols
                    if($BgpConfigured -eq $true)
                    {
                        $RoutingProtocols.BGP = New-Object RRASServiceConfig.BGP
                        $RoutingProtocols.BGPConfigured = $True        

                        # Rule 1: The Default route should not be advertised to the peers
                        $BgpPeersWithoutDefaultRouteDropEgressInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersWithoutDefaultRouteDropEgress -RoutingDomain $RoutingDomain)
                        if($BgpPeersWithoutDefaultRouteDropEgressInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.DefaultGatewayAdvertised = $True
                            $RoutingProtocols.BGP.DefaultGatewayAdvertisedPeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersWithoutDefaultRouteDropEgressInRd
                        }

                        #Rule 2: The Default route should not be accepeted
                        $BgpPeersWithoutDefaultRouteDropIngressInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersWithoutDefaultRouteDropIngress -RoutingDomain $RoutingDomain)
                        if($BgpPeersWithoutDefaultRouteDropIngressInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.DefaultGatewayAccepted = $True
                            $RoutingProtocols.BGP.DefaultGatewatAcceptedPeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersWithoutDefaultRouteDropIngressInRd
                        }

                        #Rule 3: BGP Peer IP is assigned to a local interface
                        $BgpPeersWithPeerIpOnLocalInterfaceInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersWithPeerIpOnLocalInterface -RoutingDomain $RoutingDomain)
                        if($BgpPeersWithPeerIpOnLocalInterfaceInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.PeerIpAssignedToLocalInterface = $True
                            $RoutingProtocols.BGP.PeerIPAssignedToLocalInterfacePeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersWithPeerIpOnLocalInterfaceInRd
                        }

                        # Rule 4: If IPv6 Routing is enabled while peering over IPv4 Addresses, Local IPv6 Address must be configured on the BGP Router
                        $BgpRoutersIPv6EnabledIPv4PeersNoLocalIPv6AddressInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpRoutersIPv6EnabledIPv4PeersNoLocalIPv6Address -RoutingDomain $RoutingDomain)
                        if($BgpRoutersIPv6EnabledIPv4PeersNoLocalIPv6AddressInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.IPv6EnabledIPv4PeersNoLocalIPv6Address = $true
                        }

                        #Rule 5: Unresolvable Custom Routes
                        $BgpUnreachableCustomRoutesInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpUnreachableCustomRoutes -RoutingDomain $RoutingDomain)
                        if($BgpUnreachableCustomRoutesInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.CustomRoutesNotReachable = $true
                            $RoutingProtocols.BGP.CustomRoutesNotReachableList = (@(@($BgpUnreachableCustomRoutesInRd.Network) | Sort) -join ",")
                        }

                        #Rule 6: Same prefix with multiple next hops
                        $BgpSamePrefixWithMultipleNextHopInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpSamePrefixWithMultipleNextHop -RoutingDomain $RoutingDomain)
                        if($BgpSamePrefixWithMultipleNextHopInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.RoutesWithMultipleNextHops = $true
                            $RoutingProtocols.BGP.RoutesWithMultipleNextHopsList = (@($BgpSamePrefixWithMultipleNextHopInRd.MatchPrefix) | ? {$_} | Sort -Unique | join ",")
                        }

                        #Rule 7: Peers with zero hold time
                        $BgpPeersWithZeroHoldTimeInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersWithZeroHoldTime -RoutingDomain $RoutingDomain)
                        if($BgpPeersWithZeroHoldTimeInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.HoldTimeSecZero = $true
                            $RoutingProtocols.BGP.HoldTimeSecLowValuePeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersWithZeroHoldTimeInRd
                        }

                        # Rule 8: Peers with low value of Hold Time
                        $BgpPeersWithLowHoldTimeInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersWithLowHoldTime -RoutingDomain $RoutingDomain)
                        if($BgpPeersWithLowHoldTimeInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.HoldTimeSecLowValue = $true
                            $RoutingProtocols.BGP.HoldTimeSecLowValuePeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersWithLowHoldTimeInRd
                        }

                        # Rule 9: Peers with all ingress routes dropped
                        $BgpPeersAllIngressRoutesDroppedInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersAllIngressRoutesDropped -RoutingDomain $RoutingDomain)
                        if($BgpPeersAllIngressRoutesDroppedInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.AllIngressRoutesRejected = $true
                            $RoutingProtocols.BGP.AllIngressRoutesRejectedPeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersAllIngressRoutesDroppedInRd
                        }

                        #Rule 10: Peers with all egress routes dropped
                        $BgpPeersAllEgressRoutesDroppedInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersAllEgressRoutesDropped -RoutingDomain $RoutingDomain)
                        if($BgpPeersAllEgressRoutesDroppedInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.AllEgressRoutesRejected = $true
                            $RoutingProtocols.BGP.AllEgressRoutesRejectedPeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersAllEgressRoutesDroppedInRd
                        }

                        # Rule 11: Manual Mode peers
                        $BgpPeersManualModeInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersManualMode -RoutingDomain $RoutingDomain)
                        if($BgpPeersManualModeInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.ManualModePeers = $true
                            $RoutingProtocols.BGP.ManualModePeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersManualModeInRd
                        }

                        # Rule 12: IPv6 peers with IPv4 custom routes
                        $BgpPeersIPv6WithIPv4CustomRoutesInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersIPv6WithIPv4CustomRoutes -RoutingDomain $RoutingDomain)
                        if($BgpPeersIPv6WithIPv4CustomRoutesInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.IPv6PeersWithIPv4CustomRoutes = $true
                            $RoutingProtocols.BGP.IPv6PeersWithIPv4CustomRoutesPeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersIPv6WithIPv4CustomRoutesInRd
                        }

                        #Rule 13: High Idle hold time 
                        $BgpPeersHighIdleHoldTimeInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersHighIdleHoldTime -RoutingDomain $RoutingDomain)
                        if($BgpPeersHighIdleHoldTimeInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.IdleHoldTimeSecHighValue = $true
                            $RoutingProtocols.BGP.IdleHoldTimeSecHighValuePeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersHighIdleHoldTimeInRd
                        }

                        #Rule 14: Peers without Max Prefix Limit
                        $BgpPeersWithoutMaxPrefixLimitInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersWithoutMaxPrefixLimit -RoutingDomain $RoutingDomain)
                        if($BgpPeersWithoutMaxPrefixLimitInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.PeersWithoutMaxPrefixLimit = $true
                            $RoutingProtocols.BGP.PeersWithoutMaxPrefixLimitNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersWithoutMaxPrefixLimitInRd
                        }

                        #Rule 15: Peers for which routes learned are near max prefix limit
                        $BgpPeersWithRoutesNearMaxPrefixLimitInRd = @(Get-ObjectsInRoutingDomain -Objects $BgpPeersWithRoutesNearMaxPrefixLimit -RoutingDomain $RoutingDomain)
                        if($BgpPeersWithRoutesNearMaxPrefixLimitInRd.Count -gt 0)
                        {
                            $RoutingProtocols.BGP.PrefixCountNearMaxLimit = $true
                            $RoutingProtocols.BGP.PrefixCountNearMaxLimitPeerNames = Get-CommaSeperatedBgpPeerNames -Peers $BgpPeersWithRoutesNearMaxPrefixLimitInRd
                        }
                    }

                    $RoutingDomainBpa.RoutingProtocolsConfigured = $True
                    $RoutingDomainBpa.RoutingProtocols = $RoutingProtocols
                }

                if($RoutingDomainBpa.S2SEnabled -eq $True)
                {
                    $RoutingDomainBpa.S2S = New-Object RRASServiceConfig.S2S


                    $S2SInterfacesWithCertificateAboutToExpireInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithCertificateAboutToExpire -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithCertificateAboutToExpireInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.S2SInterfacesWithCertificateAboutToExpire = $true
                        $RoutingDomainBpa.S2S.S2SInterfacesWithCertificateAboutToExpireList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithCertificateAboutToExpireInRd
                    }

                    $S2SInterfacesWithoutRootCertificateInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithoutRootCertificate -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithoutRootCertificateInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.S2SInterfacesWithoutRootCertificate = $true
                        $RoutingDomainBpa.S2S.S2SInterfacesWithoutRootCertificateList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithoutRootCertificateInRd
                    }

                    $S2SInterfacesWithRootCertificateAboutToExpireInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithRootCertificateAboutToExpire -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithRootCertificateAboutToExpireInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.S2SInterfacesWithRootCertificateAboutToExpire = $true
                        $RoutingDomainBpa.S2S.S2SInterfacesWithRootCertificateAboutToExpireList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithRootCertificateAboutToExpireInRd
                    }

                    $S2SInterfacesWithInvalidNameForEAPInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithInvalidNameForEAP -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithInvalidNameForEAPInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.EAPBasedS2SInterfacesWithInValidName = $True
                        $RoutingDomainBpa.S2S.EAPBasedS2SInterfacesWithInvalidNameList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithInvalidNameForEAPInRd
                    }

                    $S2SInterfacesWithDefaultRateLimitingParamsInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithDefaultRateLimitingParams -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithDefaultRateLimitingParamsInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.DefaultRateLimitingParams = $true
                        $RoutingDomainBpa.S2S.DefaultRateLimitingParamsList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithDefaultRateLimitingParamsInRd
                    }

                    $S2SInterfacesWithInValidRateLimitingParamsInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithInValidRateLimitingParams -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithInValidRateLimitingParamsInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.S2SInterfacesWithInValidRateLimitingParams = $True
                        $RoutingDomainBpa.S2S.S2SInterfacesWithInValidRateLimitingParamsList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithInValidRateLimitingParamsInRd
                    }

                    $S2SInterfacesWithInvalidDestinationsForPSKInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithInvalidDestinationsForPSK -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithInvalidDestinationsForPSKInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.PSKBasedS2SInterfacesWithInvalidDestination = $true
                        $RoutingDomainBpa.S2S.PSKBasedS2SInterfacesWithInvalidDestinationList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithInvalidDestinationsForPSKInRd
                    }
                   
                    if($MultiplePublicIps)
                    {
                        $S2SInterfacesWithoutSourceIpInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithoutSourceIp -RoutingDomain $RoutingDomain)
                        if($S2SInterfacesWithoutSourceIpInRd.Count -gt 0)
                        {
                            $RoutingDomainBpa.S2S.S2SInterfacesRequireSourceIpConfiguration = $True
                            $RoutingDomainBpa.S2S.S2SInterfacesRequireSourceIpConfigurationList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithoutSourceIpInRd 
                        }
                    }
                    
                    $S2SInterfacesWithCustomPolicyDiffFromGlobalPoliciesInRd = @(Get-ObjectsInRoutingDomain -Ob $S2SInterfacesWithCustomPolicyDiffFromGlobalPolicies -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithCustomPolicyDiffFromGlobalPoliciesInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.S2SInterfacesWithCustomPolicyDiffFromGlobalPolicies = $True
                        $RoutingDomainBpa.S2S.S2SInterfacesWithCustomPolicyDiffFromGlobalPoliciesList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithCustomPolicyDiffFromGlobalPoliciesInRd
                    }

                    $S2SInterfacesWithoutTriggeringRoutesInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithoutTriggeringRoutes -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithoutTriggeringRoutesInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.S2SInterfacesWithoutTriggeringRoute = $True
                        $RoutingDomainBpa.S2S.S2SInterfacesWithoutTriggeringRouteList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithoutTriggeringRoutesInRd
                    }
                    
                    $S2SInterfacesWithoutHostTriggeringRoutesInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithoutHostTriggeringRoutes -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithoutHostTriggeringRoutesInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.S2SInterfacesWithoutHostTriggeringRoute = $True
                        $RoutingDomainBpa.S2S.S2SInterfacesWithoutHostTriggeringRouteList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithoutHostTriggeringRoutesInRd
                    } 
                }        

                # For Rules Specific to BGP and S2S Deployment
                if(($BgpConfigured -eq $True) -and ($RoutingDomainBpa.S2SEnabled -eq $True))
                {
                    $S2SInterfacesWithoutHostTriggeringRoutesInRd = @(Get-ObjectsInRoutingDomain -Objects $S2SInterfacesWithoutHostTriggeringRoutes -RoutingDomain $RoutingDomain)
                    if($S2SInterfacesWithoutHostTriggeringRoutesInRd.Count -gt 0)
                    {
                        $RoutingDomainBpa.S2S.S2SInterfacesWithoutHostTriggeringRoute = $True
                        $RoutingDomainBpa.S2S.S2SInterfacesWithoutHostTriggeringRouteList = Get-CommaSeperatedS2SInterfaceNames -S2SInterfaces $S2SInterfacesWithoutHostTriggeringRoutesInRd
                    }
                }

                # For Rules specific to BGP and VPN Deployment
                if(($BgpConfigured -eq $True) -and ($RoutingDomainBpa.VpnEnabled -eq $True))
                {

                }
            }
            $RoutingDomainsBpa += $RoutingDomainBpa
        }
        return @($RoutingDomainsBpa)
    }
}

#endregion Function to generate RoutingDomain objects for BPA