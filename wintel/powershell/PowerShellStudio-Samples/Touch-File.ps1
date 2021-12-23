# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Touch-File.ps1
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

Function Touch-File {
    Param([string]$path=$(Throw "You must specify the name of a file"),
          [datetime]$touch=(Get-Date)
          ) 

    #properties to change

    [datetime]$UTCTime=$touch.ToUniversalTime()
    
    $file=Get-Item $path -ea "silentlycontinue"
    
    if ($file) {
        Write-Host "Touching $path" -foregroundcolor Green
        $file.CreationTime=$touch
        $file.CreationTimeUtc=$UTCTime
        $file.LastAccessTime=$touch
        $file.LastAccessTimeUtc=$UTCTime
        $file.LastWriteTime=$touch
        $file.LastWriteTimeUtc=$UTCTime
    }
    else {
        Write-Warning "Failed to find $path"
        
    }

}

#sample usage
# dir c:\scripts\*.ps1 | foreach {
#  Touch-File $_ "9/12/2008 01:10:00"
#  }
