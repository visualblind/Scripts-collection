// --------------------------------------------
// | The EP-Dev Whois script        
// |                                           
// | Copyright (c) 2003-2005 Patrick Brown as EP-Dev.com           
// | This program is free software; you can redistribute it and/or modify
// | it under the terms of the GNU General Public License as published by
// | the Free Software Foundation; either version 2 of the License, or
// | (at your option) any later version.              
// | 
// | This program is distributed in the hope that it will be useful,
// | but WITHOUT ANY WARRANTY; without even the implied warranty of
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// | GNU General Public License for more details.
// | 
// | You should have received a copy of the GNU General Public License
// | along with this program; if not, write to the Free Software
// | Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
// --------------------------------------------

The EP-Dev Whois: version 2.11
Information:
 This whois script will do alot of things. It will acts an an ordinary whois script, returning whois information natively on about 200 different extensions with the ability to easily add more. It will also act as a whois script for registrars who plan to pass available domains into a billing system for a customer to order. These two modes contain a multitude of features: price table, automatic alternative domain searches, ability to pass the full domain and/or extension (tld) to another script, backup nameservers, domain search logging, multiple extension (tld) and domain searches as one time, query limit bypass, custom keyword and query formats for each nameserver, enable/disable nameservers and/or extensions, custom currency support, and much more. All of the configuration can be edited from within control panel. Fully template driven, allowing for one to easily edit almost every element of the display to fit any website.

 One of the main goals of this script was to create both a user-friendly and programmer-friendly script. That is to say, create a script that could be used by novice webmasters as well as a script that would provide the customization and power that advanced webmasters require.

// --------------------------------------------
// --------------------------------------------

What's New:
 Version 2.11 fixes a bug that prevented non-buy mode queries.

 Version 2.1 fixes several bugs and adds support for multiple domain checking.

 Version 2.x: All of the code is new :). The entire script has been rewritten. Most importantly the script now has a control panel that features easy editing of nearly all aspects of the script without the need of any database! The control panel now features easy addition of nameservers and price settings, as well as easy editing of existing nameserver settings and templates. Each nameserver now has an array of individual settings such as individual timeouts. The administration panel also includes the ability to quickly check nameserver validity, allowing one to quickly pinpoint incorrect nameserver settings (such as bad keywords).

 The general search of the whois script has been updated to scrictly enforce general domain rules (such as length and format). It also has smart domain recognition that allows it to interpret somedomain.com.com as somedomain.com while still recognizing multiple dot TLDs, like somedomain.co.uk and subdomain tlds, such as somedomain.otherdomain.com as otherdomain.com. In fact, with the smart domain recognition, the tld selection could be left out altogether. Still, the search has also been updated to include the option of checkboxes instead of a dropdown box for multiple tld searching. It also has user session logging, so that queries can be temporarily logged and displayed on the following page in the search bar.

 There are many other features, but I believe that those are perhaps the most evident.

// --------------------------------------------
// --------------------------------------------

Instructions Install:
1. Upload all files.
2. Visit admin/index.php in your browser and follow the directions.
3. Visit whois.php in your browser.

UPGRADE INSTRUCTIONS:
** YOU MAY WANT TO MAKE A BACKUP OF THE /config/ FOLDER. **

VERSION (2.x -> 2.x)
1. Upload/replace everything except for the /config/ folder.
2. Visit the admin panel /admin/ in your browser and follow the instructions that appear on the screen.

VERSION (1.x -> 2.0)
1. Sorry, there isn't an upgrade path due to the new configuration and structure of version 2.0. You will just need to reconfigure it all (it will likely only take a minute or two).

// --------------------------------------------
// --------------------------------------------

