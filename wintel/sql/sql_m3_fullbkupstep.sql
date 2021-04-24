DECLARE @ResultCode	INT

EXEC @ResultCode = [master].[dbo].[xp_ss_backup] 
	@database = N'Millennium', 
	@filename = N'\\192.168.1.106\m3\Backups\%instance%_%database%_%backuptype%_%timestamp% (%ordinal% of %total%).safe', 
	@overwrite = N'1', 
	@compressionlevel = N'ispeed', 
	@server = N'svr07ps', 
	@includelogins = N'1', 
	@mailto = N'OnSuccess',
	@mailto = N'OnError',
	@mailto = N'OnCancel',
	@mailto = N'OnSkip',
	@mailto = N'OnWarning',
	@mailto = N'netadmin@sentric.net'

IF(@ResultCode != 0)
	RAISERROR('One or more operations failed to complete.', 16, 1);

