# Test Queue Health
# 
# This script will look at each queue and determine the status of each.
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
#
#
# History:
#   Version 1.x
#     Originally created by Joshua Kirkes (joshua@awesomejar.com)
#     at AwesomeJar Consulting, LLC in San Francisco, CA
#
#   Revision 1.1 
#    Created by Marc Koene
#
#   Version 2.0 (with performance data)
#	 Created by Bastian W. [Bastian@gmx-ist-cool.de]
#
#
# Revision History
# 2011-05-23	Joshua Kirkes		Created 1.0
# 2011-07-07	Marc Koene			Revision 1.1
# 2011-09-19	Bastian W.			2.0:
#									  * Added variable for the hubserver
#									  * checked if PSSnapin is loaded
#
# 2012-02-24	Bastian W.			2.1:
#									  * added Nagios performance counters
#
#
# To execute from within NSClient++
#
# [NRPE Handlers]
# check_exchange_mailqueue=cmd /c echo C:\Scripts\Nagios\NagiosMonitoring_ExchangeQueueHealth.ps1 | PowerShell.exe -Command -
#
# On the check_nrpe command include the -t 30, since it takes some time to load the Exchange cmdlet's.

if ( (Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction:SilentlyContinue) -eq $null)
{
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
}

$NagiosStatus = "0"
$NagiosDescription = ""
$NagiosPerfData = ""

ForEach ($Queue in Get-Queue -Server $env:computername)
{

			# Look for lagged queues - critical if over 5
				if ($Queue.MessageCount -gt "5" ) 
				{
					# Format the output for Nagios
					if ($NagiosDescription -ne "") 
					{
						# we already have a message queue description, so we will add a separator
						$NagiosDescription = $NagiosDescription + ", " 	
					}
					$NagiosDescription = $NagiosDescription + $Queue.Identity + " queue has " + $Queue.MessageCount + " messages to " + $Queue.NextHopDomain
			
					# Set the status to failed.
					$NagiosStatus = "2"
		
				# Look for lagged queues - warning if over 2
				} 
				elseif ($Queue.MessageCount -gt "2") 
				{
					# Format the output for Nagios
					if ($NagiosDescription -ne "") 	
					{
						# we already have a message queue description, so we will add a separator
						$NagiosDescription = $NagiosDescription + ", " 
					}
					
					$NagiosDescription = $NagiosDescription + $Queue.Identity + " queue has " + $Queue.MessageCount + " messages to " + $Queue.NextHopDomain
			
					# Don't lower the status level if we already have a critical event
					if ($NagiosStatus -ne "2") 
					{
						$NagiosStatus = "1"
					}
				}
}


# Output, what level should we tell our caller?
$NagiosPerfData = "|queue=" + $Queue.MessageCount + ";10;20;0"
$NagiosPerfData = $NagiosPerfData -replace " ", ""

if ($NagiosStatus -eq "2") 
{
	Write-Host "CRITICAL: " $NagiosDescription" "$NagiosPerfData
} 
elseif ($NagiosStatus -eq "1")
{
	Write-Host "WARNING: " $NagiosDescription" "$NagiosPerfData
} 
else 
{
	Write-Host "OK: All mail queues within limits. "$NagiosPerfData
}

exit $NagiosStatus		
