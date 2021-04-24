<?php

// IPplan v4.50
// Aug 24, 2001
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//

// parse an xml document and return an array with all the attributes 
// and values for a given tag. Two levels of nesting are supported in
// the given tag
class xml  {
    var $parser;
    var $blocktag="";
    var $gottag=0;
    var $index=-1;
    var $result=array();

    var $depth=0;

    function xml($blocktag) {
        if(extension_loaded("xml")) {
            $this->blocktag=$blocktag;
            $this->parser = xml_parser_create("");
            xml_set_object($this->parser,$this);
            xml_set_element_handler($this->parser,"tag_open","tag_close");
            //xml_set_character_data_handler($this->parser,"cdata");
        }
    }

    function parse($data) { 
        xml_parse($this->parser,$data);
        return $this->result;
    }

    function tag_open($parser,$tag,$attributes) { 
        if ($tag==$this->blocktag) {
            $this->gottag=1;
            $this->index++;
            return;
        }
        if ($this->gottag) {
            // only increase depth if inside blocktag
            $this->depth++;
            if ($this->depth==2) {
                $this->result[$this->index][$tag][]=$attributes;
            }
            else {
                /* subsequent values appear as sub arrays

  ["ADDRESS"]=>
  array(3) {
    ["ADDR"]=>
    string(11) "192.168.0.1"
    ["ADDRTYPE"]=>
    string(4) "ipv4"
    [0]=>
    array(3) {
      ["ADDR"]=>
      string(17) "00:09:5B:DE:A8:6A"
      ["ADDRTYPE"]=>
      string(3) "mac"
      ["VENDOR"]=>
      string(7) "Netgear"
    }
  }
                */
                if (isset($this->result[$this->index][$tag])) {
                    $this->result[$this->index][$tag][]=$attributes;
                }
                else {
                    $this->result[$this->index][$tag]=$attributes;
                }
            }
            //var_dump($parser,$tag,$attributes); 
        }
    }

    function cdata($parser,$cdata) { 
        //var_dump($parser,$cdata);
    }

    function tag_close($parser,$tag) { 
        if ($tag==$this->blocktag) {
            $this->gottag=0;
            return;
            //var_dump($parser,$tag); 
        }
        // only decrase depth if inside blocktag
        if ($this->gottag) {
            $this->depth--;
        }
    }

} // end of class xml

// nmap parser always returns arrays for tags of form
// [tagname][0...x][element]
// array index will mostly be zero if one as most results
// return 1 tag
class xmlnmap extends xml {

    function tag_open($parser,$tag,$attributes) { 
        if ($tag==$this->blocktag) {
            $this->gottag=1;
            $this->index++;
            return;
        }
        if ($this->gottag) {
            // only increase depth if inside blocktag
            $this->depth++;
            // dupes like this would have been overwritten! so do not overwrite
            // by always creating an array
            // <address addr="192.168.0.1" addrtype="ipv4" />
            // <address addr="00:09:5B:DE:A8:6A" addrtype="mac" vendor="Netgear" />
            $this->result[$this->index][$tag][]=$attributes;
            //var_dump($parser,$tag,$attributes); 
        }
    }

}

// a simple class to do template replacements on a file. syntax is
// similar to XSL, but only handles <xsl:value-of select="variable"/>
// replacements currently - all other tags are stripped out. this is 
// to not require the XSLT php module
class myTemplate {
   var $template;

   // reads entire file into a variable
   function get($filename) {
      $data=@file($filename);
      if (empty($data)) {   // error
         return FALSE;
      }
      else {
         $this->template=implode("",$data);
         return TRUE;
      }
   }

   // replaces in template for each instance of the fields array
   // fields is indexed by reference
   function process($fields) {
       foreach($fields as $key=>$value) {
          $this->template=str_replace("<xsl:value-of select=\"$key\"/>",
                                      $value, $this->template);
       }
       // strip out other tags that don't end in newlines
       $this->template=preg_replace("'<[\/\!]*?[^<>]*?>'si", "", 
                                    $this->template);
       // strip out all remaining tags that end in newline
       $this->template=preg_replace("'<[\/\!]*?[^<>]*?>\n'si", "", 
                                    $this->template);

       return $this->template;
   }
} // end of class myTemplate

?>
