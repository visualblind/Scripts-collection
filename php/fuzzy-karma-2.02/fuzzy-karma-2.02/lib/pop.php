<?php
	/*
		This is the API that each filtering module should use.
		Any functions listed in this class MUST be used in your
		module.
		
		You may add any other functions that you feel are necessary
		or useful.
	*/
        /*
                The POP protocol 
        */
        define("POP_EMAIL_START_POS",0);
        define("POP_EMAIL_START_LENGTH",3);
        define("POP_EMAIL_START_IDENT","+OK");
        define("POP_LENGTH_LIMIT",20);

	class pop
	{
       
		/*
			The variables listed below must remain, and should
			not need to be altered.
		*/
		var $active = false; //This is true or false.  This is called only by the constructor.
		
		/*
			The section below if for variables specific to your module.
		*/
		var $sender;
		var $recipient;
		var $message;
		var $timestamp;
		var $alert = 0;
		var $payload;
        var $messages;
		var $emails;
		var $login;
		var $login_count = 0;
		var $email_count = 0;
		var $email_row;


		/*
			This is the constructor for the module.  Some of the basic functions that the
			consturctor will perform are also included.
			The constructor takes a DAB object as a parameter.  This is the connection
			to the database.
		*/
		function pop($db) //Replace the function name with the name of the class
		{
			/*
				This is where we check to see if this module is marked as active.
				If it is not active, then we will not perform any actions.
			*/
                        
                        
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
            $conv_utils = new utils();
 			if($this->active)
			{
				/*
					This is where you will put your filtering code.
					Some example code is shown.
				*/
				$select_username = "SELECT * FROM fuzzy_temp WHERE packet_type= \"FUZZY POP3 username\"";
				$delete_username = "DELETE FROM fuzzy_temp WHERE packet_type=\"FUZZY POP3 username\"";
				$select_password = "SELECT * FROM fuzzy_temp WHERE packet_type= \"FUZZY POP3 pass\"";
				$delete_password = "DELETE FROM fuzzy_temp WHERE packet_type=\"FUZZY POP3 pass\"";
				$username_result = $db->query($select_username);
				$db->query($delete_username);
				$password_result = $db->query($select_password);
				$db->query($delete_password);
				
				while($row =@ mysql_fetch_array($username_result))
				{
					$uname = mysql_escape_string(trim(substr($conv_utils->hexStringToASCII($row[data_payload]), 5)));
					$temp = mysql_fetch_array($db->query("SELECT username FROM fuzzy_pop3_users WHERE username=\"$uname\" AND dip=\"$row[dip]\""));
					if($temp[username] != $uname)
						$db->query("INSERT INTO fuzzy_pop3_users (dip, sip, seq, username) VALUES (\"$row[dip]\", \"$row[sip]\", \"$row[seq]\", \"$uname\")");
				}//end while
				while($row =@ mysql_fetch_array($password_result))
				{
					$passwd = mysql_escape_string(trim(substr($conv_utils->hexStringToASCII($row[data_payload]), 5)));
					$db->query("UPDATE fuzzy_pop3_users SET passwd=\"$passwd\" WHERE dip=\"$row[dip]\" AND sip=\"$row[sip]\" AND ($row[seq] - fuzzy_pop3_users.seq) < 100");
				}//end while

				$select_data = "SELECT * FROM fuzzy_temp WHERE packet_type = \"FUZZY POP3 data\" ORDER BY seq";
				$delete_data = "DELETE FROM fuzzy_temp WHERE packet_type = \"FUZZY POP3 data\"";
				if(!$array = $db->query($select_data)) return false;
				$db->query($delete_data);
				while($row =@ mysql_fetch_array($array))
				{
					$data_payload = $conv_utils->hexStringToASCII($row[data_payload]);
					if(substr($data_payload, 0, POP_EMAIL_START_LENGTH) == POP_EMAIL_START_IDENT && $data_payload{strlen($data_payload)-1} != chr(10) && strlen($data_payload) > POP_LENGTH_LIMIT && substr($data_payload, POP_EMAIL_START_LENGTH+1, 4) != "Uniq" && substr($data_payload, POP_EMAIL_START_LENGTH+1, 4) != "uniq" && substr($data_payload, POP_EMAIL_START_LENGTH+1, 4) != "Scan")
					{
						$message = mysql_escape_string(trim(str_replace("\n","<br>",strip_tags($data_payload))));
						$db->query("INSERT INTO fuzzy_pop3 (sip, dip, seq, timestamp, message) VALUES (\"$row[sip]\", \"$row[dip]\", \"$row[seq]\", \"$row[timestamp]\", \"$message\")");
					}//end elseif
					elseif(substr($data_payload, 0, POP_EMAIL_START_LENGTH) != POP_EMAIL_START_IDENT)
					{
						$message = mysql_escape_string(str_replace("\n","<br>",strip_tags($data_payload)));
						$sel = "UPDATE fuzzy_pop3 SET message=CONCAT(message, \"$message\") WHERE dip=\"$row[dip]\" AND sip=\"$row[sip]\" AND ($row[seq] - seq) < 10000";
						$db->query($sel);
					}//end elseif
				}//end while                                 
				return true;
			}//end if active
			return true;
		}//end run
		
		
		/*
			This function checks to see whether or not this filter is
			considered active.  It sets the "active" variable to true or
			false accordingly.
		*/
		function isActive($db)
		{
			$select = "SELECT active FROM fuzzy_preferences WHERE protocol=\"pop3\"";
			$temp = mysql_fetch_array($db->query($select));
                        
			if($temp[active] == 1)
				$this->active = true;
			else
				$this->active = false;
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
                        $table_name = "fuzzy_pop3_users";
                        $heading = "Fuzzy Packet Analysis - Post Office Protocol v3 (POP3) - User List";
                        $sub_heading = 'See <a href="ftp://ftp.rfc-editor.org/in-notes/rfc1939.txt">RFC 1939</a>.';
                        $this_filename = "pop.php";
                        
                        // Don't touch these next variables
                        $select = 'SELECT * FROM '.$table_name.' ORDER BY dip;';
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
                                                        <li>'.$sub_heading.'</li>
                                                </td>
                                        </tr>
                                </table>
                                <table>
                                        <tr bgcolor="#006699">
                                                <td>
                                                        <span class="label">Mail Server IP</span>
                                                </td>
                                                <td>
                                                        <span class="label">Client IP</span>
                                                </td>
                                                <td>
                                                        <span class="label">User Name</span>
                                                </td>
                                                <td>
                                                        <span class="label">Password</span>
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
                                /*
                                        Customize this to match the field in your protocol table
                                */
                                $protocol_html .= '
                                        <tr bgcolor="'.$row_color.'">
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$dip.'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$sip.'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$username.'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$passwd.'</span>
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
                                                        <span>Users Listed: '.$num_packets.'</span>
                                                </td>
                                        </tr>
                                </table>';
                        $table_name = "fuzzy_pop3";
                        $heading = "Fuzzy Packet Analysis - Post Office Protocol v3 (POP3) - Email List";
                        $sub_heading = 'See <a href="ftp://ftp.rfc-editor.org/in-notes/rfc1939.txt">RFC 1939</a>.';
                        $this_filename = "pop.php";
                        
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
                                                        <li>'.$sub_heading.'</li>
                                                </td>
                                        </tr>
                                </table>
                                <table>
                                        <tr bgcolor="#006699">
                                                <td>
                                                        <span class="label">Sender</span>
                                                </td>
                                                <td>
                                                        <span class="label">Recipient</span>
                                                </td>
                                                <td>
                                                        <span class="label">Message</span>
                                                </td>
                                                <td>
                                                        <span class="label">Time Stamp</span>
                                                </td>
                                                <td>
                                                        <span class="label">Alert</span>
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
                                                        <span style="color: '.$text_color.';">'.$sender.'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$recipient.'</span>
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
