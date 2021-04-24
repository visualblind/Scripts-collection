#Get the directories / sub directories and rename to lowercase
Get-ChildItem -Path "path" -recurse| ?{ $_.PSIsContainer -And $_.Name -CMatch "[A-Z]" } | %{
$NName = $_.Name.ToLower()

#Set temporary name to enable rename to the same name; Windows is not case sensitive
$TempItem = Rename-Item -Path $_.FullName -NewName "x$NName" -PassThru
Rename-Item -Path $TempItem.FullName -NewName $NName
}

# Get the files and rename to lowercase
Get-ChildItem -Path "path" -recurse| % { if (!($_.PSIsContainer) -And $_.Name -cne $_.Name.ToLower()) { Rename-Item $_.FullName $_.Name.ToLower() } }

# Get the files and rename to uppercase
Get-ChildItem -Path "path" -recurse| % { if (!($_.PSIsContainer) -And $_.Name -cne $_.Name.ToUpper()) { Rename-Item $_.FullName $_.Name.ToUpper() } }

# Get the directories and rename to lowercase
# This does not work, use script above
Get-ChildItem -Path "path" -recurse| % { if (($_.PSIsContainer) -And $_.Name -cne $_.Name.ToLower()) { Rename-Item $_.FullName $_.Name.ToLower() } }

# Rename all files recursively to lowercase
Get-ChildItem "C:\path\to\folder" -recurse | 
  Where {-Not $_.PSIsContainer} | 
  Rename-Item -NewName {$_.FullName.ToLower()}