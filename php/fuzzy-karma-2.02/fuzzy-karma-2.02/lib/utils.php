<?php
	class utils
	{
		function utils()
		{
			
		}//end constructor
		
		function hexStringToArray($payload)
		{
			$array = "";
			$pos = 0;
			for($i= 0; $i < strlen($payload)/2; $i++)
			{
				$array[$i] = $payload{$pos}.$payload{$pos+1};
				$pos+=2;
			}//end for
			return $array;
		}//end function
		
		function hexStringToASCII($string)
		{
			$t = new utils();
			$array = $t->hexStringToArray($string);
			$ascii = "";
			for($i=0; $i < count($array); $i++)
				$ascii .= chr(hexdec($array[$i]));
			return $ascii;
		}//end function
	    
	    function ipAddress($s)
		{
        	$co=0;
        	$num = $s;
        	$ip = $num/16;
        	$addr="";
        	$cc=0;
	        while($ip > 1)
			{
    	        if($co != 0)
        	        $ip = $num/16;
           		if($co ==0)
           			$addr[$co++]= $this->my_bcmod($num,16);
          	 	else
                	$addr[$co++]= $this->my_bcmod($num,16);
            	$num=strtok($ip,".");
            	if($cc == 23)
                	$ip = 0;
        	}
        	$rr= count($addr);
        	$ipaddr=hexdec(dechex($addr[7]).dechex($addr[6])).".".hexdec(dechex($addr[5]).dechex($addr[4])).".".hexdec(dechex($addr[3]).dechex($addr[2])).".".hexdec(dechex($addr[1]).dechex($addr[0]));
        	return $ipaddr;
    	}

		function my_bcmod( $x, $y )
		{
       		// how many numbers to take at once? carefull not to exceed (int)
       		$take = 16;    
       		$mod = '';
       
       		do
       		{
        		$a = (int)$mod.substr( $x, 0, $take );
           		$x = substr( $x, $take );
           		$mod = $a % $y;    
       		} 
       		while ( strlen($x) );
       
       		return (int)$mod;
    	}
		
		
	}//end class utils	
?>