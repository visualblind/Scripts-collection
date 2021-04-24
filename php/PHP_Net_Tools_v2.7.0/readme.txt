PHP Net Tools

Copyright (C) 2005 Eric Robertson
h4rdc0d3@gmail.com


Please email me with any questions, comments, suggestions, etc.


Introduction:
=============
PHP Net Tools contains many functions to help you retrieve information about a specific domain or IP address.  It is much more advanced then similar web based networking tools I have tested.

This script has fully customizable functions for reverse dns lookup/resolve a host, domain whois, ip whois, ns lookup, dig, ping, traceroute, tracepath, port scanner, nmap, and it can even determine the country in which the target host/ip is located.  Also included is a feature to log various information about each person using the script, which can be opened as a spreadsheet.  In addition, help options are provided for using some of the functions.

Many computer systems log incoming traffic, therefore I would recommend that you password protect this script in some way to prevent misuse.

See changelog.txt for version information.

---------------------------------

Installation:
=============
1. Create a new folder in the www root of your server and copy nettools.php into it.
   (e.g. "nettools/")

2. If you wish the Get Country function to cache the large country list file on the server,
   make sure the script has write permissions (most likely 777) to the folder created in step 1.
   (for more info, see code comments in nettools.php - line 160)

3. The log user info feature also requires write permissions to the folder created in step 1.
   (disabled by default - see nettools.php, line 47, to enable)

---------------------------------

License:
========
PHP Net Tools is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, please visit http://www.gnu.org


Please see gpl.txt for more information.