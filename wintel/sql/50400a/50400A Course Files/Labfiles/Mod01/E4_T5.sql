INSERT INTO FILESTREAM_Test.dbo.Records
    VALUES (newid (), 1, NULL);
GO

INSERT INTO FILESTREAM_Test.dbo.Records
    VALUES (newid (), 2, 
      CAST ('' as varbinary(max)));
GO

INSERT INTO FILESTREAM_Test.dbo.Records
    VALUES (newid (), 3, 
      CAST (1 as varbinary(max)));
GO
SELECT *  FROM FILESTREAM_Test.dbo.Records
