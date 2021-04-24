-- Script for SelectTopNRows command from SSMS
SELECT *
  FROM [DBName].[dbo].[SJob] where jobclass = 'SyncDown' AND props LIKE '%CompanyName%' AND queuedTime >= Convert(datetime, '2013-08-01')
  ORDER BY queuedTime

-- Script for SelectTopNRows command from SSMS
Declare @MinutesRunning datetime

SELECT queuedTime, startTime, completeTime, jobclass, queuedMachine, siteMachine, co, props, state, DATEDIFF(minute,startTime, completeTime) AS MinutesRunning
FROM [DBName].[dbo].[SJob] where queuedTime >= Convert(datetime,'2013-09-10 18:00:00')