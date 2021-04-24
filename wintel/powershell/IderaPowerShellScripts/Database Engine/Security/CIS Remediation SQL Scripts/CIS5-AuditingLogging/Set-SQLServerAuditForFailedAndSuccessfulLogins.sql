-- Set SQL Server Audit to capture failed and successful logins
-- CIS 5.4 Check (Auditing and Logging)

CREATE SERVER AUDIT TrackLogins
TO APPLICATION_LOG;
GO

CREATE SERVER AUDIT SPECIFICATION TrackAllLogins
FOR SERVER AUDIT TrackLogins
ADD (FAILED_LOGIN_GROUP),
ADD (SUCCESSFUL_LOGIN_GROUP),
ADD (AUDIT_CHANGE_GROUP)
WITH (STATE = ON);
GO

ALTER SERVER AUDIT TrackLogins
WITH (STATE = ON);
GO

