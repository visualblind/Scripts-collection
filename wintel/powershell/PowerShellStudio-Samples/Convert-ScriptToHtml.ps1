# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  ConvertScriptToHTML.ps1
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
# NAME: Convert-ScriptToHTML.ps1
# 
# AUTHOR: Jeffery Hicks , SAPIEN Technologies, Inc.
# DATE  : 11/26/2008
# 
# COMMENT: This script will take an existing PowerShell script and create a color coded
# HTML Version. If you use the -linenumber switch, line numbers will also be added to the script.
# You can specify the name of the output file with -filename. Otherwise a filename based on the 
# original will be used. For example, if the source file is Get-MyData.ps1, the converted file
# will be called Get-MyData-Converted.html.
# 
# ==============================================================================================

Param ([string]$scriptname=$(Throw "You must specify a PowerShell script name"),
       [string]$filename,
       [switch]$linenumber
   )

$script=Get-Item $scriptname -ea "Silentlycontinue"

if ($script.Exists) {
#derive a filename from the script name if one wasn't specified
    if (! $filename) {
        $filename="{0}-Converted.html" -f $script.basename 
    }
    
    #get all currently loaded cmdlets
    $cmds=Get-Command -type cmdlet | select Name

    #build list of keywords
    $keywords=@("If","Else","Switch","ForEach","Function","Filter","Param")
    
    #Create beginning of file
    $style="<style type=""text/css""> `
    body { font-family:Tahoma; color:Black; Font-Size:10pt }`
    .comment {color:#006600} `
    .cmdlet {color:#0000CC} `
    .key {color:#00CC99} `
    .variable {color:#CC3300 } `
    </style>"
    $header="<html><head>$style<title>$scriptname</title></head><body>"
    Set-Content -path $filename -encoding ASCII -value $header
    $content=Get-Content $scriptname 
   
   $i=1
   foreach ($line in $content) {
      
      #replace spaces with HTML space
      $converted=$line.Replace(" ","&nbsp;")
      $converted+="<br>"

      if ($linenumber) {
      #add line numbering if specified
            $text= ("{0} {1}" -f $i,$converted)
            $i++   
        }
        else {
            $text= $converted      
        }
        
        
         #color variables      
         foreach ( $item in ([regex]"\$\w+").Matches($text) )   {
            $keymatch=$item.value
            $text=$text.replace($keymatch,"<span class=""variable"">$keymatch</span>")          
          }

        #color commands
        foreach ($cmd in $cmds) {
         #create an explicit REGEX object so we can use the IgnoreCase option
          $regex=New-Object "System.Text.regularExpressions.Regex"($cmd.name,"IgnoreCase")
	        foreach ( $item in $regex.Matches($text) )   {
             $keymatch=$item.value
             $text=$text.replace($keymatch,"<span class=""cmdlet"">$keymatch</span>")          
           }  
        }
        
        #color keywords
         foreach ($keyword in $keywords) {
         #create an explicit REGEX object so we can use the IgnoreCase option
          $regex=New-Object "System.Text.regularExpressions.Regex"($keyword,"IgnoreCase")
          #$regex.toString()
	        foreach ( $item in $regex.Matches($text) )   {
             $keymatch=$item.value
             $text=$text.replace($keymatch,"<span class=""key"">$keymatch</span>")          
           }  
        }

         #color comments
         if ($text -match [regex]"#") {
            $text=$text.Replace("#","<span class=""comment"">#")
            $text=$text.Replace("<br>","</span><br>")
            }     
        
     #add content to HTML file
     Add-Content -Path $filename -encoding ASCII -value "$text"
      }
     
   #add the end of the file
   $footer="</body></html>"
   Add-Content -Path $filename -encoding ASCII -value $footer
}
else {
    Write-Warning "Failed to find $filename"

}

Write-Host "Finished. See $filename for results."



