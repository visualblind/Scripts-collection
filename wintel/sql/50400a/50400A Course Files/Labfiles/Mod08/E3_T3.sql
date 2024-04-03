DECLARE @TraceID int
SELECT  @TraceID = TraceID FROM ::fn_trace_getinfo(default) WHERE VALUE = N'D:\Data\Mod08_Trace.trc'
EXEC sp_trace_setstatus @TraceID, 0

EXEC sp_trace_setstatus @TraceID, 2
