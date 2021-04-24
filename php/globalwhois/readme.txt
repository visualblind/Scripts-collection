GlobalWhois
By NukedWewb
Email: nukedweb@yahoo.com

Get More Free Scripts!: http://nukedweb.pxtek.net/

#####################################################


This script (whois.inc) is to be used as an INCLUDE in your own script, or you may
convert example.php to match your own website. Use example.php as a reference when
incorporating phpGlobalWhois into your own script.

phpGlobalWhois is a simple script that will do a Whois lookup against any domain with
any TLD (Top Level Domain). A built-in array of whois servers tells the script which
whois server to use to perform the lookup.

	$dom = (the domain name to look up)
	include "./whois.inc";
	$whoisresult = lookup($dom);
	$whoisresult[0] // This value will be "1" is the domain is available, or blank if it's not.
	$whoisresult[1] // This value holds the full text returned from the whois server.
	

These lines are to be included in your script. $whoisresult[0] returns an array 
holding the "available" flag, and $whoisresult[1] returns the text of the result. If the lookup failed, either
because the server was down, or because the TLD of the domain wasn't in the array, then
$whoisresult[1] will be returned empty.

If you find a TLD not listed in whois.inc that you really need to have added,
you can study the array in whois.inc to see how to edit it. You WILL also need
to visit that particular TLD's registrar and do a little research to find out
the whois server and what text you'll need to 'grab' when a domain is available.

 - Tim
nukedweb@yahoo.com
