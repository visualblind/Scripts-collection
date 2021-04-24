<?php
	/*
		This is a filter that will filter HTTP packets
		
	*/
	class http
	{
		var $active = false; //This is true or false.  This is called only by the constructor.
		
		/*
			The following variables are speciic to this module.
		*/
		
		var $sessions_sel;	
		var $session_array;
		var $filename;
		var $vtime;
		var $html;
		var $data_sel;
		var $data_array;
		var $data;
		var $filename_sel;
		var $filename_array;
		var $temp;
		
		/*
			This is the constructor for the module.
		*/
		function http($db)
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
			of packet data should be performed here.
		*/
		function run($db)
		{
			if($this->active)
			{
				$data_array = "";
				$filename_sel = "select * from fuzzy_temp where data_payload like '474554%' and packet_type = 'FUZZY HTTP port 80 G' order by id";
				$packet_del = "delete from fuzzy_temp where packet_type = 'FUZZY HTTP port 80 G'";
				if(!$filename_array = $db->query($filename_sel)) return false;
				$db->query($packet_del);
				
				$data_array = $db->query("SELECT * FROM fuzzy_temp WHERE packet_type = \"FUZZY HTTP activity\" ORDER BY seq");
				$db->query("DELETE FROM fuzzy_temp WHERE packet_type = \"FUZZY HTTP activity\"");
				while($row1 =@ mysql_fetch_array($filename_array))
				{
					$vtime  = $row1["timestamp"];
					$filename = "";
					$c_length = "";
					$c_type = "";
					$content = "";
					$data = "";
					
					$data = utils::hexStringToArray($row1["data_payload"]);
					$j = 4;
					$char = $data[$j]; 
					 while ($char != "0D" && $char != "3B" && $char != "20")
					 {
					 	$filename .= $char;
						$char = $data[++$j]; 
					 }// End While
					$filename = utils::hexStringToASCII($filename);
					$data = "";
					$ack = "";										 
					@mysql_data_seek($data_array, 0);
					while($trow =@ mysql_fetch_array($data_array))
					{
						if($trow[dport] == $row1[sport] && $trow[sip] == $row1[dip] && $trow[dip] == $row1[sip] && $trow[seq] == $row1[ack] && $trow[cid] > $row1[cid])
						{
							$ack = $trow[ack];
							break;
						}//end if
					}//end while
					
					$data_sel = "select * from fuzzy_temp where dport = '$row1[sport]' and sip = '$row1[dip]' and dip = '$row1[sip]' and ack = '$ack' and packet_type = 'FUZZY HTTP activity' order by seq";			
					$data = "";
					@mysql_data_seek($data_array, 0);
					while($trow =@ mysql_fetch_array($data_array))
					{
						if($trow[dport] == $row1[sport] && $trow[sip] == $row1[dip] && $trow[dip] == $row1[sip] && $trow[ack] == $ack)
							$data .= $trow[data_payload];
					}//end while
					
					 if (substr($data, 0,8) == "48545450")
					 {
						$data = utils::hexStringToASCII($data);
						$edata = explode(chr(13).chr(10),$data);
						for ($i=0; $i < count($edata); $i++)
						{
							if (stristr($edata[$i], "Content-Length"))
								$c_length = substr($edata[$i], 16);
							elseif (stristr($edata[$i], "Content-Type"))
								$c_type = substr($edata[$i],14);
						}//end for
						if ($c_type == "image/gif")
						{
							$insertD ="insert into fuzzy_GIFS (ip_address, usr_ip, timestamp, filename) values (\"$row1[dip]\", \"$row1[sip]\", \"$vtime\", \"$filename\")";
							$db->query($insertD);
							$content = substr(stristr($data, "GIF89"), 0, -2);
							$tmp = $db->query("select id from fuzzy_GIFS where timestamp =\"$vtime\" and filename = \"$filename\" and ip_address = \"$row1[dip]\"");
							$id =@ mysql_fetch_array($tmp);
							$id = $id[id];
							if(!$fp = fopen(VAR_PATH."gifs/$id.gif", 'w'))
								print "Could not open the GIF file!";
							else if(!fwrite($fp, $content))
								print "Could not write GIF file!";
							fclose($fp);
						}//end if gif
						
						elseif ($c_type == "image/jpeg"){
							$insertD ="insert into fuzzy_JPGS (ip_address, usr_ip, timestamp, filename) values (\"$row1[dip]\", \"$row1[sip]\", \"$vtime\", \"$filename\")";
							$db->query($insertD);
							$content = substr(stristr($data, chr(255).chr(216).chr(255).chr(224)), 0 ,-2);
							$tmp = $db->query("select id from fuzzy_JPGS where timestamp =\"$vtime\" and filename = \"$filename\" and ip_address = \"$row1[dip]\"");
							$id =@ mysql_fetch_array($tmp);
							$id = $id[id];
							if(!$fp = fopen(VAR_PATH."jpgs/$id.jpg", 'w'))
								print "Could not open the JPEG file!";
							else if(!fwrite($fp, $content))
								print "Could not write JPEG file!";
							fclose($fp);
						}//end if jpg
						
						elseif (stristr($data, "<HTML")){
							$content = substr(stristr($data, "<HTML"), 0, -2);
							$insertD ="insert into fuzzy_html (ip_address, usr_ip, vDate, filename, html) values (\"$row1[dip]\", \"$row1[sip]\", \"$vtime\", \"$filename\", \"".mysql_escape_string($content)."\")";
							$db->query($insertD);
						}//end if HTML
							
					}//end if
				}//end while
				return true;
			}//end if active	
			else
				$db->query("delete from fuzzy_temp where packet_type like '%HTTP%'");
			return true;
		}//end run
			
			
		/*
			This function checks to see whether or not this filter is
			considered active.  It sets the "active" variable to true or
			false accordingly.
		*/
		function isActive($db)
		{
			$select = "SELECT active FROM fuzzy_preferences WHERE protocol=\"html\"";
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
                        $table_name = "fuzzy_html";
                        $heading = "Fuzzy Packet Analysis - HTML";
                        $sub_heading = 'See <a href="ftp://ftp.rfc-editor.org/in-notes/rfc1939.txt">RFC 1939</a>.';
                        $this_filename = "http.php";
                        
                        // Don't touch these next variables
                        $select = 'SELECT * FROM '.$table_name.' order by id desc;';
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
                                                <td bgcolor="ffffff"><!--Leave this cell here--></td>
                                        </tr>';
                        $alt_color = 1;
                        $num_alerts = 0;
                        $num_packets = 0;
                        while ($row = mysql_fetch_array($result))
                        {
							$host = $this->resolve_cn($db, $row[usr_ip]);
						
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
                                                        <span style="color: '.$text_color.';">'.$host.'</span>
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
                                                       '.$row[html].'
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
		}//end getData"
		
		function resolve_cn($db, $ip)
		{
			if ($hst = $db->query("select network_name from fuzzy_NetBIOS where ip_address = \"".mysql_escape_string($ip)."\""))
				return $hst[network_name];
			else
				return $ip;
		}
	}// end cla
?>
