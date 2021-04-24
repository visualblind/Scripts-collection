Dim oServer
Dim oDatabase
Dim oDBFileData
Dim oLogFile
Set oServer = CreateObject("SQLDMO.SQLServer")
Set oDatabase =CreateObject("SQLDMO.Database")
Set oDBFileData =CreateObject("SQLDMO.DBFile")
Set oLogFile=CreateObject("SQLDMO.LogFile")
oDatabase.Name = "Mod06"
oDBFileData.Name = "Mod06_Data01"
oDBFileData.PhysicalName = "d:\Data\Mod06_Data01.mdf"
oDBFileData.PrimaryFile = True
oDBFileData.FileGrowthType = SQLDMOGrowth_MB
oDBFileData.FileGrowth = 10
oDatabase.FileGroups("PRIMARY").DBFiles.Add oDBFileData
oLogFile.Name = "Mod06_Log01"
oLogFile.PhysicalName = "D:\Data\Mod06_Log01.ldf"
oDatabase.TransactionLog.LogFiles.Add oLogFile
oServer.LoginSecure = True
oServer.Connect "."
oServer.Databases.Add oDatabase

