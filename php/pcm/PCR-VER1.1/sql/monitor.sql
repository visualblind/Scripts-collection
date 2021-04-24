# MySQL-Front Dump 2.5
#
# Host: localhost   Database: monitor
# --------------------------------------------------------
# Server version 3.23.47


#
# Table structure for table 'ip'
#

CREATE TABLE ip (
  id tinyint(3) unsigned NOT NULL auto_increment,
  ip varchar(16) default '0',
  puerto varchar(10) default '0',
  descripcion varchar(255) default NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY id (id),
  KEY id_2 (id)
) TYPE=MyISAM;



#
# Dumping data for table 'ip'
#

INSERT INTO ip VALUES("1", "127.0.0.1", "80", "HTTP");

