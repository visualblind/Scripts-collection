<?php
	/*
		This is the API that each filtering module should use.
		Any functions listed in this class MUST be used in your
		module.
		
		You may add any other functions that you feel are necessary
		or useful.
	*/
	class jpg
	{
		/*
			The variables listed below must remain, and should
			not need to be altered.
		*/
		var $active = false; //This is true or false.  This is called only by the constructor.
		
		/*
			The section below if for variables specific to your module.
		*/
			
		
		/*
			This is the constructor for the module.  Some of the basic functions that the
			consturctor will perform are also included.
			The constructor takes a DAB object as a parameter.  This is the connection
			to the database.
		*/
		function jpg($db) //Replace the function name with the name of the class
		{
			/*
				This is where we check to see if this module is marked as active.
				If it is not active, then we will not perform any actions.
			*/
			if(!$this->isActive($db))
				return false;
			
			if($this->active)
			{
				/*
					Run the filter, or return false if it fails
				*/
				if(!$this->run($db))
					return false;
			}//end if	
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
			$select = "SELECT active FROM fuzzy_preferences WHERE protocol=\"jpgs\"";
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
                        $table_name = "fuzzy_JPGS";
                        $heading = "Fuzzy Packet Analysis - JPEG Images";
                        $sub_heading = '';
                        $this_filename = "jpg.php";
                        
                        // Don't touch these next variables
                        $select = 'SELECT * FROM '.$table_name.';';
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
                                        	<span class="label">id</span>
                                        </td>
                                        <td>
                                            <span class="label">User</span>
                                        </td>
                                        <td>
											<span class="label">Resource Name</span>
                                        </td>
                                        <td>
                                            <span class="label">Time Accessed</span>
                                        </td>
                                        <td>
                                            <span class="label">Alert</span>
                                        </td>
                                        <td bgcolor="ffffff"><!--Leave this cell here-->
											<span><a href="'.BASE_URL.'index.php?deletefrom='.$table_name.'&id= &load='.$this_filename.'"><b>Delete All</b></a></span>
										</td>
                                    </tr>';
                        $alt_color = 1;
                        $num_alerts = 0;
                        $num_packets = 0;
                        while ($row =@ mysql_fetch_array($result))
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
                                                        <span style="color: '.$text_color.';">'.$row[id].'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$row[usr_ip].'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$row[ip_address].$row[filename].'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$row[timestamp].'</span>
                                                </td>
                                                <td>
                                                        <span style="color: '.$text_color.';">'.$row[alert].'</span>
                                                </td>
                                                <td bgcolor="ffffff">
                                                        <span><a href="'.BASE_URL.'index.php?deletefrom='.$table_name.'&id='.$row[id].'&load='.$this_filename.'">Delete</a></span>
                                                </td>
										</tr>
										<tr bgcolor="'.$row_color.'">		
												<td colspan = "5">
                                                        <span style="color: '.$text_color.';"><img src="'.URL_VAR.'jpgs/'.$row[id].'.jpg"></span>
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