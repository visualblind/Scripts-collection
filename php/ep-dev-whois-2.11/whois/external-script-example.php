<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>External Script Example</TITLE>
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
</HEAD>

<BODY>
<h1>EP-Dev Whois Buy Mode Examples</h1>
<div>This page will show you how to utilize the EP-Dev Whois script along side your billing software, allowing you to use the whois script to pass in a domain to a billing script that will then handle the order process.</div>
<br>
<div>Before a few examples, it should be noted that you can configure the EP-Dev Whois script to work with nearly any kind of billing system that supports passing in the domain name. Since EP-Dev Whois script allows for you to edit domain results via templates, you can nearly complete control over how the domains are handled.</div>
<br>
<br>
<div>The EP-Dev Whois script comes configured with a setup that passes the domain and extension as separate components to an external script. For PHP, the $_REQUEST['domain'] and $_REQUEST['ext'] hold the domain and extension of the domain respectively.<br>
<br>
If you have reached this page as the result of clicking on the buy link in the EP-Dev Whois script, then below you should see details of the domain that you clicked on (otherwise, it will be blank):<br>
DOMAIN: <?php echo $_REQUEST['domain']; ?><br>
EXTENSION: <?php echo $_REQUEST['ext']; ?><br>
FULL DOMAIN: <?php echo $_REQUEST['domain'] . "." . $_REQUEST['ext']; ?>
</div>
<br>
<div>The external script url is meant to point to a register script / hosting management script that you acquire from somewhere else. Usually these scripts will allow you to pass in domain names through some method. The most common method is to pass them in via url, such as register.php?domain=mydomain&ext=com .</div>
<br>
<br>
<div><strong>Here are some examples:</strong></div>
<br>
<div><strong>EXAMPLE 1</strong></div>
<div>Your external script requires you to use the format of register.php?domain_name=mydomain&domain_tld=com<br>
Note that you now have to send to the script domain_name instead of domain and domain_tld instead of ext. To edit domain and ext to reflect this, you must edit the "Available Domains" template within the control panel:
<ol>
	<li>Edit the Available Domains template</li>
	<li>Find <font color="blue">?domain=[[domain]]&amp;ext=[[ext]]</font> and replace with <font color="blue">?domain_name=[[domain]]&amp;domain_tld=[[ext]]</font></li>
	<li>Save Templates</li>
</ol>
</div>
<br>
<div><strong>EXAMPLE 2</strong></div>
<div>Your external script requires you to use the format of register.php?domain=mydomain&ext=.com<br>
Note that you now have to have a period before your extension (thus, ".com" instead of just "com"). To edit the extension to reflect this, you must edit the "Available Domains" template within the control panel:
<ol>
	<li>Edit the Available Domains template</li>
	<li>Find <font color="blue">?domain=[[domain]]&amp;ext=[[ext]]</font> and replace with <font color="blue">?domain=[[domain]]&amp;ext=.[[ext]]</font></li>
	<li>Save Templates</li>
</ol>
Note that we have modified the default variable of just EXT to .EXT, making our com turn into .com
</div>
<br>
<div><strong>EXAMPLE 3 (ModernBill)</strong></div>
<div>I have had requests to integrate this with Modernbill (<a href="http://www.modernbill.com">http://www.modernbill.com</a>). In this example, I will show you how to integrate the script with Modernbill's Order Wizard (default modernbill install).<br><br>
Modernbill is tricky, as it requires the domain and the tld to be passed in under one variable, in the format of orderwiz.php?submit_domain=register&domains[]=register|mydomain|com<br>
Note the extra variable (submit_domain) as well as the modified variable (domains[]) and the combined domain structure (register|mydomain|com).<br>
Here is how to configure the whois script to pass the variables into ModernBill in this fashion:
<ol>
	<li>Edit the Available Domains template</li>
	<li>Find <font color="blue">external-script-example.php?domain=[[domain]]&amp;ext=[[ext]]</font> and replace with <font color="blue">/order/orderwiz.php?submit_domain=register&amp;domains[]=register|[[domain]]|[[ext]]</font></li>
	<li>Save Templates</li>
</ol>
Remember to modify /order/ to reflect the URL to orderwiz.php such as:<br>
http://www.mydomain.com/modernbill/order/orderwiz.php
</div>
</BODY>
</HTML>