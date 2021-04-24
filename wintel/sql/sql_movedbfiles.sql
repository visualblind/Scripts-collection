alter database SI_SGR set offline with rollback immediate
alter database SI_CTech set offline with rollback immediate

ALTER DATABASE SI_SGR
  MODIFY FILE ( name=SI_SGR_log, 
                filename=N'E:\Logs\SI_SGR_log.ldf'
              )

ALTER DATABASE SI_SGR
  MODIFY FILE ( name=SI_SGR, 
                filename=N'D:\Data\SI_SGR.mdf'
              )
Alter database SI_SGR set online



ALTER DATABASE SI_CTech
  MODIFY FILE ( name=SI_Ctech_log, 
                filename=N'E:\Logs\SI_CTech_log.ldf'
              )

ALTER DATABASE SI_CTech
  MODIFY FILE ( name=SI_CTech, 
                filename=N'D:\Data\SI_CTech.mdf'
              )

alter database SI_SGR set online
alter database SI_CTech set online