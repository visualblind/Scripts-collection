dbcc sqlperf (logspace)

DECLARE @day VARCHAR(5)
DECLARE @month VARCHAR(15)
DECLARE @year VARCHAR(5)
DECLARE @hour VARCHAR(5)
DECLARE @minute VARCHAR(5)
DECLARE @filename VARCHAR(500)
SET @day = DATENAME(DAY, GETDATE())
SET @month = DATENAME(MONTH, GETDATE())
SET @year = DATENAME(YEAR, GETDATE())
SET @hour = DATENAME(HOUR, GETDATE())
SET @minute = DATENAME(MINUTE, GETDATE())
SET @filename = '\\192.168.1.106\m3\millennium-tlog\Millennium_log_' + @month + @day + @year + @hour + @minute + '.trn'
BACKUP LOG [Millennium] TO DISK = @filename

dbcc sqlperf (logspace)