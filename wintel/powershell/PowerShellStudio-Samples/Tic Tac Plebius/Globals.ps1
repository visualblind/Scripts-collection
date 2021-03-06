#========================================================================
# Created with:	SAPIEN Technologies, Inc., PrimalForms 2011 v2.0.1
# Created by:	David Corrales
# Organization:	SAPIEN Technologies, Inc.
# Filename:		Globals.ps1
#========================================================================

#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

#Application Settings (These do not carry over to Packager Settings)
$ApplicationName = "Tic Tac Plebius"
$ApplicationVersion = "1.0"

#Sample function that provides the location of the script
function Get-Scriptdirectory
{ 
	if($hostinvocation -ne $null)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		$invocation=(get-variable MyInvocation -Scope 1).Value
		Split-Path -Parent $invocation.MyCommand.Definition
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-Scriptdirectory

