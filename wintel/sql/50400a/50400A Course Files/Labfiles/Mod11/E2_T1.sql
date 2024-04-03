/* Create an encryption key */

USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO 

/* Create a certificate */

USE master;
CREATE CERTIFICATE pri_cert 
   WITH SUBJECT = 'Primary certificate';
GO


/* Create an endpoint */

CREATE ENDPOINT pri_endpoint
   STATE = STARTED
   AS TCP (
      LISTENER_PORT=8081
      , LISTENER_IP = ALL
   ) 
   FOR DATABASE_MIRRORING ( 
      AUTHENTICATION = CERTIFICATE pri_cert
      , ENCRYPTION = REQUIRED ALGORITHM AES
      , ROLE = ALL
   );
GO

/* Backup the certificate */

BACKUP CERTIFICATE pri_cert TO FILE = 'D:\Data\pri_cert.cer';
GO
