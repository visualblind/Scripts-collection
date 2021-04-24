#
# Table structure for table `pw_config`
#

DROP TABLE IF EXISTS `pw_config`;
CREATE TABLE `pw_config` (
  `config_name` varchar(255) NOT NULL default '',
  `config_value` varchar(255) NOT NULL default ''
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `pw_results`
#

DROP TABLE IF EXISTS `pw_results`;
CREATE TABLE `pw_results` (
  `ID` int(11) NOT NULL auto_increment,
  `domain` varchar(70) NOT NULL default '',
  `available` int(1) NOT NULL default '0',
  `postdate` int(11) NOT NULL default '0',
  PRIMARY KEY  (`ID`)
) TYPE=MyISAM AUTO_INCREMENT=7 ;

# --------------------------------------------------------

#
# Table structure for table `pw_servers`
#

DROP TABLE IF EXISTS `pw_servers`;
CREATE TABLE `pw_servers` (
  `ID` int(11) NOT NULL auto_increment,
  `extention` varchar(50) NOT NULL default '',
  `server` varchar(50) NOT NULL default '',
  `errormsg` varchar(50) NOT NULL default '',
  `status` int(1) NOT NULL default '1',
  PRIMARY KEY  (`ID`)
) TYPE=MyISAM AUTO_INCREMENT=6 ;

# --------------------------------------------------------

#
# Table structure for table `pw_users`
#

DROP TABLE IF EXISTS `pw_users`;
CREATE TABLE `pw_users` (
  `ID` int(11) NOT NULL auto_increment,
  `username` varchar(50) NOT NULL default '',
  `password` varchar(255) NOT NULL default '',
  `email` varchar(50) NOT NULL default '',
  `joindate` int(11) NOT NULL default '0',
  `logindate` int(11) NOT NULL default '0',
  `ipaddress` varchar(50) NOT NULL default '',
  `status` int(1) NOT NULL default '0',
  PRIMARY KEY  (`ID`)
) TYPE=MyISAM AUTO_INCREMENT=3 ;

#
# Dumping data for table `pw_config`
#

INSERT INTO `pw_config` VALUES ('sitename', 'Particle Whois Demo');
INSERT INTO `pw_config` VALUES ('mainsite', 'Particle Soft Systems');
INSERT INTO `pw_config` VALUES ('mainurl', 'http://www.particlesoft.net/');
INSERT INTO `pw_config` VALUES ('defaultskin', 'ParticleBlue');
INSERT INTO `pw_config` VALUES ('dateformat', 'D j M Y, H:i A');
INSERT INTO `pw_config` VALUES ('serverport', '43');
INSERT INTO `pw_config` VALUES ('rooturl', 'http://');
INSERT INTO `pw_config` VALUES ('rootpath', '/particlewhois/');
INSERT INTO `pw_config` VALUES ('logresults', '1');
INSERT INTO `pw_config` VALUES ('created', '1072915200');
INSERT INTO `pw_config` VALUES ('version', '1.0.2');
INSERT INTO `pw_config` VALUES ('versionint', '3');

#
# Dumping data for table `pw_servers`
#

INSERT INTO `pw_servers` VALUES (1, 'com', 'whois.opensrs.net', 'Can\'t get information', 1);
INSERT INTO `pw_servers` VALUES (2, 'net', 'whois.opensrs.net', 'Can\'t get information', 1);
INSERT INTO `pw_servers` VALUES (3, 'org', 'whois.publicinterestregistry.net', 'NOT FOUND', 1);
INSERT INTO `pw_servers` VALUES (4, 'info', 'whois.opensrs.net', 'Not found', 1);
INSERT INTO `pw_servers` VALUES (5, 'biz', 'whois.nic.biz', 'Not found', 1);