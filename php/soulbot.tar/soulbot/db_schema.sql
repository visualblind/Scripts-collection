# DATABASE NAME NEEDS TO BE 'soul_soul'
# --------------------------------------------------------

#
# Table structure for table `channels`
#

CREATE TABLE `channels` (
  `uid` bigint(20) NOT NULL auto_increment,
  `channel` varchar(150) NOT NULL default '',
  `users` bigint(20) NOT NULL default '0',
  `lasttime` timestamp(14) NOT NULL,
  PRIMARY KEY  (`uid`)
) TYPE=MyISAM AUTO_INCREMENT=210 ;

# --------------------------------------------------------

#
# Table structure for table `directories`
#

CREATE TABLE `directories` (
  `uid` bigint(20) NOT NULL auto_increment,
  `userid` bigint(20) NOT NULL default '0',
  `directory` varchar(250) NOT NULL default '',
  `timewhen` timestamp(14) NOT NULL,
  PRIMARY KEY  (`uid`),
  KEY `userid` (`userid`),
  KEY `timewhen` (`timewhen`),
  FULLTEXT KEY `directory_2` (`directory`)
) TYPE=MyISAM AUTO_INCREMENT=406679 ;

# --------------------------------------------------------

#
# Table structure for table `files`
#

CREATE TABLE `files` (
  `uid` bigint(20) NOT NULL auto_increment,
  `userid` bigint(20) NOT NULL default '0',
  `directoryid` bigint(20) NOT NULL default '0',
  `filename` varchar(255) NOT NULL default '',
  `exten` varchar(5) NOT NULL default '',
  `timewhen` timestamp(14) NOT NULL,
  `size` bigint(20) NOT NULL default '0',
  `bitrate` int(11) NOT NULL default '0',
  `length` int(11) NOT NULL default '0',
  PRIMARY KEY  (`uid`),
  KEY `bitrate` (`bitrate`),
  KEY `exten` (`exten`),
  KEY `timewhen` (`timewhen`),
  KEY `userid` (`userid`,`directoryid`),
  KEY `directoryid` (`directoryid`),
  FULLTEXT KEY `filename` (`filename`)
) TYPE=MyISAM AUTO_INCREMENT=6226643 ;

# --------------------------------------------------------

#
# Table structure for table `users`
#

CREATE TABLE `users` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user` varchar(150) NOT NULL default '',
  `intStats` enum('-1','0','1','2') NOT NULL default '0',
  `avgspeed` int(11) NOT NULL default '0',
  `downloadnum` bigint(20) NOT NULL default '0',
  `something` bigint(20) NOT NULL default '0',
  `files` bigint(20) NOT NULL default '0',
  `dirs` bigint(20) NOT NULL default '0',
  `slots` bigint(20) NOT NULL default '0',
  `lasttime` timestamp(14) NOT NULL,
  `ipaddress` bigint(20) NOT NULL default '0',
  `portnum` int(11) NOT NULL default '0',
  `description` text,
  `havepic` enum('0','1') NOT NULL default '0',
  `picstring` varchar(250) default NULL,
  `useruploads` int(11) NOT NULL default '0',
  `totaluploads` int(11) NOT NULL default '0',
  `queuesize` int(11) NOT NULL default '0',
  `slotsavail` int(11) NOT NULL default '0',
  PRIMARY KEY  (`uid`),
  KEY `user` (`user`),
  KEY `intStats` (`intStats`),
  KEY `files` (`files`),
  KEY `lasttime` (`lasttime`)
) TYPE=MyISAM AUTO_INCREMENT=1068472 ;
