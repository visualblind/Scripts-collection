@echo off
CD C:\Users\visualblind
REM robocopy C:\Users\visualblind\aws C:\Users\visualblind\OneDrive\visualblind\.aws  /e /mir /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
robocopy C:\Users\visualblind\.thinkorswim C:\Users\visualblind\OneDrive\visualblind\.thinkorswim /e /COPYALL /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
robocopy C:\Users\visualblind\.ssh C:\Users\visualblind\OneDrive\visualblind\.ssh /e /COPYALL /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
robocopy C:\Users\visualblind\ssl C:\Users\visualblind\OneDrive\visualblind\ssl /e /COPYALL /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
robocopy C:\Users\visualblind\Desktop C:\Users\visualblind\OneDrive\visualblind\Desktop /e /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
robocopy C:\Users\visualblind\Documents C:\Users\visualblind\OneDrive\visualblind\Documents /e /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
robocopy C:\Users\visualblind\Downloads C:\Users\visualblind\OneDrive\visualblind\Downloads /e /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
REM robocopy C:\Users\visualblind\github C:\Users\visualblind\OneDrive\visualblind\github /e /mir /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
robocopy C:\Users\visualblind\Pictures C:\Users\visualblind\OneDrive\visualblind\Pictures /e /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
REM robocopy C:\Users\visualblind\Music C:\Users\visualblind\OneDrive\visualblind\Music /e /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
REM robocopy D:\drivers C:\Users\visualblind\OneDrive\drivers /e /COPYALL /mir /XO /np /tee /log+:C:\Users\visualblind\Documents\Scripts\backup_log.txt
REM robocopy C:\torrent-downloads F:\torrent-downloads /E /COPYALL /XO /MOVE
REM robocopy F:\software F:\OneDrive2\OneDrive\software /E /COPYALL /XO
EXIT