-- Disable Remote Admin Connections Server Configuration Option
-- CIS 2.7 Check (Surface Area Reduction)

EXECUTE sp_configure 'remote admin connections', 0;
RECONFIGURE;
GO