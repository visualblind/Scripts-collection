#Sentric Nagios M3 CRWPrint job killer
$NagiosStatus = "0"
$NagiosPerfData = ""
$crw = get-process -name MILLPR~3,MillProcRept -ErrorAction "SilentlyContinue"
$crwlife = $crw | where {$_.StartTime -lt (Get-Date).AddMinutes(-15) }
$crwcount = $crw | measure-object #| Select-Object -expand Count
$NagiosPerfData = "|count=" + $crwcount.Count + ";10;20;0"
        if ($crwcount.Count -eq "0")
        {
        Write-Host "OK: There are no CRW jobs running on the process server "$NagiosPerfData
        }
        elseif (!$crwlife -and $crwcount.Count -ge "1")
        {
        Write-Host "OK: " ($crwcount.Count) " job(s) were found, but are younger than 15 minutes "$NagiosPerfData
        }
        else
        {
        $crwlife | stop-process -Force
        $NagiosStatus = "1"
        Write-Host "WARNING: CRW processes have been stopped "$NagiosPerfData
        }
exit $NagiosStatus