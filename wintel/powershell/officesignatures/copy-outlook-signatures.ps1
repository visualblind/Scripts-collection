<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.155
	 Created on:   	11/29/2018 12:46 AM
	 Created by:   	visualblind
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


mkdir %appdata%\microsoft\signatures\
Remove-Item %appdata%\microsoft\signatures\*.* /y
Copy-Item \\albert\sigs\%USERNAME%.htm %appdata%\microsoft\signatures /y
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Mail\ /v EditorPreference /t REG_DWORD /d 131072 /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common\MailSettings\ /v NewSignature /t REG_EXPAND_SZ /d %USERNAME% /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\14.0\Common\MailSettings\ /v NewSignature /t REG_EXPAND_SZ /d %USERNAME% /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common\MailSettings\ /v ReplySignature /t REG_EXPAND_SZ /d %USERNAME% /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\14.0\Common\MailSettings\ /v ReplySignature /t REG_EXPAND_SZ /d %USERNAME% /f