-- Creates a database key
USE QuantamCorp
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd' 
GO
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd' 
GO

-- Creates a certificate 
CREATE CERTIFICATE MyCert 

   WITH SUBJECT = 'Demo Cert', 
   EXPIRY_DATE = '10/31/2050'
GO
USE QuantamCorp
GO

-- Creates an encryption key
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyCert
GO

-- Creates an asymmetric key 
CREATE ASYMMETRIC KEY PacificSales09 
    WITH ALGORITHM = RSA_2048 
    ENCRYPTION BY PASSWORD = 'Pa$$w0rd'
GO

-- Create symmetric key
Use master;
CREATE SYMMETRIC KEY JanainaKey09 WITH ALGORITHM = AES_256    ENCRYPTION BY CERTIFICATE MyCert
GO
