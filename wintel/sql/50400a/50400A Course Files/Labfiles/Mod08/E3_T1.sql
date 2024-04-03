USE master
GO
DECLARE @RC int, @TraceID int, @on BIT
EXEC @rc = sp_trace_create @TraceID output, 0, N'D:\Data\Mod08_Trace'

SELECT RC = @RC, TraceID = @TraceID
SELECT @on = 1

EXEC sp_trace_setevent @TraceID, 10, 1, @on 
EXEC sp_trace_setevent @TraceID, 13, 11, @on 
EXEC sp_trace_setevent @TraceID, 13, 14, @on 
EXEC sp_trace_setevent @TraceID, 12, 15, @on 
EXEC sp_trace_setevent @TraceID, 13, 1, @on 

EXEC @RC = sp_trace_setstatus @TraceID, 1
GO
