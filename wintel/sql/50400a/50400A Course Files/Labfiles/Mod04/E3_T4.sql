/*Create a nonclustered index*/

CREATE NONCLUSTERED INDEX IX_CallDetailsHistory ON dbo.CallDetailsHistory
	(
	source_countrycode
	) 
ON [PRIMARY]


/*Delete the nonclustered index*/

DROP INDEX IX_CallDetailsHistory ON dbo.CallDetailsHistory
GO
CREATE NONCLUSTERED INDEX IX_CallDetailsHistory ON dbo.CallDetailsHistory
	(
	source_countrycode
	) INCLUDE (dest_countrycode)
ON [PRIMARY]
