# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Demo-Color.ps1
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

 Param([switch]$combo)

 $colors="Black","DarkMagenta","DarkRed","DarkBlue","DarkGreen","DarkCyan","DarkYellow","Red","Blue","Green","Cyan","Magenta","Yellow","DarkGray","Gray","White"

 cls

if ($combo) { #cycle through all background and foreground combinations
 for ($i=0;$i -lt $colors.count;$i++) { 
     for ($j=0;$j -lt $colors.count;$j++) {
        if ($colors[$i] -ne $colors[$j]) {
            $msg="{0} on {1}" -f $colors[$i],$colors[$j]
            Write-Host $msg -foregroundcolor $colors[$i] -backgroundcolor $colors[$j]
        }
    }
 }
}
else {
#show the list of colors
 for ($i=0;$i -lt $colors.count;$i++) { 
    Write-Host " $($colors[$i])   " -BackgroundColor $colors[$i]
 }
}
