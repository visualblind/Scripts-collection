@echo off
C:
IF EXIST c:\windows\temp\CleanAutoCompleteCache GOTO END
mkdir c:\windows\temp\CleanAutoCompleteCache
"%programfiles%\Microsoft Office\Office14\Outlook.exe" /CleanAutoCompleteCache /Recycle
echo %computername% - %username% >> \\av01file1\sfreg$\autocomplete.txt
:END
EXIT




