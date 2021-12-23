# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Get-OwnerReport.ps1
# 
# 	Comments:
# 
#    Disclaimer: This source code is intended only as a supplement to 
# 				SAPIEN Development Tools and/or on-line documentation.  
# 				See these other materials for detailed information 
# 				regarding SAPIEN code samples.
# 
# 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
# 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
# 	PARTICULAR PURPOSE.
# 
# **************************************************************************

# ==============================================================================================
# 
# Microsoft PowerShell Source File -- Created with SAPIEN Technologies PrimalScript 2011
# 
# NAME: Get-OwnerReport.ps1
# 
# AUTHOR: Jeffery Hicks , SAPIEN Technologies
# DATE  : 7/1/2008
#         Last updated 2/5/2009
# 
# COMMENT: This script uses Get-Childitem to enumerate a folder or drive
# and adds a custom property for each file owner. It also creates an alias
# property of Size which you can use in place of Length.
#
# EXAMPLES:
# c:\Scripts\Get-OwnerReport c:\test -recurse -force | sort Owner | select Name,Owner,Size  
# c:\Scripts\Get-OwnerReport c:\test -recurse | sort Owner | group Owner

# c:\Scripts\Get-OwnerReport \\jdhit-dc01\public -recurse  | group Owner| foreach {
#  $owner=$_.name
#  $_.group | measure-object size -sum -minimum -maximum | 
#  select @{name="Owner";Expression={$owner}},`
#  Count,Sum,Minimum,Maximum
#  }

# $data=c:\Scripts\Get-OwnerReport c:\test -recurse
# $data | where {$_.owner -notmatch "Administrators"} | sort owner,size |Select fullname,size,owner

#IF YOU HAVE POWER GADGETS:
# $data | group Owner| foreach {
#  $owner=$_.name
#  $_.group | Measure-Object size -sum -maximum | 
#  select @{name="Owner";Expression={$owner}},`
#  Count,Sum,Maximum
#  } | sort Count | Out-Chart -Values Maximum,Sum -Label Owner -title "C:\TEST"

#OR CREATE A PIE CHART

# $data | group Owner | foreach {
#  $owner=$_.name
#  $_.group | Measure-Object | 
#  select @{name="Owner";Expression={$owner}},Count
#  } | Out-Chart -gallery Pie -Values Count -Label Owner -title "C:\TEST"

# $data | group Owner| foreach {
#  $owner=$_.name
#  $_.group | Measure-Object size -sum | 
#  select @{name="Owner";Expression={$owner}},`
#  @{name="Total(MB)";Expression={$_.sum/1mb}},Count,Sum
#  } | Out-Chart -gallery Pie -Values "Total(MB)" -Label Owner -title "C:\TEST"

#  ****************************************************************
#  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
#  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.       * 						  * 
#  ****************************************************************
# 
# ==============================================================================================

Param([string]$path=$env:Temp,
      [switch]$recurse,
      [switch]$force
     )

    #verify the path is reachable
    if (-Not (Test-Path $path)) {
        Write-Warning "Failed to find $path"
        Return
    }
    
    #create a get-childitem script block that corresponds
    #to the passed values of -recurse and -force
    
    $cmd="Get-ChildItem $path"
    
    if ($recurse) {
        $cmd=$cmd + " -recurse"
    }
   
    if ($force) {
        $cmd=$cmd + " -force"
    }
    
    # execute the command and pipe to Where-object to filter out
    # directories. Each remaining object is piped to ForEach
    # which adds some custom properties

    &$executioncontext.InvokeCommand.NewScriptBlock($cmd) | where {
    -not $_.PSIsContainer } | foreach {
      $_ | Add-Member -MemberType "NoteProperty" -name "Owner" -value (Get-Acl $_.fullname).Owner
      $_ | Add-Member -MemberType "AliasProperty" -name "Size" -value Length -passthru
     }
    
#end of script
