FOR /F "tokens=3 delims=#" %%B IN ('wmic partition get name ^| find /i "#%disk%,"') DO set partition=%%B
set /a partition=%partition%+0
set /a local=%partition%+1