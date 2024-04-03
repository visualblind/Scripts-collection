-- SQL Server Error Log Scripts
-- Last script revision - 2019-07-02
--
-- Scripts provided by MSSQLTips.com are from various contributors. Use links below to learn more about the scripts.
-- 
-- Be careful using any of these scripts. Test all scripts in Test/Dev prior to using in Production environments.
-- Please refer to the disclaimer policy: https://www.mssqltips.com/disclaimer/
-- Please refer to the copyright policy: https://www.mssqltips.com/copyright/
--
-- Note, these scripts are meant to be run individually.
--
-- Have a script to contribute or an update?  Send an email to: tips@mssqltips.com


---------------------------------------------------------------------------------------------------------------------------
-- Purpose: This shows any errors in the SQL Server error log along with all associated error lines.
-- More information: https://www.mssqltips.com/sqlservertip/1307/simple-way-to-find-errors-in-sql-server-error-log/
-- Revision: 2019-07-02
--
USE master
GO
DROP TABLE IF EXISTS #errorLog;  -- this is new syntax in SQL 2016 and later
--IF OBJECT_ID('tempdb..#errorLog') IS NOT NULL DROP TABLE #errorLog -- this is old syntax prior to SQL 2016

CREATE TABLE #errorLog (LogDate DATETIME, ProcessInfo VARCHAR(64), [Text] VARCHAR(MAX));

INSERT INTO #errorLog
EXEC sp_readerrorlog 0 -- specify the log number or use nothing for active error log

SELECT * 
FROM #errorLog a
WHERE EXISTS (SELECT * 
              FROM #errorLog b
              WHERE [Text] like 'Error:%'
                AND a.LogDate = b.LogDate
                AND a.ProcessInfo = b.ProcessInfo)
                

---------------------------------------------------------------------------------------------------------------------------
-- Purpose: Identify location of where the SQL Server Error Log file is written
-- More information: https://www.mssqltips.com/sqlservertip/2506/identify-location-of-the-sql-server-error-log-file/
-- Revision: 2019-07-02
--
USE master
GO
xp_readerrorlog 0, 1, N'Logging SQL Server messages in file'
GO


---------------------------------------------------------------------------------------------------------------------------
-- Purpose: Stop logging all successful database backpus in the SQL Server Error Log
-- More information: https://www.mssqltips.com/sqlservertip/1307/simple-way-to-find-errors-in-sql-server-error-log/
-- Revision: 2019-07-02
--
-- this will temporarily stop logging all successful backup entries to the SQL Server error log
-- but this will revert if SQL Server is restarted, so you need to set this trace flag as a startup parameter
-- see https://www.mssqltips.com/sqlservertip/960/setting-sql-server-startup-parameters/
--
USE master
GO
DBCC TRACEON (3226,-1)


---------------------------------------------------------------------------------------------------------------------------
-- Purpose: Create new SQL Server Error Log.  This will archive the current error log and create a new empty log.
-- More information: https://www.mssqltips.com/sqlservertip/1155/sql-server-error-log-management/
-- Revision: 2019-07-02
--
EXEC master.sys.sp_cycle_errorlog;


---------------------------------------------------------------------------------------------------------------------------
-- Purpose: Logging all logins to SQL Server can eat up a lot of space in the error log.  This will change the setting so that 
-- only failed logins are logged to the SQL Server error log, so you can still audit these.
-- More information: 
-- Revision: 2019-07-02
--
USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', REG_DWORD, 2
GO


---------------------------------------------------------------------------------------------------------------------------
-- Purpose: Increase the number of SQL Server Error Logs from the default of 7.  This will increase from 7 to 30.
-- More information: https://www.mssqltips.com/sqlservertip/1155/sql-server-error-log-management/
-- Revision: 2019-07-02
--
USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'NumErrorLogs', REG_DWORD, 30
GO


---------------------------------------------------------------------------------------------------------------------------
-- Purpose: Search for text in all SQL Server Error Logs
-- More information: https://www.mssqltips.com/sqlservertip/5613/sql-server-script-to-search-through-all-error-logs/
-- Revision: 2019-07-02
--
DECLARE @LogType INT = 1
DECLARE @filterstr NVARCHAR (4000) = 'checkdb' -- change this value for keyword to search

BEGIN
   -- The list of all logs table
   DECLARE @LogList TABLE (LogNumber INT, StartDate DATETIME, SizeInBytes INT)
   -- All the log rows results table
   DECLARE @ALLLogRows TABLE (LogDate DATETIME, 
                              ProcessInfo NVARCHAR (4000), 
                              Test NVARCHAR (4000))
 
   -- Store in a table variable
   INSERT INTO @LogList 
   EXEC xp_enumerrorlogs @LogType
 
   -- Iterate on all the logs and collect all log rows
   DECLARE @idx INT = 0
   WHILE @idx <= (SELECT MAX (LogNumber) FROM @LogList)
   BEGIN
      INSERT INTO @ALLLogRows
      EXEC xp_readerrorlog @idx -- Log number
         , @LogType -- 1=SQL Server log, 2=SQL Agent log
         , @filterstr -- filter string
         , @filterstr
 
      SET @idx += 1
   END
   -- Return the results from the log rows table variable
   SELECT *
   FROM @ALLLogRows
   ORDER BY LogDate DESC
