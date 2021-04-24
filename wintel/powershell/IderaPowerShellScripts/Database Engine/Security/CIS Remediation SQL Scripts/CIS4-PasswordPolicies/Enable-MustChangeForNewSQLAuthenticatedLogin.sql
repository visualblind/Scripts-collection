-- Enable MUST_CHANGE for All SQL Authenticated Logins
-- CIS 4.1 Check (Password Policies)

-- Set the MUST_CHANGE option for SQL Authenticated logins when creating a login initially:
CREATE LOGIN $(LoginName) WITH PASSWORD = '$(Password)' MUST_CHANGE, CHECK_EXPIRATION = ON, CHECK_POLICY = ON;



