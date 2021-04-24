This will show you the longest running SPIDs on a SQL 2000 server:

select
    p.spid
,   right(convert(varchar, 
            dateadd(ms, datediff(ms, P.last_batch, getdate()), '1900-01-01'), 
            121), 12) as 'batch_duration'
,   P.program_name
,   P.hostname
,   P.loginame
from master.dbo.sysprocesses P
where P.spid > 50
and      P.status not in ('background', 'sleeping')
and      P.cmd not in ('AWAITING COMMAND'
                    ,'MIRROR HANDLER'
                    ,'LAZY WRITER'
                    ,'CHECKPOINT SLEEP'
                    ,'RA MANAGER')
order by batch_duration desc

If you need to see the SQL running for a given spid from the results, use something like this:

declare
    @spid int
,   @stmt_start int
,   @stmt_end int
,   @sql_handle binary(20)

set @spid = XXX -- Fill this in

select  top 1
    @sql_handle = sql_handle
,   @stmt_start = case stmt_start when 0 then 0 else stmt_start / 2 end
,   @stmt_end = case stmt_end when -1 then -1 else stmt_end / 2 end
from    master.dbo.sysprocesses
where   spid = @spid
order by ecid

SELECT
    SUBSTRING(	text,
    		COALESCE(NULLIF(@stmt_start, 0), 1),
    		CASE @stmt_end
    			WHEN -1
    				THEN DATALENGTH(text)
    			ELSE
    				(@stmt_end - @stmt_start)
    			END
    	)
FROM ::fn_get_sql(@sql_handle)