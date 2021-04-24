-- Disable Cross DB Ownership Chaining Server Configuration Option
-- CIS 2.3 Check (Surface Area Reduction)

EXECUTE sp_configure 'cross db ownership chaining', 0;
RECONFIGURE;




