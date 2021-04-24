@ECHO OFF

SET ROBOCOPY_FILE_NAME=robocopy.exe
SET ROBOCOPY_BASE_TEST_PATH=%WINDIR%\system32
SET ROBOCOPY_MASTER_COPY_PATH=\\192.168.1.10\robocopy
::%PROGRAMFILES%\Windows Resource Kits\Tools

SET ROBOCOPY_LOCAL_DIR=C:\ROBOCOPY

SET REMOTE_BACKUP_BASE_PATH=\\192.168.1.100\profiles
SET REMOTE_BACKUP_USER_PATH=%REMOTE_BACKUP_BASE_PATH%\%USERNAME%
SET REMOTE_BACKUP_USER_COMPUTER_PATH=%REMOTE_BACKUP_BASE_PATH%\%USERNAME%\%COMPUTERNAME%

::Robocopy exists in the System32 folder in both MS Vista and MS Windows 7.
IF EXIST "%ROBOCOPY_BASE_TEST_PATH%\%ROBOCOPY_FILE_NAME%" (
        SET ROBOCOPY_EXECUTABLE_FILE_PATH=%ROBOCOPY_BASE_TEST_PATH%\%ROBOCOPY_FILE_NAME%
) ELSE (
        ::Create the local directory for the Robocopy executable.
        MKDIR "%ROBOCOPY_LOCAL_DIR%"
       
        ::Copy the robocopy executable to the local directory.
        ::/y Suppresses prompting to confirm that you want to overwrite an existing destination file.
        COPY "%ROBOCOPY_MASTER_COPY_PATH%\%ROBOCOPY_FILE_NAME%" "%ROBOCOPY_LOCAL_DIR%\%ROBOCOPY_FILE_NAME%" /y
       
        SET ROBOCOPY_EXECUTABLE_FILE_PATH=%ROBOCOPY_LOCAL_DIR%\%ROBOCOPY_FILE_NAME%
)

ECHO Current Variables:
ECHO %ROBOCOPY_BASE_VISTA_PATH%
ECHO %REMOTE_BACKUP_BASE_PATH%
ECHO %REMOTE_BACKUP_USER_PATH%
ECHO %REMOTE_BACKUP_USER_COMPUTER_PATH%
ECHO "%ROBOCOPY_EXECUTABLE_FILE_PATH%"
ECHO "%USERPROFILE%"

::Create the remote profile backup directory for the current user.
MKDIR "%REMOTE_BACKUP_USER_PATH%"
::Create the remote profile backup directory for the current computer.
MKDIR "%REMOTE_BACKUP_USER_COMPUTER_PATH%"

::Execute robocopy to copy the user's profile folder contents to the remote storage location.
::/MIR :: MIRror a directory tree (equivalent to /E plus /PURGE).
::/R:n :: number of Retries on failed copies: default 1 million.
::/W:n :: Wait time between retries: default is 30 seconds.
::/XA:[RASHCNETO] :: eXclude files with any of the given Attributes set, e.g., S=System, H=Hidden.
::/XD dirs [dirs]... :: eXclude Directories matching given names/paths.
"%ROBOCOPY_EXECUTABLE_FILE_PATH%" "%USERPROFILE%" "%REMOTE_BACKUP_USER_COMPUTER_PATH%\" /MIR /R:1 /W:2 /XA:SH /XD *temp "temporary internet files" *cache mozilla