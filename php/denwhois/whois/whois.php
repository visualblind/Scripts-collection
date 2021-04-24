 
<title>DenWhois ::: v.1</title>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1254">
<style type="text/css">
<!--
.tablo {  background-color: #EEEEEE; border: #666666; border-style: dashed; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px}
.giris { background-color: #557B9B; border: 1px #FFFFFF solid; font-size: xx-small; color: #FFFFFF; text-transform: lowercase}
-->
</style>

<body bgcolor="#FFFFFF">
<p>&nbsp;</p>
<table width="300" border="0" cellspacing="0" cellpadding="0" align="center" class="tablo">
  <tr> 
    <td> 
      <div align="center"><font size="-1" color="#CC0000"><b><font color="#990000">Denwer 
        ::: Whois ::: v1</font></b></font></div>
    </td>
  </tr>
  <tr> 
    <td >&nbsp; </td>
  </tr>
  <tr> 
    <td valign="top"> 
      <div align="center">
        <form action ="<?=$PHP_SELF?>" method="post">
        <input type="text" name="alan_adi" class="giris" maxlength="63" size="32">
        <select name="uzanti" class="giris">
          <option value=".com">.com</option>
          <option value=".net">.net</option>
          <option value=".org">.org</option>
          <option value=".com.tr">.com.tr</option>
          <option value=".net.tr">.net.tr</option>
          <option value=".org.tr">.org.tr</option>
          <option value=".gen.tr">.gen.tr</option>
          <option value=".web.tr">.web.tr</option>
          <option value=".name.tr">.name.tr</option>
          <option value=".edu.tr">.edu.tr</option>
          <option value=".gov.tr">.gov.tr</option>
          <option value=".k12.tr">.k12.tr</option>
          <option value=".mil.tr">.mil.tr</option>
          <option value=".bbs.tr">.bbs.tr</option>
          <option value=".info">.info</option>
          <option value=".name">.name</option>
          <option value=".biz">.biz</option>
          <option value=".us">.us</option>
          <option value=".in">.in</option>
        </select>
        <input type="submit" name="Submit" value="Sorgula &gt;&gt;" class="giris">
        </form>
      </div>
    </td>
  </tr>
</table>
<br>
<?
   if(!empty($alan_adi) && !empty($uzanti) )
    {
      include("class.denwhois.php");
      $sorgu = new denWhois("$alan_adi", "$uzanti");
     
?>
      <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" class="tablo"><tr><td bgcolor="#FFFFCC"><font size="-1" color="#666666">
      <center><b><?=$sorgu->sonuc?></b></center>
      <? if($sorgu->alinmis) echo str_replace("\n", "<br>",$sorgu->cikti);?>
      </font></td></tr></table><br>       
<?
    }
?>
<table width="300" border="0" cellspacing="0" cellpadding="0" align="center" class="tablo">
  <tr>
    <td>
      <div align="center"><font size="-2" color="#990000">(c) Denwer.Com - 2005 
        (c)</font></div>
    </td>
  </tr>
</table>
<p>&nbsp;</p>
