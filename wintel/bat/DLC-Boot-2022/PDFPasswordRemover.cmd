@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\PDFPasswordRemover\PdfPasswordRemover.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\PDFPasswordRemover" -y files\PDFPasswordRemover.7z
start "" /D"%temp%\DLC1Temp\PDFPasswordRemover" "PdfPasswordRemover.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\PDFPasswordRemover" "PdfPasswordRemover.exe"