# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  NewRandomPassword.ps1
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

Function New-RandomPassword {
Param([int]$len=9 #how long a password do you want?
     )

#The password will be built from characters in this string
#Modify as you want.
[string]$s="12-34_5Abc:DeF;ghI<Jkl>MP=qrStUvwxYz67@#89$%0~!^no&"


$a=$s.toCharArray()
$x=""
for ($i=1;$i -le ($len*2);$i++) {
 $rand=$a[(Get-Random -min 0 -max $a.length)]
 if ($x -notmatch $rand) {
    $x+=$rand
  }
 }

$x.Substring(3,$len)
}

#sample usage to generate a 10 7 character passwords
for ($a=0;$a -lt 10;$a++) {
    New-RandomPassword 7
    }
