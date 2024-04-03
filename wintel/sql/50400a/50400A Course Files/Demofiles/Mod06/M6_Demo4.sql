USE msdb ;
GO
EXEC dbo.sp_add_job
    @job_name = N'NightlyBackups' ;
GO

EXEC sp_add_jobstep
    @job_name = N'NightlyBackups',
    @step_name = N'Set database to read only',
    @subsystem = N'TSQL',
    @command = N'ALTER DATABASE SALES SET READ_ONLY', 
    @retry_attempts = 5,
    @retry_interval = 5 ;
GO
EXEC sp_add_schedule
    @schedule_name = N'NightlyJob' ,
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 010000 ;
GO


EXEC sp_attach_schedule
   @job_name = N'NightlyBackups',
   @schedule_name = N'NightlyJob' ;
GO


EXEC dbo.sp_add_jobserver
    @job_name = N'NightlyBackups',
    @server_name = N'NYC-SQL1\Development' ;
GO
EXEC dbo.sp_add_jobserver
    @job_name = N'NightlyBackups',
    @server_name = N'NYC-SQL1\INSTANCE3' ;
    
    


