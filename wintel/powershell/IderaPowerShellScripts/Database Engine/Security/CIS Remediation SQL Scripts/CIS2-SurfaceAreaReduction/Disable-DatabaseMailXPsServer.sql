-- Disable Database Mail XPs Server Configuration Option
-- CIS 2.4 Check (Surface Area Reduction)

EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;
EXECUTE sp_configure 'Database Mail XPs', 0;
RECONFIGURE;
GO
EXECUTE sp_configure 'show advanced options', 0;
RECONFIGURE;