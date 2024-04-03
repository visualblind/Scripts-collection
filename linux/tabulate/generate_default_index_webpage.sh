#!/bin/sh


#### Parameters to be Edited ####

MY_TITLE="Browse Folder"
MY_HEADER="Files Present in This Folder"
FILES_TO_BE_SHOWN='*.html *.txt'
default_file_name_required="index.html" # Check with your webserver administrator
# caution : the above parameter will overwrite any existing file
# so, please take backups if required

#### Editing not required beyond this line ####



usage() { echo "Usage: $0 "'-d "your_input_data_delimiter_character" -t "My Title" -h "My Header"' 1>&2; exit 1; }

IFS_CHAR="|"
# MY_TITLE="MY_TITLE"
# MY_HEADER="MY_HEADER"

while getopts "d:t:h:" inp; do
    case "${inp}" in
        d) 
            IFS_CHAR=${OPTARG};;
        t) 
            MY_TITLE=${OPTARG};;
        h) 
            MY_HEADER=${OPTARG};;                        
        *) 
            usage;;   
     esac
done


# Compose the html file with the Header, Body ( Data ) and Footer

echo '<!DOCTYPE html>' > $default_file_name_required
echo '<html>' >> $default_file_name_required
echo '<head>
<meta name="viewport" content="width=device-width, initial-scale=1" charset="ISO-8859-1">' >> $default_file_name_required
echo '<title>'$MY_TITLE'</title>' >> $default_file_name_required
echo '<script>
function myFunction(){
  // Declare variables 
  var input, filter, table, tr, td, i;
  input = document.getElementById("myInput");
  filter = input.value.toUpperCase();
  table = document.getElementById("myTable");
  tr = table.getElementsByTagName("tr");

  // Loop through all table rows, and hide those who do not match the search query
  for (i = 1; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td") ; 
    for(j=0 ; j<td.length ; j++)
    {
      var tdata = td[j] ;
      if (tdata) {
        if (tdata.innerHTML.toUpperCase().indexOf(filter) > -1) {
          tr[i].style.display = "";
          break ; 
        } else {
          tr[i].style.display = "none";
        }
      } 
    }
  }
}
</script>' >> $default_file_name_required

echo >> $default_file_name_required        

echo '<style type="text/css">

table, th, td {
border: 1px solid black;  // changing-colors
// word-wrap: break-word;
}

tr:first-child {
  font-weight: bold;
}

tr:nth-child(even) {background: #eef}  // changing-colors
tr:nth-child(odd) {background: #fee}   // changing-colors

* {
  box-sizing: border-box;
}

#myInput {
  background-image: url("search.png");
  background-position: left center;
  background-repeat: no-repeat;
  width: 94%;
  font-size: 16px;
  padding: 8px 20px 8px 40px;
  border:2px solid Tomato;  // changing-colors
  margin-bottom: 18px;
}

#myTable {
  border-collapse: collapse;
  border: 1px solid #ddd;  // changing-colors
  width: 100%;
  margin-top: 18px;
  // Remove the // in front of the below two lines, to get fixed-width
  // table-layout: fixed;
  // word-wrap: break-word;
  // font-size: 18px;
}

#myTable th, #myTable td {
  text-align: left;
  padding: 12px;
}

#myTable tr {
  border-bottom: 1px solid #ddd;  // changing-colors
}

#myTable tr:first-child:hover, #myTable tr:hover {
  background-color: DarkKhaki;    // changing-colors
}

#myTable tr:first-child {
  background-color: DarkKhaki;    // changing-colors
  font-weight: bold;
}

</style>' >> $default_file_name_required

       echo '</head>' >> $default_file_name_required

       echo '<body>' >> $default_file_name_required

       # changing-colors

       echo '<h2 style="text-align:center;background-color:DodgerBlue;color:White;">'$MY_HEADER'</h2>' >> $default_file_name_required

	   echo '<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search in all Fields...." title="Type in a Search String" autofocus="autofocus">' >> $default_file_name_required       

       echo '<table id="myTable">' >> $default_file_name_required


# the following 10 lines are commented by way of the first and last line characters. Please remove the first and last lines to get fixed-width of columns. Also, adjust the number of col lines and their values, to suit yur input data.
<< --MULTILINE-COMMENT--
       echo '<col width="164" />
             <col width="236" />
             <col width="130" />
             <col width="191" />
             <col width="115" />
             <col width="87" />
             <col width="145" />             
             <col width="126" />' >> $default_file_name_required
--MULTILINE-COMMENT--

# the following 13 lines are commented by way of the first and last line characters. Please remove the first and last lines to get customized table header lines. Also, adjust the number of header lines and header data, to suit your input.
<< --MULTILINE-COMMENT--
       echo '<tr class="header">' >> $default_file_name_required
       echo '<th>Title</th>' >> $default_file_name_required
       echo '<th>Description</th>' >> $default_file_name_required
       echo '<th>Version</th>' >> $default_file_name_required
       # echo '<th>Author</th>' >> $default_file_name_required
       echo '<th>Original-site</th>' >> $default_file_name_required
       echo '<th>License</th>' >> $default_file_name_required
       echo '<th>Size</th>' >> $default_file_name_required
       echo '<th>Extension_by</th>' >> $default_file_name_required
       echo '<th>Tags</th>' >> $default_file_name_required
       echo '</tr>' >> $default_file_name_required
--MULTILINE-COMMENT--

# Read the standard input data file contents into an Array, Check for URLs to Create Hyperlinks and
# Also Substitute html sensitive characters with proper syntax

ls -lt $FILES_TO_BE_SHOWN | grep -v "$default_file_name_required" | awk -v SQ="'" -v fn_last='{print substr($0,index($0,$9),length($0)-index($0,$9)+1)}' '
BEGIN{print "Filename|Bytes|Updated/Created-Month|Updated/Created-Date|Updated/Created-Time"} 
# {print index($0,$9)}
# {print length($0)} 
# {print substr($0,a)}
# {print substr($0,a,length($0)-a)}
# {print substr($0,index($0,$9),length($0)-index($0,$9)+1)}
/^-/{print "<a href=" SQ "./" substr($0,index($0,$9),length($0)-index($0,$9)+1) SQ " target=" SQ "_blank" SQ " rel=" SQ "noopener noreferrer" SQ ">" substr($0,index($0,$9),length($0)-index($0,$9)+1) "</a>" "|" $5 "|" $6 "|" $7 "|" $8 }
END{print "<b>Total Files</b>" "|<b>" (NR) "</b>|"  "|"  "|" }' | sed '/^$/d' | awk -F "$IFS_CHAR" -v header=1 'BEGIN{OFS="\t";}
{
        # gsub(/</, "\\&lt;")
        # gsub(/>/, "\\&gt;")
        # gsub(/&/, "\\&gt;")
        print "\t<tr>"
        for(f = 1; f <=NF; f++)  {
                if(NR == 1 && header) {
                        printf "\t\t<th>%s</th>\n", $f
                }
                else printf "\t\t<td>%s</td>\n", $f
        }
        print "\t</tr>"
}

END {
        print "</table></body></html>"
}' >> $default_file_name_required

