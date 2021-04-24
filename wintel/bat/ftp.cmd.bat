echo off
REM COPYRIGHT 2009 company Corporation. All Rights Reserved.
REM
REM
REM The purpose of this program is to transfer files from
REM a company Corporation client's computer to a
REM company Corporation owned computer through the File Transfer
REM Protocol.


REM These are the parameters that must be changed by
REM the support providing person.


SET clientdir="C:\import"
SET username=user	
SET password=pw


REM Neither of these two settings are expected to be changed
REM even by the person who is doing customer support.
SET ftp_server=ftp.company.net
SET cmd_file=c:\company_ftp_support_commands.txt

REM This section writes the FTP commands that are used to transfer
REM files to the company's FTP server.

DEL %cmd_file%

ECHO user >> %cmd_file%
REM It is quite interesting that examples on the internet
REM which show the use of -s with Microsoft's FTP client
REM do not seem to work with respect to specifying the password
REM for a given user.  Here, the user name and password is specified
REM on the same line within the command file.  The web examples all
REM seem to specify that the username and password should be on separate
REM lines.  In testing it is found that only having them on the same
REM line works.
ECHO %username% %password% >> %cmd_file%
ECHO lcd %clientdir% >> %cmd_file%
ECHO bin >> %cmd_file%
ECHO mput * >> %cmd_file%
ECHO quit >> %cmd_file%


ftp -n -i -s:%cmd_file% %ftp_server%

REM DEL %cmd_file%

