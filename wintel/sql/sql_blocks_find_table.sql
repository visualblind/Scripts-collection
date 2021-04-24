select distinct object_name(a.rsc_objid), a.req_spid, b.loginame
from master.dbo.syslockinfo a (nolock) join
master.dbo.sysprocesses b (nolock) on a.req_spid=b.spid
where object_name(a.rsc_objid) is not null

This script will show which table was locked, the process that locked the table and the login name used by the process. Once you find out which process is locking a table, you can issue a "kill" on that SPID. The offending process will be causing a lock on the syscolumns, syscomments, and sysobjects tables.