###########################################################################
# Common code for built-in DSC Resources
###########################################################################

function IsNanoServer
{
    if($PSVersionTable.PSEdition -ieq 'Core')
    {
        return $true
    }
    return $false
}

Export-ModuleMember -Function IsNanoServer