END
GO


---------------------------------------------------------------------------------------------------------------------------
-- Purpose: Read through SQL Server Error Log and current default trace file and extract errors and warning.
-- More information: https://www.mssqltips.com/sqlservertip/5140/read-all-errors-and-warnings-in-the-sql-server-error-log-for-all-versions/
-- Revision: 2019-07-02
--
-- Load setup
CREATE TABLE #ExclusionList ([StringValue] VARCHAR(8000))
CREATE TABLE #ObjectTypeName ([ObjectType] INT, [ObjectName] VARCHAR(100))
CREATE TABLE #TraceEvents ([Trace_Event_Id] SMALLINT, [Category_Id] SMALLINT, [Name] VARCHAR(128))
INSERT INTO #ExclusionList VALUES ('Microsoft Corp')
INSERT INTO #ExclusionList VALUES ('Microsoft SQL Server')
INSERT INTO #ExclusionList VALUES ('UTC adjust')
INSERT INTO #ExclusionList VALUES ('All rights reserved')
INSERT INTO #ExclusionList VALUES ('Server name is')
INSERT INTO #ExclusionList VALUES ('Server process ID is')
INSERT INTO #ExclusionList VALUES ('System Manufact')
INSERT INTO #ExclusionList VALUES ('Authentication mode is')
INSERT INTO #ExclusionList VALUES ('Logging SQL Server messages in')
INSERT INTO #ExclusionList VALUES ('This is an informational message')
INSERT INTO #ExclusionList VALUES ('Registry startup parameters')
INSERT INTO #ExclusionList VALUES ('Command Line Startup Parameters')
INSERT INTO #ExclusionList VALUES ('Using conventional memory in')
INSERT INTO #ExclusionList VALUES ('Default collation')
INSERT INTO #ExclusionList VALUES ('Query Store settings initialized with')
INSERT INTO #ExclusionList VALUES ('The maximum number of dedicated administrator connections for this instance is')
INSERT INTO #ExclusionList VALUES ('Starting up database')
INSERT INTO #ExclusionList VALUES ('CLR version')
INSERT INTO #ExclusionList VALUES ('Using %.dll'' version')
INSERT INTO #ExclusionList VALUES ('Software Usage Metrics is')
INSERT INTO #ExclusionList VALUES ('Common Language runtime (CLR) functionality initialized using')
INSERT INTO #ExclusionList VALUES ('SQL Trace ID % was started by')
INSERT INTO #ExclusionList VALUES ('SQL Trace stopped')
INSERT INTO #ExclusionList VALUES ('A self-generated certificate was successfully loaded')
INSERT INTO #ExclusionList VALUES ('SQL server listening on')
INSERT INTO #ExclusionList VALUES ('Server is listening on')
INSERT INTO #ExclusionList VALUES ('SQL Server is ready for client connection')
INSERT INTO #ExclusionList VALUES ('SQL Server is starting at priority class')
INSERT INTO #ExclusionList VALUES ('SQL Server configured for thread mode processing')
INSERT INTO #ExclusionList VALUES ('SQL global counter collection task is created')
INSERT INTO #ExclusionList VALUES ('Large Page Extensions enabled')
INSERT INTO #ExclusionList VALUES ('Server local connection provider is ready to accept connection on')
INSERT INTO #ExclusionList VALUES ('Server named pipe provider is ready to accept connection on')
INSERT INTO #ExclusionList VALUES ('Recovery complete')
INSERT INTO #ExclusionList VALUES ('Dedicated admin connection support was established for listening')
INSERT INTO #ExclusionList VALUES ('A new instance of the full-text filter daemon host process')
INSERT INTO #ExclusionList VALUES ('Clearing tempdb database')
INSERT INTO #ExclusionList VALUES ('No user action is required')
INSERT INTO #ExclusionList VALUES ('due to some database maintenance or reconfigure operations')
INSERT INTO #ExclusionList VALUES ('The error log has been reinitialized')
INSERT INTO #ExclusionList VALUES ('Service Broker manager has')
INSERT INTO #ExclusionList VALUES ('FlushCache: cleaned up % bufs with % writes in % ms')
INSERT INTO #ExclusionList VALUES ('average throughput: % MB/sec, I/O saturation: %, context switches')
INSERT INTO #ExclusionList VALUES ('last target outstanding: %, avgWriteLatency')
INSERT INTO #ExclusionList VALUES ('cachestore flush % due to ''DBCC FREEPROCCACHE'' or ''DBCC FREESYSTEMCACHE''')
INSERT INTO #ExclusionList VALUES ('Using locked pages for buffer pool')
INSERT INTO #ExclusionList VALUES ('Resource governor reconfiguration succeeded')
INSERT INTO #ExclusionList VALUES ('FILESTREAM: % file system access share name =')
INSERT INTO #ExclusionList VALUES ('The % protocol transport is now listening for connections')
INSERT INTO #ExclusionList VALUES ('The % protocol transport is disabled or not configured')
INSERT INTO #ExclusionList VALUES ('The % endpoint is in disabled or stopped state')
INSERT INTO #ExclusionList VALUES ('Database mirroring has been enabled on this instance of SQL Server')
INSERT INTO #ExclusionList VALUES ('Database %: IO is frozen for snapsho')
INSERT INTO #ExclusionList VALUES ('Database %: IO is thawe')
INSERT INTO #ExclusionList VALUES ('Setting database option COMPATIBILITY_LEVEL to')
INSERT INTO #ExclusionList VALUES ('The activated proc % running on queue % output the following')
INSERT INTO #ExclusionList VALUES ('Database Audit Backup/Restore Event')
INSERT INTO #ExclusionList VALUES ('User-Defined Table Created')
INSERT INTO #ExclusionList VALUES ('Index Created')
INSERT INTO #ExclusionList VALUES ('Server Audit Server Alter Trace Event')
INSERT INTO #ExclusionList VALUES ('Creating member security items for % started at')
-- Exclude log shipping database events
IF @@VERSION LIKE 'Microsoft SQL Server  2000%'
BEGIN
   INSERT INTO #ExclusionList SELECT 'Setting database option SINGLE_USER to ON for database '+[secondary_database_name] FROM [msdb].[dbo].[log_shipping_secondaries]
   INSERT INTO #ExclusionList SELECT 'Setting database option MULTI_USER to ON for database '+[secondary_database_name] FROM [msdb].[dbo].[log_shipping_secondaries]
   INSERT INTO #ExclusionList SELECT 'The database '''+[secondary_database_name]+''' is marked RESTORING' FROM [msdb].[dbo].[log_shipping_secondaries]
