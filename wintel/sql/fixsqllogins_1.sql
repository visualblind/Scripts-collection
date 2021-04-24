/* First, make sure that this is the problem. This will lists the orphaned users: */
EXEC sp_change_users_login 'Report'

/* If you already have a login id and password for this user, fix it by doing: */
EXEC sp_change_users_login 'Auto_Fix', 'vendy'
EXEC sp_change_users_login 'Auto_Fix', 'bkleinhample'
EXEC sp_change_users_login 'Auto_Fix', 'dignaski'
EXEC sp_change_users_login 'Auto_Fix', 'pmeyer'
EXEC sp_change_users_login 'Auto_Fix', 'sritz'



/* If you want to create a new login id and password for this user, fix it by doing: */
EXEC sp_change_users_login 'Auto_Fix', 'user', 'login', 'password'
