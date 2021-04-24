Set-Location C:\
Clear-Host

Get-Module -ListAvailable ActiveDirectory

# Create a new user
 # - By providing all of the new user data
 # Passwords are SecureString
 $Password = Read-Host -Prompt "Password" -AsSecureString 
 $Password = "FakePassword@12345" | ConvertTo-SecureString -AsPlainText -Force

 New-ADUser -Name "Mewtwo" -AccountPassword  $Password 
 
 # Other parameters: 
  # CannotChangePassword, ChangePasswordAtLogon, PasswordNotRequired, PasswordNeverExpires
  # Description, Title
  # UserPrincipalName, SamAccountName
  # Enabled ($True or $False)
  # Names:  GivenName, Initials (or OtherName), Surname
  # LogonWorkstations: Use a comma-separated list 
  # Path: The OU path to create the account
  # Server


# Get a list of users
Get-ADUser -Filter 'Name -like "Pika*"'
Get-ADUser -Identity "Pikachu"


# Change a user password 
$Password
$OldPassword = Read-Host "What's the old password?" -AsSecureString
Get-ADUser -Identity "Pikachu" | Set-ADAccountPassword -OldPassword $OldPassword -NewPassword $Password -ErrorAction SilentlyContinue
Set-ADAccountPassword -Identity "Pikachu" -NewPassword $Password -Reset
$error[0]

# Get a list of groups
Get-ADGroup -Identity "Pokemon"
$PokemonGroup = Get-ADGroup -Identity "Pokemon"


# Add a user to a group
$Mewtwo = Get-ADUser -Identity "Mewtwo"
$PokemonGroup | Add-ADGroupMember -Members $Mewtwo

# View all members of a group (with and without recursion)
$PokemonGroup | Get-ADGroupMember 
$ReadPermissions = Get-ADGroup -Identity "AppSourceRead"
$ReadPermissions | Get-ADGroupMember
$ReadPermissions | Get-ADGroupMember -Recursive