END
ELSE
BEGIN
   INSERT INTO #ExclusionList SELECT 'Setting database option SINGLE_USER to ON for database '+[secondary_database] FROM [msdb].[dbo].[log_shipping_secondary_databases]
   INSERT INTO #ExclusionList SELECT 'Setting database option MULTI_USER to ON for database '+[secondary_database] FROM [msdb].[dbo].[log_shipping_secondary_databases]
   INSERT INTO #ExclusionList SELECT 'The database '''+[secondary_database]+''' is marked RESTORING' FROM [msdb].[dbo].[log_shipping_secondary_databases]
END
-- Setup configuration tables
INSERT INTO #ObjectTypeName VALUES (1,'Index');
INSERT INTO #ObjectTypeName VALUES (2,'Database');
INSERT INTO #ObjectTypeName VALUES (3,'User Object');
INSERT INTO #ObjectTypeName VALUES (4,'Check Constraint');
INSERT INTO #ObjectTypeName VALUES (5,'Default Constraint');
INSERT INTO #ObjectTypeName VALUES (6,'Foreign Key Constraint');
INSERT INTO #ObjectTypeName VALUES (7,'Primary Key Constraint');
INSERT INTO #ObjectTypeName VALUES (8,'Stored Procedure');
INSERT INTO #ObjectTypeName VALUES (9,'User-Defined Function');
INSERT INTO #ObjectTypeName VALUES (10,'Rule');
INSERT INTO #ObjectTypeName VALUES (11,'Replication Filter Stored Procedure');
INSERT INTO #ObjectTypeName VALUES (12,'System Table');
INSERT INTO #ObjectTypeName VALUES (13,'Trigger');
INSERT INTO #ObjectTypeName VALUES (14,'Inline Function');
INSERT INTO #ObjectTypeName VALUES (15,'Table Valued UDF');
INSERT INTO #ObjectTypeName VALUES (16,'Unique Constraint');
INSERT INTO #ObjectTypeName VALUES (17,'User Table');
INSERT INTO #ObjectTypeName VALUES (18,'View');
INSERT INTO #ObjectTypeName VALUES (19,'Extended Stored Procedure');
INSERT INTO #ObjectTypeName VALUES (20,'Ad hoc Query');
INSERT INTO #ObjectTypeName VALUES (21,'Prepared Query');
INSERT INTO #ObjectTypeName VALUES (8259,'Check Constraint');
INSERT INTO #ObjectTypeName VALUES (8260,'Default Constraint/Standalone');
INSERT INTO #ObjectTypeName VALUES (8262,'Foreign-Key Constraint');
INSERT INTO #ObjectTypeName VALUES (8272,'Stored Procedure');
INSERT INTO #ObjectTypeName VALUES (8274,'Rule');
INSERT INTO #ObjectTypeName VALUES (8275,'System Table');
INSERT INTO #ObjectTypeName VALUES (8276,'Trigger on Server');
INSERT INTO #ObjectTypeName VALUES (8277,'User-Defined Table');
INSERT INTO #ObjectTypeName VALUES (8278,'View');
INSERT INTO #ObjectTypeName VALUES (8280,'Extended Stored Procedure');
INSERT INTO #ObjectTypeName VALUES (16724,'CLR Trigger');
INSERT INTO #ObjectTypeName VALUES (16964,'Database');
INSERT INTO #ObjectTypeName VALUES (16975,'Object');
INSERT INTO #ObjectTypeName VALUES (17222,'FullText Catalog');
INSERT INTO #ObjectTypeName VALUES (17232,'CLR Stored Procedure');
INSERT INTO #ObjectTypeName VALUES (17235,'Schema');
INSERT INTO #ObjectTypeName VALUES (17475,'Credential');
INSERT INTO #ObjectTypeName VALUES (17491,'DDL Event');
INSERT INTO #ObjectTypeName VALUES (17741,'Management Event');
INSERT INTO #ObjectTypeName VALUES (17747,'Security Event');
INSERT INTO #ObjectTypeName VALUES (17749,'User Event');
INSERT INTO #ObjectTypeName VALUES (17985,'CLR Aggregate Function');
INSERT INTO #ObjectTypeName VALUES (17993,'Inline Table-Valued SQL Function');
INSERT INTO #ObjectTypeName VALUES (18000,'Partition Function');
INSERT INTO #ObjectTypeName VALUES (18002,'Replication Filter Procedure');
INSERT INTO #ObjectTypeName VALUES (18004,'Table-Valued SQL Function');
INSERT INTO #ObjectTypeName VALUES (18259,'Server Role');
INSERT INTO #ObjectTypeName VALUES (18263,'Microsoft Windows Group');
INSERT INTO #ObjectTypeName VALUES (19265,'Asymmetric Key');
INSERT INTO #ObjectTypeName VALUES (19277,'Master Key');
INSERT INTO #ObjectTypeName VALUES (19280,'Primary Key');
INSERT INTO #ObjectTypeName VALUES (19283,'ObfusKey');
INSERT INTO #ObjectTypeName VALUES (19521,'Asymmetric Key Login');
INSERT INTO #ObjectTypeName VALUES (19523,'Certificate Login');
INSERT INTO #ObjectTypeName VALUES (19538,'Role');
INSERT INTO #ObjectTypeName VALUES (19539,'SQL Login');
INSERT INTO #ObjectTypeName VALUES (19543,'Windows Login');
INSERT INTO #ObjectTypeName VALUES (20034,'Remote Service Binding');
INSERT INTO #ObjectTypeName VALUES (20036,'Event Notification on Database');
INSERT INTO #ObjectTypeName VALUES (20037,'Event Notification');
INSERT INTO #ObjectTypeName VALUES (20038,'Scalar SQL Function');
INSERT INTO #ObjectTypeName VALUES (20047,'Event Notification on Object');
INSERT INTO #ObjectTypeName VALUES (20051,'Synonym');
INSERT INTO #ObjectTypeName VALUES (20549,'End Point');
INSERT INTO #ObjectTypeName VALUES (20801,'Adhoc Queries which may be cached');
INSERT INTO #ObjectTypeName VALUES (20816,'Prepared Queries which may be cached');
INSERT INTO #ObjectTypeName VALUES (20819,'Service Broker Service Queue');
INSERT INTO #ObjectTypeName VALUES (20821,'Unique Constraint');
INSERT INTO #ObjectTypeName VALUES (21057,'Application Role');
INSERT INTO #ObjectTypeName VALUES (21059,'Certificate');
INSERT INTO #ObjectTypeName VALUES (21075,'Server');
INSERT INTO #ObjectTypeName VALUES (21076,'Transact-SQL Trigger');
INSERT INTO #ObjectTypeName VALUES (21313,'Assembly');
INSERT INTO #ObjectTypeName VALUES (21318,'CLR Scalar Function');
INSERT INTO #ObjectTypeName VALUES (21321,'Inline scalar SQL Function');
INSERT INTO #ObjectTypeName VALUES (21328,'Partition Scheme');
INSERT INTO #ObjectTypeName VALUES (21333,'User');
INSERT INTO #ObjectTypeName VALUES (21571,'Service Broker Service Contract');
INSERT INTO #ObjectTypeName VALUES (21572,'Trigger on Database');
INSERT INTO #ObjectTypeName VALUES (21574,'CLR Table-valued Function');
INSERT INTO #ObjectTypeName VALUES (21577,'Internal Table (XML Node/Queue)');
INSERT INTO #ObjectTypeName VALUES (21581,'Service Broker Message Type');
INSERT INTO #ObjectTypeName VALUES (21586,'Service Broker Route');
INSERT INTO #ObjectTypeName VALUES (21587,'Statistics');
INSERT INTO #ObjectTypeName VALUES (21825,'User');
INSERT INTO #ObjectTypeName VALUES (21827,'User');
INSERT INTO #ObjectTypeName VALUES (21831,'User');
INSERT INTO #ObjectTypeName VALUES (21843,'User');
INSERT INTO #ObjectTypeName VALUES (21847,'User');
INSERT INTO #ObjectTypeName VALUES (22099,'Service Broker Service');
INSERT INTO #ObjectTypeName VALUES (22601,'Index');
INSERT INTO #ObjectTypeName VALUES (22604,'Certificate Login');
INSERT INTO #ObjectTypeName VALUES (22611,'XMLSchema');
INSERT INTO #ObjectTypeName VALUES (22868,'Type');
INSERT INTO #TraceEvents VALUES (10,11,'RPC:Completed');
INSERT INTO #TraceEvents VALUES (11,11,'RPC:Starting');
INSERT INTO #TraceEvents VALUES (12,13,'SQL:BatchCompleted');
INSERT INTO #TraceEvents VALUES (13,13,'SQL:BatchStarting');
INSERT INTO #TraceEvents VALUES (14,8,'Audit Login');
INSERT INTO #TraceEvents VALUES (15,8,'Audit Logout');
INSERT INTO #TraceEvents VALUES (16,3,'Attention');
INSERT INTO #TraceEvents VALUES (17,10,'ExistingConnection');
INSERT INTO #TraceEvents VALUES (18,8,'Audit Server Starts And Stops');
INSERT INTO #TraceEvents VALUES (19,12,'DTCTransaction');
INSERT INTO #TraceEvents VALUES (20,8,'Audit Login Failed');
INSERT INTO #TraceEvents VALUES (21,3,'EventLog');
INSERT INTO #TraceEvents VALUES (22,3,'ErrorLog');
INSERT INTO #TraceEvents VALUES (23,4,'Lock:Released');
INSERT INTO #TraceEvents VALUES (24,4,'Lock:Acquired');
INSERT INTO #TraceEvents VALUES (25,4,'Lock:Deadlock');
INSERT INTO #TraceEvents VALUES (26,4,'Lock:Cancel');
INSERT INTO #TraceEvents VALUES (27,4,'Lock:Timeout');
INSERT INTO #TraceEvents VALUES (28,6,'Degree of Parallelism');
INSERT INTO #TraceEvents VALUES (33,3,'Exception');
INSERT INTO #TraceEvents VALUES (34,11,'SP:CacheMiss');
INSERT INTO #TraceEvents VALUES (35,11,'SP:CacheInsert');
INSERT INTO #TraceEvents VALUES (36,11,'SP:CacheRemove');
INSERT INTO #TraceEvents VALUES (37,11,'SP:Recompile');
INSERT INTO #TraceEvents VALUES (38,11,'SP:CacheHit');
INSERT INTO #TraceEvents VALUES (40,13,'SQL:StmtStarting');
INSERT INTO #TraceEvents VALUES (41,13,'SQL:StmtCompleted');
INSERT INTO #TraceEvents VALUES (42,11,'SP:Starting');
INSERT INTO #TraceEvents VALUES (43,11,'SP:Completed');
INSERT INTO #TraceEvents VALUES (44,11,'SP:StmtStarting');
INSERT INTO #TraceEvents VALUES (45,11,'SP:StmtCompleted');
INSERT INTO #TraceEvents VALUES (46,5,'Object:Created');
INSERT INTO #TraceEvents VALUES (47,5,'Object:Deleted');
INSERT INTO #TraceEvents VALUES (50,12,'SQLTransaction');
INSERT INTO #TraceEvents VALUES (51,7,'Scan:Started');
INSERT INTO #TraceEvents VALUES (52,7,'Scan:Stopped');
INSERT INTO #TraceEvents VALUES (53,1,'CursorOpen');
INSERT INTO #TraceEvents VALUES (54,12,'TransactionLog');
INSERT INTO #TraceEvents VALUES (55,3,'Hash Warning');
INSERT INTO #TraceEvents VALUES (58,6,'Auto Stats');
INSERT INTO #TraceEvents VALUES (59,4,'Lock:Deadlock Chain');
INSERT INTO #TraceEvents VALUES (60,4,'Lock:Escalation');
INSERT INTO #TraceEvents VALUES (61,15,'OLEDB Errors');
INSERT INTO #TraceEvents VALUES (67,3,'Execution Warnings');
INSERT INTO #TraceEvents VALUES (68,6,'Showplan Text (Unencoded)');
INSERT INTO #TraceEvents VALUES (69,3,'Sort Warnings');
INSERT INTO #TraceEvents VALUES (70,1,'CursorPrepare');
INSERT INTO #TraceEvents VALUES (71,13,'Prepare SQL');
INSERT INTO #TraceEvents VALUES (72,13,'Exec Prepared SQL');
INSERT INTO #TraceEvents VALUES (73,13,'Unprepare SQL');
INSERT INTO #TraceEvents VALUES (74,1,'CursorExecute');
INSERT INTO #TraceEvents VALUES (75,1,'CursorRecompile');
INSERT INTO #TraceEvents VALUES (76,1,'CursorImplicitConversion');
INSERT INTO #TraceEvents VALUES (77,1,'CursorUnprepare');
INSERT INTO #TraceEvents VALUES (78,1,'CursorClose');
INSERT INTO #TraceEvents VALUES (79,3,'Missing Column Statistics');
INSERT INTO #TraceEvents VALUES (80,3,'Missing Join Predicate');
INSERT INTO #TraceEvents VALUES (81,9,'Server Memory Change');
INSERT INTO #TraceEvents VALUES (82,14,'UserConfigurable:0');
INSERT INTO #TraceEvents VALUES (83,14,'UserConfigurable:1');
INSERT INTO #TraceEvents VALUES (84,14,'UserConfigurable:2');
INSERT INTO #TraceEvents VALUES (85,14,'UserConfigurable:3');
INSERT INTO #TraceEvents VALUES (86,14,'UserConfigurable:4');
INSERT INTO #TraceEvents VALUES (87,14,'UserConfigurable:5');
INSERT INTO #TraceEvents VALUES (88,14,'UserConfigurable:6');
INSERT INTO #TraceEvents VALUES (89,14,'UserConfigurable:7');
INSERT INTO #TraceEvents VALUES (90,14,'UserConfigurable:8');
INSERT INTO #TraceEvents VALUES (91,14,'UserConfigurable:9');
INSERT INTO #TraceEvents VALUES (92,2,'Data File Auto Grow');
INSERT INTO #TraceEvents VALUES (93,2,'Log File Auto Grow');
INSERT INTO #TraceEvents VALUES (94,2,'Data File Auto Shrink');
INSERT INTO #TraceEvents VALUES (95,2,'Log File Auto Shrink');
INSERT INTO #TraceEvents VALUES (96,6,'Showplan Text');
INSERT INTO #TraceEvents VALUES (97,6,'Showplan All');
INSERT INTO #TraceEvents VALUES (98,6,'Showplan Statistics Profile');
INSERT INTO #TraceEvents VALUES (100,11,'RPC Output Parameter');
INSERT INTO #TraceEvents VALUES (102,8,'Audit Database Scope GDR Event');
INSERT INTO #TraceEvents VALUES (103,8,'Audit Schema Object GDR Event');
INSERT INTO #TraceEvents VALUES (104,8,'Audit Addlogin Event');
INSERT INTO #TraceEvents VALUES (105,8,'Audit Login GDR Event');
INSERT INTO #TraceEvents VALUES (106,8,'Audit Login Change Property Event');
INSERT INTO #TraceEvents VALUES (107,8,'Audit Login Change Password Event');
INSERT INTO #TraceEvents VALUES (108,8,'Audit Add Login to Server Role Event');
INSERT INTO #TraceEvents VALUES (109,8,'Audit Add DB User Event');
INSERT INTO #TraceEvents VALUES (110,8,'Audit Add Member to DB Role Event');
INSERT INTO #TraceEvents VALUES (111,8,'Audit Add Role Event');
INSERT INTO #TraceEvents VALUES (112,8,'Audit App Role Change Password Event');
INSERT INTO #TraceEvents VALUES (113,8,'Audit Statement Permission Event');
INSERT INTO #TraceEvents VALUES (114,8,'Audit Schema Object Access Event');
INSERT INTO #TraceEvents VALUES (115,8,'Audit Backup/Restore Event');
INSERT INTO #TraceEvents VALUES (116,8,'Audit DBCC Event');
INSERT INTO #TraceEvents VALUES (117,8,'Audit Change Audit Event');
INSERT INTO #TraceEvents VALUES (118,8,'Audit Object Derived Permission Event');
INSERT INTO #TraceEvents VALUES (119,15,'OLEDB Call Event');
INSERT INTO #TraceEvents VALUES (120,15,'OLEDB QueryInterface Event');
INSERT INTO #TraceEvents VALUES (121,15,'OLEDB DataRead Event');
INSERT INTO #TraceEvents VALUES (122,6,'Showplan XML');
INSERT INTO #TraceEvents VALUES (123,6,'SQL:FullTextQuery');
INSERT INTO #TraceEvents VALUES (124,16,'Broker:Conversation');
INSERT INTO #TraceEvents VALUES (125,18,'Deprecation Announcement');
INSERT INTO #TraceEvents VALUES (126,18,'Deprecation Final Support');
INSERT INTO #TraceEvents VALUES (127,3,'Exchange Spill Event');
INSERT INTO #TraceEvents VALUES (128,8,'Audit Database Management Event');
INSERT INTO #TraceEvents VALUES (129,8,'Audit Database Object Management Event');
INSERT INTO #TraceEvents VALUES (130,8,'Audit Database Principal Management Event');
INSERT INTO #TraceEvents VALUES (131,8,'Audit Schema Object Management Event');
INSERT INTO #TraceEvents VALUES (132,8,'Audit Server Principal Impersonation Event');
INSERT INTO #TraceEvents VALUES (133,8,'Audit Database Principal Impersonation Event');
INSERT INTO #TraceEvents VALUES (134,8,'Audit Server Object Take Ownership Event');
INSERT INTO #TraceEvents VALUES (135,8,'Audit Database Object Take Ownership Event');
INSERT INTO #TraceEvents VALUES (136,16,'Broker:Conversation Group');
INSERT INTO #TraceEvents VALUES (137,3,'Blocked process report');
INSERT INTO #TraceEvents VALUES (138,16,'Broker:Connection');
INSERT INTO #TraceEvents VALUES (139,16,'Broker:Forwarded Message Sent');
INSERT INTO #TraceEvents VALUES (140,16,'Broker:Forwarded Message Dropped');
INSERT INTO #TraceEvents VALUES (141,16,'Broker:Message Classify');
INSERT INTO #TraceEvents VALUES (142,16,'Broker:Transmission');
INSERT INTO #TraceEvents VALUES (143,16,'Broker:Queue Disabled');
INSERT INTO #TraceEvents VALUES (144,16,'Broker:Mirrored Route State Changed');
INSERT INTO #TraceEvents VALUES (146,6,'Showplan XML Statistics Profile');
INSERT INTO #TraceEvents VALUES (148,4,'Deadlock graph');
INSERT INTO #TraceEvents VALUES (149,16,'Broker:Remote Message Acknowledgement');
INSERT INTO #TraceEvents VALUES (150,9,'Trace File Close');
INSERT INTO #TraceEvents VALUES (151,2,'Database Mirroring Connection');
INSERT INTO #TraceEvents VALUES (152,8,'Audit Change Database Owner');
INSERT INTO #TraceEvents VALUES (153,8,'Audit Schema Object Take Ownership Event');
INSERT INTO #TraceEvents VALUES (154,8,'Audit Database Mirroring Login');
INSERT INTO #TraceEvents VALUES (155,17,'FT:Crawl Started');
INSERT INTO #TraceEvents VALUES (156,17,'FT:Crawl Stopped');
INSERT INTO #TraceEvents VALUES (157,17,'FT:Crawl Aborted');
INSERT INTO #TraceEvents VALUES (158,8,'Audit Broker Conversation');
INSERT INTO #TraceEvents VALUES (159,8,'Audit Broker Login');
INSERT INTO #TraceEvents VALUES (160,16,'Broker:Message Undeliverable');
INSERT INTO #TraceEvents VALUES (161,16,'Broker:Corrupted Message');
INSERT INTO #TraceEvents VALUES (162,3,'User Error Message');
INSERT INTO #TraceEvents VALUES (163,16,'Broker:Activation');
INSERT INTO #TraceEvents VALUES (164,5,'Object:Altered');
INSERT INTO #TraceEvents VALUES (165,6,'Performance statistics');
INSERT INTO #TraceEvents VALUES (166,13,'SQL:StmtRecompile');
INSERT INTO #TraceEvents VALUES (167,2,'Database Mirroring State Change');
INSERT INTO #TraceEvents VALUES (168,6,'Showplan XML For Query Compile');
INSERT INTO #TraceEvents VALUES (169,6,'Showplan All For Query Compile');
INSERT INTO #TraceEvents VALUES (170,8,'Audit Server Scope GDR Event');
INSERT INTO #TraceEvents VALUES (171,8,'Audit Server Object GDR Event');
INSERT INTO #TraceEvents VALUES (172,8,'Audit Database Object GDR Event');
INSERT INTO #TraceEvents VALUES (173,8,'Audit Server Operation Event');
INSERT INTO #TraceEvents VALUES (175,8,'Audit Server Alter Trace Event');
INSERT INTO #TraceEvents VALUES (176,8,'Audit Server Object Management Event');
INSERT INTO #TraceEvents VALUES (177,8,'Audit Server Principal Management Event');
INSERT INTO #TraceEvents VALUES (178,8,'Audit Database Operation Event');
INSERT INTO #TraceEvents VALUES (180,8,'Audit Database Object Access Event');
INSERT INTO #TraceEvents VALUES (181,12,'TM: Begin Tran starting');
INSERT INTO #TraceEvents VALUES (182,12,'TM: Begin Tran completed');
INSERT INTO #TraceEvents VALUES (183,12,'TM: Promote Tran starting');
INSERT INTO #TraceEvents VALUES (184,12,'TM: Promote Tran completed');
INSERT INTO #TraceEvents VALUES (185,12,'TM: Commit Tran starting');
INSERT INTO #TraceEvents VALUES (186,12,'TM: Commit Tran completed');
INSERT INTO #TraceEvents VALUES (187,12,'TM: Rollback Tran starting');
INSERT INTO #TraceEvents VALUES (188,12,'TM: Rollback Tran completed');
INSERT INTO #TraceEvents VALUES (189,4,'Lock:Timeout (timeout > 0)');
INSERT INTO #TraceEvents VALUES (190,19,'Progress Report: Online Index Operation');
INSERT INTO #TraceEvents VALUES (191,12,'TM: Save Tran starting');
INSERT INTO #TraceEvents VALUES (192,12,'TM: Save Tran completed');
INSERT INTO #TraceEvents VALUES (193,3,'Background Job Error');
INSERT INTO #TraceEvents VALUES (194,15,'OLEDB Provider Information');
INSERT INTO #TraceEvents VALUES (195,9,'Mount Tape');
INSERT INTO #TraceEvents VALUES (196,20,'Assembly Load');
INSERT INTO #TraceEvents VALUES (198,13,'XQuery Static Type');
INSERT INTO #TraceEvents VALUES (199,21,'QN: Subscription');
INSERT INTO #TraceEvents VALUES (200,21,'QN: Parameter table');
INSERT INTO #TraceEvents VALUES (201,21,'QN: Template');
INSERT INTO #TraceEvents VALUES (202,21,'QN: Dynamics');
INSERT INTO #TraceEvents VALUES (212,3,'Bitmap Warning');
INSERT INTO #TraceEvents VALUES (213,3,'Database Suspect Data Page');
INSERT INTO #TraceEvents VALUES (214,3,'CPU threshold exceeded');
INSERT INTO #TraceEvents VALUES (215,10,'PreConnect:Starting');
INSERT INTO #TraceEvents VALUES (216,10,'PreConnect:Completed');
INSERT INTO #TraceEvents VALUES (217,6,'Plan Guide Successful');
INSERT INTO #TraceEvents VALUES (218,6,'Plan Guide Unsuccessful');
INSERT INTO #TraceEvents VALUES (235,8,'Audit Fulltext');
-- Declare variables
DECLARE @IntervalMinutes INT, @DateStart DATETIME, @DateEnd DATETIME, @TraceFile VARCHAR(200)
CREATE TABLE #Info ([LogDate] DATETIME, [ProcessInfo] VARCHAR(1000), [Text] VARCHAR(7000))
-- Set configuration values
SET @IntervalMinutes = 1440
SET @DateEnd = GETDATE()
SET @DateStart = DATEADD(mi, -@IntervalMinutes, @DateEnd)
-- Read error log
IF @@VERSION LIKE 'Microsoft SQL Server  2000%'
BEGIN
   CREATE TABLE #InfoTemp ([ErrorLog] VARCHAR(8000), [ContinuationRow] INT)
   INSERT INTO #InfoTemp EXEC [xp_readerrorlog]
   DELETE FROM #InfoTemp WHERE [ContinuationRow] = 1
   INSERT INTO #Info
   SELECT (CASE WHEN LEFT([ErrorLog], 1) = CHAR(9) THEN GETDATE() ELSE LEFT([ErrorLog], 22) END),
         (CASE WHEN LEFT([ErrorLog], 1) = CHAR(9) THEN '' ELSE RTRIM(LTRIM(SUBSTRING([ErrorLog], 23, 11))) END),
         (CASE WHEN LEFT([ErrorLog], 1) = CHAR(9) THEN ErrorLog ELSE RTRIM(LTRIM(SUBSTRING([ErrorLog], 34, LEN([ErrorLog]) - 34))) END)
    FROM #InfoTemp
   DELETE FROM #Info WHERE [LogDate] NOT BETWEEN @DateStart AND @DateEnd
   DROP TABLE #InfoTemp
