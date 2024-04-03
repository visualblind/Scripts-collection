/* Create a login account and add a user to the account */

USE master;
GO
CREATE LOGIN mirror_logon WITH PASSWORD = 'Pa$$w0rd';
GO
CREATE USER mirror_user FOR LOGIN mirror_logon;
GO


/* Add certificates to the user account */

CREATE CERTIFICATE pri_cert
   AUTHORIZATION mirror_user
   FROM FILE = 'D:\Data\pri_cert.cer'
GO
CREATE CERTIFICATE sb_cert
   AUTHORIZATION mirror_user
   FROM FILE = 'D:\Data\sb_cert.cer'
GO

/* Grant the CONNECT permission to the endpoint */

GRANT CONNECT ON ENDPOINT::witness_endpoint TO [mirror_logon];
GO

