<?php

function chkuri($link){
         $churl = @fopen("http://".$link,'r');
         if (!$churl) {
            $meldung="site link <b>http://$link <font color=\"red\"> is down!!</font></b><br><br>\n";
         }else{
            $meldung="site link <a href=\"http://$link\" target=_blank><b>http://$link</b></a> OK!<br>";
         }
         return $meldung;
}

function ping($link){
         $packs=5;
         for ($tt=0;$tt<=$packs;$tt++){
             $a=getmstime();
             $churl = @fsockopen(server($link), 80, &$errno, &$errstr, 20);
             $b=getmstime();
             if (!$churl){
                $zeit="down!!"; break;
             }
             $zeit=$zeit+round(($b-$a)*1000);
             @fclose($churl);
         }
         if ($zeit=="down!!"){}else{if(($zeit/$packs)<3){$zeit="<3 ms";}else{$zeit=($zeit/$packs)." ms";}}
         return $zeit;
}

function server($link){
         if(strstr($link,"/")){$link = substr($link, 0, strpos($link, "/"));}
         return $link;
}

function getmstime(){
         return (substr(microtime(),11,9)+substr(microtime(),0,10));
}

function correcturl($link){
         return str_replace("http://","",strtolower($link));
}

function selfnam(){
         global $PHP_SELF;
         return basename($PHP_SELF);
}

$link=correcturl($link);
echo "ping server <b>http://".server($link)." (".ping($link).")</b><br>";
echo chkuri($link);

echo "<form action=".selfnam()." method=get>";
echo "http://<input type=input name=link value=\"$link\" size=60>";
echo "<input type=submit name=check value=check>";
echo "</form>";
?>