$NagiosStatus = "0"
$Argument1 = $args[0]
$Argument2 = $args[1]

$procexe = get-process -name ProcessServer  -ErrorAction "SilentlyContinue"
$proccount = $procexe | measure-object | select-object -expand Count
    if ($proccount -eq "0")
    {
    Write-Host "WARNING: No process server running. Attemping to start the service"
    Net Start $Argument1
    }
    else
    {
    Net Stop $Argument1
    $procexe | stop-process -Force
    $NagiosStatus = "1"
    Write-Host "WARNING: Process server terminated"
    Start-Sleep -s 5
    Start-Service $Argument1
    Write-Host "OK: Process server started"
    }

exit $NagiosStatus

