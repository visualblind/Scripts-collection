/* Create a schema */

USE QuantamCorp
GO
CREATE SCHEMA DemoSchema

/* Create a table and assign it to the new schema that you created */


USE QuantamCorp
GO
CREATE TABLE DemoSchema.DemoTable (ID int, Name varchar (50));

/* Retrieve all records from DemoSchema.DemoTable */

USE QuantamCorp
GO
SELECT * FROM DemoSchema.DemoTable;
