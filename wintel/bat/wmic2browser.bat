rem Parameters: 
rem     %1 is the wmi class name
rem     %2 is the file name for the output
rem The format type 'hform' creates an entire, functional html page. 
rem The extension is hard-coded so the default application (presumably, a browser) will start for that extension.

rem echo off
rem echo %1 %2
wmic /output:%2.html path %1 get * /format:hform
START "" "%CD%.\%2.html"

rem If other namespaces are required, try:  
rem wmic /output:%2.html /namespace:\\root\... path %1 get * /format:hform
rem wmic /output:%2.html /namespace:\\root\cimv2\security\microsofttpm path %1 get * /format:hform


