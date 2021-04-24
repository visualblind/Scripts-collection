SELECT *
FROM [SQLsafeRepository].[dbo].[policies_stats]
Where last_failure is NOT NULL


update [SQLsafeRepository].[dbo].[policies_stats] set utc_offset ='-5' where utc_offset ='-4' and last_failure is NOT NULL

update [SQLsafeRepository].[dbo].[policies_stats] set last_status ='2' where last_failure is not NULL

update [SQLsafeRepository].[dbo].[policies_stats] set last_failure = NULL where last_failure is not NULL