USE Millennium

/** Change shared directory path **/
UPDATE SPath SET path = '\\SI04TSQL1\Millennium\Reports' WHERE name = 'Reports'
UPDATE SPath SET path = '\\SI04TSQL1\Millennium\TaxForms' WHERE name = 'TaxForms'
UPDATE SPath SET path = '\\SI04TSQL1\Millennium\Temp' WHERE name = 'Temp'
UPDATE SPath SET path = '\\SI04TSQL1\Millennium\Archive' WHERE name = 'Archive'
UPDATE SPath SET path = '\\SI04TSQL1\Millennium\SaveSimply' WHERE name = 'SaveSimply'
UPDATE SPath SET path = '\\SI04TSQL1\Millennium\StoreRoom' WHERE name = 'StoreRoom'
UPDATE SPath SET path = '\\SI04TSQL1\Millennium\Temp' WHERE name = 'ACH'
UPDATE SPath SET path = '\\SI04TSQL1\Millennium\Temp' WHERE name = 'EFile'

/** Disable synchronization **/
UPDATE SSyncDBInfo SET hostname = '', port = 0 WHERE description = 'MPI Software'

DELETE FROM SSyncDBInfo WHERE description <> 'MPI Software'

/** Delete all scheduled jobs **/
DELETE FROM SJobSchedule

/** Convert users to Admin users **/
UPDATE SUsers
    SET roleCode = 'Admin' WHERE roleCode LIKE 'PS_Tech%' OR
          roleCode LIKE 'PS_Op%' OR roleCode LIKE 'PS_Adm%' OR roleCode LIKE 'PS_Man%' OR
          roleCode LIKE 'PS_Dev%' OR roleCode LIKE 'OC_%' OR roleCode LIKE 'PS_C%'

/** Disable ACH **/
UPDATE SAchSetup SET filepath = '\\SI04TSQL1\Millennium\Ach' WHERE filepath <> ''

/** Grant the Millennium SQL Login access to the database **/
EXEC sp_grantdbaccess 'Millennium'

/** Reset the Admin password to Admin for test environment **/
UPDATE SUsers SET password='a8c823efc7b1c25fa774c1c97af44f22' WHERE userName='Admin'

UPDATE SUsers SET password='cc4d596c3dc7972f977f08aadbbc7314' WHERE userName='iVantageAdmin' 

UPDATE sUsers SET mustChangePW='0' WHERE username IN ('Admin','iVantageAdmin')

GO
EXEC sp_addrolemember N'db_owner', N'Millennium'
GO