Version History:
2.11 - July 07 2005:
FIXED BUG - Fixed a bug in whois.php that was causing all non buy mode queries to fail no_extension.
FIXED BUG - Fixed a bug in global.php that was causing some error reports to fail in PHP 4.
FIXED BUG - Fixed a bug that caused improper HTML for special currency symbols, including the pound and euro symbol, in global.php (http://www.dev-forums.com/index.php?showtopic=147).

2.1 - May 28 2005:
IMPROVED - Improved upgrade process by creating a new upgrade backend to be used during upgrade. Makes for a very easy upgrade.
ADDED FEATURE - Added ability to accept multiple domains at one time. Also added new multiple domain check page.
FIXED BUG - Fixed bug in admin/display.php that was causing the script's templates to not handle html entities properly.
FIXED BUG - Fixed a bug in the administration panel that was not triggering an error when an attempt to add a duplicate nameserver occurs.
FIXED BUG - Fixed bug in global.php that was not allowing proper TLD error reporting on systems running PHP 4.x.

2.01 - April 17 2005:
IMPROVED - Improved the initial login screen of the administration panel to list the default username and password.
FIXED BUG - Fixed a major bug in the administration panel that prevented proper modification/addition of custom config types (ex: string). The bug affected systems < PHP 5.

2.0 - March 29 2005:
ADDED FEATURE - Administration panel should now be used in editing all aspects of the script.
IMPROVED - Entire code has been rewritten and is now fully object oriented. There are too many new features, etc, to discuss.

1.5 - (Never released):
UPDATED - Updated script's price table to look better.
IMPROVED - Updated script to be more object-oriented.
UPDATED - Updated additional-servers.txt with updated .be whois information (thanks Marc).

1.41 - July 27 2004:
ADDED FEATURE - Added exclusion list to exclude TLDs from the price list that you may not want listed.
FIXED BUG - Fixed typo in search-whois that prevented whois from displaying on some php configs.
IMPROVED - Improved domain submit form to exclude the submit input as a variable.
ADDED FEATURE - Added new nameservers_with_special array to accomodate for servers that require special arguments.
FIXED BUG - Fixed price on Domain Available page not being formatted.
IMPROVED - Improved variable formats being passed into external script. The formats can now be edited from config file.
UPDATED - Updated script to work with default PHP5 install.
UPDATED - Updated additional-servers.txt with .de update (thanks Christian).
ADDED - Added external-script-example.php with explanations & examples of how to use the external_script_url variable in config.php.
UPDATED - Updated script to reflect GNU GPL more effectively.

1.4 - February 14 2004:
ADDED FEATURE - Logs have been incorporated. You can  view them in the /logs folder.
UPDATED - Updated additional-servers.txt with .pl dns updates (thanks WELOO)
ADDED FEATURE - Added support for whois servers that have limits and request entries via "is" command.

1.3 - November 17 2003:
FIXED BUG - Fixed timeout not working with custom setting in whois-class.php .
ADDED FEATURE - Added ability to modify price table in template.php.

1.2 - September 20 2003:
ADDED FEATURE - Multiple & custom currencies. The script can now form currency into any format. values can be set to US, UK, EU, or a custom setting.
ADDED FEATURE - Added template for search TLDs. People with the know-how can edit the search TLD display in the templates.php file.

1.1 - September 16 2003: 
ADDED FEATURE - Added language control. Now messages can be controlled with a language file in the template folder. Other text can be edited in the template.php file.
ADDED FEATURE - Added error checking. Now the domains are checked for length, and invalid characters.

1.0 - September 13 2003:
First release, but can already do alot.

// --------------------------------------------
// --------------------------------------------

TODO:
- Add variable domain automatic searches (such as my-[[original domain]] for an unavailable [[originaldomain]]).
- Multiple year domain price/registration recognition (such as co.uk).
- Add individual domain rules.
- Organization Name for server
- No alternatives names checkbox
- Multiple domain input support

// --------------------------------------------
// --------------------------------------------

Contact:
 ----> For Support: http://www.dev-forums.com
 I like to hear from people: opinions, comments, suggestions, and anything you may have created as an addition or add-on to the script! Don't hesitate to contact me :)
 To contact us, visit www.ep-dev.com or patiek@ep-dev.com . Thanks for your support!
 
 If you are having trouble viewing the program code: The program was created with EditPlus ( http://www.editplus.com ) and therefore is best viewed in that editor (at 1024x768).

If you modify this program, you must still include a reference to www.ep-dev.com in the modified script.