<#

Copyright (c) 2011 Microsoft Corporation. All Rights Reserved.

Module Name:

    MSFT_NetQosPolicy.Format.Helper.psm1

Description:

    Provides helper routines for formatting the output of NetQosPolicy cmdlets.

#>

function Format-NetQosPolicySpeed(
    $Value, $Precision = 0
)
{
    $Postfixes = @("Bits", "KBits", "MBits", "GBits", "TBits")
    for ($i = 0; $Value -ge 1000 -and $i -lt $Postfixes.Length - 1; $i++) {
        $Value /= 1000
    }
    $Value = [Math]::Round([Decimal]$Value, $Precision)
    return "$($Value) $($Postfixes[$i])/sec"
}
