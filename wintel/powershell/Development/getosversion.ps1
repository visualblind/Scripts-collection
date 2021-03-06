function Get-OSArchitecture {            
[cmdletbinding()]            
param(            
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]            
    [string[]]$ComputerName = $env:computername                        
)            

begin {}            

process {            
$ComputerName = Get-ADComputer -SearchBase 'OU=Servers,OU=OrganizationalUnit1,dc=CompanyName,dc=com' -Filter 'ObjectClass -eq "Computer"' -Properties Name | Select -Expand Name
 foreach ($Computer in $ComputerName) {            
              
  if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) {            
   $OS  = (Get-WmiObject -computername $computer -class Win32_OperatingSystem ).Caption            
   if ((Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer -ea 0).OSArchitecture -eq '64-bit') {            
    $architecture = "64-Bit"            
   } else  {            
    $architecture = "32-Bit"            
   }            

#$Array += $computer, $architecture
   $OutputObj  = New-Object -Type PSObject            
   $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer            
   $OutputObj | Add-Member -MemberType NoteProperty -Name Architecture -Value $architecture            
   $OutputObj | Add-Member -MemberType NoteProperty -Name OperatingSystem -Value $OS            
   $OutputObj            
  }            
 }            
}            

end {}            

}

Get-OSArchitecture server1, server2, server3