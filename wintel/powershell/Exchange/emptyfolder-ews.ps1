#===================================================================================================
#Author = Sunil Chauhan
#Email= Sunilkms@gmail.com
#Blogs=Sunil.chauhan.blogspot.com
#=====================================================================================================
# this Script can be useful to Quickly Empty a specific Folder in user mailbox
# can also delete subfolder under a specific folder.
#Usage Example:
#Empty Junk Email Folder From user Mailbox "Testuser@xzy.com"
#>.\EmptyFolder-Ews.ps1 -Mailbox "Testuser@xzy.com" -folder "Junk Email" -admin "admin@xyz.com" -pass "adminpass"

#Empty Junk Email Folder as well as folders under Junk Email From user Mailbox "Testuser@xzy.com"
#>.\EmptyFolder-Ews.ps1 -Mailbox "Testuser@xzy.com" -folder "Junk Email" -DeleteSubFolders $true -admin "admin@xyz.com" -pass "adminpass"
#=====================================================================================================

param (
	$Mailbox
	$folder
	$DeleteSubFolders
	$admin
	$pass
)

#Impersonate Admin Account details
$AccountWithImpersonationRights = $admin
$password = $pass

#folder which you wants to empty from user mailbox
$FolderToEmpty = $folder

#EWS url for your orgnization
$uri = [system.URI] "https://outlook.office365.com/ews/exchange.asmx"
#define EWS Dll file Path
$dllpath = "C:\Program Files\Microsoft\Exchange\Web Services\2.0\Microsoft.Exchange.WebServices.dll"
Import-Module $dllpath
#-------------------------------------------------------------------------------------
## Set Exchange Version
$ExchangeVersion = [Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2010_SP2
$service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService($ExchangeVersion)
$service.Credentials = New-Object Microsoft.Exchange.WebServices.Data.WebCredentials -ArgumentList `
								  $AccountWithImpersonationRights, $password
$service.url = $uri

$service.ImpersonatedUserId = New-Object Microsoft.Exchange.WebServices.Data.ImpersonatedUserId `
([Microsoft.Exchange.WebServices.Data.ConnectingIdType]::SMTPAddress, $Mailbox);

#Connect to the Inbox
$MailboxRootid = new-object Microsoft.Exchange.WebServices.Data.FolderId `
([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::MsgFolderRoot, $Mailbox)
$MailboxRoot = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($service, $MailboxRootid)

#Getting Folders in the Mailbox
# you can change to folder view if there are more them 100 folder in the mailbox
$FolderList = new-object Microsoft.Exchange.WebServices.Data.FolderView(100)
$FolderList.Traversal = [Microsoft.Exchange.WebServices.Data.FolderTraversal]::Deep
$findFolderResults = $MailboxRoot.FindFolders($FolderList)

#identifying Source Folder
$FoldertoemptyID = $findFolderResults | ? { $_.DisplayName -match $Foldertoempty }

If ($FoldertoemptyID.TotalCount -eq 0)
{
	Write-host "There were no email Found in the folder:" $FoldertoemptyID.DisplayName
}
else
{
	Write-host "Item will be deleted from folder:" $FoldertoemptyID.DisplayName
	Write-host "No of Items in Folder:"$FoldertoEmptyID.TotalCount
	Read-host "Hit enter to Remove all the items..."
	$FoldertoemptyID.Empty([Microsoft.Exchange.WebServices.Data.DeleteMode]::SoftDelete, $False)
	#$FoldertoemptyID.Empty([Microsoft.Exchange.WebServices.Data.DeleteMode]::HardDelete,$True)
	"Done"
}
if ($deleteSubFolders)
{
	""
	Write-host "All the subfolder and there item will be pruged under Folder:"$FoldertoemptyID.DisplayName -f yellow
	Read-host "Hit enter to Remove all the items..."
	$FoldertoemptyID.Empty([Microsoft.Exchange.WebServices.Data.DeleteMode]::SoftDelete, $True)
	#$FoldertoemptyID.Empty([Microsoft.Exchange.WebServices.Data.DeleteMode]::HardDelete,$True)
	"Done"
}
 