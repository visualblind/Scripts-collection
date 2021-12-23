'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  DNSServer.vbs
'
'	Comments:
'
'   Disclaimer: This source code is intended only as a supplement to 
'		SAPIEN Development Tools and/or on-line documentation.  
'		See these other materials for detailed information 
'		regarding SAPIEN code samples.
'
'	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
'	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
'	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
'	PARTICULAR PURPOSE.
'
'**************************************************************************

On Error Resume Next
Dim strComputer
Dim objWMIService
Dim propValue
Dim objItem
Dim SWBemlocator
Dim UserName
Dim Password
Dim colItems

strComputer = "MYDNSServer"
UserName = ""
Password = ""
Set SWBemlocator = CreateObject("WbemScripting.SWbemLocator")
Set objWMIService = SWBemlocator.ConnectServer(strComputer,"root\microsoftDNS",UserName,Password)
Set colItems = objWMIService.ExecQuery("Select * from MicrosoftDNS_Server",,48)
For Each objItem in colItems
	WScript.Echo "AddressAnswerLimit: " & objItem.AddressAnswerLimit
	WScript.Echo "AllowUpdate: " & objItem.AllowUpdate
	WScript.Echo "AutoCacheUpdate: " & objItem.AutoCacheUpdate
	WScript.Echo "AutoConfigFileZones: " & objItem.AutoConfigFileZones
	WScript.Echo "BindSecondaries: " & objItem.BindSecondaries
	WScript.Echo "BootMethod: " & objItem.BootMethod
	WScript.Echo "Caption: " & objItem.Caption
	WScript.Echo "CreationClassName: " & objItem.CreationClassName
	WScript.Echo "DefaultAgingState: " & objItem.DefaultAgingState
	WScript.Echo "DefaultNoRefreshInterval: " & objItem.DefaultNoRefreshInterval
	WScript.Echo "DefaultRefreshInterval: " & objItem.DefaultRefreshInterval
	WScript.Echo "Description: " & objItem.Description
	WScript.Echo "DisableAutoReverseZones: " & objItem.DisableAutoReverseZones
	WScript.Echo "DisjointNets: " & objItem.DisjointNets
	WScript.Echo "DsAvailable: " & objItem.DsAvailable
	WScript.Echo "DsPollingInterval: " & objItem.DsPollingInterval
	WScript.Echo "DsTombstoneInterval: " & objItem.DsTombstoneInterval
	WScript.Echo "EDnsCacheTimeout: " & objItem.EDnsCacheTimeout
	WScript.Echo "EnableDirectoryPartitions: " & objItem.EnableDirectoryPartitions
	WScript.Echo "EnableDnsSec: " & objItem.EnableDnsSec
	WScript.Echo "EnableEDnsProbes: " & objItem.EnableEDnsProbes
	WScript.Echo "EventLogLevel: " & objItem.EventLogLevel
	WScript.Echo "ForwardDelegations: " & objItem.ForwardDelegations
	for each propValue in objItem.Forwarders
		WScript.Echo "Forwarders: " & propValue
	next
	WScript.Echo "ForwardingTimeout: " & objItem.ForwardingTimeout
	WScript.Echo "InstallDate: " & objItem.InstallDate
	WScript.Echo "IsSlave: " & objItem.IsSlave
	for each propValue in objItem.ListenAddresses
		WScript.Echo "ListenAddresses: " & propValue
	next
	WScript.Echo "LocalNetPriority: " & objItem.LocalNetPriority
	WScript.Echo "LogFileMaxSize: " & objItem.LogFileMaxSize
	WScript.Echo "LogFilePath: " & objItem.LogFilePath
	for each propValue in objItem.LogIPFilterList
		WScript.Echo "LogIPFilterList: " & propValue
	next
	WScript.Echo "LogLevel: " & objItem.LogLevel
	WScript.Echo "LooseWildcarding: " & objItem.LooseWildcarding
	WScript.Echo "MaxCacheTTL: " & objItem.MaxCacheTTL
	WScript.Echo "MaxNegativeCacheTTL: " & objItem.MaxNegativeCacheTTL
	WScript.Echo "Name: " & objItem.Name
	WScript.Echo "NameCheckFlag: " & objItem.NameCheckFlag
	WScript.Echo "NoRecursion: " & objItem.NoRecursion
	WScript.Echo "RecursionRetry: " & objItem.RecursionRetry
	WScript.Echo "RecursionTimeout: " & objItem.RecursionTimeout
	WScript.Echo "RoundRobin: " & objItem.RoundRobin
	WScript.Echo "RpcProtocol: " & objItem.RpcProtocol
	WScript.Echo "ScavengingInterval: " & objItem.ScavengingInterval
	WScript.Echo "SecureResponses: " & objItem.SecureResponses
	WScript.Echo "SendPort: " & objItem.SendPort
	for each propValue in objItem.ServerAddresses
		WScript.Echo "ServerAddresses: " & propValue
	next
	WScript.Echo "Started: " & objItem.Started
	WScript.Echo "StartMode: " & objItem.StartMode
	WScript.Echo "Status: " & objItem.Status
	WScript.Echo "StrictFileParsing: " & objItem.StrictFileParsing
	WScript.Echo "SystemCreationClassName: " & objItem.SystemCreationClassName
	WScript.Echo "SystemName: " & objItem.SystemName
	WScript.Echo "UpdateOptions: " & objItem.UpdateOptions
	WScript.Echo "Version: " & objItem.Version
	WScript.Echo "WriteAuthorityNS: " & objItem.WriteAuthorityNS
	WScript.Echo "XfrConnectTimeout: " & objItem.XfrConnectTimeout
Next
