#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

[string]$SampleGlobalVariable = "Sample Variable"

#--------------------------------------------
# Packager Command Line Parsing Functions
#--------------------------------------------

function Parse-Commandline
{
	Param([string]$CommandLine)
	
	$Arguments = New-Object System.Collections.Specialized.StringCollection
	#Find First Quote
	$index = $CommandLine.IndexOf('"')

	while ( $index -ne -1)
	{#Continue as along as we find a quote
	
		#Find Closing Quote
		$closeIndex = $CommandLine.IndexOf('"',$index + 1)
		
		if($closeIndex -eq -1)
		{ 
			break #Can't find a match
		}
		
		$value = $CommandLine.Substring($index + 1,$closeIndex - ($index + 1))
		
		[void]$Arguments.Add($value)
		$index = $closeIndex

		#Find First Quote
		$index = $CommandLine.IndexOf('"',$index + 1)
	}
	
	return $Arguments
}

function Convert-ArgumentsToDictionary
{
	Param([System.Collections.Specialized.StringCollection] $Params, [char] $ParamIndicator)
	
	$Dictionary = New-Object System.Collections.Specialized.StringDictionary
	
	for($index = 0; $index -lt $Params.Count; $index++)
	{
		[string]$param = $Params[$index]
		
		#Clear the values
		$key = ""
		$value = ""

		if($param.StartsWith($ParamIndicator))
		{
			#Remove the indicator
			$key = $param.Remove(0,1)
			
			if($index  + 1 -lt $Params.Count)
			{
				#Check if the next Argument is a parameter
				[string]$param = $Params[$index + 1]
				if($param.StartsWith($ParamIndicator) -ne $true )
				{
					#If it isn't a parameter then set it as the value
					$value = $param
					$index++
				}
			}
			
			$Dictionary[$key] = $value
		}#else skip
	}
		
	return $Dictionary
}

