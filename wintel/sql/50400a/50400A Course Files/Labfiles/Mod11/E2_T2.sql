/* Create an encryption key */

USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO 


/* Create a certificate */

USE master;
CREATE CERTIFICATE sb_cert 
   WITH SUBJECT = 'Standby certificate';
GO


/* Create an endpoint */

CREATE ENDPOINT sb_endpoint
   STATE = STARTED
   AS TCP (
      LISTENER_PORT=8082
      , LISTENER_IP = ALL
   ) 
   FOR DATABASE_MIRRORING ( 
      AUTHENTICATION = CERTIFICATE sb_cert
      , ENCRYPTION = REQUIRED ALGORITHM AES
      , ROLE = ALL
   );
GO


/* Backup the certificate */

BACKUP CERTIFICATE sb_cert TO FILE = 'D:\Data\sb_cert.cer';
GO
