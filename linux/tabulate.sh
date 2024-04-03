#!/bin/bash


usage() { echo "Usage: $0 "'-d "your_input_data_delimiter_character" -t "My Title" -h "My Header"' 1>&2; exit 1; }

IFS_CHAR=$' \t\n'
MY_TITLE="MY_TITLE"
MY_HEADER="MY_HEADER"

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

echo '<!DOCTYPE html>'
echo '<html>'
echo '<head>
<meta name="viewport" content="width=device-width, initial-scale=1" charset="ISO-8859-1">'
echo '<title>'$MY_TITLE'</title>'
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
</script>'

echo        

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

</style>'

       echo '</head>'

       echo '<body>'

       # changing-colors

       echo '<h2 style="text-align:center;background-color:DodgerBlue;color:White;">'$MY_HEADER'</h2>'

	   echo '<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search in all Fields...." title="Type in a Search String" autofocus="autofocus">'       

       echo '<table id="myTable">'


# the following 10 lines are commented by way of the first and last line characters. Please remove the first and last lines to get fixed-width of columns. Also, adjust the number of col lines and their values, to suit yur input data.
<< --MULTILINE-COMMENT--
       echo '<col width="164" />
             <col width="236" />
             <col width="130" />
             <col width="191" />
             <col width="115" />
             <col width="87" />
             <col width="145" />             
             <col width="126" />'
--MULTILINE-COMMENT--

# the following 13 lines are commented by way of the first and last line characters. Please remove the first and last lines to get customized table header lines. Also, adjust the number of header lines and header data, to suit your input.
<< --MULTILINE-COMMENT--
       echo '<tr class="header">'
       echo '<th>Title</th>'
       echo '<th>Description</th>'
       echo '<th>Version</th>'
       # echo '<th>Author</th>'
       echo '<th>Original-site</th>'
       echo '<th>License</th>'
       echo '<th>Size</th>'
       echo '<th>Extension_by</th>'
       echo '<th>Tags</th>'
       echo '</tr>'
--MULTILINE-COMMENT--

# Read the standard input data file contents into an Array, Check for URLs to Create Hyperlinks and
# Also Substitute html sensitive characters with proper syntax

cat - | sed '/^$/d' | while IFS=$IFS_CHAR read -ra line ; do
        echo '<tr>'
        for i in "${line[@]}"; do

            # for hyperlinking a URL, first un-hash the for statement down below ( i.e. remove the starting # character ), save the file and run it as usual, to find out
          	# the column index number of the URL, then hash it as before and modify the 
          	# index number in the if statement further down below ( currently :24 ) and 
          	# un-hash all the statements below it, including the if statement, save the file and run it as usual, to make it to work
       		
         # for index in "${!line[@]}"; do printf "%s:%s\n" "$index" "${line[$index]}"; done

          if [ -n "$i" ]; then	
          	# if [[ ${line[@]:24:1} == "$i" && "$i" =~ ^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/|ftp:\/\/|ftps:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$ ]]; then		
			# 	if [[ ! ( "$i" =~ ^http.*:// || "$i" =~ ^ftp.*:// ) ]]; then			
			# 		i='http://'$i
			# 	fi
			# 	echo '<td><a href="'$i'" target="_blank">'Home Page'</a></td>'          		
			# else
           		echo '<td>'$( echo $i|sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' )'</td>'
           	# fi
          fi
        done
         echo '</tr>'
       done
        echo '</table>'
		echo        

        echo '</body>'
        echo '</html>'

# Un-hash the below line, if you need a compressed gzip file also, for very large files.
# gzip -9 --verbose < $html > $html.gz

