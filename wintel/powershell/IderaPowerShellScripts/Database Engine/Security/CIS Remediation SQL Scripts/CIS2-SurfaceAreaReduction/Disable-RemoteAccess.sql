-- Disable Remote Access Server Configuration Option
-- CIS 2.6 Check (Surface Area Reduction)

EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;
EXECUTE sp_configure 'remote access', 0;
RECONFIGURE;
GO
EXECUTE sp_configure 'show advanced options', 0;
RECONFIGURE;