/* Retrieve the address fields from the Person.Address table */

USE QuantamCorp
GO
SELECT AddressLine1, AddressLine2, City, StateProvinceID, PostalCode
FROM Person.Address
WHERE PostalCode BETWEEN N'98000' and N'99999';
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Drop the IX_Address_PostalCode index, if it exists and then create it */

USE QuantamCorp;
GO
IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IX_Address_PostalCode')
    DROP INDEX IX_Address_PostalCode ON Person.Address;
GO
CREATE NONCLUSTERED INDEX IX_Address_PostalCode
    ON Person.Address (PostalCode)
    INCLUDE (AddressLine1, AddressLine2, City, StateProvinceID);
GO

--------------------------------------------------------------------------------------------------------------------------------------------

