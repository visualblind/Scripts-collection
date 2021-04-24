-- Enable CHECK_EXPIRATION for All SQL Authenticated Logins Within the Sysadmin Role
-- CIS 4.2 Check (Password Policies)

ALTER LOGIN "$(LoginName)" WITH CHECK_EXPIRATION = ON;

