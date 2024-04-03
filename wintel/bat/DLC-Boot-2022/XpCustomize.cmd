REM You can edit this file to customize Mini Xp. Remove REM from the line to make it functional.
@echo off

REM AUTO LAUNCH
start "" /D"%DLC1%\DLC1\Programs" "AutoMountDrives.cmd"

REM DLC Command Line
nircmd shortcut hiderun.exe "~$folder.desktop$" "Mouse Emulator" "%DLC1%\DLC1\Programs\MouseEmulatorD.cmd" "%DLC1%\DLC1\Programs\Icon\MouseEmulator.ico"
nircmd shortcut hiderun.exe "~$folder.desktop$" "Acronis True Image 2013" "%DLC1%\DLC1\Programs\1AcronisTrueImageHome.cmd" "%DLC1%\DLC1\Programs\Icon\AcronisTrueImageHome.ico"
nircmd shortcut hiderun.exe "~$folder.desktop$" "Norton Ghost" "%DLC1%\DLC1\Programs\Ghost32.cmd" "%DLC1%\DLC1\Programs\Icon\NortonGhost.ico"
nircmd shortcut hiderun.exe "~$folder.desktop$" "Partition Wizard" "%DLC1%\DLC1\Programs\Partitionwizard.cmd" "%DLC1%\DLC1\Programs\Icon\PartitionWizard.ico"
start "" /D"%SystemRoot%\System32" "penetwork.exe"
nircmd waitprocess penetwork.exe
start "" /D"%DLC1%\DLC1\Programs" "VNCServer.cmd"
exit