END
ELSE
BEGIN
   INSERT INTO #Info EXEC [xp_readerrorlog] 0, 1, NULL, NULL, @DateStart, @DateEnd
END
-- Get trace file
SELECT @TraceFile = CAST([value] AS NVARCHAR(1000))
  FROM ::fn_trace_getinfo(default)
 WHERE [traceid] = 1
   AND [property] = 2
-- Read trace file
IF @TraceFile <> ''
BEGIN
   INSERT INTO #Info ([LogDate], [Text])
   SELECT MIN([ftg].[StartTime]), '['+ISNULL([ftg].[DatabaseName],'')+'] '+ISNULL([otn].[ObjectName],'')+' '+ISNULL(REPLACE([te].[name],'Object:',''),'')+' by '+ISNULL([ftg].[LoginName],'')+' with: '+ISNULL([ftg].[ApplicationName],'n/a')
     FROM ::fn_trace_gettable(@TraceFile, DEFAULT) [ftg]
   INNER JOIN #TraceEvents [te] ON [te].[trace_event_id] = [ftg].[EventClass]
   INNER JOIN #ObjectTypeName [otn] ON [otn].[ObjectType] = [ftg].[ObjectType]
    WHERE [ftg].[StartTime] BETWEEN @DateStart AND @DateEnd
      AND ISNULL([ftg].[ObjectType], 0) NOT IN (21587/*Statistics*/)
      AND NOT (ISNULL([ftg].[DatabaseID], 0) = 2/*TempDB*/ AND [ftg].[ObjectType] IN (8277/*User-Defined Table*/, 22601/*Index*/))
   GROUP BY '['+ISNULL([ftg].[DatabaseName],'')+'] '+ISNULL([otn].[ObjectName],'')+' '+ISNULL(REPLACE([te].[name],'Object:',''),'')+' by '+ISNULL([ftg].[LoginName],'')+' with: '+ISNULL([ftg].[ApplicationName],'n/a')
