<?php
// --------------------------------------------
// | The EP-Dev Whois script        
// |                                           
// | Copyright (c) 2003-2005 EP-Dev.com :           
// | This program is distributed as free       
// | software under the GNU General Public     
// | License as published by the Free Software 
// | Foundation. You may freely redistribute     
// | and/or modify this program.               
// |                                           
// --------------------------------------------


/* ------------------------------------------------------------------ */
//	EP-Dev Whois Admin Variable Format Class
//	Contains all functions used in generating the format of configuration
//	data that can later be used in search, replace, deletion, and addition
//	functions of the admin panel.
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_Admin_Variable_Format
{
	var $ERROR;

	var $format;

	var $var_error;

	function EP_Dev_Whois_Admin_Variable_Format(&$error_handle)
	{
		$this->ERROR = $error_handle;


		// setup types
		$this->format['boolean'] = "^(true|false)$";
		$this->format['integer'] = "^[0-9]+$";
		$this->format['string'] = ""; // ^[^;\n]*$
		$this->format['array'] = "";

		// setup type errors
		$this->var_error['boolean'] = " value should be true or false.";
		$this->var_error['integer'] = " value should be a number.";
		$this->var_error['string'] = " value should be a string.";
		$this->var_error['array'] = " value should be in format of single number (such as 1) or multiple numbers (such as 1, 2, 3)";
	}


	/* ------------------------------------------------------------------ */
	//	Convert Variable to String Format
	//
	//	Variable is any variable of the script, such as $my_variable
	//
	//	A custom rule can be given via $rule:
	//	['rule'] = regexp
	//	['error'] = "TEXT ERROR"
	//	['type'] = "type, such as string";
	//
	//	A custom format can be given via $special, will replace [[value]]
	//	with formatted value.
	//
	//	$value = mixed var
	//	$keys = array
	//	$array_type = string
	//	$special = String of irregular search / replace format
	/* ------------------------------------------------------------------ */

	function convertVarToString($value, $keys, $array_type, $rule=NULL, $special=NULL)
	{
		// debug
		//echo "processing varToString value '{$value}' with rule '{$rule}'\n"; var_dump($keys); echo "\n";

		// assign final key to $key
		if (!empty($keys))
			$key = $keys[count($keys)-1];
		else
			$key = "";

		// Get rule if no rule specified.
		if (empty($rule))
			$rule = $this->discoverVarType($value, $key);
		else
			$rule = $this->getRule($rule, $key);

		// +------------------------------
		//	Format variables into output
		// +------------------------------

		switch($rule['type'])
		{
			// array
			case "array" :
				// format into array format
				$new_value = "array(" . implode(", ", $value) . ")";
			break;

			// integer
			case "integer" :
				$new_value = (string) $value;
			break;

			// boolean
			case "boolean" :
				$new_value = ($value ? "true" : "false");
			break;

			// string
			case "string" :
				$new_value = trim("\"". str_replace("\'", "'", addslashes($value)) ."\"");
			break;

			// otherwise, construct as string
			default :
				$new_value = trim("\"". str_replace("\'", "'", addslashes($value)) ."\"");
		}

		// debug
		//echo "finished process\n\n";

		return $this->format($new_value, $keys, $array_type, $rule, $special);
	}

	/* ------------------------------------------------------------------ */
	//	Convert Data to String Format
	//
	//	Data, for example, would be any general string.
	//
	//	A custom rule can be given via $rule:
	//	['rule'] = regexp
	//	['error'] = "TEXT ERROR"
	//	['type'] = "type, such as string";
	//
	//	A custom format can be given via $special, will replace [[value]]
	//	with formatted value.
	//
	//	$value = mixed var
	//	$keys = array
	//	$array_type = string
	//	$special = String of irregular search / replace format
	/* ------------------------------------------------------------------ */

	function convertDataToString($value, $keys, $array_type, $rule=NULL, $special=NULL)
	{
		// debug
		//echo "processing DataToString value '{$value}' with rule '{$rule}'\n"; var_dump($keys); echo "\n";

		// assign final key to $key
		if (!empty($keys))
			$key = $keys[count($keys)-1];
		else
			$key = $array_type;

		// Get rule if no rule specified.
		if (empty($rule))
			$rule = $this->discoverDataType($value, $key);
		else
			$rule = $this->getRule($rule, $key);

		/* Check for errors in format.
			We do this now as it is absolutely required, except for arrays */
		if ($rule['type'] != "array")
			$this->check_Rule($value, $rule);


		// +------------------------------
		//	Format variables into output
		// +------------------------------

		switch($rule['type'])
		{
			// array
			case "array" :
				// format into array format
				$new_value = "array(" . implode(", ", $value) . ")";
			break;

			// integer
			case "integer" :
				$new_value = trim($value);
			break;

			// boolean
			case "boolean" :
				$new_value = trim($value);
			break;

			// string
			case "string" :
				$new_value = trim("\"". str_replace("\'", "'", addslashes($value)) ."\"");
			break;

			// otherwise, construct as string
			default :
				$new_value = trim("\"". str_replace("\'", "'", addslashes($value)) ."\"");
		}

		// debug
		//echo "finished process\n\n";

		return $this->format($new_value, $keys, $array_type, $rule, $special);
	}


	/* ------------------------------------------------------------------ */
	//	Format given data into expected format of file
	//
	//	A custom rule can be given via $rule:
	//	['rule'] = regexp
	//	['error'] = "TEXT ERROR"
	//	['type'] = "type, such as string";
	//
	//	A custom format can be given via $special, will replace [[value]]
	//	with formatted value.
	//
	//	$value = mixed var
	//	$keys = array
	//	$array_type = string
	//	$special = String of irregular search / replace format
	/* ------------------------------------------------------------------ */
	
	function format($value, $keys, $array_type, $rule, $special=NULL)
	{
		// format for key output
		$key_output = "";
		if (is_array($keys) && !empty($keys))
		{
			foreach($keys as $cur_key)
			{
				// detect if numeric key or if string key
				if (is_numeric($cur_key))
					$key_output .= "[" . $cur_key . "]";
				else
					$key_output .= "['" . $cur_key . "']";
			}
		}

		// Format into final output
		if (empty($special))
			$final_format = "\$this->" . $array_type . $key_output . " = " . $value . ";";
		else // special format [[value]] is replaced with formatted value
			$final_format = str_replace("[[value]]", $value, $special);

		return $final_format;
	}


	function check_Rule($value, $rule)
	{
		if (!empty($rule['rule']))
		{
			if (!eregi($rule['rule'], $value))
				$this->ERROR->kill($rule['error']);
		}
	}


	function discoverVarType($value, $key)
	{
		// Expecting $value to be of type array, integer, boolean, or string

		// If array
		if (is_array($value))
		{
			$RULE = $this->getRule("array", $key);
		}

		// If integer
		elseif (is_numeric($value))
		{
			$RULE = $this->getRule("integer", $key);
		}

		// If boolean
		elseif(is_bool($value))
		{
			$RULE = $this->getRule("boolean", $key);
		}

		// For everything else, assume string
		else
		{
			$RULE = $this->getRule("string", $key);
		}

		return $RULE;
	}


	function discoverDataType($value, $key)
	{
		// Expecting $value to be e general string OR an array.

		// If array
		if (is_array($value))
		{
			$RULE = $this->getRule("array", $key);
		}

		// If integer
		elseif (is_numeric($value))
		{
			$RULE = $this->getRule("integer", $key);
		}

		// If boolean
		elseif(eregi($this->format['boolean'], $value))
		{
			$RULE = $this->getRule("boolean",  $key);
		}

		// For everything else, assume string
		else
		{
			$RULE = $this->getRule("string", $key);
		}

		return $RULE;
	}


	function getRule($type, $key)
	{
		$rule = array (
				"rule" => $this->format[$type],
				"error" => $key . $this->var_error[$type],
				"type" => $type
			);

		return $rule;
	}

}