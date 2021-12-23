# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#   This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File: ProcessSummary.ps1 
# 
# 	Comments:
# 
#   Disclaimer: This source code is intended only as a supplement to 
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

Function Get-ProcessSummary {
$procs=Get-Process | select name,description,starttime,path -errorAction Silentlycontinue

foreach ($process in $procs) {
    if ($process.description -IsNot [string]) {
        $procname=$process.name}
        else {
        $procname=$process.description
        }
    if ($process.starttime -IsNot [DateTime]) {
        $procTime="N/A" }
        else {
        $procTime=($process.starttime).ToString()
        }
    if ($process.path -IsNot [string]) {
        $procPath="N/A" }
        else {
        $procPath=$process.path
        }
        

#create new object to hold values
$obj = New-Object System.Object
Add-Member -inputobject $obj -membertype NoteProperty -Name Name -value $procname
Add-Member -inputobject $obj -membertype NoteProperty -Name StartTime -value $procTime
Add-Member -inputobject $obj -membertype NoteProperty -Name Path -value $procPath

Write-Output $obj

 }
}

[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
[void][reflection.assembly]::LoadWithPartialName("System.Drawing")
 
$form = new-object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size 800,400
$Form.Text = "Process Summary"

$DataGridView = new-object System.windows.forms.DataGridView

$array= New-Object System.Collections.ArrayList

$griddata=@(Get-ProcessSummary | write-output)
$array.AddRange($griddata)
$DataGridView.DataSource = $array
$DataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
$DataGridView.AllowUsertoResizeColumns=$True
$DataGridView.AutoSizeColumnsMode="AllCellsExceptHeader"
$form.Controls.Add($DataGridView)
$form.topmost = $True
$form.showdialog() | Out-Null
