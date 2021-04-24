-- Disable Scan For Startup Procs Server Configuration Option
-- CIS 2.8 Check (Surface Area Reduction)

EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;
EXECUTE sp_configure 'scan for startup procs', 0;
RECONFIGURE;
GO
EXECUTE sp_configure 'show advanced options', 0;
RECONFIGURE;