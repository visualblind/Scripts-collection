-- Enable CHECK_POLICY for All SQL Authenticated Logins
-- CIS 4.3 Check (Password Policies)

ALTER LOGIN "$(LoginName)" WITH CHECK_POLICY = ON;