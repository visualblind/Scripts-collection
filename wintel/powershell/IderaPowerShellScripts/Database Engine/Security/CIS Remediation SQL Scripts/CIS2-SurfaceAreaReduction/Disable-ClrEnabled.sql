-- Disable CLR Enabled Server Configuration Option
-- CIS 2.2 Check (Surface Area Reduction)

EXECUTE sp_configure 'clr enabled', 0;
RECONFIGURE;