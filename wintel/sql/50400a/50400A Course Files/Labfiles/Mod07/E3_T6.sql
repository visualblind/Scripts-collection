SELECT ID, content, encrypted_content   AS 'Decrypted content'
FROM TestTable;
GO

OPEN SYMMETRIC KEY Mod07_Key
DECRYPTION BY CERTIFICATE Mod07_Cert;
GO

SELECT ID, content,
CONVERT(varchar, DecryptByKey(encrypted_content))    AS 'Decrypted content'
FROM TestTable;
