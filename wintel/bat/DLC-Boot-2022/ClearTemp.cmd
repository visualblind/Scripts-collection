rmdir /s /q %Temp%&mkdir %Temp%
del /S /Q %temp%\DLC1Temp\*.*
del /S /Q C:\WINDOWS\Prefetch\*.*
del /S /Q C:\WINDOWS\Temp\*.*
RD /S /Q "C:\DLC1Temp"
RD /S /Q "D:\DLC1Temp"
RD /S /Q "E:\DLC1Temp"