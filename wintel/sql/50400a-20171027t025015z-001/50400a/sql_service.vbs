strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colServiceList = objWMIService.ExecQuery ("Select * from Win32_Service where DisplayName ='SQL Server Browser'")
For Each objService in colServiceList
errReturnCode = objService.Change( , , , ,"Automatic")
Next
For Each objService in colServiceList
errReturn = objService.StartService()
Next
