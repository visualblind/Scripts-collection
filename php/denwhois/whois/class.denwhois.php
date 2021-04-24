<?
#************************************************************************************************##
# 	Bu script Denwer.Com tarafýndan
#    yazýlmýþtýr. Eðer bu scripti kullanýyorsanýz 
#    kendisine
#  
#		  feedback@denwer.com 
#
#    adresinden ulaþýp bir teþekkür mesajý atýnýz :P
#   
#    Scripti beðenmediyseniz silin gitsin, yazan kiþiyede "berbat", "kötü" gibisinden mail atmayýn
#    ne siz yorulun nede ben; ayrýca imlâ kurallarýý ihlal ediyor olabilirim, bu benim sorunumdur.
#
#    mail: feedback@denwer.com | web: http://www.denwer.com
#
#************************************************************************************************#

unset($alan_adi_dizi);

$alan_adi_dizi[".com"    ] = Array("whois.crsnic.net"			, "dom ", "no match"	);
$alan_adi_dizi[".net"    ] = Array("whois.crsnic.net"			, "dom ", "no match"	);
$alan_adi_dizi[".org"    ] = Array("whois.publicinterestregistry.net"   , "", "not found"	);
$alan_adi_dizi[".info"   ] = Array("whois.afilias.net" 			, "", "not found"	);
$alan_adi_dizi[".name"   ] = Array("whois.nic.name" 			, "", "no match"	);
$alan_adi_dizi[".biz"    ] = Array("whois.neulevel.biz" 		, "", "not found"	);
$alan_adi_dizi[".us"     ] = Array("whois.nic.us" 			, "", "not found"	);
$alan_adi_dizi[".com.tr" ] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".net.tr" ] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".org.tr" ] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".gen.tr" ] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".web.tr" ] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".name.tr"] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".edu.tr" ] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".gov.tr" ] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".k12.tr" ] = Array("whois.nic.tr"  			, "", "no match"	);
$alan_adi_dizi[".mil.tr" ] = Array("whois.nic.tr" 			, "", "no match"	);
$alan_adi_dizi[".bbs.tr" ] = Array("whois.nic.tr" 			, "", "no match"	);
$alan_adi_dizi[".in"     ] = Array("whois.inregistry.in"		, "", "not found"	);

#************************************************************************************************#

class denWhois 
  {
    
    var   $baglanti     = false ;
    var   $alinmis      = false ;
    var   $cikti        = ""    ;
    var   $sunucu	= ""    ;
    var   $komut        = ""    ;
    var   $bulunmadi    = ""    ;
    var   $sonuc        = ""    ;

    function denWhois($domain ,$uzanti)
     {
      global $alan_adi_dizi       ;
      $this->sunucu    = $alan_adi_dizi["$uzanti"][0];
      $this->komut     = $alan_adi_dizi["$uzanti"][1];
      $this->bulunamadi= $alan_adi_dizi["$uzanti"][2];
     
      if ( !empty($this->sunucu))
       {
         if( ($this->baglanti = @fsockopen($this->sunucu, 43)) == FALSE)
           $this->sonuc = "Baðlantý kurulamadý : " . $this->sunucu;
         else
          {
            fputs($this->baglanti, "$this->komut$domain$uzanti\n\n");
            while( !feof($this->baglanti) )
             $this->cikti .= fgets($this->baglanti,256);
            fclose($this->baglanti);           
            if( stristr($this->cikti, $this->bulunamadi) )
             { $this->sonuc = "$domain$uzanti alan adýný satýn alabilirsiniz !!"; $this->alinmis=FALSE;}
            else
             { $this->sonuc = "$domain$uzanti alan adý daha önceden alýnmýþ"    ; $this->alinmis=TRUE; }
          }
       }
     }
    }
?>