-- Disable Ad Hoc Distributed Queries Server Configuration Option
-- CIS 2.1 Check (Surface Area Reduction)

EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;
EXECUTE sp_configure 'Ad Hoc Distributed Queries', 0;
RECONFIGURE;
GO
EXECUTE sp_configure 'show advanced options', 0;
RECONFIGURE;