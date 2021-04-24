ls *.txt | rename-item -NewName { $_.name -replace "Old", "New" }

get-childitem *.txt | foreach { rename-item -LiteralPath $_ $_.Name.Replace("Old", "New") }
