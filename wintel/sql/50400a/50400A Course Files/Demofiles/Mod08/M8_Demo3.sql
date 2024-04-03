/* Create and configure a trace */

USE master
GO
DECLARE @RC int, @TraceID int, @on BIT
EXEC @rc = sp_trace_create @TraceID output, 0, N'D:\Demofiles\Demo_Trace'

-- Select the return code to verify if the trace creation was successful.
SELECT RC = @RC, TraceID = @TraceID

-- Set the events and the data columns that you need to capture.
SELECT @on = 1

EXEC sp_trace_setevent @TraceID, 10, 1, @on 
EXEC sp_trace_setevent @TraceID, 13, 11, @on 
EXEC sp_trace_setevent @TraceID, 13, 14, @on 
EXEC sp_trace_setevent @TraceID, 12, 15, @on 
EXEC sp_trace_setevent @TraceID, 13, 1, @on 


EXEC @RC = sp_trace_setstatus @TraceID, 1
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Generate a workload */

USE QuantamCorp
GO
SELECT * FROM Production.ProductDescription

----------------------------------------------------------------------------------------------------------------------------------------------

/* Capture the workload */

DECLARE @TraceID int
SELECT  @TraceID = TraceID FROM ::fn_trace_getinfo(default) WHERE VALUE = N'D:\Demofiles\Demo_Trace.trc'
EXEC sp_trace_setstatus @TraceID, 0

EXEC sp_trace_setstatus @TraceID, 2

