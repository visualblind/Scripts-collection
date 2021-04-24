-- Set Maximum number of error log files
-- CIS 5.1 Check (Auditing and Logging)

EXEC master.sys.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'NumErrorLogs', REG_DWORD, $(NumberAbove12);
