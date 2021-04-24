$ServerName = Get-Content -Path "$env:SystemDrive\physical-servers.txt"  
  
foreach ($Server in $ServerName) {  
  
				if (test-Connection -ComputerName $Server -Count 2 -Quiet ) {   
						('{0} is Pinging' -f $Server)
										} else
										{('{0} not pinging' -f $Server)  
										} 
} 