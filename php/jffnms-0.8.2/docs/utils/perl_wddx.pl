
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use WDDX;

my $wddx = new WDDX;
$ua = new LWP::UserAgent;

#@params = (WDDX::NULL,WDDX::NULL,WDDX::NULL,WDDX::NULL,WDDX::NULL,2);
#@params = (undef,undef,undef,undef,2);
@params = ($wddx->null(),1,1,$wddx->null(),0,2);

print $wddx->serialize($wddx->array2wddx(\@params)),"\n";

my $req = POST 'http://boxen.lan.tiba.com/jffnms-sat4/admin/satellite.php',
               [ 
	        "sat_id" => "1",
	        "capabilities" => "W",
	        "class" => "events", "method" => "list",  
#	        "method" => "ping",
		"params" => $wddx->serialize($wddx->array2wddx(\@params))
	       ];

$response = $ua->request($req);

print $response->as_string,"\n";

my $wddx_request = $wddx->deserialize( $response->content() );

$type = $wddx_request->type;
$data = $wddx->wddx2perl($wddx_request);

#print "type: ", $type, " - ",$data,"\n"; 

if ($type eq "hash") {
    foreach $key (keys %$data) {
	$value = $data->{$key};
	print $key, "=>", $value,"\n";
    }    
}

if ($type eq "array") {
    foreach $element (@{$data}) {
	foreach $key (keys %$element) {
	    print $key, "=>", $value = $element->{$key},"\n";
	}    
	print "-----------------\n";
    }
}
