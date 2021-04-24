-- Drop Orphaned Users
-- CIS 3.3 Check (Authentication and Authorization)

USE "$(DBName)";
GO
DROP USER "$(UserName)";