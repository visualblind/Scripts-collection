@if (@X)==(@Y) @end /* Harmless hybrid line that begins a JScript comment
@goto :Batch

::JREN.BAT version 2.7 by Dave Benham
::
::  Release History:
::    2.7  2016-12-15: Added /NKEEP option.
::    2.6  2016-07-10: Fixed bug in ts() offset computations when the before and
::                     after have different timezones due to daylight savings.
::                     Added olm: and old: options to the ts() function to allow
::                     the addition of months/years without changing the local hour.
::                     In other words, the computation compensates for changes in
::                     dayling savings conditions.
::    2.4  2015-07-15: Added /?? and /??TS() paged help options
::    2.3  2015-03-03: Ignore invalid characters if /LIST mode
::                     Bug fix - abort if invalid character with /T mode
::    2.2  2014-12-10: Bug fix - forgot to make the search regex global
::    2.1  2014-12-10: Additional dt: options for FileSystemObject timestamps
::    2.0  2014-12-07: New /LIST option.
::                     Added ts() function and /?ts() documentation
::                     Many new JScript functions for use with /J with /LIST
::                     Added GOTO at top to improve startup performance
::    1.1  2014-12-02: Options may be prefaced with / or -
::                     Corrected some documentation
::    1.0  2014-11-30: Initial release
::
::============ Documentation ===========
:::
:::JREN  Search  Replace  [/Option  [Value]]...
:::JREN  /?[REGEX|REPLACE|VERSION|TS()]
:::JREN  /??[ts()]
:::
:::  Rename files in the current directory by performing a regular expression
:::  search/replace on the old file name to generate the new file name.
:::  This includes read only, hidden, and system files.
:::
:::  Search  - By default, this is a case sensitive JScript (ECMA) regular
:::            expression expressed as a string. The search is applied globally
:::            to the entire file name.
:::
:::            JScript regex syntax documentation is available at
:::            http://msdn.microsoft.com/en-us/library/ae5bf541(v=vs.80).aspx
:::
:::  Replace - By default, this is the string to be used as a replacement for
:::            each found search expression. Full support is provided for
:::            substituion patterns available to the JScript replace method.
:::
:::            For example, $& represents the portion of the source that matched
:::            the entire search pattern, $1 represents the first captured
:::            submatch, $2 the second captured submatch, etc. A $ literal
:::            can be escaped as $$.
:::
:::            An empty replacement string must be represented as "".
:::
:::            Replace substitution pattern syntax is fully documented at
:::            http://msdn.microsoft.com/en-US/library/efy6s3e6(v=vs.80).aspx
:::
:::  Options:  Behavior may be altered by appending one or more options.
:::  The option names are case insensitive, and may appear in any order
:::  after the Replace argument. Options may be prefaced with / or -
:::
:::      /D  - Rename Directories instead of files.
:::
:::      /FM FileOrFolderMask
:::
:::            Only rename files or folders that match any of the pattern(s)
:::            using standard wildcards. Multiple patterns are delimited by a
:::            pipe (|). Only complete name matches count.
:::
:::              * matches any 0 or more characters
:::              ? matches any 0 or 1 character except .
:::
:::      /FX FileOrFolderExclusion
:::
:::            Exclude files or folders that match any of the pattern(s)
:::            using standard wildcards. Multiple patterns are delimited by a
:::            pipe (|). Only complete name matches count.
:::
:::              * matches any 0 or more characters
:::              ? matches any 0 or 1 character except .
:::
:::      /I  - Ignore case when matching.
:::
:::      /J  - Treat Replace as a JScript expression.
:::            The following variables contain details about each match:
:::
:::              $0 = the substring that matched the Search
:::              $1 through $n = captured submatch strings
:::              $off = the offset where the match occurred
:::              $src = the original source string
:::
:::            The following are also available:
:::
:::              $n = An incrementing number for use in the name. The value
:::                   is reset to the /NBEG value for each directory.
:::                   It increases by the /NINC value for each renamed file.
:::                   The value may be zero padded to the width specified by
:::                   the /NPAD value.
:::
:::              lc(str)
:::
:::                 Convert str to lower case. Shorthand for str.toLowerCase().
:::
:::              uc(str)
:::
:::                 Convert str to upper case. Shorthand for str.toUpperCase().
:::
:::              lpad(string,pad)
:::
:::                 Used to left pad string str to a minimum length. If the
:::                 str already has length >= the pad string length, then no
:::                 change is made. Otherwise it left pads the value with the
:::                 characters of the pad string to the length of pad.
:::
:::                 Examples:
:::                    lpad(15,'0000')    returns "0015"
:::                    lpad(15,'    ')    returns "  15"
:::                    lpad(19011,'0000') returns "19011"
:::
:::              rpad(string,pad)
:::
:::                 Used to right pad the string to a minimum length. If the
:::                 str already has length >= the pad string length, then no
:::                 change is made. Otherwise it right pads the value with the
:::                 characters of the pad string to the length of pad.
:::
:::              ts( {option:value, option:value...} )
:::
:::                 Perform date/time computations and produce formatted
:::                 timestamps. This function can get the current date/and time,
:::                 or get the created/lastModified/lastAccessed timestamps for
:::                 the file being renamed, or parse a date/time from the name
:::                 of the file, or use a user specified value.
:::
:::                 Use JREN /?TS() to get help on the ts() function
:::
:::              attr( [offChar] )
:::
:::                 Lists the attributes of the file/folder. Set attributes are
:::                 listed in upper case and unset attributes are shown as the
:::                 offChar, or lower case. The listed attributes are:
:::                   R - Read Only
:::                   H - Hidden
:::                   S - System
:::                   A - Archive
:::                   L - Link or Shortcut
:::                   C - Compressed
:::
:::              size( [pad] )
:::
:::                 File/folder size, optionally left padded to the length of
:::                 the pad string.
:::
:::              type( [pad] )
:::
:::                 File/folder type, optionally right padded to the length of
:::                 the pad string.
:::
:::              name( [pad] )
:::
:::                 Name of the file/folder, optionally right padded to
:::                 the length of the pad string.
:::
:::              path( [pad] )
:::
:::                 Full Path of file/folder, optionally right padded to
:::                 the length of the pad string.
:::
:::              parent( [pad] )
:::
:::                 Path of the parent folder, optionally right padded to
:::                 the length of the pad string.
:::
:::              sName( [pad ])
:::
:::                 Short (8.3) name of the file/folder, optionally right padded
:::                 to the length of the pad string.
:::
:::              sPath( [pad] )
:::
:::                 Path of the file/folder using short (8.3) names, optionally
:::                 right padded to the length of the pad string.
:::
:::              sParent( [pad] )
:::
:::                 Path of the parent folder using short (8.3) names,
:::                 optionally right padded to the length of the pad string.
:::
:::      /L  - Convert names to Lower case. Entire names can be converted to
:::            lower case without any other changes by using empty strings ("")
:::            for both Search and Replace.
:::
:::      /LIST - List the Rename results only, without quotes, and without
:::            renaming anything. Invalid file name characters are ignored.
:::            The resulting "name" is always listed, even if no change.
:::
:::      /NBEG BeginValue
:::
:::            Specifies the initial $n value. The value will be reset for each
:::            folder unless the /NKEEP option is given. The value must be an
:::            integer >= 0. The default value is 1.
:::
:::      /NINC IncrementValue
:::
:::            Specifies the amount $n is incremented after each rename.
:::            The value must be an integer >=1. The default value is 1.
:::
:::      /NKEEP - Do not reset $n with each folder. Note that child folders
:::            are processed before parents, so a child folder will likely
:::            receive the initial /NBEG value.
:::
:::      /NPAD MinWidth
:::
:::            Specifies the minimum width for each $n value. If the $n value
:::            has fewer digits than MinWidth, then the value is zero padded
:::            on the left to achieve the MinWidth. The value must be >= 1.
:::            The default value is 3.
:::
:::      /P RootPath
:::
:::            Specifies the path where the rename is to take place.
:::            The default of . represents the current directory.
:::            Wildcards are not allowed.
:::
:::      /PM PathMask
:::
:::            Only rename files or folders whose parent folder path matches
:::            any of the PathMask pattern(s) using augmented wildcards.
:::            Multiple patterns are delimited by a pipe (|). Only full path
:::            matches count.
:::
:::              /P:  matches the root path specified by option /P
:::              **   matches any 0 or more characters
:::              *    matches any 0 or more characters except \
:::              ?    matches any 0 or 1 character except . or \
:::
:::           This option is only useful if the /S option is used.
:::
:::      /PX PathExclusion
:::
:::            Exclude files or folders whose parent folder path matches any
:::            of the PathExclusion pattern(s) using augmented wildcards.
:::            Multiple patterns are delimited by a pipe (|). Only full path
:::            matches count.
:::
:::              /P:  matches the root path specified by option /P
:::              **   matches any 0 or more characters
:::              *    matches any 0 or more characters except \
:::              ?    matches any 0 or 1 character except . or \
:::
:::           This option is only useful if the /S option is used.
:::
:::      /Q  - Do not list the renamed files/folders (Quiet mode).
:::
:::      /RFM RegexFileOrFoldereMask
:::
:::            Only rename files or folders that match the regular expression,
:::            ignoring case. Partial name matches count.
:::
:::      /RFX RegexFileOrFolderExclusion
:::
:::            Exclude files or folders that match the regular Expression,
:::            ignoring case. Partial name matches count.
:::
:::      /RPM RegexPathMask
:::
:::            Only rename files or folders whose parent folder path matches the
:::            RegexPathMask regular expression, ignoring case. Partial path
:::            matches count. This option is really only useful if the /S
:::            option is used.
:::
:::      /RPX RegexPathExclusion
:::
:::            Exclude files or folders whose parent folder path matches the
:::            RegexPathExclusion regular expression, ignoring case. Partial
:::            path matches count. This option is really only useful if the
:::            /S option is used.
:::
:::      /S  - Recurse Subdirectories.
:::
:::      /T  - List the rename operations that would be attempted,
:::            but do not rename anything. (Test mode)
:::
:::      /U  - Convert names to Upper case. Entire names can be converted to
:::            upper case without any other changes by using empty strings ("")
:::            for both Search and Replace.
:::
:::  Help is available by supplying a single argument beginning with /?:
:::
:::      /?        - Writes this help documentation to stdout.
:::      /??       - Same as /? except uses MORE to provide pagination
:::
:::      /?REGEX   - Opens up Microsoft's JScript regular expression
:::                  documentation within your browser.
:::
:::      /?REPLACE - Opens up Microsoft's JScript REPLACE documentation
:::                  within your browser.
:::
:::      /?VERSION - Writes the JREN version number to stdout.
:::
:::      /?TS()    - Writes documentation for the ts() function to stdout.
:::      /??TS()   - Same as /??TS() except uses MORE for pagination.
:::
:::  JREN.BAT was written by Dave Benham, and originally posted at
:::  http://www.dostips.com/forum/viewtopic.php?f=3&t=6081
:::
:: =============== ts() documentation ===============
::+
::+ts( [ { [option:value [,option:value]...] } ] )
::+  
::+  A JScript function that can performs date and time computations and return
::+  a formatted time string.
::+  
::+  The option object argument within curly braces is optional - if no argument
::+  is given, then it returns the current timestamp using compressed ISO 8601
::+  format with milliseconds and local time zone - YYYYMMDDThhmmss.fff+zzzz
::+  
::+    Examples:
::+      ts()  - Current date/time:  YYYYMMDDThhmmss.fff+zzzz
::+      ts({dt:'created',fmt:'{iso-dt}'})  - The file create date:  YYYY-MM-DD
::+      ts({od:-1,fmt:'{YYYY}_{MM}_{DD}'}) - Yesterday's date:  YYYY_MM_DD
::+  
::+  Option names are case sensitive. There are 5 types of options:
::+    1) Specify the base date          - dt:
::+    2) Specify date/time offsets      - oy: om: od: oh: on: os: of:
::+    3) Specify the output time zone   - tz:
::+    4) Specify the output format      - fmt:
::+    5) Configure the day-of-week and  - wkd: weekday: mth: month:
::+       month names for non-English
::+       users
::+
::+  Specify the base date and time
::+
::+    dt:  Value specifies the base date and time. Many formats supported:
::+
::+      Current local date/time
::+        - do not specify a dt: value
::+        - undefined value
::+        - empty string ''
::+
::+        Examples:
::+          dt:''
::+          dt:undefined
::+
::+      Milliseconds since 1970-01-01 00:00:00 UTC
::+        - NumericExpression (math OK)
::+        - NumericString (no math)
::+
::+        Examples:
::+          dt: 1391230800000          = January 1, 19970 00:00:00 UTC
::+          dt: 1391230000000+800000   = January 1, 19970 00:00:00 UTC
::+          dt:'1391230800000'         = January 1, 19970 00:00:00 UTC
::+          dt:'1391230000000+800000'  = error
::+
::+      String timestamp representation
::+        - Any string accepted by the JScript Date.Parse() method.
::+            See http://msdn.microsoft.com/en-us/library/k4w173wk(v=vs.84).aspx
::+
::+        Examples: All of the following represent Midnight on January 4, 2013
::+                  assuming local time zone is U.S Eastern Standard Time (EST)
::+
::+          dt:'1-4-2013'                  Defaults to local time zone
::+          dt:'January 4, 2013 EST'       Explicit Eastern Std Time (US)
::+          dt:'2013/1/4 -05'              Explicit Eastern Std Time (US)
::+          dt:'Jan 3 2013 23: CST'        Central Standard Time (US)
::+          dt:'2013 3 Jan 9:00 pm -0800'  Pacific Standard Time (US)
::+          dt:'01/04/2013 05:00:00 UTC'   Universal Coordinated Time
::+          dt:'1/4/2013 05:30 +0530'      India Standard Time
::+
::+      File timestamps to millisecond accuracy using WMI. Very slow, but
::+      locale agnostic. WMI call may not work on some older machines.
::+        - 'created'   = Creation date/time of the file
::+        - 'modified'  = Last Modified date/time of the file
::+        - 'accessed'  = Last Accessed date/time of the file
::+
::+        Example:
::+          dt:'created'  = creation date/time of the file to be renamed
::+
::+      File timestamps to second accuracy using FileSystemObject. Very fast,
::+      but locale dependent. May not parse properly for some countries.
::+        - 'fsoCreated'  = Creation date/time of the file
::+        - 'fsoModified' = Last Modified date/time of the file
::+        - 'fsoAccessed' = Last Accessed date/time of the file
::+
::+      Array with 2 to 7 numeric expressions (local time only)
::+        - [year,months,days,hours,minutes,seconds,milliseconds]
::+            year and months are required, the rest are optional
::+            Missing values are assumed to be 0
::+            Missing values are not allowed between specified values
::+            month 0 = January
::+            day 1 = First day of month, day 0 = Last day of prior month
::+
::+          Examples:
::+            dt:[2014,3,1,17,30,22,457]  = April 1, 2014, 17:30:22.457
::+            dt:[2014,0,1]               = January 1, 2014, 00:00:00
::+            dt:[2014,0]                 = December 31, 2013, 00:00:00
::+            dt:[2014,,10]               = error
::+
::+  Date/Time offsets and time zone options all use the same syntax.
::+  The value represents a numeric offset for the specified time unit.
::+  It may be expressed as a numeric expression (math allowed), or
::+  a numeric string (no math allowed). Both positive and negative
::+  values may be used.
::+
::+    oy:  Year offset
::+    om:  Months offset
::+    od:  Days offset
::+    oh:  Hours offset
::+    on:  Minutes offset
::+    os:  Seconds offset
::+    of:  Milliseconds (Fractional seconds) offset
::+
::+    olm: LocalMonths offset (adjusted for changes in daylight savings)
::+    old: LocalDays offset (adjusted for changes in daylight savings)
::+
::+    tz:  Time zone used for output = minutes offset from UTC
::+
::+  The fmt: option is a string that specifies the format of the output.
::+  Strings within curly braces are replaced by dynamic components that are
::+  derived from the computed time stamp. Strings within braces that do not
::+  match a fmt: component are left as is. Strings not in braces are left
::+  as is. The format component names are not case senstive.
::+
::+  For example, a U.S. date would be represented as fmt:'{yyyy}/{mm}/{dd}'
::+
::+  The default format is '{ISOTS}', which yields YYYYMMDDThhmmss.fff+hhmm
::+
::+    {YYYY}  4 digit year, zero padded
::+
::+    {YY}    2 digit year, zero padded
::+
::+    {Y}     year without zero padding
::+
::+    {MONTH} month name
::+
::+    {MTH}   month abbreviation
::+
::+    {MM}    2 digit month, zero padded
::+
::+    {M}     month without zero padding
::+
::+    {WEEKDAY} day of week name
::+
::+    {WKD}   day of week abbreviation
::+
::+    {W}     day of week number, 0=Sunday
::+
::+    {DD}    2 digit day, zero padded
::+
::+    {D}     day without zero padding
::+
::+    {HH}    2 digit hours, 24 hour format, zero padded
::+
::+    {H}     hours, 24 hour format without zero padding
::+
::+    {HH12}  2 digit hours, 12 hour format, zero padded
::+
::+    {H12}   hours, 12 hour format without zero padding
::+
::+    {NN}    2 digit minutes, zero padded
::+
::+    {N}     minutes without padding
::+
::+    {SS}    2 digit seconds, zero padded
::+
::+    {S}     seconds without padding
::+
::+    {FFF}   3 digit milliseconds, zero padded
::+
::+    {F}     milliseconds without padding
::+
::+    {AM}    AM or PM in upper case
::+
::+    {PM}    am or pm in lower case
::+
::+    {ZZZZ}  timezone expressed as minutes offset from UTC,
::+            zero padded to 3 digits with sign
::+
::+    {Z}     timzone minutes offset from UTC without padding
::+
::+    {ZS}    timezone sign
::+
::+    {ZH}    timezone hours hours offset from UTC, (no sign),
::+            padded to 2 digits
::+
::+    {ZM}    timezone minutes offset from UTC (no sign),
::+            padded to 2 digits
::+
::+    {ISOTS} YYYYMMDDThhmmss.fff+hhss
::+            Compressed ISO 8601 date/time (timestamp) with milliseconds
::+            and time zone
::+
::+    {ISODT} YYYYMMDD
::+            Compressed ISO 8601 date format
::+
::+    {ISOTM} hhmmss.fff
::+            Compressed ISO 8601 time format with milliseconds
::+
::+    {ISOTZ} +hhmm
::+            Compressed ISO 8601 timezone format
::+
::+    {ISO-TS} YYYY-MM-DDThh:mm:ss.fff+hh:ss
::+             ISO 8601 date/time (timestamp) with milliseconds and time zone
::+
::+    {ISO-DT} YYYY-MM-DD
::+             ISO 8601 date format
::+
::+    {ISO-TM} hh:mm:ss.fff
::+             ISO 8601 time format with milliseconds
::+
::+    {ISO-TZ} +hh:mm
::+             ISO 8601 timezone
::+
::+    {U}     Unix Epoch time: same as {US}
::+            Seconds since 1970-01-01 00:00:00 UTC.
::+            Negative numbers represent dates prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {UMS}   Milliseconds since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {US}    Seconds since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {UM}    Minutes since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {UH}    Hours since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {UD}    Days since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {USD}   Decimal seconds since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {UMD}   Decimal minutes since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {UHD}   Decimal hours since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {UDD}   Decimal days since 1970-01-01 00:00:00.000 UTC.
::+            Negative numbers represent days prior to 1970-01-01.
::+            This value should not be used with the -TZ option
::+
::+    {{}     A { character
::+
::+  The following options override the default English names for the months
::+  and days of the week. The value for each option is a space delimited list
::+  of names or abbreviations.
::+
::+    wkd: Day of week abbreviations
::+         default = 'Sun Mon Tue Wed Thu Fri Sat'
::+
::+    weekday: Day of week names
::+         default = 'Sunday Monday Tuesday Wednesday Thursday Friday'
::+
::+    mth: Month abbreviations
::+         default = 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'
::+
::+    month: Month names
::+         default = 'January February March April May Jun July August'
::+                 + ' September October November December'
::+
============= :Batch portion ============
@echo off
setlocal disableDelayedExpansion

if .%2 equ . (
  set "test=%~1"
  setlocal enableDelayedExpansion
  if "!test:~0,1!" equ "-" set "test=/!test:~1!"
  if "!test!" equ "/?" (
    for /f "tokens=* delims=:" %%A in ('findstr "^:::" "%~f0"') do @echo(%%A
    exit /b 0
  ) else if "!test!" equ "/??" 2>nul (
    (for /f "tokens=* delims=:" %%A in ('findstr "^:::" "%~f0"') do @echo(%%A)|more /e
    exit /b 0
  ) else if /i "!test!" equ "/?ts()" (
    for /f "tokens=* delims=:+" %%A in ('findstr "^::+" "%~f0"') do @echo(%%A
    exit /b 0
  ) else if /i "!test!" equ "/??ts()" 2>nul (
    (for /f "tokens=* delims=:+" %%A in ('findstr "^::+" "%~f0"') do @echo(%%A)|more /e
    exit /b 0
  ) else if /i "!test!" equ "/?regex" (
    explorer "http://msdn.microsoft.com/en-us/library/ae5bf541(v=vs.80).aspx"
    exit /b 0
  ) else if /i "!test!" equ "/?replace" (
    explorer "http://msdn.microsoft.com/en-US/library/efy6s3e6(v=vs.80).aspx"
    exit /b 0
  ) else if /i "!test!" equ "/?version" (
    for /f "tokens=* delims=:" %%A in ('findstr "^::JREN\.BAT" "%~f0"') do @echo(%%A
    exit /b 0
  ) else (
    call :err "Insufficient arguments"
    exit /b 2
  )
)

:: Define options
set "options= /D: /FM:"" /FX:"" /I: /J: /L: /LIST: /NBEG:1 /NINC:1 /NKEEP: /NPAD:3 /P:. /PM:"" /PX:"" /RFM:"" /RFX:"" /RPM:"" /RPX:"" /Q: /S: /T: /U: "

:: Set default option values
for %%O in (%options%) do for /f "tokens=1,* delims=:" %%A in ("%%O") do set "%%A=%%~B"

:: Get options
:loop
if not "%~3"=="" (
  set "test=%~3"
  setlocal enableDelayedExpansion
  if "!test:~0,1!" equ "-" set "test=/!test:~1!"
  if "!test:~0,1!" neq "/" (
    call :err "Too many arguments"
    exit /b 2
  )
  for /f "delims=" %%A in ("!test!") do (
    set "test=!options:*%%A:=! "
    if "!test!"=="!options! " (
        endlocal
        call :err "Invalid option %~3"
        exit /b 2
    ) else if "!test:~0,1!"==" " (
        endlocal
        set "%%A=1"
        if /i "%%A" equ "/L" set "/U="
        if /i "%%A" equ "/U" set "/L="
    ) else (
        endlocal
        if %4. equ . (
          call :err "Missing %~3 value"
          exit /b 2
        )
        set "%%A=%~4"
        shift /3
    )
  )
  shift /3
  goto :loop
)

:: Execute
cscript //E:JScript //nologo "%~f0" %1 %2
exit /b %errorlevel%

:err
>&2 (
  echo ERROR: %~1
)
exit /b

************* JScript portion **********/
var $n
var _g=new Object();
try {

  _g.defineReplFunc=function() {
    eval(_g.replFunc);
  }

  _g.main=function() {

    function err( msg, rtn ) {
      WScript.StdErr.WriteLine(msg);
      if (rtn) WScript.Quit(rtn);
    }

    function BuildRegex( loc, regex, options ) {
      try {
        return regex ? new RegExp( regex, options ) : false;
      } catch(e) {
        err( 'Invalid '+loc+' regular expression: '+e.message, 1);
      }
    }

    function GetInt( loc, numStr, minVal ) {
      var n = parseInt( numStr );
      if (isNaN(n) || n<minVal) {
        err( 'Error: Invalid '+loc+' value', 1 );
      }
      return n;
    }

    var env = WScript.CreateObject("WScript.Shell").Environment("Process"),
        fso = new ActiveXObject("Scripting.FileSystemObject");

    try {
      var root = fso.GetFolder( env('/P') );
    } catch(e) {
      err( 'Invalid /P path: '+e.message, 1 );
    }

    function MaskRepl($0) {
      switch ($0) {
        case '/P:':
        case '/p:': return root.Path.replace(/[.^$*+?()[{\\|]/g,"\\$&");
        case '**':  return '.*';
        case '*':   return '[^\\\\]*';
        case '?':   return '[^\\\\.]?';
        default:    return '\\'+$0;
      }
    }

    var args=WScript.Arguments,
        search = BuildRegex( 'Search', args.Item(0), env('/I')?'gi':'g' ),
        replace=args.Item(1),
        rMask = BuildRegex( '/RFM', env('/RFM'), 'i' ),
        rExclude = BuildRegex( '/RFX', env('/RFX'), 'i' ),
        rPathMask = BuildRegex( '/RPM', env('/RPM'), 'i' ),
        rPathExclude = BuildRegex( '/RPX', env('/RPX'), 'i' ),
        regex = new RegExp("/P:|[*][*]|[*]|[?]|[.^$+()[{\\\\]","ig");
        mask = env('/FM') ? new RegExp( '^(?:' + env('/FM').replace(regex,MaskRepl) + ')$', 'i' ) : false;
        exclude = env('/FX') ? new RegExp( '^(?:' + env('/FX').replace(regex,MaskRepl) + ')$', 'i' ) : false;
        pathMask = env('/PM') ? new RegExp( '^(?:' + env('/PM').replace(regex,MaskRepl) + ')$', 'i' ) : false;
        pathExclude = env('/PX') ? new RegExp( '^(?:' + env('/PX').replace(regex,MaskRepl) + ')$', 'i' ) : false;
        upper = env('/U'),
        lower = env('/L'),
        recurse = env('/S'),
        jscript = env('/J'),
        list = env('/LIST'),
        beg = GetInt( '/NBEG', env('/NBEG'), 0 ),
        inc = GetInt( '/NINC', env('/NINC'), 1 ),
        pad = GetInt( '/NPAD', env('/NPAD'), 1 ),
        keep = env('/NKEEP'),
        padStr = Array( pad+1 ).join('0'),
        test = env('/T'),
        quiet = env('/Q');

    var num = beg;

    _g.dirs = env('/D');

    function ProcessFolder( folder ) {
      var i, a=[];
      if (!keep) eval('var num = beg');
      if (recurse || _g.dirs) {
        var folders = new Enumerator(folder.SubFolders);
        for( i=0 ; !folders.atEnd(); folders.moveNext()) {
          a[i++]=folders.item()
          if (recurse) ProcessFolder(folders.item());
        }
      }
      if ( (!pathMask || pathMask.test(folder.Path)) &&
           (!rPathMask || rPathMask.test(folder.Path)) &&
           (!pathExclude || !pathExclude.test(folder.Path)) &&
           (!rPathExclude || !rPathExclude.test(folder.Path)) ) {
        if (!_g.dirs) {
          a=[];
          var files = new Enumerator(folder.Files);
          for (i=0; !files.atEnd(); files.moveNext()) a[i++]=files.item();
        }
        for (i=0; i<a.length; i++) {
          _g.file = a[i];
          _g.wmiFile = undefined;
          var oldName = a[i].Name;
          if ( (!mask || mask.test(oldName)) &&
               (!rMask || rMask.test(oldName)) &&
               (!exclude || !exclude.test(oldName)) &&
               (!rExclude || !rExclude.test(oldName)) ) {
            if (jscript) {
              $n = num.toString();
              if ($n.length<pad) $n = (padStr+$n).slice(-pad);
            }
            try {
              var newName = oldName.replace( search, replace );
            } catch(e) {
              err( 'Replace error: '+e.message, 1 );
            }
            if (!list) newName=newName.replace( /[ .]+$/, "" );
            if (jscript && !list && newName.search(/[<>|:/\\*?"\x00-\x1F]/)>=0) err('Error: Invalid file name character in Replace',1);
            if (upper) newName = uc(newName);
            if (lower) newName = lc(newName);
            if (newName != oldName || list) {
              try {
                var oldPath=a[i].Path;
                if (!test && !list) {
                  if (a[i].Name.toUpperCase() == newName.toUpperCase()) a[i].Name = '_{JREN_tempName}_';
                  a[i].Name = newName;
                }
                if (list) WScript.echo(newName);
                else if (!quiet) WScript.echo( '"'+oldPath+'"  -->  "'+newName+'"' );
              } catch(e) {
                if (a[i].Name != oldName) a[i].Name = oldName;
                err( 'Unable to rename "'+a[i].Path+'"  -->  "'+newName+'" : "'+e.message, 0 );
              }
              num+=inc;
            }
          }
        }
      }
    }

    if (jscript) {
      var regex=new RegExp('.|'+search,''),
          cnt;
      'x'.replace( regex, function(){cnt=arguments.length-2; return '';} );
      _g.replFunc='_g.replFunc=function($0';
      for (var i=1; i<cnt; i++) _g.replFunc+=',$'+i;
      _g.replFunc+=',$off,$src){return eval(_g.replace);}';
      _g.defineReplFunc();
      _g.replace = replace;
      replace = _g.replFunc;
    } else if (!list && replace.search(/[<>|:/\\*?"\x00-\x1F]/)>=0) err('Error: Invalid file name character in Replace',1);

    ProcessFolder( root );
    WScript.Quit(0);
  }

  _g.main();

} catch(e) {
  WScript.StdErr.WriteLine("JScript runtime error: "+e.message);
  WScript.Quit(1);
}

function lc(str) { return str.toLowerCase(); }

function uc(str) { return str.toUpperCase(); }

function lpad( val, pad ) {
  if (!pad) pad='';
  var rtn=val.toString();
  return (rtn.length<pad.length) ? (pad+rtn).slice(-pad.length) : val;
}

function rpad( val, pad ) {
  if (!pad) pad='';
  var rtn=val.toString();
  return (rtn.length<pad.length) ? (rtn+pad).slice(0,pad.length) : val;
}

function ts(opt) {
  if (opt===undefined) opt={};
  if (opt.constructor !== Object) badOp('ts()');
  if (!opt.wkd)     opt.wkd='Sun Mon Tue Wed Thu Fri Sat';
  if (!opt.weekday) opt.weekday='Sunday Monday Tuesday Wednesday Thursday Friday Saturday';
  if (!opt.mth)     opt.mth='Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec';
  if (!opt.month)   opt.month='January February March April May June July August September October November December';
  if (!opt.fmt)     opt.fmt='{isots}';

  var wkd     = opt.wkd.split(' '),
      weekday = opt.weekday.split(' '),
      mth     = opt.mth.split(' '),
      month   = opt.month.split(' '),
      y,m,d,w,h,h12,n,s,f,u,z,zs,za, dt,
      sp=' ', ps='/', pc=':', pd='-', pp='.', p2='00', p3='000', p4='0000';
  if (wkd.length!=7)     badOp('wkd');
  if (weekday.length!=7) badOp('weekday');
  if (mth.length!=12)    badOp('mth');
  if (month.length!=12)  badOp('month');

  dt = getDt(opt.dt);
  if (opt.oy) dt.setUTCFullYear(     dt.getUTCFullYear()    +getNum('oy'));
  if (opt.om) dt.setUTCMonth(        dt.getUTCMonth()       +getNum('om'));
  if (opt.od) dt.setUTCDate(         dt.getUTCDate()        +getNum('od'));
  if (opt.oh) dt.setUTCHours(        dt.getUTCHours()       +getNum('oh'));
  if (opt.on) dt.setUTCMinutes(      dt.getUTCMinutes()     +getNum('on'));
  if (opt.os) dt.setUTCSeconds(      dt.getUTCSeconds()     +getNum('os'));
  if (opt.of) dt.setUTCMilliseconds( dt.getUTCMilliseconds()+getNum('of'));
  if (opt.tz) dt.setUTCMinutes(      dt.getUTCMinutes()  +(z=getNum('tz')));

  if (opt.olm) dt.setMonth(        dt.getMonth()       +getNum('olm'));
  if (opt.old) dt.setDate(         dt.getDate()        +getNum('old'));

  y = opt.tz!==undefined ? dt.getUTCFullYear(): dt.getFullYear();
  m = opt.tz!==undefined ? dt.getUTCMonth()   : dt.getMonth();
  d = opt.tz!==undefined ? dt.getUTCDate()    : dt.getDate();
  w = opt.tz!==undefined ? dt.getUTCDay()     : dt.getDay();
  h = opt.tz!==undefined ? dt.getUTCHours()   : dt.getHours();
  n = opt.tz!==undefined ? dt.getUTCMinutes() : dt.getMinutes();
  s = opt.tz!==undefined ? dt.getUTCSeconds() : dt.getSeconds();
  f = opt.tz!==undefined ? dt.getUTCMilliseconds() : dt.getMilliseconds();
  u = dt.getTime();

  h12 = h%12;
  if (!h12) h12=12;

  if (!opt.tz) z=-dt.getTimezoneOffset();
  zs = z<0 ? '-' : '+';
  za = Math.abs(z);

  return opt.fmt.replace( /\{(.*?)\}/gi, repl );

  function getNum( v ) {
    var rtn = Number(opt[v]);
    if (isNaN(rtn-rtn)) badOp(v);
    return rtn;
  }

  function getDt( v ) {
    var dt, n;
    if (v===undefined) {
      dt = new Date();
    } else switch (v.constructor) {
      case Date:
      case Number:
        dt = new Date(v);
        break;
      case Array:
        try {dt=eval( 'new Date('+v.join(',')+')' )} catch(e){}
        break;
      case String:
        switch (v.toLowerCase()) {
          case '':         dt = new Date(); break;
          case 'created':  dt = getWmiDt('c'); break;
          case 'modified': dt = getWmiDt('m'); break;
          case 'accessed': dt = getWmiDt('a'); break;
          case 'fsocreated':  dt = new Date(_g.file.DateCreated); break;
          case 'fsomodified': dt = new Date(_g.file.DateLastModified); break;
          case 'fsoaccessed': dt = new Date(_g.file.DateLastAccessed); break;
          default:
            n=Number(v);
            if (isNaN(n-n)) dt = new Date(v);
            else            dt = new Date(n);
            break;
        }
        break;
    }
    if (isNaN(dt)) badOp('dt');
    return dt;
  }
 
  function badOp(option) {
    throw new Error('Invalid '+option+' value');
  }

  function trunc( n ) { return Math[n>0?"floor":"ceil"](n); }
 
  function repl($0,$1) {
    switch ($1.toUpperCase()) {
      case 'YYYY' : return lpad(y,p4);
      case 'YY'   : return (p2+y.toString()).slice(-2);
      case 'Y'    : return y.toString();
      case 'MM'   : return lpad(m+1,p2);
      case 'M'    : return (m+1).toString();
      case 'DD'   : return lpad(d,p2);
      case 'D'    : return d.toString();
      case 'W'    : return w.toString();
      case 'HH'   : return lpad(h,p2);
      case 'H'    : return h.toString();
      case 'HH12' : return lpad(h12,p2);
      case 'H12'  : return h12.toString();
      case 'NN'   : return lpad(n,p2);
      case 'N'    : return n.toString();
      case 'SS'   : return lpad(s,p2);
      case 'S'    : return s.toString();
      case 'FFF'  : return lpad(f,p3);
      case 'F'    : return f.toString();
      case 'AM'   : return h>=12 ? 'PM' : 'AM';
      case 'PM'   : return h>=12 ? 'pm' : 'am';
      case 'UMS'  : return u.toString();
      case 'USD'  : return (u/1000).toString();
      case 'UMD'  : return (u/1000/60).toString();
      case 'UHD'  : return (u/1000/60/60).toString();
      case 'UDD'  : return (u/1000/60/60/24).toString();
      case 'U'    : return trunc(u/1000).toString();
      case 'US'   : return trunc(u/1000).toString();
      case 'UM'   : return trunc(u/1000/60).toString();
      case 'UH'   : return trunc(u/1000/60/60).toString();
      case 'UD'   : return trunc(u/1000/60/60/24).toString();
      case 'ZZZZ' : return zs+lpad(za,p3);
      case 'Z'    : return z.toString();
      case 'ZS'   : return zs;
      case 'ZH'   : return lpad(trunc(za/60),p2);
      case 'ZM'   : return lpad(za%60,p2);
      case 'ISOTS'  : return ''+lpad(y,p4)+lpad(m+1,p2)+lpad(d,p2)+'T'+lpad(h,p2)+lpad(n,p2)+lpad(s,p2)+pp+lpad(f,p3)+zs+lpad(trunc(za/60),p2)+lpad(za%60,p2);
      case 'ISODT'  : return ''+lpad(y,p4)+lpad(m+1,p2)+lpad(d,p2);
      case 'ISOTM'  : return ''+lpad(h,p2)+lpad(n,p2)+lpad(s,p2)+pp+lpad(f,p3);
      case 'ISOTZ'  : return ''+zs+lpad(trunc(za/60),p2)+lpad(za%60,p2);
      case 'ISO-TS' : return ''+lpad(y,p4)+pd+lpad(m+1,p2)+pd+lpad(d,p2)+'T'+lpad(h,p2)+pc+lpad(n,p2)+pc+lpad(s,p2)+pp+lpad(f,p3)+zs+lpad(trunc(za/60),p2)+pc+lpad(za%60,p2);
      case 'ISO-DT' : return ''+lpad(y,p4)+pd+lpad(m+1,p2)+pd+lpad(d,p2);
      case 'ISO-TM' : return ''+lpad(h,p2)+pc+lpad(n,p2)+pc+lpad(s,p2)+pp+lpad(f,p3);
      case 'ISO-TZ' : return ''+zs+lpad(trunc(za/60),p2)+pc+lpad(za%60,p2);
      case 'WEEKDAY': return weekday[w];
      case 'WKD'    : return wkd[w];
      case 'MONTH'  : return month[m];
      case 'MTH'    : return mth[m];
      case '{'      : return $1;
      default       : return $0;
    }
  }

  function getWmiDt( prop ) {
    if (_g.wmi===undefined) {
      var svcLoc = new ActiveXObject("WbemScripting.SWbemLocator");
      _g.wmi = svcLoc.ConnectServer(".", "root\\cimv2");
    }
    if (_g.wmiFile===undefined) {
      _g.wmiFile = new Enumerator(_g.wmi.ExecQuery(
                                    "Select * From "+(_g.dirs?"Win32_Directory":"Cim_DataFile")
                                     +" Where Name = '"+_g.file.Path.replace(/\\/g,"\\\\").replace(/'/g,"\\'")+"'"
                                  )).item();
    }
    var wmiDt;
    switch (prop.toLowerCase()) {
      case 'c': wmiDt=_g.wmiFile.CreationDate; break;
      case 'm': wmiDt=_g.wmiFile.LastModified; break;
      case 'a': wmiDt=_g.wmiFile.LastAccessed; break;
      default: return undefined;
    }
    var tz=Number(wmiDt.substr(22));
    var dt = new Date(     wmiDt.substr(0,4)+ps+wmiDt.substr(4,2)+ps+wmiDt.substr(6,2)
                       +sp+wmiDt.substr(8,2)+pc+wmiDt.substr(10,2)+pc+wmiDt.substr(12,2)
                       +sp+wmiDt.substr(21,1)+lpad(trunc(tz/60),p2)+lpad(tz%60,p2)
                     );
    dt.setMilliseconds(Number(wmiDt.substr(15,3)));
    return dt;
  }

}

function attr(off) {
  var a=_g.file.Attributes;
  var o=off?off.substr(0,1):'';
  return  (a&1   ?'R':o?o:'r')  //Read only
         +(a&2   ?'H':o?o:'h')  //Hidden
         +(a&4   ?'S':o?o:'s')  //System
         +(a&32  ?'A':o?o:'a')  //Archive
         +(a&1024?'L':o?o:'l')  //Link or Shortcut
         +(a&2048?'C':o?o:'c'); //Compressed
}

function size(pad) {return lpad(_g.file.Size,pad);}

function type(pad) {return rpad(_g.file.Type,pad);}

function path(pad) {return rpad(_g.file.Path,pad);}

function parent(pad) {return rpad(_g.file.ParentFolder.Path,pad);}

function name(pad) {return rpad(_g.file.Name,pad);}

function sPath(pad) {return rpad(_g.file.ShortPath,pad);}

function sParent(pad) {return rpad(_g.file.ParentFolder.ShortPath,pad);}

function sName(pad) {return rpad(_g.file.ShortName,pad);}