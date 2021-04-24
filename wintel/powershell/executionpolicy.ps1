Set-ExecutionPolicy
   [-ExecutionPolicy] <ExecutionPolicy>
   [[-Scope] <ExecutionPolicyScope>]
   [-Force]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]

Get-ExecutionPolicy -List
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Undefined
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Undefined
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Invoke-Command -ComputerName "Server01" -ScriptBlock {Get-ExecutionPolicy} | Set-ExecutionPolicy -Force

#Unblock a script to run it without changing the execution policy
The first command uses the **Set-ExecutionPolicy** cmdlet to change the execution policy to RemoteSigned.
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

The second command uses the Get-ExecutionPolicy cmdlet to get the effective execution policy in the session. The output shows that it is RemoteSigned.
Get-ExecutionPolicy
RemoteSigned

The third command shows what happens when you run a blocked script in a Windows PowerShell session in which the execution policy is RemoteSigned. The RemoteSigned policy prevents you from running scripts that are downloaded from the Internet unless they are digitally signed.
.\Start-ActivityTracker.ps1
.\Start-ActivityTracker.ps1 : File .\Start-ActivityTracker.ps1 cannot be loaded. The file .\Start-ActivityTracker.ps1 
is not digitally signed. The script will not execute on the system. For more information, see about_Execution_Policies 
at http://go.microsoft.com/fwlink/?LinkID=135170. 
At line:1 char:1
+ .\Start-ActivityTracker.ps1
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ CategoryInfo          : NotSpecified: (:) [], PSSecurityException
+ FullyQualifiedErrorId : UnauthorizedAccess

The fourth command uses the Unblock-File cmdlet to unblock the script so it can run in the session.Before running an **Unblock-File** command, read the script contents and verify that it is safe.
PS C:\> Unblock-File -Path "Start-ActivityTracker.ps1"

The fifth and sixth commands show the effect of the **Unblock-File** command. The **Unblock-File** command does not change the execution policy. However, it unblocks the script so it will run in Windows PowerShell.
PS C:\> Get-ExecutionPolicy
RemoteSigned
PS C:\> Start-ActivityTracker.ps1
Task 1: