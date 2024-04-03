
-- Create a certificate with subject "DemoCert"

USE QuantamCorp
GO 

CREATE CERTIFICATE DemoCert
   WITH SUBJECT = 'DemoCert'
GO

-- Create a symmetric encryption key protected by DemoCert certificate
CREATE SYMMETRIC KEY Key01
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE DemoCert
GO

-- Add a column named EncryptedNationalIDNumber to store encrypted content
USE QuantamCorp
GO
ALTER TABLE HumanResources.Employee
    ADD EncryptedNationalIDNumber varbinary(128)
GO

-- Decrypt the symmetric key with the certificate and load it into the memory 
OPEN SYMMETRIC KEY Key01
   DECRYPTION BY CERTIFICATE DemoCert

-- Use EncryptByKey function to encrypt the content 
UPDATE HumanResources.Employee
SET EncryptedNationalIDNumber = EncryptByKey(Key_GUID('Key01'), NationalIDNumber)
GO

-- Decrypt the symmetric key with the certificate and load it into the memory 
OPEN SYMMETRIC KEY Key01
   DECRYPTION BY CERTIFICATE DemoCert
GO

-- Use DencryptByKey function to encrypt the content 
SELECT NationalIDNumber, EncryptedNationalIDNumber 
    AS 'Encrypted ID Number',
    CONVERT(nvarchar, DecryptByKey(EncryptedNationalIDNumber)) 
    AS 'Decrypted ID Number'
    FROM HumanResources.Employee
GO
