set /p pw=Enter your new password:
cmdkey.exe /add:*ADDomain.com /user:ADDomain\Username /pass:%pw%