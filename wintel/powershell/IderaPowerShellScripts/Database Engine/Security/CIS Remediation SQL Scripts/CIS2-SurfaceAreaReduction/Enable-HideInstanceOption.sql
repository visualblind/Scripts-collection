-- Enable Hide Instance Option
-- CIS 2.12 Check (Surface Area Reduction)

EXEC master..xp_instance_regwrite
	@rootkey = N'HKEY_LOCAL_MACHINE',
	@key = N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib',
	@value_name = N'HideInstance',
	@type = N'REG_DWORD',
	@value = 1;