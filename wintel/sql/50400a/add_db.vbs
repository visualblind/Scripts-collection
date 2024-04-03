Dim oServer
Dim oDatabase
Dim oDBFile1
Dim oDBFile2
Dim oLogFile
Dim oFileGroup
Set oServer = CreateObject("SQLDMO.SQLServer")
Set oFileGroup =CreateObject("SQLDMO.FileGroup")
Set oDatabase =CreateObject("SQLDMO.Database")
Set oDBFile1 =CreateObject("SQLDMO.DBFile")
Set oDBFile2 =CreateObject("SQLDMO.DBFile")
Set oLogFile=CreateObject("SQLDMO.LogFile")
oServer.LoginSecure = True
oServer.Connect "."
Set oDatabase = oServer.Databases("Mod06")
oFileGroup.Name = "Mod06_LookupFG"
oDatabase.FileGroups.Add oFileGroup
oDBFile1.Name = "Mod06_Lookup01"
oDBFile1.PhysicalName = "d:\Data\Mod06_Lookup01.ndf"
oDBFile1.Size = 10
oDBFile1.FileGrowthType = SQLDMOGrowth_MB
oDBFile1.FileGrowth = 10
oDatabase.FileGroups("Mod06_LookupFG").DBFiles.Add oDBFile1
oDBFile2.Name = "Mod06_Lookup02"
oDBFile2.PhysicalName = "d:\Data\Mod06_Lookup02.ndf"
oDBFile2.Size = 10
oDBFile2.FileGrowthType = SQLDMOGrowth_MB
oDBFile2.FileGrowth = 10
oDatabase.FileGroups("Mod06_LookupFG").DBFiles.Add oDBFile2