END
-- Delete exclusions
DELETE [i] FROM #Info [i] INNER JOIN #ExclusionList [li] ON [i].[Text] LIKE '%'+[li].[stringValue]+'%'
-- Read TempDB size
IF @@VERSION LIKE 'Microsoft SQL Server  2000%'
BEGIN
   IF  (SELECT SUM([size]*8.0/1024) 'Current size in MB'
         FROM [tempdb].[dbo].[sysfiles])
      / 
      (SELECT SUM([size]*8.0/1024) 'Initial size in MB'
         FROM [master].[dbo].[sysaltfiles]
        WHERE [dbid] = 2)
      > 2
   BEGIN
      INSERT INTO #Info ([LogDate], [Text])
      VALUES (GETDATE(), '[TempDB] current size more than twice greater of initial size')
   END
END
ELSE
BEGIN
   IF  (SELECT SUM([size]*8.0/1024) 'Current size in MB'
         FROM [tempdb].[sys].[database_files])
      / 
      (SELECT SUM([size]*8.0/1024) 'Initial size in MB'
         FROM [master].[sys].[sysaltfiles]
        WHERE [dbid] = 2)
      > 2
   BEGIN
      INSERT INTO #Info ([LogDate], [Text])
      VALUES (GETDATE(), '[TempDB] current size more than twice greater of initial size')
   END
END
-- Finish
SELECT * FROM #Info ORDER BY [LogDate]
DROP TABLE #Info
-- Unload setup
DROP TABLE #ExclusionList
DROP TABLE #ObjectTypeName
DROP TABLE #TraceEvents