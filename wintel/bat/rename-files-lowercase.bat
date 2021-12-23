@ECHO ON

for /f "Tokens=*" %f in ('dir /l/b/a-d') do (rename "%f" "%f")

REM Rename All Lowercase

for /f "Tokens=*" %f in ('dir /l/b/a') do (rename "%f" "%f")