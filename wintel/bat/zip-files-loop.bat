@ECHO ON

SET SourceDir=E:\Games\roms\snes
SET DestDir=D:\ROMS\SNES\dest

CD /D "C:\Program Files\7-Zip"
FOR /F "TOKENS=*" %%F IN ('DIR /B /A-D "%SourceDir%"') DO (
    7z.exe a "%DestDir%\%%~NF.zip" "%SourceDir%\%%~NXF"
)
EXIT