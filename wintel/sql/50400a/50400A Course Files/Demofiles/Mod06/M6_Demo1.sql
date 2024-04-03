/* Create an account credential */

CREATE CREDENTIAL DemoUser WITH IDENTITY = 'NYC-SQL1\Administrator', 
    SECRET = 'Pa$$w0rd';
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create an account proxy */

USE msdb
GO
EXEC dbo.sp_add_proxy
    @proxy_name = 'DemoUser',
    @enabled = 1,
    @description = 'Maintenance tasks on catalog application.',
    @credential_name = 'DemoUser' ;
GO
EXEC dbo.sp_grant_proxy_to_subsystem @proxy_name=N'DemoUser', @subsystem_id=3
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a job */

USE msdb
GO
EXEC dbo.sp_add_job
    @job_name = N'NightlyBackup' ;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create one or more job steps */

USE msdb
GO
EXEC sp_add_jobstep
    @job_name = N'NightlyBackup',
    @step_name = N'Backup QuantamCorp',
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'sqlcmd -E -q "BACKUP QuantamCorp TO DISK=''D:\Demofiles\QuantamCorp.bak''"', 
		@database_name=N'master', 
		@flags=0, 
		@proxy_name=N'DemoUser'
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a schedule */

USE msdb
GO
EXEC sp_add_schedule
    @schedule_name = N'NightlyJobs' ,
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 010000 ;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Attach a schedule to the job */

USE msdb
GO
EXEC sp_attach_schedule
   @job_name = N'NightlyBackup',
   @schedule_name = N'NightlyJobs' ;
GO

--------------------------------------------------------------------------------------------------------------------------------------------