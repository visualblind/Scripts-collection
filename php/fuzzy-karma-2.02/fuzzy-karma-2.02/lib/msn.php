<?php
	/*
		This is the API that each filtering module should use.
		Any functions listed in this class MUST be used in your
		module.
		
		You may add any other functions that you feel are necessary
		or useful.
	*/
	 
	 	/*
			MSN Defines
		*/
			define("MSN_PORT_IDENT",771);      //check data section of packet to see what these are changed to.
			define("MSN_MESSAGE_POS",0);
			define("MSN_MESSAGE_IDENT","MSG");
			define("MSN_MESSAGE_LENGTH",3);
			define("MSN_SIGN_OFF","BYE");
			define("MSN_SIGN_ON","FLN");
			define("MSN_TYPING_IDENT",10);
	
		
	class msn
	{

		/*
			The variables listed below must remain, and should
			not need to be altered.
		*/
		var $active = false; //This is true or false.  This is called only by the constructor.
		
		/*
			The section below if for variables specific to your module.
		*/
		var $messages_output;
		var $messages;
		var $message_count = 0;
		var $users;
		var $user_count = 0;
		
		
		/*
			This is the constructor for the module.  Some of the basic functions that the
			constructor will perform are also included.
			The constructor takes a DAB object as a parameter.  This is the connection
			to the database.
		*/
		function msn($db) //Replace the function name with the name of the class
		{
			/*
				This is where we check to see if this module is marked as active.
				If it is not active, then we will not perform any actions.
			*/       //This comment keeps it from being tested for activity

			if(!$this->isActive($db))
				return false;	
			return true;
		}//end constructor
		
		
		/*
			This function actually performs the analysis for the module.  Any filtering
			one packet data should be performed here.
		*/
		function run($db)
		{
			if($this->active)
			{
				$array = "";	// Where you will store your packets
				$select = "SELECT * FROM fuzzy_temp WHERE packet_type=\"FUZZY MSN activity\" ORDER BY seq";	// The select statement you will use
				$delete = "DELETE FROM fuzzy_temp WHERE packet_type=\"FUZZY MSN activity\"";
				if(!$array = $db->query($select)) return false;   //PUTS ALL THE MSN PACKETS INTO $array
				$db->query($delete);
				
				/*
					Loop to analyze each packet one by one.
				*/
				while($row =@ mysql_fetch_array($array))
				{
					/*
						This is where you will actually perform the analysis on each packet
						If the packet matches your criteria, then you will store it in the
						table that matches with your filter.
					*/
					$message = "";
					$username = "";
					$email = "";
					$payload = utils::hexStringToASCII($row[data_payload]);
					if(substr($payload, MSN_MESSAGE_POS, MSN_MESSAGE_LENGTH) == MSN_MESSAGE_IDENT) //check to see if it's "MSG"
					{
						$temp = explode(" ", $payload);
						$username = mysql_escape_string(str_replace("%20", " ", $temp[2]));
						$email = $temp[1];
						if($username == "U")   //THIS MSN HEADER WILL ONLY HAVE AN EMAIL ADDRESS (WHEN I WAS SENDING PACKETS)
						{
							$email = mysql_escape_string(trim(substr($temp[count($temp)-1], 0, -EOP)));    //--  put parsed email into the fuzzy_msn_users[email_address] field  WHAT'S THIS?  PARSING TO GET THE EMAIL ADDRESS? -EOP=6?
							$username = "Unkown";
						}//end if
						if($username == "N")
						{
							$username = "Unkown";
							$email = "Unknown";
						}//end if
						if(ord($payload{strlen($payload)-3}) != MSN_TYPING_IDENT)                       //IF THIS PACKET REALLY CONTAINS A MESSAGE
						{
							$temp = explode(chr(13).chr(10), $payload);
							$message = mysql_escape_string(trim(substr($temp[count($temp)-1], 0)));
						}//end if message						
					}//end if
					elseif(substr($row, MSN_MESSAGE_POS, MSN_MESSAGE_LENGTH) == MSN_SIGN_OFF)	//THIS IS A SIGN OFF PACKET
					{
						$uname = $db->query("select * from fuzzy_msn where src_ip = \"$row[sip]\";");
						$message = $uname[username]." has signed off!";
						$this->message_count++;
					}//end elseif
					elseif(substr($payload, MSN_MESSAGE_POS, MSN_MESSAGE_LENGTH) == MSN_SIGN_ON)	//THIS IS A SIGN ON PACKET
					{
						$message = trim(substr($payload, MSN_MESSAGE_POS+MSN_MESSAGE_LENGTH, -4))." has just signed in!";
					}//end elseif
					//PUT THE INFORMATION INTO THE DATABASE
					if($message != "")
						$db->query("insert into fuzzy_msn (message, timestamp, src_ip, dest_ip, username, email) values ('$message', '$row[timestamp]', '$row[sip]', '$row[dip]', '$username', '$email')");					
				}//end while
				return true;
			}//end if active	
			else
				$db->query("delete from fuzzy_temp where packet_type like '%FUZZY MSN%'");
			return true;
		}//end run
		
		
		/*
			This function checks to see whether or not this filter is
			considered active.  It sets the "active" variable to true or
			false accordingly.
		*/
		function isActive($db)
		{
			$select = "SELECT active FROM fuzzy_preferences WHERE protocol=\"msn\"";
			$temp = mysql_fetch_array($db->query($select));
			if($temp[active] == 1){
				$this->active = true;
			}
			else{
				$this->active = false;
			}
			return true;
		}//end isActive
		
		
		/*
			This function performs the statistical analysis for this module
		*/
		function doStats($db)
		{
			/*
				This is where you will perform that statistical analysis
				based on the algorithm provided for this module.
			*/
		}//end doStats
		
		
		/*
			This function returns statistical information for the module.
		*/
		function getStats($db)
		{
			/*
				This should retrieve the statistical information and return it in
				html format.
			*/
		}//end getStats
		
		
		/*
			This function returns the threshold values that correspond to this filter.
		*/
		function getThresh($db)
		{
			/*
				This should retrieve the threshold information from the database
				that relates to this filter.
			*/
		}//end getThresh
		
		
		/*
			This function returns information about this filter in html format.
		*/
		function getData($db)
		{
			/*
				This returns information relating to this filter in HTML format.
			*/
			  /*
                                You should customize these next variables to match your protocol
                        */
                        $table_name = "fuzzy_msn";
                        $heading = "Fuzzy Packet Analysis - MSN Messenger";
                        $sub_heading = 'See <a href="ftp://ftp.rfc-editor.org/in-notes/rfc1939.txt">RFC 1939</a>.';
                        $this_filename = "msn.php";
                        
                        // Don't touch these next variables
                        $select = 'SELECT * FROM '.$table_name.' ORDER BY timestamp;';
                        $result = $db->query($select);
                        
                        $alt_color = 0;
                        $count = 0;
                        
                        /*
                                Make sure you use the same HTML format when you customize your fields
                        */
                        $protocol_html .= '<br /><br />
                                <table cellpadding="2" cellspacing="2" border="0">
                                        <tr>
                                                <td colspan="8">
                                                        <span class="heading">'.$heading.'</span>
                                                </td>
                                        </tr>
                                </table>
                                <table>
                                        <tr bgcolor="#006699">
                                                <td>
                                                        <span class="label">username</span>
                                                </td>
                                                <td>
                                                        <span class="label">email</span>
                                                </td>
                                                <td>
                                                        <span class="label">message</span>
                                                </td>
                                                <td>
                                                        <span class="label">timestamp</span>
                                                </td>
                                                <td>
                                                        <span class="label">alert</span>
                                                </td>
                                                <td bgcolor="ffffff"><!--Leave this cell here--></td>
                                        </tr>';
                        $alt_color = 1;
                        $num_alerts = 0;
                        $num_packets = 0;
                        while ($row = mysql_fetch_array($result))
                        {
                                /*
                                        You shouldn't need to touch anything here
                                */
                                // extract all values from the array
                                extract ($row, EXTR_OVERWRITE);
                                $text_color = "#3366cc";
                                $num_packets++;
                                if ($alt_color == 0)
                                {
                                        $row_color = "#ABCDEF";
                                        $alt_color = 1;
                                }
                                else 
                                {
                                        $row_color = "#EEEEEE";
                                        $alt_color = 0;
                                }
                                if ($alert == 1) 
                                {
                                        $row_color = "#FF0000";
                                        $text_color = "#ffffff";
                                        $num_alerts++;
                                }
                                /*
                                        Customize this to match the field in your protocol table
                                */
                                $protocol_html .= '
                                        <tr bgcolor="'.$row_color.'">
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$username.'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$email.'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$message.'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$timestamp.'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$alert.'</span>
                                                </td>
                                                <td bgcolor="ffffff">
                                                        <span><a href="'.$base_url.'index.php?deletefrom='.$table_name.'&id='.$id.'&load='.$this_filename.'">Delete</a></span>
                                                </td>
                                        </tr>';
                        }
                        $protocol_html .= '</table>';
                        $protocol_html .= '
                                <table>
                                        <tr>
                                                <td>
                                                        <span>Packets Listed: '.$num_packets.'</span>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td>
                                                        <span>Alerts Flagged: '.$num_alerts.'</span>
                                                </td>
                                        </tr>
                                </table>';
                        return ($protocol_html);
		}//end getData
	}// end class
?>
