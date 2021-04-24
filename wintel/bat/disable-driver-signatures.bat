:: Put Windows in Test mode
bcdedit /set TESTSIGNING OFF

:: Disable Windows Test mode
bcdedit /set TESTSIGNING ON

:: Disable driver signature enforcement Windows 10 permanently
bcdedit /set NOINTEGRITYCHECKS ON

:: Enable driver signature enforcement back again
bcdedit /set NOINTEGRITYCHECKS OFF