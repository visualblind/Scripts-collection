
  var xhr;

  var url = "";

//  var iterationsLeft=100;  // for load testing
  var iterationsLeft=1;

  var dataSource=4;

  function getRandomInt(min, max) 
    {
    return Math.floor(Math.random() * (max - min + 1)) + min;
    }

  function debugRequest() 
    {
    var currentStatus = "URL: " + url +
                        "  State: " + xhr.readyState.toString() +
                        "  Status: " + xhr.status.toString() +
                        "  Status: " + xhr.statusText;

    document.getElementById('xxx').innerHTML = currentStatus;
    }

 
  function processRequest(e) 
    {
//    debugRequest();

    if (xhr.readyState == 4 && xhr.status == 200) 
      {
      var response = JSON.parse(xhr.responseText);

      if (dataSource == 7)
        {
        alert(xhr.responseText); 
        }

      var serverInfoArray = response.dnsServerInfoArray;

      var toShow = serverInfo2Table(serverInfoArray) + getMoreInfo();

      document.getElementById('xxx').innerHTML = toShow;

      activateAccordian();

      if (iterationsLeft > 0)
        {
        runOnce();
        }
      }

    if (xhr.readyState == 4 && xhr.status == 0) 
      {
//      document.getElementById('xxx').innerHTML = "Probably a timeout, try to reload - or could be site is down";
      }
    }


  function runOnce()
    {
    iterationsLeft--;

    xhr = new XMLHttpRequest();

    url = "http://" + dataSource + "." + getRandomInt(1,100000000).toString() + ".dns.whatsmydnsserver.com/api";

    xhr.open('GET', 
             url,
             true);

    xhr.send();
 
    xhr.onreadystatechange = processRequest;
    }


  function dnsDetective()
    {
    document.getElementById('xxx').innerHTML = "<img src=\"images/gears.gif\" height=\"60\" width=\"60\">;";
    iterationsLeft=1;
    runOnce();
    }

  function dnsDetectiveDebug()
    {
    dataSource=7;
    dnsDetective();
    }




  function serverInfo2Table(serverInfoArray) 
    {
    var table = "";
    table += "<div class=\"Results\">";
    table += "<table cellspacing=20>";

    for (var i in serverInfoArray)
      {
      table += "<tr><td><table class=\"SingleDNSServer\" border=1>";

      var issueStatus = serverInfoArray[i].issues;

      if (issueStatus  == "")
        {
        issueStatus = "Everything is fine";
        }
      else
        {
        issueStatus = issueStatus.replace(/\n/g,
                                          "<br>");
        issueStatus = issueStatus.replace(/  /g,
                                          "&nbsp;&nbsp;");
        }

      table += "<tr>";
      table += "<td class=\"TableHeader\">Your DNS Server</td>" + 
                "<td class=\"TableData\">" + serverInfoArray[i].ipAddress.ipAddress + "</td>";
      table += "</tr>";
      table += "<tr>";
      table += "<td class=\"TableHeader\">Owner of this server</td>" + 
                "<td class=\"TableData\">" + serverInfoArray[i].ipAddress.isp + "</td>";
      table += "</tr>";
      table += "<tr>";
      table += "<td class=\"TableHeader\">Status of this server</td>" + 
                "<td class=\"TableData\">" + issueStatus  + "</td>";
      table += "</tr>";

      table += "</table></td></tr>";
      }

    table += "</table></div>";

    return table;
    }

  function getMoreInfo()
    {
    var more = "";

    more += "<button class=\"accordion\">Click here for more information about your results</button>";
    more += "<div class=\"panel\">";

    more += "<p>";
    more += "The results presented here are sometimes different from what you may expect. ";
    more += "It's important to understand why this is and how to interpret the results shown.";
    more += "</p>";

    more += "<p>";
    more += "Many people configure their computer or router to use a specific DNS server that they prefer (such as Google DNS which is found at 8.8.8.8). ";
    more += "The expectation is that the server at 8.8.8.8 provides your DNS services, but that isn't what really happens. ";
    more += "If it did, that server would be swamped with requests. ";
    more += "Instead, it hands your request off to another server that's part of a large group of servers that it controls. ";
    more += "By doing this, no one server will be completely overwhelmed with requests.";
    more += "</p>";

    more += "<p>";
    more += "The data that's reported here shows the identity of the server that actually processes your requests. ";
    more += "You can verify that it's being run by an organization that you trust. ";
    more += "We also check the reputation of each server that we report to see if it has been flagged by people for doing questionable things.";
    more += "</p>";

    more += "<p>";
    more += "This also explains why if you check your DNS server multiple times using this service you'll often receive different IP addresses. ";
    more += "This happens because each IP address represents a different server in the \"group\".";
    more += "</p>";

    more += "</div>";

    return more;
    }







