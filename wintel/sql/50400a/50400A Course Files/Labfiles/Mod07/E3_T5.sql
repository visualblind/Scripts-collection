ALTER TABLE TestTable
ADD encrypted_content varbinary(1000); 
GO	

OPEN SYMMETRIC KEY Mod07_Key DECRYPTION BY CERTIFICATE Mod07_cert;

UPDATE TestTable
SET encrypted_content = EncryptByKey(Key_GUID('Mod07_Key'), content);
GO
