-- The following T-SQL statements will be run against on msdb system databaseon the monitor server
USE msdb;
GO

-- Find the secondary server
SELECT *
FROM [dbo].[log_shipping_monitor_secondary]
WHERE [secondary_server] = 'xx' AND [secondary_database] = 'xx';
GO
-- Delete the secondary server according the the result found on above
DELETE FROM [dbo].[log_shipping_monitor_secondary]
WHERE [secondary_id] = 'xx' AND [secondary_database] = 'xx';
GO

-- Find the primary server 
SELECT *
FROM [dbo].[log_shipping_monitor_primary]
WHERE [primary_server] = 'xx' AND [primary_database] = 'xx';
GO
-- Delete the priamry server according the the result found on above
DELETE FROM [dbo].[log_shipping_monitor_primary]
WHERE [primary_id]= 'xx' AND [primary_database]='xx';
GO