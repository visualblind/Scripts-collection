@echo off
C:
IF EXIST c:\windows\temp\CleanAutoCompleteCache GOTO END
mkdir c:\windows\temp\CleanAutoCompleteCache
"%programfiles%\Microsoft Office\Office14\Outlook.exe" /CleanAutoCompleteCache /Recycle
echo %computername% - %username% >> \\FileServer\hiddenshare$\autocomplete.txt
:END
EXIT




