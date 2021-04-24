-- Revoke Connect Permissions on Guest
-- CIS 3.2 Check (Authentication and Authorization)

USE "$(DBName)";
REVOKE CONNECT FROM guest;