<?php
	include_once('/usr/local/apache2/htdocs/jkarma/etc/conf.php');

class collector{
	var $DB_COLUMNS="";
	var $db;
	var $util;
	
	function collector(){
		$this->util= new utils();
		$this->run();
	}
	
	function run(){

		$this->db = new DAB(SQL_HOST,SQL_USER,SQL_PASS,SQL_DB);
		$this->db->connect();
		$q = $this->db->query("select sig_id, sig_name from signature where sig_name like \"FUZZY%\"");
						
		while($qq=@mysql_fetch_array($q))
			$this->resolve($qq[0],$qq[1]);
	}

	function resolve($qr,$qn){
			$sub=$this->db->query("Select event.timestamp,event.cid from event where event.signature='$qr' order by cid");
			$this->db->query("Delete from event where event.signature='$qr'");
			$c = "";
			while($subq=@mysql_fetch_array($sub))
			{
				$empty = "";
				$query = "Insert into fuzzy_temp(cid,timestamp,packet_type,version,protocol,sip,dip,sport,dport,seq,ack,data_payload) Values (";
				$c = $subq[cid];
				$query.="'$c','".addslashes($subq[timestamp])."','".addslashes($qn)."',";
				
				$subq1=mysql_fetch_array($this->db->query("Select iphdr.ip_ver,iphdr.ip_proto,iphdr.ip_src,iphdr.ip_dst from iphdr where iphdr.cid='$c'"));
				$this->db->query("Delete from iphdr where cid='$c'");
				$query.="'$subq1[ip_ver]','$subq1[ip_proto]','".addslashes($this->util->ipAddress($subq1[ip_src]))."','".addslashes($this->util->ipAddress($subq1[ip_dst]))."',";
				
				$subql=mysql_fetch_array($this->db->query("Select tcphdr.tcp_sport,tcphdr.tcp_dport,tcphdr.tcp_seq,tcphdr.tcp_ack from tcphdr where tcphdr.cid = '$c'"));
				$this->db->query("Delete from tcphdr where tcphdr.cid='$c'");
				if($subql[tcp_sport] != "")
				{
					$empty = "something";
					$query.="'$subql[tcp_sport]','$subql[tcp_dport]','$subql[tcp_seq]','$subql[tcp_ack]',";
				}//end if
				
				$subql=mysql_fetch_array($this->db->query("Select udphdr.udp_sport,udphdr.udp_dport from udphdr where udphdr.cid='$c'"));
				$this->db->query("Delete from udphdr where udphdr.cid='$c'");
				if($subql[udp_sport] != "")
				{
					$empty = "something";
					$query.="'$subql[udp_sport]','$subql[udp_dport]','','',";
				}//end if
				
				$subql=mysql_fetch_array($this->db->query("Select data.data_payload from data where data.cid='$c' limit 1"));
				$this->db->query("Delete from data where data.cid='$c'");
				$query.="'$subql[data_payload]')";
				
				if($query != "Insert into fuzzy_temp(timestamp,packet_type,version,protocol,sip,dip,sport,dport,seq,ack,data_payload) Values (" && $empty != ""){
					$this->db->query($query);
				}
			}//end while
		}//end function
}//end class
?>