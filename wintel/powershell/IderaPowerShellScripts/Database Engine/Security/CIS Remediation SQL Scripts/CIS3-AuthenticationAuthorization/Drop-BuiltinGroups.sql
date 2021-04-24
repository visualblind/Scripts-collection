-- Drop BUILTIN groups
-- CIS 3.10 Check (Authentication and Authorization)

USE [master];
GO
DROP LOGIN "[BUILTIN\$(GroupName)]";
GO
