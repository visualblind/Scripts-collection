/* Create an encryption key */

USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO 

/* Create a certiifcate */

USE master;
CREATE CERTIFICATE witness_cert 
   WITH SUBJECT = 'Witness certificate';
GO

/* Create an endpoint */

CREATE ENDPOINT witness_endpoint
   STATE = STARTED
   AS TCP (
      LISTENER_PORT=8083
      , LISTENER_IP = ALL
   ) 
   FOR DATABASE_MIRRORING ( 
      AUTHENTICATION = CERTIFICATE witness_cert
      , ENCRYPTION = REQUIRED ALGORITHM AES
      , ROLE = WITNESS
   );
GO

/* Backup the certificate */

BACKUP CERTIFICATE witness_cert TO FILE = 'D:\Data\witness_cert.cer';
GO
