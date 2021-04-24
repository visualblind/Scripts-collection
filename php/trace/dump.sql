# --------------------------------------------------------
#
# Table structure for table 'info'
#

CREATE TABLE info (
   id int(11) NOT NULL auto_increment,
   vxsid int(11) DEFAULT '0' NOT NULL,
   van int(11) DEFAULT '0' NOT NULL,
   idsite int(11) DEFAULT '0' NOT NULL,
   text text NOT NULL,
   PRIMARY KEY (id)
);


# --------------------------------------------------------
#
# Table structure for table 'site'
#

CREATE TABLE site (
   sid int(11) NOT NULL auto_increment,
   naam varchar(100) NOT NULL,
   PRIMARY KEY (sid)
);


# --------------------------------------------------------
#
# Table structure for table 'van'
#

CREATE TABLE van (
   vid int(11) NOT NULL auto_increment,
   plaats varchar(100) NOT NULL,
   PRIMARY KEY (vid)
);


# --------------------------------------------------------
#
# Table structure for table 'vanxsite'
#

CREATE TABLE vanxsite (
   vanxsiteid int(11) NOT NULL auto_increment,
   van_id int(11) DEFAULT '0' NOT NULL,
   site_id int(11) DEFAULT '0' NOT NULL,
   datum datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
   PRIMARY KEY (vanxsiteid),
   UNIQUE vanxsiteid (vanxsiteid)
);


