<form name="lg" method="post" action="lg.php">
  <table border=0>
    <tr><td>Gimme:</td></tr>
    <tr><td>
      <select name="func">
        <option value="tcptraceroute">TCPTraceRoute (IPv4 only)</option>
        <option value="traceroute">TraceRoute</option>
	<option value="tracepath">TracePath</option>
        <option value="ping">Ping</option>
        <option value="whois">WhoIs</option>
        <option value="dnsa">DNS Lookup</option>
        <option value="dnsmx">DNS Lookup SMTP records (MX)</option>
        <option value="dnsns">DNS Lookup NameServers (NS)</option>
        <option value="dnsany">DNS Lookup All info (ANY)</option>
      </select>
    </td></tr><tr><td>
      When verifying an URL check one of those: 
      <input type="radio" name="ipv" value="ipv4" checked>IPv4
      <input type="radio" name="ipv" value="ipv6">IPv6
    </td></tr>
    <tr><td>On:</td></tr>
    <tr><td>
    <?php
        
       if ( $_SERVER["REMOTE_HOST"] )
         $v=$_SERVER["REMOTE_HOST"];
       else
         $v=$SERVER["REMOTE_ADDR"];
       echo "<input type=\"text\" name=\"target\" size=\"40\" value=\"$v\">";
    ?>
    </td></tr>
    <tr><td><input type="submit" value="GO"> <input type=button name="reset" value="RST" onClick="document.lg.target.value='';document.lg.target.focus();"></td></tr>
    </table>
</form>
<script>
  document.lg.target.focus();
</script>
