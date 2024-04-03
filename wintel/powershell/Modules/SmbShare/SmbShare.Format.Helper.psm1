<#

Copyright (c) 2011 Microsoft Corporation. All Rights Reserved.

Module Name:

    SmbShare.Format.Helper.psm1

Description:

    Provides helper routines for formatting the output of
    SmbShare CmdLets.

#>

function Format-LinkSpeed($LinkSpeed)
<#
Function Description:
    This function returns the link speed of a network adapter

Arguments:
    $LinkSpeed

Return Value:
    Formatted link speed
#>
{
    $out=
      if($LinkSpeed -eq $null)
        {"Unknown"}
      else
        {
          switch ($LinkSpeed)
          {
            {$_ -lt 1000} {"$_  bps"; break}
            {$_ -lt 1000000} {"$($_/1000) Kbps"; break}
            {$_ -lt 1000000000} {"$($_/1000000) Mbps"; break}
            default {"$($_/1000000000) Gbps"}
          }
       }

     return $out
}