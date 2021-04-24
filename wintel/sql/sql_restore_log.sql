
restore log logshiptest from disk = 'c:\logshiptest\logshiptest_av01tsql1_norecovery.trn' with recovery

restore log Millennium from disk = 'e:\m3test_logship\m3test_av01tsql1_norecovery.trn' with norecovery

--restore multi-log trn file
RESTORE LOG Millennium FROM DISK = 'E:\logship\Millennium_log_November262012230.trn' WITH NORECOVERY, FILE = 2