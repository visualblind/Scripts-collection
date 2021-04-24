#Value	Scope	Category
#2	Global	Distribution
#8	Universal	Distribution
#-2147483640	Universal	Security
#-2147483643	DomainLocal	Security
#-2147483644	DomainLocal	Security
#-2147483646	Global	Security

Get-ADGroup -Filter * -Properties GroupType | where {$_.GroupType -eq "-2147483644"} | FL nam


$searcher.filter = "(&(objectclass=group)(grouptype=-2147483644))"
$searcher | Convert-ADSearchResult | Out-Gridview

Get-ADGroup -Filter { GroupCategory -eq 'Security' } | Where { $_.Name -eq "Software" }