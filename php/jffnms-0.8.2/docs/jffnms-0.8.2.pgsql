------------------------------------------------------------------
-- My2Pg 1.27 translated dump
--
------------------------------------------------------------------

--
-- Sequences for table ACCT
--

CREATE SEQUENCE acct_id_seq;

-- MySQL dump 9.11
--
-- Host: localhost    Database: jffnms-release
-- ------------------------------------------------------
-- Server version	4.0.24

--
-- Table structure for table `acct`
--

CREATE TABLE acct (
  id INT4 DEFAULT nextval('acct_id_seq'),
  usern varchar(15) NOT NULL default '',
  s_name varchar(30) NOT NULL default '',
  c_name varchar(30) NOT NULL default '',
  elapsed_time INT4 NOT NULL default '0',
  bytes_in INT4 default '0',
  bytes_out INT4 default '0',
  DATE TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  cmd varchar(250) NOT NULL default '',
  type varchar(15) NOT NULL default '0',
  analized INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `acct`
--


--
-- Table structure for table `actions`
--



--
-- Sequences for table ACTIONS
--

CREATE SEQUENCE actions_id_seq;

CREATE TABLE actions (
  id INT4 DEFAULT nextval('actions_id_seq'),
  description varchar(40) NOT NULL default '',
  command varchar(60) NOT NULL default 'none',
  internal_parameters varchar(120) NOT NULL default '',
  user_parameters varchar(120) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `actions`
--

INSERT INTO actions VALUES (1,'No Action','none','','');
INSERT INTO actions VALUES (2,'Send Mail','email','from:nms,to:<profile-email>,subject:NMS','from:From,subject:Subject,comment:Comment');
INSERT INTO actions VALUES (3,'Send SMS via Modem','smsclient','smsname:<profile-smsalias>','');
INSERT INTO actions VALUES (4,'Send SMS via Mail','email','short:1,from:nms,to:<profile-email>,subject:NMS','from:From,subject:Subject');

--
-- Table structure for table `alarm_states`
--



--
-- Sequences for table ALARM_STATES
--

CREATE SEQUENCE alarm_states_id_seq;

CREATE TABLE alarm_states (
  id INT4 DEFAULT nextval('alarm_states_id_seq'),
  description varchar(30) NOT NULL default '',
  activate_alarm INT2 NOT NULL default '0',
  sound_in varchar(30) NOT NULL default '',
  sound_out varchar(30) NOT NULL default '',
  state INT4 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `alarm_states`
--

INSERT INTO alarm_states VALUES (1,'down',10,'down.wav','up.wav',1);
INSERT INTO alarm_states VALUES (2,'up',100,'','',2);
INSERT INTO alarm_states VALUES (3,'alert',60,'boing.wav','',3);
INSERT INTO alarm_states VALUES (4,'testing',40,'','',4);
INSERT INTO alarm_states VALUES (5,'running',100,'','',2);
INSERT INTO alarm_states VALUES (6,'not running',20,'','',1);
INSERT INTO alarm_states VALUES (7,'open',100,'','',2);
INSERT INTO alarm_states VALUES (8,'closed',15,'','',1);
INSERT INTO alarm_states VALUES (9,'error',90,'boing.wav','',3);
INSERT INTO alarm_states VALUES (10,'invalid',30,'','',1);
INSERT INTO alarm_states VALUES (11,'valid',110,'','',2);
INSERT INTO alarm_states VALUES (12,'reachable',100,'','',2);
INSERT INTO alarm_states VALUES (13,'unreachable',5,'','',1);
INSERT INTO alarm_states VALUES (14,'lowerlayerdown',10,'down.wav','up.wav',1);
INSERT INTO alarm_states VALUES (15,'synchronized',100,'','',2);
INSERT INTO alarm_states VALUES (16,'unsynchronized',6,'','',1);
INSERT INTO alarm_states VALUES (17,'battery normal',100,'','',2);
INSERT INTO alarm_states VALUES (18,'battery low',4,'','',1);
INSERT INTO alarm_states VALUES (19,'battery unknown',2,'','',1);
INSERT INTO alarm_states VALUES (20,'on battery',3,'','',1);
INSERT INTO alarm_states VALUES (21,'on line',90,'','',2);
INSERT INTO alarm_states VALUES (22,'ok',100,'','',2);
INSERT INTO alarm_states VALUES (23,'out of bounds',10,'','',1);
INSERT INTO alarm_states VALUES (24,'unavailable',10,'down.wav','up.wav',1);
INSERT INTO alarm_states VALUES (25,'available',100,'','',2);
INSERT INTO alarm_states VALUES (26,'battery depleted',3,'','',1);

--
-- Table structure for table `alarms`
--



--
-- Sequences for table ALARMS
--

CREATE SEQUENCE alarms_id_seq;

CREATE TABLE alarms (
  id INT4 DEFAULT nextval('alarms_id_seq'),
  date_start TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  date_stop TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  interface INT4 NOT NULL default '0',
  type INT4 NOT NULL default '0',
  active INT4 NOT NULL default '1',
  referer_start INT4 NOT NULL default '0',
  referer_stop INT4 NOT NULL default '0',
  triggered INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `alarms`
--


--
-- Table structure for table `auth`
--



--
-- Sequences for table AUTH
--

CREATE SEQUENCE auth_id_seq;

CREATE TABLE auth (
  id INT4 DEFAULT nextval('auth_id_seq'),
  usern varchar(60) NOT NULL default '',
  passwd varchar(60) NOT NULL default '',
  fullname varchar(60) NOT NULL default '',
  router INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `auth`
--

INSERT INTO auth VALUES (1,'No User','$1$txVdymrd$AO3Qa8js9lVNkyscQ552b1','No User Name',0);
INSERT INTO auth VALUES (2,'admin','adpexzg3FUZAk','Administrator',0);

--
-- Table structure for table `autodiscovery`
--



--
-- Sequences for table AUTODISCOVERY
--

CREATE SEQUENCE autodiscovery_id_seq;

CREATE TABLE autodiscovery (
  id INT4 DEFAULT nextval('autodiscovery_id_seq'),
  description varchar(40) NOT NULL default '0',
  poller_default INT2 NOT NULL default '1',
  permit_add INT2 NOT NULL default '0',
  permit_del INT2 NOT NULL default '0',
  permit_mod INT2 NOT NULL default '0',
  permit_disable INT2 NOT NULL default '0',
  skip_loopback INT2 NOT NULL default '0',
  check_state INT2 NOT NULL default '1',
  check_address INT2 NOT NULL default '1',
  alert_del INT2 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `autodiscovery`
--

INSERT INTO autodiscovery VALUES (1,'No Autodiscovery',1,0,0,0,0,0,1,1,1);
INSERT INTO autodiscovery VALUES (2,'Standard',1,1,0,0,1,1,1,1,1);
INSERT INTO autodiscovery VALUES (3,'Automagic',1,1,1,1,0,1,1,1,1);
INSERT INTO autodiscovery VALUES (4,'Administrative',0,1,1,0,1,1,1,1,1);
INSERT INTO autodiscovery VALUES (5,'Just Inform',0,0,0,0,0,0,1,1,1);
INSERT INTO autodiscovery VALUES (6,'Standard (for Switches)',1,1,0,1,0,1,1,0,1);

--
-- Table structure for table `clients`
--



--
-- Sequences for table CLIENTS
--

CREATE SEQUENCE clients_id_seq;

CREATE TABLE clients (
  id INT4 DEFAULT nextval('clients_id_seq'),
  username varchar(60) NOT NULL default '',
  password varchar(30) NOT NULL default '',
  name varchar(60) NOT NULL default '',
  shortname varchar(30) NOT NULL default '',
  enabled INT2 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `clients`
--

INSERT INTO clients VALUES (1,'unkclient','','Unknown Customer','Unknown',1);
INSERT INTO clients VALUES (2,'','','New Customer','Customer1',1);

--
-- Table structure for table `events`
--



--
-- Sequences for table EVENTS
--

CREATE SEQUENCE events_id_seq;

CREATE TABLE events (
  id INT4 DEFAULT nextval('events_id_seq'),
  DATE TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  type INT4 NOT NULL default '0',
  host INT4 NOT NULL default '0',
  interface varchar(40) NOT NULL default '',
  state varchar(40) NOT NULL default '',
  username varchar(40) NOT NULL default '',
  info varchar(150) NOT NULL default '',
  referer INT4 NOT NULL default '0',
  ack INT4 NOT NULL default '0',
  analized INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `events`
--


--
-- Table structure for table `events_latest`
--



--
-- Sequences for table EVENTS_LATEST
--

CREATE SEQUENCE events_latest_id_seq;

CREATE TABLE events_latest (
  id INT4 DEFAULT nextval('events_latest_id_seq'),
  DATE TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  type INT4 NOT NULL default '0',
  host INT4 NOT NULL default '0',
  interface varchar(40) NOT NULL default '',
  state varchar(40) NOT NULL default '',
  username varchar(40) NOT NULL default '',
  info varchar(150) NOT NULL default '',
  referencia INT4 NOT NULL default '0',
  ack INT4 NOT NULL default '0',
  analized INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `events_latest`
--


--
-- Table structure for table `filters`
--



--
-- Sequences for table FILTERS
--

CREATE SEQUENCE filters_id_seq;

CREATE TABLE filters (
  id INT4 DEFAULT nextval('filters_id_seq'),
  description varchar(40) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `filters`
--

INSERT INTO filters VALUES (1,'All Events');
INSERT INTO filters VALUES (4,'Severity Level > Warning');
INSERT INTO filters VALUES (5,'Dont Show SLA or Commands');
INSERT INTO filters VALUES (8,'Dont Show SLA');
INSERT INTO filters VALUES (10,'BGP Events');
INSERT INTO filters VALUES (13,'Commands Only');
INSERT INTO filters VALUES (17,'Interfaces');
INSERT INTO filters VALUES (18,'UnACK Events');
INSERT INTO filters VALUES (19,'Windows Events');
INSERT INTO filters VALUES (20,'PIX');

--
-- Table structure for table `filters_cond`
--



--
-- Sequences for table FILTERS_COND
--

CREATE SEQUENCE filters_cond_id_seq;

CREATE TABLE filters_cond (
  id INT4 DEFAULT nextval('filters_cond_id_seq'),
  filter_id INT4 NOT NULL default '1',
  pos INT4 NOT NULL default '1',
  field_id INT4 NOT NULL default '1',
  op varchar(10) NOT NULL default '=',
  value varchar(60) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `filters_cond`
--

INSERT INTO filters_cond VALUES (1,1,1,1,'=','1');
INSERT INTO filters_cond VALUES (2,5,1,2,'!=','12');
INSERT INTO filters_cond VALUES (3,4,1,3,'>','30');
INSERT INTO filters_cond VALUES (4,5,3,2,'!=','8');
INSERT INTO filters_cond VALUES (5,5,2,4,'=','');
INSERT INTO filters_cond VALUES (6,8,1,2,'!=','12');
INSERT INTO filters_cond VALUES (10,10,1,2,'=','6');
INSERT INTO filters_cond VALUES (13,13,1,2,'=','8');
INSERT INTO filters_cond VALUES (20,17,1,11,'>','1');
INSERT INTO filters_cond VALUES (21,18,1,12,'=','0');
INSERT INTO filters_cond VALUES (22,19,1,2,'=','46');
INSERT INTO filters_cond VALUES (23,19,5,5,'=','');
INSERT INTO filters_cond VALUES (24,19,10,2,'=','47');
INSERT INTO filters_cond VALUES (25,19,15,5,'=','');
INSERT INTO filters_cond VALUES (26,19,20,2,'=','48');
INSERT INTO filters_cond VALUES (27,19,25,5,'=','');
INSERT INTO filters_cond VALUES (28,19,30,2,'=','49');
INSERT INTO filters_cond VALUES (29,20,2,5,'=','');
INSERT INTO filters_cond VALUES (30,20,3,2,'=','63');
INSERT INTO filters_cond VALUES (31,20,4,5,'=','');
INSERT INTO filters_cond VALUES (32,20,5,2,'=','62');
INSERT INTO filters_cond VALUES (33,20,6,5,'=','');
INSERT INTO filters_cond VALUES (34,20,7,2,'=','65');
INSERT INTO filters_cond VALUES (35,20,9,2,'=','67');
INSERT INTO filters_cond VALUES (37,20,10,5,'=','');
INSERT INTO filters_cond VALUES (38,20,11,2,'=','61');
INSERT INTO filters_cond VALUES (39,20,12,5,'=','');
INSERT INTO filters_cond VALUES (40,20,13,2,'=','66');
INSERT INTO filters_cond VALUES (41,20,1,2,'=','64');
INSERT INTO filters_cond VALUES (43,20,8,5,'=','');
INSERT INTO filters_cond VALUES (44,20,14,5,'=','');
INSERT INTO filters_cond VALUES (45,20,15,2,'=','29');
INSERT INTO filters_cond VALUES (46,20,16,5,'=','');
INSERT INTO filters_cond VALUES (47,20,17,2,'=','28');

--
-- Table structure for table `filters_fields`
--



--
-- Sequences for table FILTERS_FIELDS
--

CREATE SEQUENCE filters_fields_id_seq;

CREATE TABLE filters_fields (
  id INT4 DEFAULT nextval('filters_fields_id_seq'),
  description varchar(40) NOT NULL default '',
  field varchar(40) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `filters_fields`
--

INSERT INTO filters_fields VALUES (1,'ALL','');
INSERT INTO filters_fields VALUES (2,'Event Type','types.id');
INSERT INTO filters_fields VALUES (3,'Severity Level','severity.level');
INSERT INTO filters_fields VALUES (4,'AND','AND');
INSERT INTO filters_fields VALUES (5,'OR','OR');
INSERT INTO filters_fields VALUES (6,'Host','hosts.id');
INSERT INTO filters_fields VALUES (7,'Zone','zones.id');
INSERT INTO filters_fields VALUES (11,'Interface ID','interfaces.id');
INSERT INTO filters_fields VALUES (12,'Acknowledge','events.ack');

--
-- Table structure for table `graph_types`
--



--
-- Sequences for table GRAPH_TYPES
--

CREATE SEQUENCE graph_types_id_seq;

CREATE TABLE graph_types (
  id INT4 DEFAULT nextval('graph_types_id_seq'),
  description varchar(30) NOT NULL default '',
  type INT4 NOT NULL default '1',
  graph1 varchar(60) NOT NULL default '',
  graph2 varchar(60) NOT NULL default '',
  sizex1 INT4 NOT NULL default '0',
  sizey1 INT4 NOT NULL default '0',
  sizex2 INT4 NOT NULL default '0',
  sizey2 INT4 NOT NULL default '0',
  allow_aggregation INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `graph_types`
--

INSERT INTO graph_types VALUES (1,'No Graph Selected',1,'','',0,0,0,0,0);
INSERT INTO graph_types VALUES (3,'Traffic',4,'traffic','',500,150,0,0,1);
INSERT INTO graph_types VALUES (4,'Utilization',4,'traffic_util','',500,150,0,0,0);
INSERT INTO graph_types VALUES (5,'Packets',4,'packets','error_packets',275,170,250,170,1);
INSERT INTO graph_types VALUES (6,'Error Rate',4,'error_rate','',500,170,0,0,0);
INSERT INTO graph_types VALUES (7,'RTT & Packet Loss',4,'rtt','traffic_pl',275,155,260,140,0);
INSERT INTO graph_types VALUES (8,'Interface Packet Loss',4,'packetloss','',500,180,0,0,0);
INSERT INTO graph_types VALUES (9,'Cisco CPU Usage',3,'cpu_util','',500,175,0,0,1);
INSERT INTO graph_types VALUES (10,'Cisco Memory',3,'memory','',510,150,0,0,0);
INSERT INTO graph_types VALUES (11,'Drops',4,'drop_packets','',500,175,0,0,0);
INSERT INTO graph_types VALUES (14,'BGP Updates',6,'bgp_updates','',500,150,0,0,0);
INSERT INTO graph_types VALUES (15,'Used Storage',8,'storage','',500,150,0,0,1);
INSERT INTO graph_types VALUES (16,'CSS VIP Hits',9,'css_vip_hits','',500,150,0,0,0);
INSERT INTO graph_types VALUES (17,'CSS VIP Traffic',9,'css_vip_output_only_traffic','',500,150,0,0,0);
INSERT INTO graph_types VALUES (18,'Solaris Memory Usage',10,'ucd_memory','',500,180,0,0,0);
INSERT INTO graph_types VALUES (19,'Solaris Load Average',10,'ucd_load_average','',500,150,0,0,0);
INSERT INTO graph_types VALUES (20,'Solaris CPU Usage',10,'ucd_cpu_solaris','',500,175,0,0,0);
INSERT INTO graph_types VALUES (21,'CPU Usage',11,'ucd_cpu_linux','',500,175,0,0,1);
INSERT INTO graph_types VALUES (22,'Load Average',11,'ucd_load_average','',500,150,0,0,1);
INSERT INTO graph_types VALUES (23,'Established Connections',2,'tcp_conn_number','',500,175,0,0,1);
INSERT INTO graph_types VALUES (24,'Connection Delay',2,'tcp_conn_delay','',500,175,0,0,0);
INSERT INTO graph_types VALUES (25,'IP Accounting',3,'acct_bytes','acct_packets',275,170,260,170,0);
INSERT INTO graph_types VALUES (26,'Processes / Users',12,'hostmib_users_procs','',500,170,0,0,0);
INSERT INTO graph_types VALUES (27,'TCP Connection Status',12,'tcpmib_connections','',500,150,0,0,0);
INSERT INTO graph_types VALUES (28,'Processor Utilization',12,'cpu_util','',500,175,0,0,0);
INSERT INTO graph_types VALUES (29,'Processes / Users',11,'hostmib_users_procs','',500,170,0,0,0);
INSERT INTO graph_types VALUES (30,'TCP Connection Status',11,'tcpmib_connections','',500,150,0,0,0);
INSERT INTO graph_types VALUES (31,'TCP Connection Status',3,'tcpmib_connections','',500,150,0,0,0);
INSERT INTO graph_types VALUES (32,'Accounted Packets',13,'cisco_mac_packets','',500,150,0,0,0);
INSERT INTO graph_types VALUES (33,'Accounted Bytes',13,'cisco_mac_bytes','',500,150,0,0,0);
INSERT INTO graph_types VALUES (34,'SP RTT & Loss',14,'rtt','packetloss',270,170,265,170,0);
INSERT INTO graph_types VALUES (35,'Median RTT',14,'rtt','',500,175,0,0,0);
INSERT INTO graph_types VALUES (36,'Packets Lost',14,'packetloss','',500,175,0,0,0);
INSERT INTO graph_types VALUES (37,'Temperature',17,'temperature','',500,180,0,0,1);
INSERT INTO graph_types VALUES (38,'SA Agent Round-Trip Latency',19,'cisco_saagent_rtl','',500,150,0,0,0);
INSERT INTO graph_types VALUES (39,'SA Agent Jitter',19,'cisco_saagent_jitter','',500,150,0,0,0);
INSERT INTO graph_types VALUES (40,'SA Agent % Packet Loss',19,'cisco_saagent_packetloss','',500,150,0,0,0);
INSERT INTO graph_types VALUES (41,'Host Round Trip Time',20,'rtt','',500,150,0,0,0);
INSERT INTO graph_types VALUES (42,'Host Packet Loss',20,'packetloss','',500,175,0,0,0);
INSERT INTO graph_types VALUES (43,'TC Class Rate',21,'tc_rate','',500,150,0,0,1);
INSERT INTO graph_types VALUES (44,'Instances/Memory',15,'apps_instances','apps_memory',250,175,280,175,0);
INSERT INTO graph_types VALUES (45,'Connection Delay',23,'tcp_conn_delay','',500,175,0,0,0);
INSERT INTO graph_types VALUES (46,'Temperature',26,'temperature','',500,175,0,0,1);
INSERT INTO graph_types VALUES (47,'Packets New',4,'packets_new','',610,170,0,0,0);
INSERT INTO graph_types VALUES (48,'Livingston Portmaster Serial',28,'pm_serial','',500,175,0,0,0);
INSERT INTO graph_types VALUES (49,'CGI Requests',27,'iis_tcgir','',500,150,0,0,0);
INSERT INTO graph_types VALUES (50,'POSTs and GETs',27,'iis_tptg','',500,150,0,0,0);
INSERT INTO graph_types VALUES (51,'Files Sent',27,'iis_tfs','',500,150,0,0,0);
INSERT INTO graph_types VALUES (52,'Bytes Received',27,'iis_tbr','',500,150,0,0,0);
INSERT INTO graph_types VALUES (53,'Hits',29,'apache_tac','',500,175,0,0,1);
INSERT INTO graph_types VALUES (54,'KBytes',29,'apache_tkb','',500,175,0,0,1);
INSERT INTO graph_types VALUES (55,'Apache CPU Load',29,'apache_cplo','',500,175,0,0,0);
INSERT INTO graph_types VALUES (59,'Bytes Per Request',29,'apache_bpr','',500,175,0,0,0);
INSERT INTO graph_types VALUES (60,'Workers',29,'apache_workers','',500,175,0,0,0);
INSERT INTO graph_types VALUES (61,'Load/Capacity',31,'apc_load_capacity','',500,175,0,0,0);
INSERT INTO graph_types VALUES (62,'Voltages',31,'apc_voltages','',500,150,0,0,0);
INSERT INTO graph_types VALUES (63,'Time Remaining',31,'apc_time_remaining','',500,150,0,0,0);
INSERT INTO graph_types VALUES (64,'Temperature',31,'temperature','',500,150,0,0,0);
INSERT INTO graph_types VALUES (65,'Records',30,'sql_records','',500,150,0,0,0);
INSERT INTO graph_types VALUES (66,'Traffic',32,'alteon_octets','',500,175,0,0,1);
INSERT INTO graph_types VALUES (67,'Session Rate',32,'alteon_sessionrate','',500,175,0,0,1);
INSERT INTO graph_types VALUES (68,'Failures',32,'alteon_failures_sessions','',500,175,0,0,0);
INSERT INTO graph_types VALUES (69,'Current Sessions',32,'alteon_sessions','',500,175,0,0,1);
INSERT INTO graph_types VALUES (70,'Current Sessions',33,'alteon_sessions','',500,175,0,0,1);
INSERT INTO graph_types VALUES (71,'Sessions Rate',33,'alteon_sessionrate','',500,175,0,0,1);
INSERT INTO graph_types VALUES (72,'Octets',33,'alteon_octets','',500,175,0,0,1);
INSERT INTO graph_types VALUES (73,'Response Time',34,'response_time','',500,175,0,0,0);
INSERT INTO graph_types VALUES (74,'Memory',35,'alteon_memory','',500,175,0,0,0);
INSERT INTO graph_types VALUES (75,'CPU Load',35,'alteon_load_average','',500,175,0,0,0);
INSERT INTO graph_types VALUES (76,'TCP Connections',35,'tcpmib_connections','',500,150,0,0,0);
INSERT INTO graph_types VALUES (77,'Sensor Value',36,'brocade_sensor','',500,175,0,0,0);
INSERT INTO graph_types VALUES (78,'Frames',37,'frames','',500,175,0,0,0);
INSERT INTO graph_types VALUES (79,'Traffic',37,'traffic_words','',500,175,0,0,0);
INSERT INTO graph_types VALUES (80,'Cisco Dialup Usage',38,'cisco_serial','',500,175,0,0,0);
INSERT INTO graph_types VALUES (81,'Time Usage',39,'inf_ldisk_time','',500,150,0,0,0);
INSERT INTO graph_types VALUES (82,'I/O Rate',39,'inf_ldisk_rate','',500,150,0,0,0);
INSERT INTO graph_types VALUES (83,'Battery Temperature',40,'temperature','',500,150,0,0,0);
INSERT INTO graph_types VALUES (84,'Time Remaining',40,'ups_time_remaining','',500,150,0,0,0);
INSERT INTO graph_types VALUES (85,'UPS Voltage',41,'ups_voltage','',500,150,0,0,1);
INSERT INTO graph_types VALUES (86,'UPS Current',41,'ups_current','',500,150,0,0,1);
INSERT INTO graph_types VALUES (87,'UPS Load',41,'ups_load','',500,150,0,0,1);
INSERT INTO graph_types VALUES (88,'Charge Remaining',40,'ups_charge_remaining','',500,150,0,0,0);
INSERT INTO graph_types VALUES (89,'IPTables Rate',42,'iptables_rate','',500,150,0,170,1);
INSERT INTO graph_types VALUES (90,'Routes',6,'bgp_routes','',500,150,0,0,0);
INSERT INTO graph_types VALUES (91,'PIX Connections',43,'pix_connections','',500,175,0,0,0);
INSERT INTO graph_types VALUES (92,'NAT Active Binds',44,'cisco_nat_active','',500,150,0,0,0);
INSERT INTO graph_types VALUES (93,'NAT Packets',44,'cisco_nat_packets','',500,150,0,0,0);
INSERT INTO graph_types VALUES (94,'Sensor Value',45,'sensor_value','',500,150,0,0,0);

--
-- Table structure for table `hosts`
--



--
-- Sequences for table HOSTS
--

CREATE SEQUENCE hosts_id_seq;

CREATE TABLE hosts (
  id INT4 DEFAULT nextval('hosts_id_seq'),
  ip_tacacs varchar(16) NOT NULL default '',
  ip varchar(20) NOT NULL default '',
  name varchar(30) NOT NULL default '',
  rocommunity varchar(100) NOT NULL default '',
  rwcommunity varchar(100) NOT NULL default '',
  zone INT4 NOT NULL default '0',
  tftp varchar(20) NOT NULL default '',
  autodiscovery INT4 NOT NULL default '1',
  config_type INT4 NOT NULL default '1',
  autodiscovery_default_customer INT4 NOT NULL default '1',
  satellite INT4 NOT NULL default '1',
  dmii varchar(10) NOT NULL default '1',
  lat decimal(12,2) NOT NULL default '0.00',
  lon decimal(12,2) NOT NULL default '0.00',
  show_host INT2 NOT NULL default '1',
  poll INT2 NOT NULL default '1',
  creation_date INT4 NOT NULL default '0',
  modification_date INT4 NOT NULL default '0',
  last_poll_date INT4 NOT NULL default '0',
  last_poll_time INT4 NOT NULL default '0',
  poll_interval INT4 NOT NULL default '300',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `hosts`
--

INSERT INTO hosts VALUES (1,'','','Unknown','','',1,'',1,1,1,1,'1','0.00','0.00',1,1,0,0,0,0,300);

--
-- Table structure for table `hosts_config`
--



--
-- Sequences for table HOSTS_CONFIG
--

CREATE SEQUENCE hosts_config_id_seq;

CREATE TABLE hosts_config (
  id INT4 DEFAULT nextval('hosts_config_id_seq'),
  DATE TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  host INT4 NOT NULL default '0',
  config TEXT DEFAULT '' NOT NULL,
  PRIMARY KEY (id)

);

--
-- Dumping data for table `hosts_config`
--

INSERT INTO hosts_config VALUES (1,'0001-01-01 00:00:00',1,'No Config');

--
-- Table structure for table `hosts_config_types`
--



--
-- Sequences for table HOSTS_CONFIG_TYPES
--

CREATE SEQUENCE hosts_config_types_id_seq;

CREATE TABLE hosts_config_types (
  id INT4 DEFAULT nextval('hosts_config_types_id_seq'),
  description varchar(60) NOT NULL default '',
  command varchar(30) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `hosts_config_types`
--

INSERT INTO hosts_config_types VALUES (1,'No Configuration Transfer','none');
INSERT INTO hosts_config_types VALUES (2,'Cisco IOS, Newer than 12.0 (CONFIG-COPY-MIB)','cisco_cc');
INSERT INTO hosts_config_types VALUES (3,'Cisco IOS, Older than 12.0 (SYS-MIB)','cisco_sys');
INSERT INTO hosts_config_types VALUES (4,'Cisco CatOS, Catalyst Switches (STACK-MIB)','cisco_catos');
INSERT INTO hosts_config_types VALUES (5,'Alteon WebOS Switches (DANGEROUS)','alteon_webos');

--
-- Table structure for table `interface_types`
--



--
-- Sequences for table INTERFACE_TYPES
--

CREATE SEQUENCE interface_types_id_seq;

CREATE TABLE interface_types (
  id INT4 DEFAULT nextval('interface_types_id_seq'),
  description varchar(40) NOT NULL default '',
  autodiscovery_validate INT2 NOT NULL default '0',
  autodiscovery_enabled INT2 NOT NULL default '0',
  autodiscovery_function varchar(40) NOT NULL default '',
  autodiscovery_parameters varchar(200) NOT NULL default '',
  autodiscovery_default_poller INT4 NOT NULL default '1',
  have_graph INT2 NOT NULL default '0',
  rrd_structure_rra TEXT DEFAULT '' NOT NULL,
  rrd_structure_res varchar(20) NOT NULL default '',
  rrd_structure_step INT4 NOT NULL default '300',
  graph_default INT4 NOT NULL default '1',
  break_by_card INT2 NOT NULL default '0',
  update_handler varchar(30) NOT NULL default 'none',
  allow_manual_add INT2 NOT NULL default '0',
  sla_default INT4 NOT NULL default '1',
  have_tools INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `interface_types`
--

INSERT INTO interface_types VALUES (1,'No Interface Type',0,0,'none','',1,0,'','',300,1,0,'none',0,1,0);
INSERT INTO interface_types VALUES (2,'TCP Ports',0,1,'tcp_ports','-sT -p1-500,600-1024',5,1,'RRA:LAST:0.5:1:<resolution>','103680',300,23,0,'tcp_ports',1,1,1);
INSERT INTO interface_types VALUES (3,'Cisco System Info',1,1,'host_information','cisco,9.1,9.5',3,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,9,0,'none',0,7,0);
INSERT INTO interface_types VALUES (4,'Physical Interfaces',1,1,'snmp_interfaces','',2,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,3,1,'none',0,1,1);
INSERT INTO interface_types VALUES (6,'BGP Neighbors',1,1,'bgp_peers','',8,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,90,0,'none',0,1,0);
INSERT INTO interface_types VALUES (8,'Storage',1,1,'storage','',9,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,15,0,'none',0,9,0);
INSERT INTO interface_types VALUES (9,'CSS VIPs',0,1,'css_vips','',10,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,17,0,'none',0,1,0);
INSERT INTO interface_types VALUES (10,'Solaris System Info',1,1,'host_information','solaris,sparc,sun,11.2.3.10,8072.3.2.3',12,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,20,0,'none',0,1,0);
INSERT INTO interface_types VALUES (11,'Linux/Unix System Info',1,1,'host_information','2021.250.10,linux,2021.250.255,freebsd,netSnmp,8072',11,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,21,0,'none',0,10,0);
INSERT INTO interface_types VALUES (12,'Windows System Info',1,1,'host_information','enterprises.311',13,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,28,0,'none',0,11,0);
INSERT INTO interface_types VALUES (13,'Cisco MAC Accounting',1,1,'cisco_accounting','',14,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,33,0,'none',0,1,0);
INSERT INTO interface_types VALUES (14,'Smokeping Host',1,1,'smokeping','/var/lib/smokeping',15,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,34,0,'none',0,8,0);
INSERT INTO interface_types VALUES (15,'Applications',1,0,'hostmib_apps','',16,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,44,0,'none',0,1,0);
INSERT INTO interface_types VALUES (16,'Cisco Power Supply',1,1,'cisco_envmib','PowerSupply,5.1.2,5.1.3',17,0,'','103680',300,1,1,'none',0,1,0);
INSERT INTO interface_types VALUES (17,'Cisco Temperature',1,1,'cisco_envmib','Temperature,3.1.2,3.1.6',18,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,37,1,'none',0,1,0);
INSERT INTO interface_types VALUES (18,'Cisco Voltage',1,1,'cisco_envmib','Voltage,2.1.2,2.1.7',19,0,'','103680',300,1,1,'none',0,1,0);
INSERT INTO interface_types VALUES (19,'Cisco SA Agent',1,1,'cisco_saagent','',20,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,39,0,'none',0,1,0);
INSERT INTO interface_types VALUES (20,'Reachable',1,1,'reachability','',21,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,41,0,'none',0,1,0);
INSERT INTO interface_types VALUES (21,'Linux Traffic Control',1,1,'linux_tc','.1.3.6.1.4.1.2021.5001',22,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,43,1,'none',0,1,0);
INSERT INTO interface_types VALUES (22,'NTP',0,1,'ntp_client','',23,0,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,1,0,'none',0,1,0);
INSERT INTO interface_types VALUES (23,'UDP Ports',0,0,'tcp_ports','-sU -p1-500,600-1024 --host_timeout 15000',24,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,45,0,'tcp_ports',1,1,0);
INSERT INTO interface_types VALUES (24,'Compaq Physical Drives',0,1,'cpqmib','phydrv',25,0,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,1,0,'none',0,1,0);
INSERT INTO interface_types VALUES (25,'Compaq Fans',0,1,'cpqmib','fans',26,0,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,1,0,'none',0,1,0);
INSERT INTO interface_types VALUES (26,'Compaq Temperature',0,1,'cpqmib','temperature',27,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,46,0,'none',0,1,0);
INSERT INTO interface_types VALUES (27,'IIS Webserver Information',0,1,'iis_info','',28,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,50,0,'none',0,1,0);
INSERT INTO interface_types VALUES (28,'Livingston Serial Port',0,1,'livingston_serial_port','',29,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,48,0,'none',0,1,0);
INSERT INTO interface_types VALUES (29,'Apache',0,1,'apache','',30,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,53,0,'none',1,1,0);
INSERT INTO interface_types VALUES (30,'SQL Query',0,1,'none','',32,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,65,0,'none',1,1,0);
INSERT INTO interface_types VALUES (31,'APC',1,1,'apc','enterprises.318',31,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,61,0,'none',0,1,0);
INSERT INTO interface_types VALUES (32,'Alteon Real Server',1,1,'alteon_realservers','',33,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,66,0,'none',0,1,0);
INSERT INTO interface_types VALUES (33,'Alteon Virtual Server',0,1,'alteon_virtualservers','',34,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,70,0,'none',0,1,0);
INSERT INTO interface_types VALUES (34,'Alteon Real Services',0,1,'alteon_realservices','',35,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,73,0,'none',0,1,0);
INSERT INTO interface_types VALUES (35,'Alteon System Info',1,1,'host_information','enterprises.1872',36,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,75,0,'none',0,1,0);
INSERT INTO interface_types VALUES (36,'Brocade Sensors',0,0,'brocade_sensors','',37,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,77,0,'none',0,1,0);
INSERT INTO interface_types VALUES (37,'Brocade FC Ports',0,0,'brocade_fcports','',38,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,78,0,'none',0,1,0);
INSERT INTO interface_types VALUES (38,'Cisco Dialup Usage',1,1,'cisco_serial_port','',39,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,80,0,'none',0,1,0);
INSERT INTO interface_types VALUES (39,'Windows Logical Disks',1,1,'informant_ldisks','',40,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,82,0,'none',0,1,0);
INSERT INTO interface_types VALUES (40,'UPS',1,1,'ups','',41,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,84,0,'none',0,1,0);
INSERT INTO interface_types VALUES (41,'UPS Lines',0,1,'ups_lines','',42,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,85,0,'none',0,1,0);
INSERT INTO interface_types VALUES (42,'IPTables Chains',1,1,'linux_iptables','.1.3.6.1.4.1.2021.5002',43,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,89,1,'none',0,1,0);
INSERT INTO interface_types VALUES (43,'Cisco PIX',1,1,'pix_connections','',44,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,91,0,'none',0,1,0);
INSERT INTO interface_types VALUES (44,'Cisco NAT',0,1,'simple','.1.3.6.1.4.1.9.10.77.1.2.1.0,NAT',45,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,93,0,'none',0,1,0);
INSERT INTO interface_types VALUES (45,'Sensors',1,1,'sensors','',46,1,'RRA:AVERAGE:0.5:1:<resolution>','103680',300,94,1,'none',0,1,0);

--
-- Table structure for table `interface_types_field_types`
--



--
-- Sequences for table INTERFACE_TYPES_FIELD_TYPES
--

CREATE SEQUENCE interface_types_field_types_id_seq;

CREATE TABLE interface_types_field_types (
  id INT4 DEFAULT nextval('interface_types_field_types_id_seq'),
  description varchar(30) NOT NULL default '',
  handler varchar(30) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `interface_types_field_types`
--

INSERT INTO interface_types_field_types VALUES (1,'Unknown','none');
INSERT INTO interface_types_field_types VALUES (3,'Index','text');
INSERT INTO interface_types_field_types VALUES (5,'Boolean','bool');
INSERT INTO interface_types_field_types VALUES (7,'Description','text');
INSERT INTO interface_types_field_types VALUES (8,'Other','text');
INSERT INTO interface_types_field_types VALUES (20,'RRDTool DS','rrd_ds');

--
-- Table structure for table `interface_types_fields`
--



--
-- Sequences for table INTERFACE_TYPES_FIELDS
--

CREATE SEQUENCE interface_types_fields_id_seq;

CREATE TABLE interface_types_fields (
  id INT4 DEFAULT nextval('interface_types_fields_id_seq'),
  description varchar(40) NOT NULL default '',
  name varchar(40) NOT NULL default '',
  pos INT4 NOT NULL default '10',
  itype INT4 NOT NULL default '1',
  ftype INT4 NOT NULL default '1',
  showable INT2 NOT NULL default '1',
  overwritable INT2 NOT NULL default '1',
  tracked INT2 NOT NULL default '0',
  default_value varchar(250) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `interface_types_fields`
--

INSERT INTO interface_types_fields VALUES (1,'Unknown','unknown',10,1,1,0,0,0,'');
INSERT INTO interface_types_fields VALUES (3,'SNMP IFIndex','interfacenumber',60,4,3,1,1,0,'');
INSERT INTO interface_types_fields VALUES (4,'Description','description',10,4,7,1,1,1,'');
INSERT INTO interface_types_fields VALUES (5,'IP Address','address',30,4,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (6,'Input Bandwidth','bandwidthin',50,4,8,1,1,0,'1');
INSERT INTO interface_types_fields VALUES (7,'Port Number','port',10,2,3,1,1,0,'');
INSERT INTO interface_types_fields VALUES (9,'Check Content','check_content',30,2,5,2,1,0,'0');
INSERT INTO interface_types_fields VALUES (10,'Port Description','description',20,2,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (11,'Input Bytes','input',10,4,20,0,0,0,'DS:input:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (12,'Established Connections','tcp_conn_number',10,2,20,0,0,0,'DS:tcp_conn_number:GAUGE:600:0:10000');
INSERT INTO interface_types_fields VALUES (13,'Check Content URL','check_url',40,2,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (14,'Output Bytes','output',20,4,20,0,0,0,'DS:output:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (15,'Input Packets','inpackets',70,4,20,0,0,0,'DS:inpackets:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (16,'Flip In Out in Graphs','flipinout',70,4,5,2,1,0,'0');
INSERT INTO interface_types_fields VALUES (20,'Connection Delay','conn_delay',20,2,20,0,0,0,'DS:conn_delay:GAUGE:600:0:100000');
INSERT INTO interface_types_fields VALUES (21,'Output Bandwidth','bandwidthout',51,4,8,2,1,0,'1');
INSERT INTO interface_types_fields VALUES (22,'Peer Address','peer',36,4,8,1,1,0,'');
INSERT INTO interface_types_fields VALUES (23,'Input Errors','inputerrors',30,4,20,0,0,0,'DS:inputerrors:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (24,'Output Errors','outputerrors',40,4,20,0,0,0,'DS:outputerrors:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (25,'Round Trip Time','rtt',50,4,20,0,0,0,'DS:rtt:GAUGE:600:0:10000');
INSERT INTO interface_types_fields VALUES (26,'PacketLoss','packetloss',60,4,20,0,0,0,'DS:packetloss:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (27,'Output Packets','outpackets',80,4,20,0,0,0,'DS:outpackets:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (28,'Drops','drops',90,4,20,0,0,0,'DS:drops:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (29,'Not Used','aux4',100,4,20,0,0,0,'DS:aux4:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (30,'Saved Input Bandwidth','bandwidthin',110,4,20,0,0,0,'DS:bandwidthin:GAUGE:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (31,'Saved Output Bandwidth','bandwidthout',120,4,20,0,0,0,'DS:bandwidthout:GAUGE:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (32,'Index','index',10,12,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (33,'Description','description',20,12,7,1,0,1,'System Information');
INSERT INTO interface_types_fields VALUES (34,'Number of Processors','cpu_num',30,12,8,1,1,0,'1');
INSERT INTO interface_types_fields VALUES (35,'Index','index',10,11,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (36,'Description','description',20,11,7,1,0,1,'System Information');
INSERT INTO interface_types_fields VALUES (37,'Number of CPUs','cpu_num',30,11,8,1,1,0,'1');
INSERT INTO interface_types_fields VALUES (43,'CPU','cpu',10,3,20,0,0,0,'DS:cpu:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (44,'Mem Used','mem_used',20,3,20,0,0,0,'DS:mem_used:GAUGE:600:0:100000000000');
INSERT INTO interface_types_fields VALUES (45,'Mem Free','mem_free',30,3,20,0,0,0,'DS:mem_free:GAUGE:600:0:100000000000');
INSERT INTO interface_types_fields VALUES (46,'Acct Packets','acct_packets',40,3,20,0,0,0,'DS:acct_packets:ABSOLUTE:600:0:100000000000');
INSERT INTO interface_types_fields VALUES (47,'Acct Bytes','acct_bytes',50,3,20,0,0,0,'DS:acct_bytes:GAUGE:600:0:100000000000');
INSERT INTO interface_types_fields VALUES (48,'Tcp Active','tcp_active',60,3,20,0,0,0,'DS:tcp_active:COUNTER:600:0:10000000');
INSERT INTO interface_types_fields VALUES (49,'Tcp Passive','tcp_passive',70,3,20,0,0,0,'DS:tcp_passive:COUNTER:600:0:1000000');
INSERT INTO interface_types_fields VALUES (50,'Tcp Established','tcp_established',80,3,20,0,0,0,'DS:tcp_established:COUNTER:600:0:1000000');
INSERT INTO interface_types_fields VALUES (51,'Bgpin','bgpin',10,6,20,0,0,0,'DS:bgpin:COUNTER:600:0:10000000');
INSERT INTO interface_types_fields VALUES (52,'Bgpout','bgpout',20,6,20,0,0,0,'DS:bgpout:COUNTER:600:0:10000000');
INSERT INTO interface_types_fields VALUES (53,'Bgpuptime','bgpuptime',30,6,20,0,0,0,'DS:bgpuptime:GAUGE:600:0:10000000');
INSERT INTO interface_types_fields VALUES (56,'Storage Block Size','storage_block_size',10,8,20,0,0,0,'DS:storage_block_size:GAUGE:600:0:<size>');
INSERT INTO interface_types_fields VALUES (57,'Storage Block Count','storage_block_count',20,8,20,0,0,0,'DS:storage_block_count:GAUGE:600:0:<size>');
INSERT INTO interface_types_fields VALUES (58,'Storage Used Blocks','storage_used_blocks',30,8,20,0,0,0,'DS:storage_used_blocks:GAUGE:600:0:<size>');
INSERT INTO interface_types_fields VALUES (59,'Output','output',10,9,20,0,0,0,'DS:output:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (60,'Hits','hits',20,9,20,0,0,0,'DS:hits:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (61,'Cpu User Ticks','cpu_user_ticks',10,10,20,0,0,0,'DS:cpu_user_ticks:COUNTER:600:0:86400');
INSERT INTO interface_types_fields VALUES (62,'Cpu Idle Ticks','cpu_idle_ticks',20,10,20,0,0,0,'DS:cpu_idle_ticks:COUNTER:600:0:86400');
INSERT INTO interface_types_fields VALUES (63,'Cpu Wait Ticks','cpu_wait_ticks',30,10,20,0,0,0,'DS:cpu_wait_ticks:COUNTER:600:0:86400');
INSERT INTO interface_types_fields VALUES (64,'Cpu Kernel Ticks','cpu_kernel_ticks',40,10,20,0,0,0,'DS:cpu_kernel_ticks:COUNTER:600:0:86400');
INSERT INTO interface_types_fields VALUES (65,'Swap Total','swap_total',50,10,20,0,0,0,'DS:swap_total:GAUGE:600:0:10000000000');
INSERT INTO interface_types_fields VALUES (66,'Swap Available','swap_available',60,10,20,0,0,0,'DS:swap_available:GAUGE:600:0:10000000000');
INSERT INTO interface_types_fields VALUES (67,'Mem Total','mem_total',70,10,20,0,0,0,'DS:mem_total:GAUGE:600:0:10000000000');
INSERT INTO interface_types_fields VALUES (68,'Mem Available','mem_available',80,10,20,0,0,0,'DS:mem_available:GAUGE:600:0:10000000000');
INSERT INTO interface_types_fields VALUES (69,'Load Average 1','load_average_1',90,10,20,0,0,0,'DS:load_average_1:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (70,'Load Average 5','load_average_5',100,10,20,0,0,0,'DS:load_average_5:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (71,'Load Average 15','load_average_15',110,10,20,0,0,0,'DS:load_average_15:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (72,'Cpu User Ticks','cpu_user_ticks',10,11,20,0,0,0,'DS:cpu_user_ticks:COUNTER:600:0:86400');
INSERT INTO interface_types_fields VALUES (73,'Cpu Idle Ticks','cpu_idle_ticks',20,11,20,0,0,0,'DS:cpu_idle_ticks:COUNTER:600:0:86400');
INSERT INTO interface_types_fields VALUES (74,'Cpu Nice Ticks','cpu_nice_ticks',30,11,20,0,0,0,'DS:cpu_nice_ticks:COUNTER:600:0:86400');
INSERT INTO interface_types_fields VALUES (75,'Cpu System Ticks','cpu_system_ticks',40,11,20,0,0,0,'DS:cpu_system_ticks:COUNTER:600:0:86400');
INSERT INTO interface_types_fields VALUES (76,'Load Average 1','load_average_1',50,11,20,0,0,0,'DS:load_average_1:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (77,'Load Average 5','load_average_5',60,11,20,0,0,0,'DS:load_average_5:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (78,'Load Average 15','load_average_15',70,11,20,0,0,0,'DS:load_average_15:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (79,'Num Users','num_users',80,11,20,0,0,0,'DS:num_users:GAUGE:600:0:100000');
INSERT INTO interface_types_fields VALUES (80,'Num Procs','num_procs',90,11,20,0,0,0,'DS:num_procs:GAUGE:600:0:10000000');
INSERT INTO interface_types_fields VALUES (81,'Tcp Active','tcp_active',100,11,20,0,0,0,'DS:tcp_active:COUNTER:600:0:10000000');
INSERT INTO interface_types_fields VALUES (82,'Tcp Passive','tcp_passive',110,11,20,0,0,0,'DS:tcp_passive:COUNTER:600:0:1000000');
INSERT INTO interface_types_fields VALUES (83,'Tcp Established','tcp_established',120,11,20,0,0,0,'DS:tcp_established:COUNTER:600:0:1000000');
INSERT INTO interface_types_fields VALUES (84,'CPU','cpu',10,12,20,0,0,0,'DS:cpu:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (85,'Num Users','num_users',20,12,20,0,0,0,'DS:num_users:GAUGE:600:0:100000');
INSERT INTO interface_types_fields VALUES (86,'Num Procs','num_procs',30,12,20,0,0,0,'DS:num_procs:GAUGE:600:0:10000000');
INSERT INTO interface_types_fields VALUES (87,'Tcp Active','tcp_active',40,12,20,0,0,0,'DS:tcp_active:COUNTER:600:0:10000000');
INSERT INTO interface_types_fields VALUES (88,'Tcp Passive','tcp_passive',50,12,20,0,0,0,'DS:tcp_passive:COUNTER:600:0:1000000');
INSERT INTO interface_types_fields VALUES (89,'Tcp Established','tcp_established',60,12,20,0,0,0,'DS:tcp_established:COUNTER:600:0:1000000');
INSERT INTO interface_types_fields VALUES (90,'Input','input',10,13,20,0,0,0,'DS:input:COUNTER:600:0:10000000000');
INSERT INTO interface_types_fields VALUES (91,'Output','output',20,13,20,0,0,0,'DS:output:COUNTER:600:0:10000000000');
INSERT INTO interface_types_fields VALUES (92,'Inputpackets','inputpackets',30,13,20,0,0,0,'DS:inputpackets:COUNTER:600:0:10000000000');
INSERT INTO interface_types_fields VALUES (93,'Outputpackets','outputpackets',40,13,20,0,0,0,'DS:outputpackets:COUNTER:600:0:10000000000');
INSERT INTO interface_types_fields VALUES (94,'RTT','rtt',10,14,20,0,0,0,'DS:rtt:GAUGE:600:0:10000');
INSERT INTO interface_types_fields VALUES (95,'Packetloss','packetloss',20,14,20,0,0,0,'DS:packetloss:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (98,'Temperature','temperature',10,17,20,0,0,0,'DS:temperature:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (100,'Forward Jitter','forward_jitter',10,19,20,0,0,0,'DS:forward_jitter:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (101,'Backward Jitter','backward_jitter',20,19,20,0,0,0,'DS:backward_jitter:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (102,'Rt Latency','rt_latency',30,19,20,0,0,0,'DS:rt_latency:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (103,'Forward Packetloss','forward_packetloss',40,19,20,0,0,0,'DS:forward_packetloss:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (104,'Backward Packetloss','backward_packetloss',50,19,20,0,0,0,'DS:backward_packetloss:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (105,'RTT','rtt',10,20,20,0,0,0,'DS:rtt:GAUGE:600:0:10000');
INSERT INTO interface_types_fields VALUES (106,'Packetloss','packetloss',20,20,20,0,0,0,'DS:packetloss:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (107,'Bytes','bytes',10,21,20,0,0,0,'DS:bytes:COUNTER:600:0:<ceil>');
INSERT INTO interface_types_fields VALUES (108,'Packets','packets',20,21,20,0,0,0,'DS:packets:COUNTER:600:0:<ceil>');
INSERT INTO interface_types_fields VALUES (109,'Disk Type','storage_type',10,8,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (110,'Size (Bytes)','size',20,8,7,1,1,1,'0');
INSERT INTO interface_types_fields VALUES (111,'Description','description',30,8,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (112,'Index','index',40,8,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (113,'Index','index',10,10,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (114,'Description','description',20,10,7,1,0,1,'System Information');
INSERT INTO interface_types_fields VALUES (115,'Number of Processors','cpu_num',30,10,8,1,1,0,'1');
INSERT INTO interface_types_fields VALUES (116,'Index','index',10,14,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (117,'Description','description',20,14,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (118,'Index','index',10,20,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (119,'Description','description',20,20,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (120,'Rate','rate',20,21,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (121,'Ceil','ceil',30,21,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (122,'Index','index',50,21,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (123,'Description','description',40,21,7,2,1,0,'');
INSERT INTO interface_types_fields VALUES (124,'Index','index',10,9,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (125,'Owner','owner',20,9,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (126,'VIP Address','address',30,9,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (127,'Bandwidth','bandwidth',40,9,8,1,1,0,'1');
INSERT INTO interface_types_fields VALUES (128,'Description','description',20,18,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (129,'Description','description',20,17,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (130,'Description','description',20,16,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (131,'Index','index',30,18,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (132,'Index','index',30,17,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (133,'Index','index',10,16,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (134,'Number of Processors','cpu_num',30,3,8,1,1,0,'1');
INSERT INTO interface_types_fields VALUES (135,'Index','index',10,3,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (136,'Description','description',20,3,7,1,0,1,'System Information');
INSERT INTO interface_types_fields VALUES (137,'Index','index',10,19,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (138,'Description','description',20,19,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (139,'Description','description',20,13,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (140,'Index','index',35,13,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (141,'MAC Address','mac',30,13,8,0,0,1,'');
INSERT INTO interface_types_fields VALUES (142,'Interface Index','ifindex',40,13,8,2,0,1,'');
INSERT INTO interface_types_fields VALUES (143,'IP Address','address',25,13,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (144,'Flip Graph In/Out','flipinout',45,13,5,2,1,0,'0');
INSERT INTO interface_types_fields VALUES (145,'Local IP','local',30,6,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (146,'Remote IP','remote',40,6,3,1,0,0,'');
INSERT INTO interface_types_fields VALUES (147,'Autonomous System','asn',20,6,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (149,'Description','description',50,6,7,2,1,0,'');
INSERT INTO interface_types_fields VALUES (150,'Process Name','process_name',10,15,3,2,0,0,'');
INSERT INTO interface_types_fields VALUES (151,'Description','description',20,15,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (153,'Instances at Discovery','instances',30,15,8,1,1,0,'1');
INSERT INTO interface_types_fields VALUES (154,'Pings to Send','pings',80,4,8,2,1,0,'50');
INSERT INTO interface_types_fields VALUES (155,'Pings to Send','pings',30,20,8,2,1,0,'50');
INSERT INTO interface_types_fields VALUES (156,'PL Threshold %','threshold',40,20,8,2,1,0,'70');
INSERT INTO interface_types_fields VALUES (157,'Interval (ms)','interval',50,20,8,2,1,0,'300');
INSERT INTO interface_types_fields VALUES (158,'Check Content RegExp','check_regexp',50,2,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (159,'Current Instances','current_instances',10,15,20,0,0,0,'DS:current_instances:GAUGE:600:0:99999');
INSERT INTO interface_types_fields VALUES (160,'Index','index',10,22,3,0,0,0,'1');
INSERT INTO interface_types_fields VALUES (161,'Fixed Admin Status','fixed_admin_status',99,4,5,2,1,0,'0');
INSERT INTO interface_types_fields VALUES (162,'Usage Threshold %','usage_threshold',40,8,8,2,1,0,'80');
INSERT INTO interface_types_fields VALUES (164,'Used Memory','used_memory',20,15,20,0,0,0,'DS:used_memory:GAUGE:600:0:9999999');
INSERT INTO interface_types_fields VALUES (165,'IP Mask','mask',32,4,8,2,1,1,'');
INSERT INTO interface_types_fields VALUES (167,'Show in Celcius','show_celcius',40,17,5,2,1,0,'1');
INSERT INTO interface_types_fields VALUES (168,'Port Number','port',10,23,3,1,1,0,'');
INSERT INTO interface_types_fields VALUES (169,'Port Description','description',20,23,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (170,'Connection Delay','conn_delay',10,23,20,0,0,0,'DS:conn_delay:GAUGE:600:0:100000');
INSERT INTO interface_types_fields VALUES (171,'Controller','controller',10,24,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (172,'Drive','drvindex',11,24,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (173,'Drive Model','model',15,24,8,1,0,1,'');
INSERT INTO interface_types_fields VALUES (174,'Index','index',5,24,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (175,'Index','index',5,25,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (176,'Chassis','chassis',10,25,8,1,0,1,'');
INSERT INTO interface_types_fields VALUES (177,'Fan','fanindex',11,25,8,1,0,1,'');
INSERT INTO interface_types_fields VALUES (178,'Location','location',20,25,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (179,'Index','index',5,26,3,0,1,0,'');
INSERT INTO interface_types_fields VALUES (180,'Chassis','chassis',10,26,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (181,'Sensor','tempindex',11,26,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (182,'Location','location',2,26,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (183,'Temperature','temperature',80,26,20,0,0,0,'DS:temperature:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (184,'Index','index',10,27,3,0,0,0,'1');
INSERT INTO interface_types_fields VALUES (185,'Total Bytes Received','tbr',10,27,20,0,0,0,'DS:tbr:COUNTER:600:0:999999999');
INSERT INTO interface_types_fields VALUES (186,'Total CGI Requests','tcgir',20,27,20,0,0,0,'DS:tcgir:COUNTER:600:0:999999999');
INSERT INTO interface_types_fields VALUES (187,'Total Files Sent','tfs',30,27,20,0,0,0,'DS:tfs:COUNTER:600:0:999999999');
INSERT INTO interface_types_fields VALUES (188,'Total Gets','tg',40,27,20,0,0,0,'DS:tg:COUNTER:600:0:999999999');
INSERT INTO interface_types_fields VALUES (189,'Total Posts','tp',50,27,20,0,0,0,'DS:tp:COUNTER:600:0:999999999');
INSERT INTO interface_types_fields VALUES (190,'Serial Lines Free','pm_serial_free',10,28,20,1,0,0,'DS:pm_serial_free:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (191,'Serial Lines Connecting','pm_serial_connecting',20,28,20,1,0,0,'DS:pm_serial_connecting:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (192,'Serial Lines Established','pm_serial_established',30,28,20,1,0,0,'DS:pm_serial_established:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (193,'Serial Lines Disconnecting','pm_serial_disconnecting',40,28,20,1,0,0,'DS:pm_serial_disconnecting:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (194,'Serial Lines Command','pm_serial_command',50,28,20,1,0,0,'DS:pm_serial_command:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (195,'Serial Lines NoService','pm_serial_noservice',60,28,20,1,0,0,'DS:pm_serial_noservice:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (196,'Index','index',10,28,3,0,0,0,'1');
INSERT INTO interface_types_fields VALUES (197,'Process Threshold','proc_threshold',40,12,8,2,1,0,'100');
INSERT INTO interface_types_fields VALUES (199,'Description','description',20,29,7,2,1,0,'Apache Stats');
INSERT INTO interface_types_fields VALUES (200,'Total Accesses','tac',30,29,20,0,0,0,'DS:tac:COUNTER:600:0:100000');
INSERT INTO interface_types_fields VALUES (201,'IP:Port','ip_port',10,29,3,1,1,0,'');
INSERT INTO interface_types_fields VALUES (202,'Total KBytes','tkb',20,29,20,0,0,0,'DS:tkb:COUNTER:600:0:10000000');
INSERT INTO interface_types_fields VALUES (203,'CPU Load','cplo',60,29,20,0,0,0,'DS:cplo:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (204,'Uptime','up',10,29,20,0,0,0,'DS:up:GAUGE:600:0:99999999999999');
INSERT INTO interface_types_fields VALUES (205,'Bytes Per Request','bpr',40,29,20,0,0,0,'DS:bpr:GAUGE:600:0:10000000');
INSERT INTO interface_types_fields VALUES (208,'Busy Workers','bw',90,29,20,0,0,0,'DS:bw:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (209,'Idle Workers','iw',50,29,20,0,0,0,'DS:iw:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (210,'Index','index',10,31,3,0,0,0,'1');
INSERT INTO interface_types_fields VALUES (211,'Description','description',20,31,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (212,'Battery Capacity','capacity',10,31,20,0,0,0,'DS:capacity:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (213,'Output Load','load',20,31,20,0,0,0,'DS:load:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (214,'Input Voltage','in_voltage',31,31,20,0,0,0,'DS:in_voltage:GAUGE:600:0:400');
INSERT INTO interface_types_fields VALUES (215,'Output Voltage','out_voltage',40,31,20,0,0,0,'DS:out_voltage:GAUGE:600:0:400');
INSERT INTO interface_types_fields VALUES (216,'Time Remaining','time_remaining',50,31,20,0,0,0,'DS:time_remaining:GAUGE:600:0:9999999999');
INSERT INTO interface_types_fields VALUES (217,'Temperature','temperature',60,31,20,0,0,0,'DS:temperature:GAUGE:600:0:200');
INSERT INTO interface_types_fields VALUES (218,'Show Temp in Celcius','show_celcius',31,31,5,2,1,0,'1');
INSERT INTO interface_types_fields VALUES (220,'Index','index',10,30,3,1,1,0,'1');
INSERT INTO interface_types_fields VALUES (221,'Description','description',20,30,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (222,'DSN','dsn',30,30,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (223,'Username','username',40,30,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (224,'Password','password',50,30,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (225,'Max Records','max_records',60,30,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (226,'Min Records','min_records',70,30,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (227,'Counter Records','records_counter',10,30,20,0,0,0,'DS:records_counter:COUNTER:600:0:9999999999');
INSERT INTO interface_types_fields VALUES (228,'Query','query',55,30,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (229,'Absolute Records','records_absolute',20,30,20,0,0,0,'DS:records_absolute:GAUGE:600:0:9999999999');
INSERT INTO interface_types_fields VALUES (230,'Is Absolute?','absolute',80,30,5,1,1,0,'0');
INSERT INTO interface_types_fields VALUES (231,'Percentile','percentile',55,4,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (232,'Index','index',10,32,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (233,'Hostname','hostname',20,32,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (234,'Max Connections','max_connections',30,32,8,2,1,0,'');
INSERT INTO interface_types_fields VALUES (235,'Total Sessions','total_sessions',50,32,20,0,0,0,'DS:total_sessions:COUNTER:600:0:100000000');
INSERT INTO interface_types_fields VALUES (236,'Current Sessions','current_sessions',55,32,20,0,0,0,'DS:current_sessions:GAUGE:600:0:<max_connections>');
INSERT INTO interface_types_fields VALUES (237,'Failures','failures',60,32,20,0,0,0,'DS:failures:COUNTER:600:0:10000');
INSERT INTO interface_types_fields VALUES (238,'Octets','octets',65,32,20,0,0,0,'DS:octets:COUNTER:600:0:1000000000');
INSERT INTO interface_types_fields VALUES (239,'Index','index',10,33,3,0,0,1,'');
INSERT INTO interface_types_fields VALUES (240,'Hostname','hostname',20,33,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (241,'Total Sessions','total_sessions',30,33,20,0,0,0,'DS:total_sessions:COUNTER:600:0:100000000');
INSERT INTO interface_types_fields VALUES (242,'Current Sessions','current_sessions',35,33,20,0,0,0,'DS:current_sessions:GAUGE:600:0:20000');
INSERT INTO interface_types_fields VALUES (243,'Octets','octets',40,33,20,0,0,0,'DS:octets:COUNTER:600:0:1000000000');
INSERT INTO interface_types_fields VALUES (244,'Index','index',10,34,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (245,'Hostname','hostname',20,34,7,1,0,0,'');
INSERT INTO interface_types_fields VALUES (246,'Address','address',30,34,7,1,0,0,'');
INSERT INTO interface_types_fields VALUES (247,'Port','port',35,34,7,1,0,0,'');
INSERT INTO interface_types_fields VALUES (248,'Real Server','real_server',15,34,8,0,0,1,'');
INSERT INTO interface_types_fields VALUES (249,'Response Time','response_time',40,34,20,0,0,0,'DS:response_time:GAUGE:600:0:10000');
INSERT INTO interface_types_fields VALUES (250,'Index','index',10,35,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (251,'Description','description',20,35,7,1,0,0,'');
INSERT INTO interface_types_fields VALUES (252,'Number of CPUs','cpu_num',30,35,8,0,0,0,'');
INSERT INTO interface_types_fields VALUES (253,'TCP Active','tcp_active',40,35,20,0,0,0,'DS:tcp_active:COUNTER:600:0:10000');
INSERT INTO interface_types_fields VALUES (254,'TCP Passive','tcp_passive',41,35,20,0,0,0,'DS:tcp_passive:COUNTER:600:0:10000');
INSERT INTO interface_types_fields VALUES (255,'TCP Established','tcp_established',42,35,20,0,0,0,'DS:tcp_established:COUNTER:600:0:10000');
INSERT INTO interface_types_fields VALUES (256,'Memory Total','mem_total',50,35,20,0,0,0,'DS:mem_total:GAUGE:600:0:100000000');
INSERT INTO interface_types_fields VALUES (257,'Memory Used','mem_used',51,35,20,0,0,0,'DS:mem_used:GAUGE:600:0:100000000');
INSERT INTO interface_types_fields VALUES (258,'CPU A 1 Sec','cpua_1sec',60,35,20,0,0,0,'DS:cpua_1sec:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (259,'CPU A 4 Secs','cpua_4secs',61,35,20,0,0,0,'DS:cpua_4secs:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (260,'CPU A 64 Secs','cpua_64secs',62,35,20,0,0,0,'DS:cpua_64secs:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (261,'CPU B 1 Sec','cpub_1sec',65,35,20,0,0,0,'DS:cpub_1sec:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (262,'CPU B 4 Secs','cpub_4secs',66,35,20,0,0,0,'DS:cpub_4secs:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (263,'CPU B 64 Secs','cpub_64secs',67,35,20,0,0,0,'DS:cpub_64secs:GAUGE:600:0:1000');
INSERT INTO interface_types_fields VALUES (264,'Index','index',10,36,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (265,'Type','sensor_type',30,36,8,1,0,0,'');
INSERT INTO interface_types_fields VALUES (266,'Value','sensor_value',40,36,20,0,0,0,'DS:sensor_value:GAUGE:600:0:3000000000');
INSERT INTO interface_types_fields VALUES (267,'Index','index',10,37,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (268,'Description','description',20,37,7,1,0,0,'');
INSERT INTO interface_types_fields VALUES (269,'Physical Status','phy',40,37,8,1,0,0,'');
INSERT INTO interface_types_fields VALUES (270,'Tx Words','tx_words',40,37,20,0,0,0,'DS:tx_words:COUNTER:600:0:1000000000');
INSERT INTO interface_types_fields VALUES (271,'Rx Words','rx_words',45,37,20,0,0,0,'DS:rx_words:COUNTER:600:0:1000000000');
INSERT INTO interface_types_fields VALUES (272,'Tx Frames','tx_frames',50,37,20,0,0,0,'DS:tx_frames:COUNTER:600:0:100000000');
INSERT INTO interface_types_fields VALUES (273,'Rx Frames','rx_frames',55,37,20,0,0,0,'DS:rx_frames:COUNTER:600:0:100000000');
INSERT INTO interface_types_fields VALUES (274,'Index','index',10,38,3,0,0,0,'1');
INSERT INTO interface_types_fields VALUES (275,'Async Used','cisco_async',10,38,20,0,0,0,'DS:cisco_async:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (276,'DSX Used','cisco_dsx',20,38,20,0,0,0,'DS:cisco_dsx:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (277,'Free','cisco_free',30,38,20,0,0,0,'DS:cisco_free:GAUGE:600:0:5000');
INSERT INTO interface_types_fields VALUES (278,'Description','description',20,38,7,2,1,0,'');
INSERT INTO interface_types_fields VALUES (279,'System Name','name',40,11,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (280,'Location','location',50,11,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (281,'Contact','contact',60,11,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (282,'System Name','name',50,12,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (283,'Location','location',60,12,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (284,'Contact','contact',70,12,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (285,'System Name','name',40,3,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (286,'Location','location',50,3,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (287,'Contact','contact',60,3,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (288,'System Name','name',40,10,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (289,'Location','location',50,10,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (290,'Contact','contact',60,10,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (291,'System Name','name',40,35,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (292,'Location','location',50,35,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (293,'Contact','contact',60,35,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (294,'Index','index',10,39,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (295,'Description','description',20,39,7,2,1,0,'SNMP Informant Disk Stats');
INSERT INTO interface_types_fields VALUES (296,'lDisk % Read Time','inf_d_read_time',20,39,20,0,0,0,'DS:inf_d_read_time:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (297,'lDisk % Write Time','inf_d_write_time',10,39,20,0,0,0,'DS:inf_d_write_time:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (298,'lDisk Read Rate','inf_d_read_rate',30,39,20,0,0,0,'DS:inf_d_read_rate:GAUGE:600:0:1048576000');
INSERT INTO interface_types_fields VALUES (299,'lDisk Write Rate','inf_d_write_rate',25,39,20,0,0,0,'DS:inf_d_write_rate:GAUGE:600:0:1048576000');
INSERT INTO interface_types_fields VALUES (300,'Index','index',10,40,3,0,0,0,'1');
INSERT INTO interface_types_fields VALUES (301,'Identification','ident',20,40,7,1,0,1,'');
INSERT INTO interface_types_fields VALUES (302,'Description','description',30,40,7,2,1,0,'');
INSERT INTO interface_types_fields VALUES (303,'Battery Temperature','temperature',10,40,20,0,0,0,'DS:temperature:GAUGE:600:0:200');
INSERT INTO interface_types_fields VALUES (304,'Show in Celcius','show_celcius',40,40,5,2,1,0,'1');
INSERT INTO interface_types_fields VALUES (305,'Minutes Remaining','minutes_remaining',20,40,20,0,0,0,'DS:minutes_remaining:GAUGE:600:0:10000');
INSERT INTO interface_types_fields VALUES (306,'Index','index',10,41,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (307,'Line Type','line_type',20,41,8,0,0,0,'');
INSERT INTO interface_types_fields VALUES (308,'Line Index','line_index',30,41,8,0,0,0,'');
INSERT INTO interface_types_fields VALUES (309,'Description','description',40,41,7,2,1,0,'');
INSERT INTO interface_types_fields VALUES (310,'Voltage','voltage',10,41,20,0,0,0,'DS:voltage:GAUGE:600:0:500');
INSERT INTO interface_types_fields VALUES (311,'Current','current',20,41,20,0,0,0,'DS:current:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (312,'Load','load',30,41,20,0,0,0,'DS:load:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (313,'Charge Remaining','charge_remaining',30,40,20,0,0,0,'DS:charge_remaining:GAUGE:600:0:100');
INSERT INTO interface_types_fields VALUES (314,'IPTables Chain','chainnumber',10,42,3,1,1,0,'');
INSERT INTO interface_types_fields VALUES (315,'Default Policy','policy',30,42,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (316,'Number of Packets','ipt_packets',10,42,20,0,0,0,'DS:ipt_packets:COUNTER:600:0:1000000000');
INSERT INTO interface_types_fields VALUES (317,'Number of Bytes','ipt_bytes',20,42,20,0,0,0,'DS:ipt_bytes:COUNTER:600:0:<bandwidth>');
INSERT INTO interface_types_fields VALUES (318,'Description','description',20,42,7,2,1,0,'');
INSERT INTO interface_types_fields VALUES (319,'Accepted Routers','accepted_routes',40,6,20,0,0,0,'DS:accepted_routes:GAUGE:600:0:900000');
INSERT INTO interface_types_fields VALUES (320,'Advertised Routers','advertised_routes',50,6,20,0,0,0,'DS:advertised_routes:GAUGE:600:0:900000');
INSERT INTO interface_types_fields VALUES (322,'Estimated Bandwidth','bandwidth',40,42,8,2,1,0,'10240000');
INSERT INTO interface_types_fields VALUES (323,'Index','index',10,43,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (324,'Connections','pix_connections',10,43,20,0,0,0,'DS:pix_connections:GAUGE:600:0:1000000');
INSERT INTO interface_types_fields VALUES (325,'Description','description',20,43,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (326,'Index','index',10,44,3,0,0,0,'1');
INSERT INTO interface_types_fields VALUES (327,'Description','description',20,44,7,2,1,0,'');
INSERT INTO interface_types_fields VALUES (328,'Cisco Max Inbound NAT Bytes','NatInMax',30,44,8,2,1,0,'1000000000');
INSERT INTO interface_types_fields VALUES (329,'Cisco Max Outbound NAT Bytes','NatOutMax',40,44,8,2,1,0,'1000000000');
INSERT INTO interface_types_fields VALUES (330,'Cisco NAT Other IP Outbound','cisco_nat_other_ip_outbound',10,44,20,0,0,0,'DS:cisco_nat_other_ip_outbound:COUNTER:600:0:<NatOutMax>');
INSERT INTO interface_types_fields VALUES (331,'Cisco NAT Other IP Inbound','cisco_nat_other_ip_inbound',15,44,20,0,0,0,'DS:cisco_nat_other_ip_inbound:COUNTER:600:0:<NatInMax>');
INSERT INTO interface_types_fields VALUES (332,'Cisco NAT ICMP Outbound','cisco_nat_icmp_outbound',20,44,20,0,0,0,'DS:cisco_nat_icmp_outbound:COUNTER:600:0:<NatOutMax>');
INSERT INTO interface_types_fields VALUES (333,'Cisco NAT ICMP Inbound','cisco_nat_icmp_inbound',25,44,20,0,0,0,'DS:cisco_nat_icmp_inbound:COUNTER:600:0:<NatInMax>');
INSERT INTO interface_types_fields VALUES (334,'Cisco NAT UDP Outbound','cisco_nat_udp_outbound',30,44,20,0,0,0,'DS:cisco_nat_udp_outbound:COUNTER:600:0:<NatOutMax>');
INSERT INTO interface_types_fields VALUES (335,'Cisco NAT UDP Inbound','cisco_nat_udp_inbound',35,44,20,0,0,0,'DS:cisco_nat_udp_inbound:COUNTER:600:0:<NatInMax>');
INSERT INTO interface_types_fields VALUES (336,'Cisco NAT TCP Outbound','cisco_nat_tcp_outbound',40,44,20,0,0,0,'DS:cisco_nat_tcp_outbound:COUNTER:600:0:<NatOutMax>');
INSERT INTO interface_types_fields VALUES (337,'Cisco NAT TCP Inbound','cisco_nat_tcp_inbound',45,44,20,0,0,0,'DS:cisco_nat_tcp_inbound:COUNTER:600:0:<NatInMax>');
INSERT INTO interface_types_fields VALUES (338,'Cisco NAT Active Binds','cisco_nat_active_binds',50,44,20,0,0,0,'DS:cisco_nat_active_binds:GAUGE:600:0:100000');
INSERT INTO interface_types_fields VALUES (339,'Index','index',10,45,3,0,0,0,'');
INSERT INTO interface_types_fields VALUES (340,'Value','value',10,45,20,0,0,0,'DS:value:GAUGE:600:-100000:100000');
INSERT INTO interface_types_fields VALUES (341,'Description','description',20,45,7,1,1,0,'');
INSERT INTO interface_types_fields VALUES (342,'Show in Celcius','show_celcius',31,45,5,2,1,0,'1');
INSERT INTO interface_types_fields VALUES (343,'Show in Celcius','show_in_celcius',30,26,5,2,1,0,'1');

--
-- Table structure for table `interfaces`
--



--
-- Sequences for table INTERFACES
--

CREATE SEQUENCE interfaces_id_seq;

CREATE TABLE interfaces (
  id INT4 DEFAULT nextval('interfaces_id_seq'),
  type INT4 NOT NULL default '1',
  interface varchar(30) NOT NULL default '',
  host INT4 NOT NULL default '1',
  client INT4 NOT NULL default '1',
  sla INT4 NOT NULL default '1',
  poll INT4 NOT NULL default '1',
  make_sound INT2 NOT NULL default '1',
  show_rootmap INT2 NOT NULL default '1',
  rrd_mode INT2 NOT NULL default '2',
  creation_date INT4 NOT NULL default '0',
  modification_date INT4 NOT NULL default '0',
  last_poll_date INT4 NOT NULL default '0',
  poll_interval INT4 NOT NULL default '0',
  check_status INT2 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `interfaces`
--

INSERT INTO interfaces VALUES (1,1,'Unknown0',1,1,1,1,1,1,1,0,0,0,0,1);

--
-- Table structure for table `interfaces_values`
--



--
-- Sequences for table INTERFACES_VALUES
--

CREATE SEQUENCE interfaces_values_id_seq;

CREATE TABLE interfaces_values (
  id INT4 DEFAULT nextval('interfaces_values_id_seq'),
  interface INT4 NOT NULL default '0',
  field INT4 NOT NULL default '0',
  value varchar(250) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `interfaces_values`
--

INSERT INTO interfaces_values VALUES (1,1,1,'');

--
-- Table structure for table `journal`
--



--
-- Sequences for table JOURNAL
--

CREATE SEQUENCE journal_id_seq;

CREATE TABLE journal (
  id INT4 DEFAULT nextval('journal_id_seq'),
  date_start TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  date_stop TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  comment TEXT DEFAULT '' NOT NULL,
  subject varchar(40) NOT NULL default '',
  active INT2 NOT NULL default '1',
  ticket varchar(20) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `journal`
--

INSERT INTO journal VALUES (1,'2002-01-20 19:09:07','0001-01-01 00:00:00','Internally used ID','',0,'');
INSERT INTO journal VALUES (2,'2002-01-20 19:09:07','0001-01-01 00:00:00','Internally used ID','',0,'');

--
-- Table structure for table `maps`
--



--
-- Sequences for table MAPS
--

CREATE SEQUENCE maps_id_seq;

CREATE TABLE maps (
  id INT4 DEFAULT nextval('maps_id_seq'),
  parent INT4 NOT NULL default '0',
  name varchar(60) NOT NULL default '',
  color varchar(6) NOT NULL default '00A348',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `maps`
--

INSERT INTO maps VALUES (1,1,'Root Map','00A348');

--
-- Table structure for table `maps_interfaces`
--



--
-- Sequences for table MAPS_INTERFACES
--

CREATE SEQUENCE maps_interfaces_id_seq;

CREATE TABLE maps_interfaces (
  id INT4 DEFAULT nextval('maps_interfaces_id_seq'),
  map INT4 NOT NULL default '0',
  interface INT4 NOT NULL default '0',
  x INT4 NOT NULL default '1',
  y INT4 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `maps_interfaces`
--

INSERT INTO maps_interfaces VALUES (1,1,1,1,1);

--
-- Table structure for table `nad_hosts`
--



--
-- Sequences for table NAD_HOSTS
--

CREATE SEQUENCE nad_hosts_id_seq;

CREATE TABLE nad_hosts (
  id INT4 DEFAULT nextval('nad_hosts_id_seq'),
  snmp_name varchar(120) NOT NULL default '',
  description varchar(250) NOT NULL default '',
  snmp_community varchar(60) NOT NULL default '',
  forwarding INT2 NOT NULL default '0',
  date_added INT4 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `nad_hosts`
--


--
-- Table structure for table `nad_ips`
--



--
-- Sequences for table NAD_IPS
--

CREATE SEQUENCE nad_ips_id_seq;

CREATE TABLE nad_ips (
  id INT4 DEFAULT nextval('nad_ips_id_seq'),
  host INT4 NOT NULL default '1',
  ip varchar(20) NOT NULL default '',
  type INT4 NOT NULL default '0',
  network INT4 NOT NULL default '1',
  dns varchar(120) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `nad_ips`
--


--
-- Table structure for table `nad_networks`
--



--
-- Sequences for table NAD_NETWORKS
--

CREATE SEQUENCE nad_networks_id_seq;

CREATE TABLE nad_networks (
  id INT4 DEFAULT nextval('nad_networks_id_seq'),
  network varchar(20) NOT NULL default '',
  deep INT2 NOT NULL default '1',
  oper_status INT2 NOT NULL default '1',
  parent INT4 NOT NULL default '1',
  seed INT4 NOT NULL default '1',
  oper_status_changed INT4 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `nad_networks`
--


--
-- Table structure for table `pollers`
--



--
-- Sequences for table POLLERS
--

CREATE SEQUENCE pollers_id_seq;

CREATE TABLE pollers (
  id INT4 DEFAULT nextval('pollers_id_seq'),
  name varchar(60) NOT NULL default '',
  description varchar(60) NOT NULL default '',
  command varchar(60) NOT NULL default '',
  parameters varchar(100) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `pollers`
--

INSERT INTO pollers VALUES (1,'no_poller','No Poller','no_poller','');
INSERT INTO pollers VALUES (2,'input','SNMP Input Rate','snmp_counter','.1.3.6.1.2.1.2.2.1.10.<interfacenumber>,.1.3.6.1.2.1.31.1.1.1.6.<interfacenumber>');
INSERT INTO pollers VALUES (3,'verify_interface_number','Cisco Verify Interface Number','verify_interface_number','');
INSERT INTO pollers VALUES (5,'cisco_snmp_ping_start','Cisco SNMP Ping Start','cisco_snmp_ping_start','');
INSERT INTO pollers VALUES (6,'cisco_snmp_ping_wait','Cisco SNMP Ping Wait','cisco_snmp_ping_wait','');
INSERT INTO pollers VALUES (7,'packetloss','Cisco SNMP Ping Get PL','cisco_snmp_ping_get_pl','');
INSERT INTO pollers VALUES (8,'rtt','Cisco SNMP Ping Get RTT','cisco_snmp_ping_get_rtt','');
INSERT INTO pollers VALUES (9,'cisco_snmp_ping_end','Cisco SNMP Ping End','cisco_snmp_ping_end','');
INSERT INTO pollers VALUES (10,'output','SNMP Output Rate','snmp_counter','.1.3.6.1.2.1.2.2.1.16.<interfacenumber>,.1.3.6.1.2.1.31.1.1.1.10.<interfacenumber>');
INSERT INTO pollers VALUES (11,'outputerrors','SNMP Output Errors','snmp_counter','.1.3.6.1.2.1.2.2.1.20.<interfacenumber>');
INSERT INTO pollers VALUES (12,'inputerrors','SNMP Input Errors','snmp_counter','.1.3.6.1.2.1.2.2.1.14.<interfacenumber>');
INSERT INTO pollers VALUES (13,'interface_oper_status','SNMP Interface Operational Status','snmp_interface_status_all','8');
INSERT INTO pollers VALUES (14,'interface_admin_status','SNMP Interface Administrative Status','snmp_interface_status_all','7');
INSERT INTO pollers VALUES (16,'cpu','Cisco CPU Utilization','snmp_counter','.1.3.6.1.4.1.9.9.109.1.1.1.1.5.1');
INSERT INTO pollers VALUES (21,'inpackets','SNMP Input Packets','snmp_counter','.1.3.6.1.2.1.2.2.1.11.<interfacenumber>,.1.3.6.1.2.1.31.1.1.1.7.<interfacenumber>');
INSERT INTO pollers VALUES (22,'outpackets','SNMP Output Packets','snmp_counter','.1.3.6.1.2.1.2.2.1.17.<interfacenumber>,.1.3.6.1.2.1.31.1.1.1.11.<interfacenumber>');
INSERT INTO pollers VALUES (23,'tcp_status,tcp_content,conn_delay','TCP Port Check & Delay','tcp_status','');
INSERT INTO pollers VALUES (24,'mem_used','Cisco Used Memory','snmp_counter','.1.3.6.1.4.1.9.9.48.1.1.1.5.1');
INSERT INTO pollers VALUES (25,'mem_free','Cisco Free Memory','snmp_counter','.1.3.6.1.4.1.9.9.48.1.1.1.6.1');
INSERT INTO pollers VALUES (26,'drops','SNMP Drops','snmp_counter','.1.3.6.1.2.1.2.2.1.19.<interfacenumber>');
INSERT INTO pollers VALUES (30,'cpu','Cisco 2500 Series CPU Utilization','snmp_counter','.1.3.6.1.4.1.9.2.1.56.0');
INSERT INTO pollers VALUES (31,'bgpin','BGP Inbound Updates','snmp_counter','.1.3.6.1.2.1.15.3.1.10.<remote>');
INSERT INTO pollers VALUES (32,'bgpout','BGP Outbound Updates','snmp_counter','.1.3.6.1.2.1.15.3.1.11.<remote>');
INSERT INTO pollers VALUES (33,'bgpuptime','BGP Uptime','snmp_counter','.1.3.6.1.2.1.15.3.1.16.<remote>');
INSERT INTO pollers VALUES (35,'storage_used_blocks','Storage Device Used Blocks','snmp_counter','.1.3.6.1.2.1.25.2.3.1.6.<index>');
INSERT INTO pollers VALUES (36,'storage_block_count','Storage Device Total Blocks','snmp_counter','.1.3.6.1.2.1.25.2.3.1.5.<index>');
INSERT INTO pollers VALUES (37,'storage_block_size','Storage Device Block Size','snmp_counter','.1.3.6.1.2.1.25.2.3.1.4.<index>');
INSERT INTO pollers VALUES (38,'bgp_peer_status','BGP Peer Status','bgp_peer_status','<remote>');
INSERT INTO pollers VALUES (40,'hits','CSS VIP Hits','snmp_counter','.1.3.6.1.4.1.2467.1.16.4.1.18.\"<owner>\".\"<interface>\"');
INSERT INTO pollers VALUES (41,'output','CSS VIP Traffic Rate','snmp_counter','.1.3.6.1.4.1.2467.1.16.4.1.25.\"<owner>\".\"<interface>\"');
INSERT INTO pollers VALUES (42,'cpu_kernel_ticks','CPU Kernel Time','snmp_counter','.1.3.6.1.4.1.2021.11.55.0');
INSERT INTO pollers VALUES (43,'cpu_idle_ticks','CPU Idle Time','snmp_counter','.1.3.6.1.4.1.2021.11.53.0');
INSERT INTO pollers VALUES (44,'cpu_wait_ticks','CPU Wait Time','snmp_counter','.1.3.6.1.4.1.2021.11.54.0');
INSERT INTO pollers VALUES (45,'cpu_system_ticks','CPU System Time','snmp_counter','.1.3.6.1.4.1.2021.11.52.0');
INSERT INTO pollers VALUES (46,'mem_available','Real Memory Available','snmp_counter','.1.3.6.1.4.1.2021.4.6.0');
INSERT INTO pollers VALUES (47,'mem_total','Real Memory Total','snmp_counter','.1.3.6.1.4.1.2021.4.5.0');
INSERT INTO pollers VALUES (48,'swap_available','Swap Memory Available','snmp_counter','.1.3.6.1.4.1.2021.4.4.0');
INSERT INTO pollers VALUES (49,'swap_total','Swap Memory Total','snmp_counter','.1.3.6.1.4.1.2021.4.3.0');
INSERT INTO pollers VALUES (50,'load_average_15','Load Average 15 min','snmp_counter','.1.3.6.1.4.1.2021.10.1.3.3');
INSERT INTO pollers VALUES (51,'load_average_5','Load Average 5 min','snmp_counter','.1.3.6.1.4.1.2021.10.1.3.2');
INSERT INTO pollers VALUES (52,'load_average_1','Load Average 1 min','snmp_counter','.1.3.6.1.4.1.2021.10.1.3.1');
INSERT INTO pollers VALUES (53,'cpu_user_ticks','CPU User Time','snmp_counter','.1.3.6.1.4.1.2021.11.50.0');
INSERT INTO pollers VALUES (54,'cpu_nice_ticks','CPU Nice Time','snmp_counter','.1.3.6.1.4.1.2021.11.51.0');
INSERT INTO pollers VALUES (55,'bandwidthin','Get Bandwidth IN from DB','db','bandwidthin,to_bytes');
INSERT INTO pollers VALUES (56,'bandwidthout','Get Bandwidth OUT from DB','db','bandwidthout,to_bytes');
INSERT INTO pollers VALUES (57,'tcp_conn_number','TCP Connection Numbers','tcp_connection_number','');
INSERT INTO pollers VALUES (58,'acct_bytes,acct_packets','Cisco Accounting','cisco_accounting','');
INSERT INTO pollers VALUES (59,'cpu','Host MIB Proc Average Util','snmp_walk_average','.1.3.6.1.2.1.25.3.3.1.2');
INSERT INTO pollers VALUES (60,'num_procs','Host MIB Number of Processes','snmp_counter','.1.3.6.1.2.1.25.1.6.0');
INSERT INTO pollers VALUES (61,'num_users','Host MIB Number of Users','snmp_counter','.1.3.6.1.2.1.25.1.5.0');
INSERT INTO pollers VALUES (62,'tcp_active','TCP MIB Active Opens','snmp_counter','.1.3.6.1.2.1.6.5.0');
INSERT INTO pollers VALUES (63,'tcp_passive','TCP MIB Passive Opens','snmp_counter','.1.3.6.1.2.1.6.6.0');
INSERT INTO pollers VALUES (64,'tcp_established','TCP MIB Established Connections','snmp_counter','.1.3.6.1.2.1.6.9.0');
INSERT INTO pollers VALUES (65,'inputpackets','Cisco MAC Accounting Input Packets','snmp_counter','.1.3.6.1.4.1.9.9.84.1.2.1.1.3.<ifindex>.1.<mac>');
INSERT INTO pollers VALUES (66,'outputpackets','Cisco MAC Accounting Output Packets','snmp_counter','.1.3.6.1.4.1.9.9.84.1.2.1.1.3.<ifindex>.2.<mac>');
INSERT INTO pollers VALUES (67,'input','Cisco MAC Accounting Input Bytes','snmp_counter','.1.3.6.1.4.1.9.9.84.1.2.1.1.4.<ifindex>.1.<mac>');
INSERT INTO pollers VALUES (68,'output','Cisco MAC Accounting Output Bytes','snmp_counter','.1.3.6.1.4.1.9.9.84.1.2.1.1.4.<ifindex>.2.<mac>');
INSERT INTO pollers VALUES (69,'packetloss','Smokeping Loss','smokeping','loss');
INSERT INTO pollers VALUES (70,'rtt','Smokeping RTT','smokeping','median');
INSERT INTO pollers VALUES (71,'app_status,current_instances','Host MIB Process Verifier','hostmib_apps','<interface>');
INSERT INTO pollers VALUES (72,'cisco_powersupply_status','Cisco Power Supply Status','cisco_envmib_status','5.1.3');
INSERT INTO pollers VALUES (73,'cisco_temperature_status','Cisco Temperature Status','cisco_envmib_status','3.1.6');
INSERT INTO pollers VALUES (74,'cisco_voltage_status','Cisco Voltage Status','cisco_envmib_status','2.1.7');
INSERT INTO pollers VALUES (75,'temperature','Cisco Temperature','snmp_counter','.1.3.6.1.4.1.9.9.13.1.3.1.3.<index>');
INSERT INTO pollers VALUES (76,'sa_agent_verify','Verify SA Agent Operation','cisco_saagent_verify','');
INSERT INTO pollers VALUES (77,'forward_jitter','SA Agent Forward Jitter','cisco_saagent_forwardjitter','');
INSERT INTO pollers VALUES (78,'backward_jitter','SA Agent Backward Jitter','cisco_saagent_backwardjitter','');
INSERT INTO pollers VALUES (79,'rt_latency','SA Agent Round-Trip Latency','cisco_saagent_rtl','');
INSERT INTO pollers VALUES (80,'forward_packetloss','SA Agent fw % PacketLoss','cisco_saagent_fwpacketloss','');
INSERT INTO pollers VALUES (81,'backward_packetloss','SA Agent bw % PacketLoss','cisco_saagent_bwpacketloss','');
INSERT INTO pollers VALUES (82,'verify_smokeping_number','Verify Smokeping Number','verify_smokeping_number','');
INSERT INTO pollers VALUES (85,'tcp_content_analisis','TCP Port Response Check','tcp_port_content','tcp_content');
INSERT INTO pollers VALUES (86,'ping','Reachability Start FPING','reachability_start','');
INSERT INTO pollers VALUES (87,'wait','Reachability Wait until finished','reachability_wait','');
INSERT INTO pollers VALUES (88,'rtt','Reachability RTT','reachability_values','rtt');
INSERT INTO pollers VALUES (89,'packetloss','Reachability PL','reachability_values','pl');
INSERT INTO pollers VALUES (90,'ping_cleanup','Reachability End','reachability_end','');
INSERT INTO pollers VALUES (91,'status','Reachability Status','reachability_status','');
INSERT INTO pollers VALUES (93,'bytes','Linux TC Bytes','snmp_counter','<autodiscovery_parameters>.1.6.<index>');
INSERT INTO pollers VALUES (94,'packets','Linux TC Packets','snmp_counter','<autodiscovery_parameters>.1.7.<index>');
INSERT INTO pollers VALUES (95,'verify_tc_number','Linux TC Verfy Interface Number','verify_tc_class_number','');
INSERT INTO pollers VALUES (100,'tcp_status,tcp_content','TCP Port Status','buffer','');
INSERT INTO pollers VALUES (101,'app_status','Host MIB Status','buffer','');
INSERT INTO pollers VALUES (102,'ntp_status','NTP Status','ntp_client','');
INSERT INTO pollers VALUES (103,'used_memory','Host MIB Process Memory Usage','hostmib_perf','2');
INSERT INTO pollers VALUES (105,'udp_status,conn_delay','UDP Port Status & Delay','udp_status','');
INSERT INTO pollers VALUES (106,'udp_status','UDP Port Status','buffer','');
INSERT INTO pollers VALUES (107,'temperature','Compaq Temperature','snmp_counter','.1.3.6.1.4.1.232.6.2.6.8.1.4.<chassis>.<tempindex>');
INSERT INTO pollers VALUES (108,'temp_status','Compaq Temperature Status','snmp_status','.1.3.6.1.4.1.232.6.2.6.8.1.6.<chassis>.<tempindex>,2=up');
INSERT INTO pollers VALUES (109,'fan_status','Compaq Fan Condition','snmp_status','.1.3.6.1.4.1.232.6.2.6.7.1.9.<chassis>.<fanindex>,2=up');
INSERT INTO pollers VALUES (110,'compaq_disk','Compaq Drive Condition','snmp_status','.1.3.6.1.4.1.232.3.2.5.1.1.6.<controller>.<drvindex>,2=up');
INSERT INTO pollers VALUES (111,'tbr','IIS Total Bytes Received','snmp_counter','.1.3.6.1.4.1.311.1.7.3.1.4.0');
INSERT INTO pollers VALUES (112,'tcgir','IIS Total CGI Requests','snmp_counter','.1.3.6.1.4.1.311.1.7.3.1.35.0');
INSERT INTO pollers VALUES (113,'tfs','IIS Total Files Sent','snmp_counter','.1.3.6.1.4.1.311.1.7.3.1.5.0');
INSERT INTO pollers VALUES (114,'tg','IIS Total GETs','snmp_counter','.1.3.6.1.4.1.311.1.7.3.1.18.0');
INSERT INTO pollers VALUES (115,'tp','IIS Total Posts','snmp_counter','.1.3.6.1.4.1.311.1.7.3.1.19.0');
INSERT INTO pollers VALUES (116,'pm_serial_free','Livingston Portmaster Free','livingston_serial_port_status','1');
INSERT INTO pollers VALUES (117,'pm_serial_established','Livingston Portmaster Established','livingston_serial_port_status','3');
INSERT INTO pollers VALUES (118,'pm_serial_disconnecting','Livingston Portmaster Disconnecting','livingston_serial_port_status','4');
INSERT INTO pollers VALUES (119,'pm_serial_command','Livingston Portmaster Command','livingston_serial_port_status','5');
INSERT INTO pollers VALUES (120,'pm_serial_connecting','Livingston Portmaster Connecting','livingston_serial_port_status','2');
INSERT INTO pollers VALUES (121,'pm_serial_noservice','Livingston Portmaster No Service','livingston_serial_port_status','6');
INSERT INTO pollers VALUES (122,'tac,tkb,cplo,up,bpr,bw,iw','Apache Status','apache','');
INSERT INTO pollers VALUES (123,'capacity','a APC Battery Capacity','snmp_counter','.1.3.6.1.4.1.318.1.1.1.2.2.1.0');
INSERT INTO pollers VALUES (124,'load','a APC Output Load','snmp_counter','.1.3.6.1.4.1.318.1.1.1.4.2.3.0');
INSERT INTO pollers VALUES (125,'in_voltage','a APC Input Voltage','snmp_counter','.1.3.6.1.4.1.318.1.1.1.3.2.1.0');
INSERT INTO pollers VALUES (126,'out_voltage','a APC Output Voltage','snmp_counter','.1.3.6.1.4.1.318.1.1.1.4.2.1.0');
INSERT INTO pollers VALUES (127,'time_remaining','a APC Time Remaining','snmp_counter','.1.3.6.1.4.1.318.1.1.1.2.2.3.0');
INSERT INTO pollers VALUES (128,'status','a APC Battery Status','snmp_status','.1.3.6.1.4.1.318.1.1.1.2.1.1.0,2=battery normal|1=battery unknown|3=battery low');
INSERT INTO pollers VALUES (129,'temperature','a APC Temperature','snmp_counter','.1.3.6.1.4.1.318.1.1.1.2.2.2.0');
INSERT INTO pollers VALUES (130,'output_status','a APC Output Status','snmp_status','.1.3.6.1.4.1.318.1.1.1.4.1.1.0,2=on line|3=on battery');
INSERT INTO pollers VALUES (131,'records_counter,records_absolute','ODBC Query','odbc_query','');
INSERT INTO pollers VALUES (132,'sql_status','SQL Query Status','sql_status','');
INSERT INTO pollers VALUES (133,'admin_state','Alteon RServer Admin','snmp_counter','.1.3.6.1.4.1.1872.2.1.5.2.1.10.<index>');
INSERT INTO pollers VALUES (134,'oper_state','Alteon RServer Oper','snmp_status','.1.3.6.1.4.1.1872.2.1.9.2.2.1.7.<index>,2=up');
INSERT INTO pollers VALUES (135,'current_sessions','Alteon RServer Current Sessions','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.2.5.1.2.<index>');
INSERT INTO pollers VALUES (136,'failures','Alteon RServer Failures','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.2.5.1.4.<index>');
INSERT INTO pollers VALUES (137,'octets','Alteon RServer Octets','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.2.5.1.7.<index>');
INSERT INTO pollers VALUES (138,'total_sessions','Alteon RServer Total Sessions','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.2.5.1.3.<index>');
INSERT INTO pollers VALUES (139,'admin_state','Alteon VServer Admin State','snmp_counter','.1.3.6.1.4.1.1872.2.1.5.5.1.4.<index>');
INSERT INTO pollers VALUES (140,'current_sessions','Alteon VServer Current Sessions','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.2.7.1.2.<index>');
INSERT INTO pollers VALUES (141,'total_sessions','Alteon VServer Total Sessions','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.2.7.1.3.<index>');
INSERT INTO pollers VALUES (142,'octets','Alteon VServer Octets','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.2.7.1.6.<index>');
INSERT INTO pollers VALUES (143,'admin_state','Alteon RService Admin State','snmp_counter','.1.3.6.1.4.1.1872.2.1.5.2.1.10.<real_server>');
INSERT INTO pollers VALUES (144,'oper_state','Alteon RService Oper State','snmp_status','.1.3.6.1.4.1.1872.2.1.9.2.4.1.6.<index>,2=up');
INSERT INTO pollers VALUES (145,'response_time','Alteon RService Response Time','snmp_counter','.1.3.6.1.4.1.1872.2.1.9.2.4.1.7.<index>');
INSERT INTO pollers VALUES (146,'cpua_1sec','Alteon CPU A 1Sec','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.16.1.0');
INSERT INTO pollers VALUES (147,'cpua_4secs','Alteon CPU A 4Secs','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.16.3.0');
INSERT INTO pollers VALUES (148,'cpua_64secs','Alteon CPU A 64Secs','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.16.5.0');
INSERT INTO pollers VALUES (149,'cpub_1sec','Alteon CPU B 1Sec','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.1.16.2.0');
INSERT INTO pollers VALUES (150,'cpub_4secs','Alteon CPU B 4 Secs','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.16.4.0');
INSERT INTO pollers VALUES (151,'cpub_64secs','Alteon CPU B 64Secs','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.16.6.0');
INSERT INTO pollers VALUES (152,'mem_total','Alteon Memory Total','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.12.6.0');
INSERT INTO pollers VALUES (153,'mem_used','Alteon Memory Used','snmp_counter','.1.3.6.1.4.1.1872.2.1.8.12.4.0');
INSERT INTO pollers VALUES (154,'sensor_value','Brocade Sensor Value','snmp_counter','1.3.6.1.4.1.1588.2.1.1.1.1.22.1.4.<index>');
INSERT INTO pollers VALUES (155,'oper_status','Brocade Sensor Oper','snmp_status','1.3.6.1.4.1.1588.2.1.1.1.1.22.1.3.<index>,4=ok|3=alert|5=alert');
INSERT INTO pollers VALUES (156,'tx_words','Brocade FCPort TxWords','snmp_counter','1.3.6.1.4.1.1588.2.1.1.1.6.2.1.11.<index>');
INSERT INTO pollers VALUES (157,'rx_words','Brocade FCPort RxWords','snmp_counter','1.3.6.1.4.1.1588.2.1.1.1.6.2.1.12.<index>');
INSERT INTO pollers VALUES (158,'tx_frames','Brocade FCPort TxFrames','snmp_counter','1.3.6.1.4.1.1588.2.1.1.1.6.2.1.13.<index>');
INSERT INTO pollers VALUES (159,'rx_frames','Brocade FCPort RxFrames','snmp_counter','1.3.6.1.4.1.1588.2.1.1.1.6.2.1.14.<index>');
INSERT INTO pollers VALUES (160,'admin_state','Brocade Fc Port Admin State','snmp_counter','1.3.6.1.4.1.1588.2.1.1.1.6.2.1.5.<index>');
INSERT INTO pollers VALUES (161,'oper_status','Brocade fC Ports Oper Status','snmp_status','1.3.6.1.4.1.1588.2.1.1.1.6.2.1.4.<index>,1=up|3=testing');
INSERT INTO pollers VALUES (162,'phy_state','Brocade FC Port Phy State','brocade_fcport_phystate','<index>');
INSERT INTO pollers VALUES (163,'cisco_async','Cisco Async Utilisation','cisco_serial_port_status','1');
INSERT INTO pollers VALUES (164,'cisco_dsx','Cisco DSX Utilisation','cisco_serial_port_status','2');
INSERT INTO pollers VALUES (165,'cisco_free','Cisco Port Free','cisco_serial_port_status','3');
INSERT INTO pollers VALUES (166,'inf_d_read_time','Informant Disk Read Time','snmp_counter','.1.3.6.1.4.1.9600.1.1.1.1.2.<index>');
INSERT INTO pollers VALUES (167,'inf_d_write_time','Informant Disk Write Time','snmp_counter','.1.3.6.1.4.1.9600.1.1.1.1.4.<index>');
INSERT INTO pollers VALUES (168,'inf_d_read_rate','Informant Disk Read Rate','snmp_counter','.1.3.6.1.4.1.9600.1.1.1.1.15.<index>');
INSERT INTO pollers VALUES (169,'inf_d_write_rate','Informant Disk Write Rate','snmp_counter','.1.3.6.1.4.1.9600.1.1.1.1.18.<index>');
INSERT INTO pollers VALUES (170,'status','UPS Battery Status','snmp_status','.1.3.6.1.2.1.33.1.2.1.0,2=battery normal|1=battery unknown|3=battery low|3=battery depleted');
INSERT INTO pollers VALUES (171,'temperature','UPS Battery Temperature','snmp_counter','.1.3.6.1.2.1.33.1.2.7.0');
INSERT INTO pollers VALUES (172,'minutes_remaining','UPS Battery Minutes Remaining','snmp_counter','.1.3.6.1.2.1.33.1.2.3.0');
INSERT INTO pollers VALUES (173,'charge_remaining','UPS Battery Charge Remaining','snmp_counter','.1.3.6.1.2.1.33.1.2.4.0');
INSERT INTO pollers VALUES (174,'voltage','UPS Lines Voltage','ups_line','');
INSERT INTO pollers VALUES (175,'current','UPS Lines Current','ups_line','');
INSERT INTO pollers VALUES (176,'load','UPS Lines Load','ups_line','');
INSERT INTO pollers VALUES (177,'ipt_packets','IPTables Chain Packets','snmp_counter','.1.3.6.1.4.1.2021.5002.1.4.<chainnumber>');
INSERT INTO pollers VALUES (178,'ipt_bytes','IPTables Chainl Bytes','snmp_counter','.1.3.6.1.4.1.2021.5002.1.5.<chainnumber>');
INSERT INTO pollers VALUES (179,'accepted_routes','BGP Accepted Routes','snmp_counter','.1.3.6.1.4.1.9.9.187.1.2.4.1.1.<remote>.1.1');
INSERT INTO pollers VALUES (180,'advertised_routes','BGP Advertised Routes','snmp_counter','.1.3.6.1.4.1.9.9.187.1.2.4.1.6.<remote>.1.1');
INSERT INTO pollers VALUES (181,'pix_connections','Pix Connections Poller','snmp_counter','.1.3.6.1.4.1.9.9.147.1.2.2.2.1.5.<index>');
INSERT INTO pollers VALUES (182,'cisco_nat_other_ip_inbound','Cisco NAT Other IP Inbound','snmp_counter','.1.3.6.1.4.1.9.10.77.1.3.1.1.2.1');
INSERT INTO pollers VALUES (183,'cisco_nat_icmp_inbound','Cisco NAT ICMP Inbound','snmp_counter','.1.3.6.1.4.1.9.10.77.1.3.1.1.2.2');
INSERT INTO pollers VALUES (184,'cisco_nat_udp_inbound','Cisco NAT UDP Inbound','snmp_counter','.1.3.6.1.4.1.9.10.77.1.3.1.1.2.3');
INSERT INTO pollers VALUES (185,'cisco_nat_tcp_inbound','Cisco NAT TCP Inbound','snmp_counter','.1.3.6.1.4.1.9.10.77.1.3.1.1.2.4');
INSERT INTO pollers VALUES (186,'cisco_nat_other_ip_outbound','Cisco NAT Other IP Outbound','snmp_counter','.1.3.6.1.4.1.9.10.77.1.3.1.1.3.1');
INSERT INTO pollers VALUES (187,'cisco_nat_icmp_outbound','Cisco NAT ICMP Outbound','snmp_counter','.1.3.6.1.4.1.9.10.77.1.3.1.1.3.2');
INSERT INTO pollers VALUES (188,'cisco_nat_udp_outbound','Cisco NAT UDP Outbound','snmp_counter','.1.3.6.1.4.1.9.10.77.1.3.1.1.3.3');
INSERT INTO pollers VALUES (189,'cisco_nat_tcp_outbound','Cisco NAT TCP Outbound','snmp_counter','.1.3.6.1.4.1.9.10.77.1.3.1.1.3.4');
INSERT INTO pollers VALUES (190,'cisco_nat_active_binds','Cisco NAT Active Binds','snmp_counter','.1.3.6.1.4.1.9.10.77.1.2.1.0');
INSERT INTO pollers VALUES (191,'value','Sensor Value','snmp_counter','.1.3.6.1.2.1.25.8.1.5.<index>');

--
-- Table structure for table `pollers_backend`
--



--
-- Sequences for table POLLERS_BACKEND
--

CREATE SEQUENCE pollers_backend_id_seq;

CREATE TABLE pollers_backend (
  id INT4 DEFAULT nextval('pollers_backend_id_seq'),
  description varchar(60) NOT NULL default '',
  command varchar(60) NOT NULL default '',
  parameters varchar(60) NOT NULL default '',
  type INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `pollers_backend`
--

INSERT INTO pollers_backend VALUES (1,'No Backend','no_backend','',0);
INSERT INTO pollers_backend VALUES (2,'Unknown Event','event','1',0);
INSERT INTO pollers_backend VALUES (9,'Temporal Buffer','buffer','',0);
INSERT INTO pollers_backend VALUES (10,'RRDTool All DSs','rrd','*',0);
INSERT INTO pollers_backend VALUES (12,'Alarm Verify Operational','alarm','3,,180',1);
INSERT INTO pollers_backend VALUES (14,'Change Interface Number','verify_interface_number','',0);
INSERT INTO pollers_backend VALUES (19,'Alarm TCP Port','alarm','22',1);
INSERT INTO pollers_backend VALUES (20,'Alarm Environmental','alarm','26',1);
INSERT INTO pollers_backend VALUES (24,'Alarm BGP Peer','alarm','6,,180',1);
INSERT INTO pollers_backend VALUES (25,'Application Alarm','alarm','38',1);
INSERT INTO pollers_backend VALUES (27,'Alarm TCP Content','alarm','39',1);
INSERT INTO pollers_backend VALUES (28,'Alarm Reachability','alarm','40',1);
INSERT INTO pollers_backend VALUES (29,'Admin Status Change View','db','show_rootmap,down=2|up=1,0',1);
INSERT INTO pollers_backend VALUES (30,'Multiple Temporal Buffer','multi_buffer','',0);
INSERT INTO pollers_backend VALUES (31,'Alarm NTP','alarm','41,nothing',1);
INSERT INTO pollers_backend VALUES (32,'RRD Individual Value','rrd','',0);
INSERT INTO pollers_backend VALUES (33,'Alarm APC','alarm','60',1);
INSERT INTO pollers_backend VALUES (34,'Alarm SQL Records','alarm','50',1);
INSERT INTO pollers_backend VALUES (35,'Alteon Admin Status View','db','show_rootmap,down=0|up=2,2',1);
INSERT INTO pollers_backend VALUES (36,'Alarm Alteon RServer','alarm','68',1);
INSERT INTO pollers_backend VALUES (37,'Alarm Alteon Service','alarm','69',1);
INSERT INTO pollers_backend VALUES (38,'Alarm Alteon VServer','alarm','70',1);
INSERT INTO pollers_backend VALUES (39,'Brocace FC Admin View','db','show_rootmap,down=2|up=1,0',0);
INSERT INTO pollers_backend VALUES (40,'Alarm Brocade FC Port','alarm','71',1);

--
-- Table structure for table `pollers_groups`
--



--
-- Sequences for table POLLERS_GROUPS
--

CREATE SEQUENCE pollers_groups_id_seq;

CREATE TABLE pollers_groups (
  id INT4 DEFAULT nextval('pollers_groups_id_seq'),
  description varchar(60) NOT NULL default '',
  interface_type INT4 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `pollers_groups`
--

INSERT INTO pollers_groups VALUES (1,'No Polling',1);
INSERT INTO pollers_groups VALUES (2,'Cisco Interface',4);
INSERT INTO pollers_groups VALUES (3,'Cisco Router',3);
INSERT INTO pollers_groups VALUES (5,'TCP/IP Port',2);
INSERT INTO pollers_groups VALUES (8,'BGP Neighbor',6);
INSERT INTO pollers_groups VALUES (9,'Storage Device',8);
INSERT INTO pollers_groups VALUES (10,'CSS VIP',9);
INSERT INTO pollers_groups VALUES (11,'Linux/Unix Host',11);
INSERT INTO pollers_groups VALUES (12,'Solaris Host',10);
INSERT INTO pollers_groups VALUES (13,'Windows Host',12);
INSERT INTO pollers_groups VALUES (14,'Cisco Accounting',13);
INSERT INTO pollers_groups VALUES (15,'Smokeping Host',14);
INSERT INTO pollers_groups VALUES (16,'HostMIB Application',15);
INSERT INTO pollers_groups VALUES (17,'Cisco Power Supply',16);
INSERT INTO pollers_groups VALUES (18,'Cisco Tempererature',17);
INSERT INTO pollers_groups VALUES (19,'Cisco Voltage',18);
INSERT INTO pollers_groups VALUES (20,'Cisco SA Agent',19);
INSERT INTO pollers_groups VALUES (21,'Reachability',20);
INSERT INTO pollers_groups VALUES (22,'TC Class',21);
INSERT INTO pollers_groups VALUES (23,'NTP',22);
INSERT INTO pollers_groups VALUES (24,'UDP/IP Port',23);
INSERT INTO pollers_groups VALUES (25,'Compaq Physical Drive',24);
INSERT INTO pollers_groups VALUES (26,'Compaq Fan',25);
INSERT INTO pollers_groups VALUES (27,'Compaq Temperature',26);
INSERT INTO pollers_groups VALUES (28,'IIS Info',27);
INSERT INTO pollers_groups VALUES (29,'Livingston Portmaster',28);
INSERT INTO pollers_groups VALUES (30,'Apache',29);
INSERT INTO pollers_groups VALUES (31,'APC',31);
INSERT INTO pollers_groups VALUES (32,'ODBC',30);
INSERT INTO pollers_groups VALUES (33,'Alteon Real Server',32);
INSERT INTO pollers_groups VALUES (34,'Alteon Virtual Server',33);
INSERT INTO pollers_groups VALUES (35,'Alteon Real Services',34);
INSERT INTO pollers_groups VALUES (36,'Alteon System Info',35);
INSERT INTO pollers_groups VALUES (37,'Brocade Sensors',36);
INSERT INTO pollers_groups VALUES (38,'Brocade FC Ports',37);
INSERT INTO pollers_groups VALUES (39,'Cisco Dialup',38);
INSERT INTO pollers_groups VALUES (40,'Windows Informant Disks',39);
INSERT INTO pollers_groups VALUES (41,'UPS',40);
INSERT INTO pollers_groups VALUES (42,'UPS Lines',41);
INSERT INTO pollers_groups VALUES (43,'IPTable Chain',42);
INSERT INTO pollers_groups VALUES (44,'PIX Connection Stat',43);
INSERT INTO pollers_groups VALUES (45,'Cisco NAT',44);
INSERT INTO pollers_groups VALUES (46,'Sensors',45);

--
-- Table structure for table `pollers_poller_groups`
--



--
-- Sequences for table POLLERS_POLLER_GROUPS
--

CREATE SEQUENCE pollers_poller_groups_id_seq;

CREATE TABLE pollers_poller_groups (
  id INT4 DEFAULT nextval('pollers_poller_groups_id_seq'),
  poller_group INT4 NOT NULL default '1',
  pos INT2 NOT NULL default '1',
  poller INT4 NOT NULL default '1',
  backend INT4 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `pollers_poller_groups`
--

INSERT INTO pollers_poller_groups VALUES (1,1,1,1,1);
INSERT INTO pollers_poller_groups VALUES (2,2,20,2,9);
INSERT INTO pollers_poller_groups VALUES (3,2,10,3,14);
INSERT INTO pollers_poller_groups VALUES (4,2,15,5,9);
INSERT INTO pollers_poller_groups VALUES (5,2,50,6,1);
INSERT INTO pollers_poller_groups VALUES (6,2,55,7,9);
INSERT INTO pollers_poller_groups VALUES (7,2,60,8,9);
INSERT INTO pollers_poller_groups VALUES (8,2,65,9,1);
INSERT INTO pollers_poller_groups VALUES (9,2,30,10,9);
INSERT INTO pollers_poller_groups VALUES (10,2,40,11,9);
INSERT INTO pollers_poller_groups VALUES (11,2,45,12,9);
INSERT INTO pollers_poller_groups VALUES (12,2,80,1,10);
INSERT INTO pollers_poller_groups VALUES (14,2,16,13,12);
INSERT INTO pollers_poller_groups VALUES (16,3,10,16,9);
INSERT INTO pollers_poller_groups VALUES (20,3,2,20,19);
INSERT INTO pollers_poller_groups VALUES (21,2,25,21,9);
INSERT INTO pollers_poller_groups VALUES (22,2,35,22,9);
INSERT INTO pollers_poller_groups VALUES (23,5,10,23,30);
INSERT INTO pollers_poller_groups VALUES (24,3,20,24,9);
INSERT INTO pollers_poller_groups VALUES (25,3,50,1,10);
INSERT INTO pollers_poller_groups VALUES (26,3,30,25,9);
INSERT INTO pollers_poller_groups VALUES (27,2,46,26,9);
INSERT INTO pollers_poller_groups VALUES (30,8,10,31,32);
INSERT INTO pollers_poller_groups VALUES (31,8,40,32,32);
INSERT INTO pollers_poller_groups VALUES (32,8,50,33,32);
INSERT INTO pollers_poller_groups VALUES (35,9,10,37,9);
INSERT INTO pollers_poller_groups VALUES (36,9,20,36,9);
INSERT INTO pollers_poller_groups VALUES (37,9,30,35,9);
INSERT INTO pollers_poller_groups VALUES (38,9,60,1,10);
INSERT INTO pollers_poller_groups VALUES (39,8,5,38,24);
INSERT INTO pollers_poller_groups VALUES (41,10,10,41,9);
INSERT INTO pollers_poller_groups VALUES (42,10,20,40,9);
INSERT INTO pollers_poller_groups VALUES (43,10,60,1,10);
INSERT INTO pollers_poller_groups VALUES (44,11,10,54,9);
INSERT INTO pollers_poller_groups VALUES (45,11,20,53,9);
INSERT INTO pollers_poller_groups VALUES (46,11,30,43,9);
INSERT INTO pollers_poller_groups VALUES (47,11,40,45,9);
INSERT INTO pollers_poller_groups VALUES (48,11,50,52,9);
INSERT INTO pollers_poller_groups VALUES (49,11,60,51,9);
INSERT INTO pollers_poller_groups VALUES (50,11,70,50,9);
INSERT INTO pollers_poller_groups VALUES (51,11,80,1,10);
INSERT INTO pollers_poller_groups VALUES (52,12,10,45,9);
INSERT INTO pollers_poller_groups VALUES (53,12,20,43,9);
INSERT INTO pollers_poller_groups VALUES (54,12,30,42,9);
INSERT INTO pollers_poller_groups VALUES (55,12,40,44,9);
INSERT INTO pollers_poller_groups VALUES (56,12,50,52,9);
INSERT INTO pollers_poller_groups VALUES (57,12,60,51,9);
INSERT INTO pollers_poller_groups VALUES (58,12,70,50,9);
INSERT INTO pollers_poller_groups VALUES (59,12,80,46,9);
INSERT INTO pollers_poller_groups VALUES (60,12,90,47,9);
INSERT INTO pollers_poller_groups VALUES (61,12,100,48,9);
INSERT INTO pollers_poller_groups VALUES (62,12,110,49,9);
INSERT INTO pollers_poller_groups VALUES (63,12,120,1,10);
INSERT INTO pollers_poller_groups VALUES (64,2,47,55,9);
INSERT INTO pollers_poller_groups VALUES (65,2,48,56,9);
INSERT INTO pollers_poller_groups VALUES (66,5,20,57,9);
INSERT INTO pollers_poller_groups VALUES (67,5,60,1,10);
INSERT INTO pollers_poller_groups VALUES (68,3,40,58,30);
INSERT INTO pollers_poller_groups VALUES (69,13,10,59,9);
INSERT INTO pollers_poller_groups VALUES (70,13,20,60,9);
INSERT INTO pollers_poller_groups VALUES (71,13,30,61,9);
INSERT INTO pollers_poller_groups VALUES (72,13,40,62,9);
INSERT INTO pollers_poller_groups VALUES (73,13,50,64,9);
INSERT INTO pollers_poller_groups VALUES (74,13,60,63,9);
INSERT INTO pollers_poller_groups VALUES (75,13,100,1,10);
INSERT INTO pollers_poller_groups VALUES (76,11,15,60,9);
INSERT INTO pollers_poller_groups VALUES (77,11,25,61,9);
INSERT INTO pollers_poller_groups VALUES (78,11,35,64,9);
INSERT INTO pollers_poller_groups VALUES (79,11,45,62,9);
INSERT INTO pollers_poller_groups VALUES (80,11,55,63,9);
INSERT INTO pollers_poller_groups VALUES (81,3,15,64,9);
INSERT INTO pollers_poller_groups VALUES (82,3,25,62,9);
INSERT INTO pollers_poller_groups VALUES (83,3,35,63,9);
INSERT INTO pollers_poller_groups VALUES (84,14,10,65,9);
INSERT INTO pollers_poller_groups VALUES (85,14,20,67,9);
INSERT INTO pollers_poller_groups VALUES (86,14,30,68,9);
INSERT INTO pollers_poller_groups VALUES (87,14,40,66,9);
INSERT INTO pollers_poller_groups VALUES (88,14,50,1,10);
INSERT INTO pollers_poller_groups VALUES (89,15,30,70,9);
INSERT INTO pollers_poller_groups VALUES (90,15,20,69,9);
INSERT INTO pollers_poller_groups VALUES (91,15,90,1,10);
INSERT INTO pollers_poller_groups VALUES (92,16,10,71,30);
INSERT INTO pollers_poller_groups VALUES (93,17,20,72,20);
INSERT INTO pollers_poller_groups VALUES (94,18,10,73,20);
INSERT INTO pollers_poller_groups VALUES (95,19,20,74,20);
INSERT INTO pollers_poller_groups VALUES (96,18,20,75,9);
INSERT INTO pollers_poller_groups VALUES (97,18,50,1,10);
INSERT INTO pollers_poller_groups VALUES (98,20,10,76,11);
INSERT INTO pollers_poller_groups VALUES (99,20,20,77,9);
INSERT INTO pollers_poller_groups VALUES (100,20,30,81,9);
INSERT INTO pollers_poller_groups VALUES (101,20,40,80,9);
INSERT INTO pollers_poller_groups VALUES (102,20,50,79,9);
INSERT INTO pollers_poller_groups VALUES (103,20,60,78,9);
INSERT INTO pollers_poller_groups VALUES (104,20,90,1,10);
INSERT INTO pollers_poller_groups VALUES (105,15,10,82,14);
INSERT INTO pollers_poller_groups VALUES (106,5,30,85,27);
INSERT INTO pollers_poller_groups VALUES (107,21,1,86,9);
INSERT INTO pollers_poller_groups VALUES (108,21,122,87,1);
INSERT INTO pollers_poller_groups VALUES (109,21,123,88,9);
INSERT INTO pollers_poller_groups VALUES (110,21,124,89,9);
INSERT INTO pollers_poller_groups VALUES (111,21,126,90,1);
INSERT INTO pollers_poller_groups VALUES (112,21,125,91,28);
INSERT INTO pollers_poller_groups VALUES (113,21,127,1,10);
INSERT INTO pollers_poller_groups VALUES (114,22,92,93,9);
INSERT INTO pollers_poller_groups VALUES (115,22,93,94,9);
INSERT INTO pollers_poller_groups VALUES (116,22,91,95,14);
INSERT INTO pollers_poller_groups VALUES (117,22,94,1,10);
INSERT INTO pollers_poller_groups VALUES (122,2,17,14,29);
INSERT INTO pollers_poller_groups VALUES (123,5,15,100,19);
INSERT INTO pollers_poller_groups VALUES (124,16,20,101,25);
INSERT INTO pollers_poller_groups VALUES (125,16,90,1,10);
INSERT INTO pollers_poller_groups VALUES (126,23,50,102,31);
INSERT INTO pollers_poller_groups VALUES (127,16,30,103,9);
INSERT INTO pollers_poller_groups VALUES (129,24,10,105,30);
INSERT INTO pollers_poller_groups VALUES (130,24,20,106,19);
INSERT INTO pollers_poller_groups VALUES (131,24,30,1,10);
INSERT INTO pollers_poller_groups VALUES (132,27,10,108,20);
INSERT INTO pollers_poller_groups VALUES (133,27,20,107,9);
INSERT INTO pollers_poller_groups VALUES (134,27,90,1,10);
INSERT INTO pollers_poller_groups VALUES (135,26,10,109,20);
INSERT INTO pollers_poller_groups VALUES (136,25,10,110,20);
INSERT INTO pollers_poller_groups VALUES (137,28,10,111,9);
INSERT INTO pollers_poller_groups VALUES (138,28,20,112,9);
INSERT INTO pollers_poller_groups VALUES (139,28,30,113,9);
INSERT INTO pollers_poller_groups VALUES (140,28,40,114,9);
INSERT INTO pollers_poller_groups VALUES (141,28,50,115,9);
INSERT INTO pollers_poller_groups VALUES (142,28,90,1,10);
INSERT INTO pollers_poller_groups VALUES (143,29,90,1,10);
INSERT INTO pollers_poller_groups VALUES (144,29,10,116,9);
INSERT INTO pollers_poller_groups VALUES (145,29,20,120,9);
INSERT INTO pollers_poller_groups VALUES (146,29,30,117,9);
INSERT INTO pollers_poller_groups VALUES (147,29,50,119,9);
INSERT INTO pollers_poller_groups VALUES (148,29,60,121,9);
INSERT INTO pollers_poller_groups VALUES (149,29,40,118,9);
INSERT INTO pollers_poller_groups VALUES (150,30,20,1,10);
INSERT INTO pollers_poller_groups VALUES (151,30,10,122,30);
INSERT INTO pollers_poller_groups VALUES (152,31,10,128,20);
INSERT INTO pollers_poller_groups VALUES (153,31,20,123,9);
INSERT INTO pollers_poller_groups VALUES (154,31,31,124,9);
INSERT INTO pollers_poller_groups VALUES (155,31,40,125,9);
INSERT INTO pollers_poller_groups VALUES (156,31,50,126,9);
INSERT INTO pollers_poller_groups VALUES (157,31,60,127,9);
INSERT INTO pollers_poller_groups VALUES (158,31,90,1,10);
INSERT INTO pollers_poller_groups VALUES (159,31,70,129,9);
INSERT INTO pollers_poller_groups VALUES (160,31,15,130,33);
INSERT INTO pollers_poller_groups VALUES (161,32,10,131,30);
INSERT INTO pollers_poller_groups VALUES (162,32,20,132,34);
INSERT INTO pollers_poller_groups VALUES (163,32,90,1,10);
INSERT INTO pollers_poller_groups VALUES (164,33,10,133,35);
INSERT INTO pollers_poller_groups VALUES (165,33,15,134,12);
INSERT INTO pollers_poller_groups VALUES (166,33,20,135,9);
INSERT INTO pollers_poller_groups VALUES (167,33,25,136,9);
INSERT INTO pollers_poller_groups VALUES (168,33,30,137,9);
INSERT INTO pollers_poller_groups VALUES (169,33,35,138,9);
INSERT INTO pollers_poller_groups VALUES (170,33,90,1,10);
INSERT INTO pollers_poller_groups VALUES (171,34,10,139,29);
INSERT INTO pollers_poller_groups VALUES (172,34,20,140,9);
INSERT INTO pollers_poller_groups VALUES (173,34,30,142,9);
INSERT INTO pollers_poller_groups VALUES (174,34,40,141,9);
INSERT INTO pollers_poller_groups VALUES (175,34,90,1,10);
INSERT INTO pollers_poller_groups VALUES (176,35,10,143,29);
INSERT INTO pollers_poller_groups VALUES (177,35,30,144,37);
INSERT INTO pollers_poller_groups VALUES (178,35,20,145,9);
INSERT INTO pollers_poller_groups VALUES (179,35,90,1,10);
INSERT INTO pollers_poller_groups VALUES (180,36,10,146,9);
INSERT INTO pollers_poller_groups VALUES (181,36,11,147,9);
INSERT INTO pollers_poller_groups VALUES (182,36,12,148,9);
INSERT INTO pollers_poller_groups VALUES (183,36,15,149,9);
INSERT INTO pollers_poller_groups VALUES (184,36,16,150,9);
INSERT INTO pollers_poller_groups VALUES (185,36,17,151,9);
INSERT INTO pollers_poller_groups VALUES (186,36,20,62,9);
INSERT INTO pollers_poller_groups VALUES (187,36,21,63,9);
INSERT INTO pollers_poller_groups VALUES (188,36,22,64,9);
INSERT INTO pollers_poller_groups VALUES (189,36,30,153,9);
INSERT INTO pollers_poller_groups VALUES (190,36,35,152,9);
INSERT INTO pollers_poller_groups VALUES (191,36,90,1,10);
INSERT INTO pollers_poller_groups VALUES (192,37,10,155,12);
INSERT INTO pollers_poller_groups VALUES (193,37,20,154,9);
INSERT INTO pollers_poller_groups VALUES (194,37,90,1,10);
INSERT INTO pollers_poller_groups VALUES (195,38,40,156,9);
INSERT INTO pollers_poller_groups VALUES (196,38,45,157,9);
INSERT INTO pollers_poller_groups VALUES (197,38,50,158,9);
INSERT INTO pollers_poller_groups VALUES (198,38,55,159,9);
INSERT INTO pollers_poller_groups VALUES (199,38,90,1,10);
INSERT INTO pollers_poller_groups VALUES (200,38,10,160,39);
INSERT INTO pollers_poller_groups VALUES (201,38,20,161,12);
INSERT INTO pollers_poller_groups VALUES (202,38,30,162,40);
INSERT INTO pollers_poller_groups VALUES (203,39,10,165,9);
INSERT INTO pollers_poller_groups VALUES (204,39,20,164,9);
INSERT INTO pollers_poller_groups VALUES (205,39,30,163,9);
INSERT INTO pollers_poller_groups VALUES (206,39,90,1,10);
INSERT INTO pollers_poller_groups VALUES (207,40,10,168,32);
INSERT INTO pollers_poller_groups VALUES (208,40,20,169,32);
INSERT INTO pollers_poller_groups VALUES (209,40,30,166,32);
INSERT INTO pollers_poller_groups VALUES (210,40,40,167,32);
INSERT INTO pollers_poller_groups VALUES (211,41,10,170,20);
INSERT INTO pollers_poller_groups VALUES (212,41,20,173,32);
INSERT INTO pollers_poller_groups VALUES (213,41,30,172,32);
INSERT INTO pollers_poller_groups VALUES (214,41,40,171,32);
INSERT INTO pollers_poller_groups VALUES (215,42,10,174,32);
INSERT INTO pollers_poller_groups VALUES (216,42,20,175,32);
INSERT INTO pollers_poller_groups VALUES (217,42,30,176,32);
INSERT INTO pollers_poller_groups VALUES (218,43,10,178,32);
INSERT INTO pollers_poller_groups VALUES (219,43,20,177,32);
INSERT INTO pollers_poller_groups VALUES (220,8,20,179,32);
INSERT INTO pollers_poller_groups VALUES (221,8,30,180,32);
INSERT INTO pollers_poller_groups VALUES (222,44,10,181,32);
INSERT INTO pollers_poller_groups VALUES (223,45,50,190,32);
INSERT INTO pollers_poller_groups VALUES (224,45,10,186,32);
INSERT INTO pollers_poller_groups VALUES (225,45,20,187,32);
INSERT INTO pollers_poller_groups VALUES (226,45,30,188,32);
INSERT INTO pollers_poller_groups VALUES (227,45,40,189,32);
INSERT INTO pollers_poller_groups VALUES (228,45,15,182,32);
INSERT INTO pollers_poller_groups VALUES (229,45,25,183,32);
INSERT INTO pollers_poller_groups VALUES (230,45,35,184,32);
INSERT INTO pollers_poller_groups VALUES (231,45,45,185,32);
INSERT INTO pollers_poller_groups VALUES (232,46,20,191,32);

--
-- Table structure for table `profiles`
--



--
-- Sequences for table PROFILES
--

CREATE SEQUENCE profiles_id_seq;

CREATE TABLE profiles (
  id INT4 DEFAULT nextval('profiles_id_seq'),
  userid INT4 NOT NULL default '1',
  profile_option INT4 default '1',
  value INT4 default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `profiles`
--

INSERT INTO profiles VALUES (1,1,1,1);
INSERT INTO profiles VALUES (2,2,9,12);
INSERT INTO profiles VALUES (3,2,11,300);
INSERT INTO profiles VALUES (4,2,13,30);
INSERT INTO profiles VALUES (5,2,16,36);
INSERT INTO profiles VALUES (6,2,20,46);
INSERT INTO profiles VALUES (7,2,25,50);
INSERT INTO profiles VALUES (8,2,2,8);
INSERT INTO profiles VALUES (9,2,8,6);
INSERT INTO profiles VALUES (10,2,14,32);
INSERT INTO profiles VALUES (11,2,15,34);
INSERT INTO profiles VALUES (12,2,6,20);

--
-- Table structure for table `profiles_options`
--



--
-- Sequences for table PROFILES_OPTIONS
--

CREATE SEQUENCE profiles_options_id_seq;

CREATE TABLE profiles_options (
  id INT4 DEFAULT nextval('profiles_options_id_seq'),
  tag varchar(30) NOT NULL default '',
  description varchar(60) NOT NULL default '',
  editable INT2 NOT NULL default '0',
  show_in_profile INT2 NOT NULL default '1',
  use_default INT2 NOT NULL default '0',
  default_value varchar(60) NOT NULL default '',
  type varchar(10) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `profiles_options`
--

INSERT INTO profiles_options VALUES (1,'NO_TAG','No Option',1,1,0,'','select');
INSERT INTO profiles_options VALUES (2,'ADMIN_ACCESS','Administration Access',0,1,0,'1','select');
INSERT INTO profiles_options VALUES (6,'REPORTS_VIEW_ALL_INTERFACES','View All Interfaces',0,1,0,'1','select');
INSERT INTO profiles_options VALUES (8,'ADMIN_USERS','User Administration',0,1,0,'1','select');
INSERT INTO profiles_options VALUES (9,'MAP_SOUND','Map Sound',1,1,1,'1','select');
INSERT INTO profiles_options VALUES (11,'EMAIL','eMail',1,1,1,'','text');
INSERT INTO profiles_options VALUES (12,'MAP','Base Map',0,0,0,'1','text');
INSERT INTO profiles_options VALUES (13,'EVENTS_SOUND','Events Sound',1,1,1,'1','select');
INSERT INTO profiles_options VALUES (14,'ADMIN_SYSTEM','System Administration',0,1,0,'1','select');
INSERT INTO profiles_options VALUES (15,'ADMIN_HOSTS','Host Administration',0,1,0,'1','select');
INSERT INTO profiles_options VALUES (16,'VIEW_REPORTS','Reports Access',0,0,1,'1','select');
INSERT INTO profiles_options VALUES (19,'POPUPS_DISABLED','Disable Popups',0,1,0,'1','select');
INSERT INTO profiles_options VALUES (20,'VIEW_STARTPAGE_STATS','View Start Page Stats',1,1,1,'1','select');
INSERT INTO profiles_options VALUES (21,'EVENTS_DEFAULT_FILTER','Events Default Filter',1,1,0,'0','text');
INSERT INTO profiles_options VALUES (22,'EVENTS_REFRESH','Events Refresh Interval (secs)',1,1,0,'20','text');
INSERT INTO profiles_options VALUES (23,'MAP_REFRESH','Map Refresh Interval (secs)',1,1,0,'20','text');
INSERT INTO profiles_options VALUES (24,'SMSALIAS','SMS Pager Alias',1,1,0,'','text');
INSERT INTO profiles_options VALUES (25,'VIEW_TYPE_DEFAULT','Default View Type',1,1,1,'dhtml','select');
INSERT INTO profiles_options VALUES (26,'VIEW_DEFAULT','Default View',1,1,0,'start','select');
INSERT INTO profiles_options VALUES (27,'CUSTOMER','Customer Filter',0,1,0,'','text');

--
-- Table structure for table `profiles_values`
--



--
-- Sequences for table PROFILES_VALUES
--

CREATE SEQUENCE profiles_values_id_seq;

CREATE TABLE profiles_values (
  id INT4 DEFAULT nextval('profiles_values_id_seq'),
  profile_option INT4 NOT NULL default '1',
  description varchar(30) NOT NULL default '',
  value varchar(250) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `profiles_values`
--

INSERT INTO profiles_values VALUES (1,1,'No Value','1');
INSERT INTO profiles_values VALUES (5,9,'Disable','0');
INSERT INTO profiles_values VALUES (6,8,'Yes','1');
INSERT INTO profiles_values VALUES (7,8,'No','0');
INSERT INTO profiles_values VALUES (8,2,'Yes','1');
INSERT INTO profiles_values VALUES (12,9,'Enable','1');
INSERT INTO profiles_values VALUES (20,6,'Yes','1');
INSERT INTO profiles_values VALUES (21,6,'No','0');
INSERT INTO profiles_values VALUES (30,13,'Yes','1');
INSERT INTO profiles_values VALUES (31,13,'No','0');
INSERT INTO profiles_values VALUES (32,14,'Yes','1');
INSERT INTO profiles_values VALUES (33,14,'No','0');
INSERT INTO profiles_values VALUES (34,15,'Yes','1');
INSERT INTO profiles_values VALUES (35,15,'No','0');
INSERT INTO profiles_values VALUES (36,16,'Yes','1');
INSERT INTO profiles_values VALUES (37,16,'No','0');
INSERT INTO profiles_values VALUES (43,19,'Yes','1');
INSERT INTO profiles_values VALUES (44,19,'No','0');
INSERT INTO profiles_values VALUES (46,20,'Yes','1');
INSERT INTO profiles_values VALUES (47,20,'No','0');
INSERT INTO profiles_values VALUES (48,25,'Normal','normal');
INSERT INTO profiles_values VALUES (49,25,'Text Only','text');
INSERT INTO profiles_values VALUES (50,25,'DHTML','dhtml');
INSERT INTO profiles_values VALUES (52,25,'Normal Big','normal-big');
INSERT INTO profiles_values VALUES (53,25,'DHTML Big','dhtml-big');
INSERT INTO profiles_values VALUES (55,26,'Start Page','start');
INSERT INTO profiles_values VALUES (56,26,'Hosts & Events','hosts-events');
INSERT INTO profiles_values VALUES (57,26,'Interfaces & Events','interfaces-events');
INSERT INTO profiles_values VALUES (58,26,'Maps & Events','maps-events');
INSERT INTO profiles_values VALUES (59,26,'Alarmed Interfaces & Events','alarmed-events');
INSERT INTO profiles_values VALUES (60,26,'Alarmed Interfaces','alarmed');
INSERT INTO profiles_values VALUES (61,26,'Interfaces','interfaces');
INSERT INTO profiles_values VALUES (62,26,'Hosts','hosts');
INSERT INTO profiles_values VALUES (63,26,'Maps','maps');
INSERT INTO profiles_values VALUES (64,26,'Hosts All Interfaces','hosts-all-int');
INSERT INTO profiles_values VALUES (65,26,'Events','events');
INSERT INTO profiles_values VALUES (66,26,'Alarmed Hosts & Events','alarmed-hosts-events');
INSERT INTO profiles_values VALUES (300,11,'','');

--
-- Table structure for table `satellites`
--



--
-- Sequences for table SATELLITES
--

CREATE SEQUENCE satellites_id_seq;

CREATE TABLE satellites (
  id INT4 DEFAULT nextval('satellites_id_seq'),
  description varchar(40) NOT NULL default '',
  parent INT4 NOT NULL default '1',
  url varchar(150) NOT NULL default '',
  sat_group INT4 NOT NULL default '1',
  sat_type INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `satellites`
--

INSERT INTO satellites VALUES (1,'Local',1,'',1,1);

--
-- Table structure for table `severity`
--



--
-- Sequences for table SEVERITY
--

CREATE SEQUENCE severity_id_seq;

CREATE TABLE severity (
  id INT2 DEFAULT nextval('severity_id_seq'),
  level INT2 NOT NULL default '0',
  severity varchar(20) NOT NULL default '',
  bgcolor varchar(15) NOT NULL default '',
  fgcolor varchar(15) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `severity`
--

INSERT INTO severity VALUES (1,127,'Unknown','000000','FFFFFF');
INSERT INTO severity VALUES (2,30,'Warning','00AA00','FFFFFF');
INSERT INTO severity VALUES (3,40,'Fault','F51D30','EEEEEE');
INSERT INTO severity VALUES (4,50,'Big Fault','DA4725','FFFFFF');
INSERT INTO severity VALUES (5,60,'Critical','FF0000','FFFFFF');
INSERT INTO severity VALUES (13,10,'Administrative','8D00BA','FFFFFF');
INSERT INTO severity VALUES (14,20,'Information','F9FD5F','000000');
INSERT INTO severity VALUES (18,35,'Service','0090F0','FFFFFF');

--
-- Table structure for table `slas`
--



--
-- Sequences for table SLAS
--

CREATE SEQUENCE slas_id_seq;

CREATE TABLE slas (
  id INT4 DEFAULT nextval('slas_id_seq'),
  description varchar(60) NOT NULL default '',
  state INT2 NOT NULL default '3',
  info varchar(60) NOT NULL default '',
  event_type INT4 NOT NULL default '12',
  threshold INT2 NOT NULL default '100',
  interface_type INT4 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `slas`
--

INSERT INTO slas VALUES (1,'No SLA',3,'No SLA',12,100,1);
INSERT INTO slas VALUES (4,'Customer Satellite Link',3,'Customer Sat Link:',12,75,4);
INSERT INTO slas VALUES (5,'Main Fiber Link',3,'Main Link:',12,100,4);
INSERT INTO slas VALUES (6,'Main Satellite Link',3,'Main Sat Link:',12,100,4);
INSERT INTO slas VALUES (7,'Cisco Router',3,'Router:',12,100,3);
INSERT INTO slas VALUES (8,'Smokeping Host',3,'Smokeping:',12,100,14);
INSERT INTO slas VALUES (9,'Storage',3,'Storage',12,100,8);
INSERT INTO slas VALUES (10,'Linux/Unix CPU',3,'',12,100,11);
INSERT INTO slas VALUES (11,'Windows CPU',3,'',12,100,12);
INSERT INTO slas VALUES (12,'APC UPS',3,'APC UPS',12,100,31);

--
-- Table structure for table `slas_cond`
--



--
-- Sequences for table SLAS_COND
--

CREATE SEQUENCE slas_cond_id_seq;

CREATE TABLE slas_cond (
  id INT4 DEFAULT nextval('slas_cond_id_seq'),
  condition varchar(250) NOT NULL default '',
  description varchar(60) NOT NULL default '',
  event varchar(60) NOT NULL default '',
  variable_show varchar(250) NOT NULL default '',
  variable_show_info varchar(60) NOT NULL default '',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `slas_cond`
--

INSERT INTO slas_cond VALUES (1,'1=2','Unknown','Unknown','','');
INSERT INTO slas_cond VALUES (2,'(<rtt> > 60)','RoundTrip Time > 60ms','RTT > 60','<rtt>','ms');
INSERT INTO slas_cond VALUES (3,'( ((<packetloss> * 100) / <pings>) > 20)','Packet Loss > 20%','PL > 20%','((<packetloss> * 100) / <pings>)','%');
INSERT INTO slas_cond VALUES (4,'(<in> < ((<bandwidthin>*95)/100))','Input Traffic < 95%','IN < 95%','(<in> / 1000)','Kbps');
INSERT INTO slas_cond VALUES (5,'AND','AND','','','');
INSERT INTO slas_cond VALUES (6,'OR','OR','','','');
INSERT INTO slas_cond VALUES (7,'(<rtt> > 700)','RoundTrip Time > 700ms','RTT > 700','<rtt>','ms');
INSERT INTO slas_cond VALUES (8,'(<rtt> > 900)','RoundTrip Time > 900ms','RTT > 900','<rtt>','ms');
INSERT INTO slas_cond VALUES (9,'(((<packetloss> * 100) / <pings>) > 50)','Packet Loss > 50%','PL > 50%','((<packetloss> * 100) / <pings>)','%');
INSERT INTO slas_cond VALUES (11,'(<in> > ((<bandwidthin>*90)/100))','Input Traffic > 90%','IN > 90%','(<in> / 1000)','Kbps');
INSERT INTO slas_cond VALUES (12,'(<in> < ((<bandwidthin>*1)/100))','Input Traffic < 1%','IN < 1 %','','');
INSERT INTO slas_cond VALUES (13,' (<out> > ((<bandwidthout>*90)/100))','Output Traffic > 90%','OUT > 90%','(<out> / 1000 )','kbps');
INSERT INTO slas_cond VALUES (14,'(<out> < ((<bandwidthout>*95)/100))','Output Traffic < 95%','OUT < 95%','(<out> / 1000 )','kbps');
INSERT INTO slas_cond VALUES (15,'( ( (<inerrors> / (<inpackets> + <inerrors> + 1) )*100) > 20)','Input Error Rate > 20%','IN ERR > 20%','( (<inerrors> / (<inpackets> + <inerrors> + 1) )*100)','% = <inerrors> eps');
INSERT INTO slas_cond VALUES (16,'( ( (<inerrors> / (<inpackets> + <inerrors> + 1) )*100) > 10)','Input Error Rate > 10%','IN ERR > 10%','( (<inerrors> / (<inpackets> + <inerrors> + 1) )*100)','% = <inerrors> eps');
INSERT INTO slas_cond VALUES (18,'( ( (<drops> / (<outpackets> + 1) )*100) > 1)','Drops > 1%','Drops > 1%','( (<drops> / (<outpackets> + 1) )*100)','% = <drops> dps');
INSERT INTO slas_cond VALUES (19,' ( ( (<drops> / (<outpackets> + 1) )*100) > 2)','Drops > 2%','Drops > 2%','( (<drops> / (<outpackets> + 1) )*100)','% = <drops> dps');
INSERT INTO slas_cond VALUES (20,'(((<packetloss> * 100) / <pings>) > 10)','Packet Loss > 10%','PL > 10%','((<packetloss> * 100) / <pings>)','%');
INSERT INTO slas_cond VALUES (21,'( ( (<drops> / (<outpackets> +<drops> + 1) )*100) > 10)','Drops > 10%','Drops > 10%','( (<drops> / (<outpackets> +<drops> + 1) )*100)','%');
INSERT INTO slas_cond VALUES (22,' (<in> < ((<bandwidthin>*99)/100))','Input Traffic < 99%','IN < 99%',' (<in> / 1000 )','Kbps');
INSERT INTO slas_cond VALUES (23,' (<out> < ((<bandwidthout>*99)/100))',' Output Traffic < 99%',' OUT < 99%',' (<out> / 1000 )','Kbps');
INSERT INTO slas_cond VALUES (24,'(<cpu> > 60)','CPU Utilization > 60%','CPU > 60%','<cpu>','%');
INSERT INTO slas_cond VALUES (25,'(<packetloss> > 10)','SP Packet Loss > 10%','Packet Loss > 10%','<packetloss>','%');
INSERT INTO slas_cond VALUES (26,'( <storage_used_blocks> > ((<storage_block_count>*<usage_threshold>)/100))','Used Storage','Used > <usage_threshold>%','((<storage_used_blocks> * 100)/<storage_block_count>)','%');
INSERT INTO slas_cond VALUES (27,'( <load_average_5> > 5 )','Load Average > 5','Load Average > 5','<load_average_5>','');
INSERT INTO slas_cond VALUES (28,'(((( <cpu_user_ticks> + <cpu_nice_ticks> + <cpu_system_ticks> ) * 100 ) / ( <cpu_user_ticks> + <cpu_idle_ticks> + <cpu_nice_ticks> + <cpu_system_ticks> )) > 80)','CPU Utilization > 80%','Usage > 80%','((( <cpu_user_ticks> + <cpu_nice_ticks> + <cpu_system_ticks> ) * 100 ) / ( <cpu_user_ticks> + <cpu_idle_ticks> + <cpu_nice_ticks> + <cpu_system_ticks> ))','%');
INSERT INTO slas_cond VALUES (29,'( ((<mem_used> * 100) / (<mem_used> + <mem_free>)) > 80)','Memory Usage > 80%','Memory Usage > 80%','((<mem_used> * 100) / (<mem_used> + <mem_free>))','%');
INSERT INTO slas_cond VALUES (30,'(<cpu> > 90)','CPU Utilization > 90%','CPU > 90%','<cpu>','%');
INSERT INTO slas_cond VALUES (31,'(<num_procs> > <proc_threshold>)','Too Many Processes','Processes > <proc_threshold>','<num_procs>','Processes');
INSERT INTO slas_cond VALUES (32,'(<temperature> > 55)','APC temp > 55','APC temp > 55','<temperature>','C');
INSERT INTO slas_cond VALUES (33,'(<time_remaining> < 300000)','APC time < 50 minutes','APC time < 50 minutes','<time_remaining>','min');

--
-- Table structure for table `slas_sla_cond`
--



--
-- Sequences for table SLAS_SLA_COND
--

CREATE SEQUENCE slas_sla_cond_id_seq;

CREATE TABLE slas_sla_cond (
  id INT4 DEFAULT nextval('slas_sla_cond_id_seq'),
  pos INT2 NOT NULL default '1',
  sla INT4 NOT NULL default '1',
  cond INT4 NOT NULL default '1',
  show_in_result INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `slas_sla_cond`
--

INSERT INTO slas_sla_cond VALUES (1,1,1,1,0);
INSERT INTO slas_sla_cond VALUES (9,30,4,4,0);
INSERT INTO slas_sla_cond VALUES (10,40,4,7,1);
INSERT INTO slas_sla_cond VALUES (11,50,4,20,1);
INSERT INTO slas_sla_cond VALUES (12,70,4,6,0);
INSERT INTO slas_sla_cond VALUES (13,74,4,5,0);
INSERT INTO slas_sla_cond VALUES (14,10,5,11,1);
INSERT INTO slas_sla_cond VALUES (15,20,5,2,1);
INSERT INTO slas_sla_cond VALUES (16,40,5,20,1);
INSERT INTO slas_sla_cond VALUES (17,50,5,6,0);
INSERT INTO slas_sla_cond VALUES (18,60,5,6,0);
INSERT INTO slas_sla_cond VALUES (19,10,6,11,1);
INSERT INTO slas_sla_cond VALUES (20,30,6,7,1);
INSERT INTO slas_sla_cond VALUES (21,60,6,6,0);
INSERT INTO slas_sla_cond VALUES (22,40,6,3,1);
INSERT INTO slas_sla_cond VALUES (23,50,6,6,0);
INSERT INTO slas_sla_cond VALUES (33,20,4,14,0);
INSERT INTO slas_sla_cond VALUES (35,75,4,6,0);
INSERT INTO slas_sla_cond VALUES (36,15,5,13,1);
INSERT INTO slas_sla_cond VALUES (37,70,5,6,0);
INSERT INTO slas_sla_cond VALUES (38,20,6,13,1);
INSERT INTO slas_sla_cond VALUES (39,70,6,6,0);
INSERT INTO slas_sla_cond VALUES (40,10,4,16,1);
INSERT INTO slas_sla_cond VALUES (41,73,4,5,0);
INSERT INTO slas_sla_cond VALUES (42,45,6,16,1);
INSERT INTO slas_sla_cond VALUES (43,55,6,6,0);
INSERT INTO slas_sla_cond VALUES (44,30,5,16,1);
INSERT INTO slas_sla_cond VALUES (45,45,5,6,0);
INSERT INTO slas_sla_cond VALUES (47,60,4,18,1);
INSERT INTO slas_sla_cond VALUES (48,72,4,6,0);
INSERT INTO slas_sla_cond VALUES (49,10,7,24,1);
INSERT INTO slas_sla_cond VALUES (50,10,8,25,1);
INSERT INTO slas_sla_cond VALUES (51,30,8,6,0);
INSERT INTO slas_sla_cond VALUES (52,20,8,2,1);
INSERT INTO slas_sla_cond VALUES (53,1,9,26,1);
INSERT INTO slas_sla_cond VALUES (54,10,10,27,1);
INSERT INTO slas_sla_cond VALUES (55,20,10,28,1);
INSERT INTO slas_sla_cond VALUES (56,30,10,6,0);
INSERT INTO slas_sla_cond VALUES (57,20,7,29,1);
INSERT INTO slas_sla_cond VALUES (58,30,7,6,0);
INSERT INTO slas_sla_cond VALUES (59,10,11,30,1);
INSERT INTO slas_sla_cond VALUES (60,20,11,31,1);
INSERT INTO slas_sla_cond VALUES (61,30,11,6,0);
INSERT INTO slas_sla_cond VALUES (62,5,12,32,1);
INSERT INTO slas_sla_cond VALUES (63,10,12,6,0);
INSERT INTO slas_sla_cond VALUES (64,1,12,33,1);

--
-- Table structure for table `syslog`
--



--
-- Sequences for table SYSLOG
--

CREATE SEQUENCE syslog_id_seq;

CREATE TABLE syslog (
  DATE TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  host varchar(128) default NULL,
  date_logged TIMESTAMP NOT NULL default '0001-01-01 00:00:00',
  message text,
  id INT4 DEFAULT nextval('syslog_id_seq'),
  analized INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `syslog`
--


--
-- Table structure for table `syslog_types`
--



--
-- Sequences for table SYSLOG_TYPES
--

CREATE SEQUENCE syslog_types_id_seq;

CREATE TABLE syslog_types (
  id INT4 DEFAULT nextval('syslog_types_id_seq'),
  match_text varchar(255) NOT NULL default '',
  interface varchar(10) NOT NULL default '',
  username varchar(20) NOT NULL default '',
  state varchar(10) NOT NULL default '',
  info varchar(10) NOT NULL default '',
  type INT4 NOT NULL default '1',
  pos INT2 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `syslog_types`
--

INSERT INTO syslog_types VALUES (1,'UNKNOWN','0','','','*',1,1);
INSERT INTO syslog_types VALUES (2,'%SYS-5-CONFIG_I:.+|%SYS-5-CONFIG:','7','5','','3',2,1);
INSERT INTO syslog_types VALUES (3,'%LINEPROTO-5-UPDOWN:','5','','9','',3,1);
INSERT INTO syslog_types VALUES (4,'%LINK-3-UPDOWN:','2','','6','',4,1);
INSERT INTO syslog_types VALUES (5,'%CONTROLLER-5-UPDOWN:','3','','7','2',5,1);
INSERT INTO syslog_types VALUES (6,'%BGP-5-ADJCHANGE:','2','','3','6',6,1);
INSERT INTO syslog_types VALUES (7,'%LINK-5-CHANGED:','2','','7','6',7,1);
INSERT INTO syslog_types VALUES (9,'%RCMD-4-RSHPORTATTEMPT:','5','','','7',9,1);
INSERT INTO syslog_types VALUES (17,'%CLEAR-5-COUNTERS:','5','7','','10',17,1);
INSERT INTO syslog_types VALUES (20,'%PIX-2-106006:','7','5','1','3',29,1);
INSERT INTO syslog_types VALUES (21,'%PIX-2-106007:','7','5','1','3',29,1);
INSERT INTO syslog_types VALUES (22,'%PIX-2-106001:','8','6','4','2',29,1);
INSERT INTO syslog_types VALUES (25,'%PIX-3-106010:','7','5','1','3',29,1);
INSERT INTO syslog_types VALUES (26,'%PIX-3-106014:','7','5','1','3',29,1);
INSERT INTO syslog_types VALUES (29,'%PIX-3-305006:.+|%PIX-2-106012:.+|%PIX-3-305005:.+|%PIX-3-307001:.+','','','','D',28,1);
INSERT INTO syslog_types VALUES (30,'%CDP-4-DUPLEX_MISMATCH:','5','10','','11',34,1);
INSERT INTO syslog_types VALUES (31,'%SEC-6-IPACCESSLOGS:','2','4','3','5',35,1);
INSERT INTO syslog_types VALUES (32,'%SEC-6-IPACCESSLOGP:.+|%SEC-6-IPACCESSLOGNP:','2','7','3','8',35,1);
INSERT INTO syslog_types VALUES (33,'%BGP-3-NOTIFICATION: (\\S+ \\S+) neighbor (\\S+) \\S+ (\\S+ \\S+ \\S+) \\S+ \\S+','2','','1','3',36,1);
INSERT INTO syslog_types VALUES (34,'%SYS-5-RESTART:','','','','D',26,1);
INSERT INTO syslog_types VALUES (35,'%SYS-5-RELOAD:','','','','D',26,1);
INSERT INTO syslog_types VALUES (36,'%SEC-6-IPACCESSLOGDP:','2','5','3','9',35,1);
INSERT INTO syslog_types VALUES (37,'EXCESSCOLL:','1','','','',37,1);
INSERT INTO syslog_types VALUES (38,'^([^[]+)(?:\\[\\d+\\])?:\\s+(.+)$','1','','','2',44,100);
INSERT INTO syslog_types VALUES (39,'CRON\\[\\d+\\]: \\((\\S+)\\) CMD (.*)','cron','1','','2',45,1);
INSERT INTO syslog_types VALUES (40,'^(\\S.*)\\[info\\]\\s*(\\S+)\\s*(\\S.*)','1','','2','3',46,10);
INSERT INTO syslog_types VALUES (41,'^(\\S.*)\\[error\\]\\s*(\\S+)\\s*(\\S.*)','1','','2','3',48,10);
INSERT INTO syslog_types VALUES (42,'^(\\S.*)\\[warning\\]\\s*(\\S+)\\s*(\\S.*)','1','','2','3',47,10);
INSERT INTO syslog_types VALUES (43,'^security\\[failure\\] (\\d*) (.*)','','','1','2',49,10);
INSERT INTO syslog_types VALUES (44,'%PIX-1-(\\d*): (.*)','1','','','2',67,2);
INSERT INTO syslog_types VALUES (45,'%PIX-2-(\\d*): (.*)','1','','','2',66,2);
INSERT INTO syslog_types VALUES (46,'%PIX-3-(\\d*): (.*)','1','','','2',65,2);
INSERT INTO syslog_types VALUES (47,'%PIX-4-(\\d*): (.*)','1','','','2',64,2);
INSERT INTO syslog_types VALUES (48,'%PIX-6-(\\d*): (.*)','1','','','2',62,2);
INSERT INTO syslog_types VALUES (49,'%PIX-5-(\\d*): (.*)','1','','','2',63,2);
INSERT INTO syslog_types VALUES (50,'%PIX-7-(\\d*): (.*)','1','','','2',61,2);
INSERT INTO syslog_types VALUES (51,'%PIX-4-106023:','6','4','1','2',29,1);
INSERT INTO syslog_types VALUES (52,'^UPS: (.*)\\. (.*)$','UPS','','','1',26,1);
INSERT INTO syslog_types VALUES (53,'WebOS <slb>: real server (\\S+) operational','1','','up','',68,1);
INSERT INTO syslog_types VALUES (54,'WebOS <slb>: cannot contact real server (\\S+)','1','','down','',68,1);
INSERT INTO syslog_types VALUES (55,'WebOS <slb>: No services are available for Virtual Server\\d+:(\\S+)','1','','down','',70,1);
INSERT INTO syslog_types VALUES (56,'WebOS <slb>: Services are available for Virtual Server\\d+:(\\S+)','1','','up','',70,1);
INSERT INTO syslog_types VALUES (57,'WebOS <slb>: real service (\\S+) operational','1','','up','',69,1);
INSERT INTO syslog_types VALUES (58,'WebOS <slb>: cannot contact real service (\\S+)','1','','closed','',69,1);
INSERT INTO syslog_types VALUES (59,'%ISDN-6-CONNECT: Interface (\\S+) is now (\\S+) (.+)$','1','','2','3',72,1);
INSERT INTO syslog_types VALUES (60,'%ISDN-6-DISCONNECT: Interface (\\S+) (\\S+) (.+)$','1','','2','3',72,1);

--
-- Table structure for table `tools`
--



--
-- Sequences for table TOOLS
--

CREATE SEQUENCE tools_id_seq;

CREATE TABLE tools (
  id INT4 DEFAULT nextval('tools_id_seq'),
  description varchar(60) NOT NULL default '',
  name varchar(30) NOT NULL default '',
  file_group varchar(30) NOT NULL default '',
  itype INT4 NOT NULL default '1',
  pos INT4 NOT NULL default '1',
  allow_set INT2 NOT NULL default '0',
  allow_get INT2 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `tools`
--

INSERT INTO tools VALUES (1,'Nothing','none','none',1,1,0,1);
INSERT INTO tools VALUES (3,'Description','if_alias','',4,2,1,1);
INSERT INTO tools VALUES (4,'Change Admin Status','if_admin','',4,3,1,1);
INSERT INTO tools VALUES (5,'Connections List','tcp_cnx','',2,1,1,1);

--
-- Table structure for table `trap_receivers`
--



--
-- Sequences for table TRAP_RECEIVERS
--

CREATE SEQUENCE trap_receivers_id_seq;

CREATE TABLE trap_receivers (
  id INT4 DEFAULT nextval('trap_receivers_id_seq'),
  position INT4 NOT NULL default '0',
  match_oid varchar(100) NOT NULL default '',
  description varchar(60) NOT NULL default '',
  command varchar(60) NOT NULL default '',
  parameters varchar(250) NOT NULL default '',
  backend INT4 NOT NULL default '1',
  interface_type INT4 NOT NULL default '1',
  stop_if_matches INT2 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `trap_receivers`
--

INSERT INTO trap_receivers VALUES (1,99,'.*','Default Trap Receiver','unknown','',2,1,1);
INSERT INTO trap_receivers VALUES (2,10,'.1.3.6.1.6.3.1.1.5.4','Link Up','static','up,interfacenumber,1',12,4,1);
INSERT INTO trap_receivers VALUES (3,10,'.1.3.6.1.6.3.1.1.5.3','Link Down','static','down,interfacenumber,1',12,4,1);

--
-- Table structure for table `traps`
--



--
-- Sequences for table TRAPS
--

CREATE SEQUENCE traps_id_seq;

CREATE TABLE traps (
  id INT4 DEFAULT nextval('traps_id_seq'),
  ip varchar(20) NOT NULL default '',
  trap_oid varchar(250) NOT NULL default '',
  analized INT2 NOT NULL default '0',
  DATE INT4 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `traps`
--


--
-- Table structure for table `traps_varbinds`
--



--
-- Sequences for table TRAPS_VARBINDS
--

CREATE SEQUENCE traps_varbinds_id_seq;

CREATE TABLE traps_varbinds (
  id INT4 DEFAULT nextval('traps_varbinds_id_seq'),
  trapid INT4 NOT NULL default '0',
  trap_oid varchar(250) default NULL,
  value varchar(250) NOT NULL default '',
  oidid INT4 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `traps_varbinds`
--


--
-- Table structure for table `triggers`
--



--
-- Sequences for table TRIGGERS
--

CREATE SEQUENCE triggers_id_seq;

CREATE TABLE triggers (
  id INT4 DEFAULT nextval('triggers_id_seq'),
  description varchar(40) NOT NULL default '',
  type varchar(20) NOT NULL default 'alarm',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `triggers`
--

INSERT INTO triggers VALUES (1,'No Trigger','alarm');
INSERT INTO triggers VALUES (2,'Interface Status Change','alarm');

--
-- Table structure for table `triggers_rules`
--



--
-- Sequences for table TRIGGERS_RULES
--

CREATE SEQUENCE triggers_rules_id_seq;

CREATE TABLE triggers_rules (
  id INT4 DEFAULT nextval('triggers_rules_id_seq'),
  trigger_id INT4 NOT NULL default '1',
  pos INT4 NOT NULL default '10',
  field varchar(40) NOT NULL default '',
  operator varchar(20) NOT NULL default '',
  value varchar(100) NOT NULL default '',
  action_id INT4 NOT NULL default '1',
  action_parameters varchar(250) NOT NULL default '',
  stop INT2 NOT NULL default '1',
  and_or INT2 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `triggers_rules`
--

INSERT INTO triggers_rules VALUES (1,1,10,'none','=','',1,'',1,1);
INSERT INTO triggers_rules VALUES (2,2,10,'type','!IN','12,25',2,'from:,subject:<interface-client_shortname> <interface-interface> <interface-description> <alarm-type_description> <alarm-state_description>,comment:Default Trigger',0,1);

--
-- Table structure for table `triggers_users`
--



--
-- Sequences for table TRIGGERS_USERS
--

CREATE SEQUENCE triggers_users_id_seq;

CREATE TABLE triggers_users (
  id INT4 DEFAULT nextval('triggers_users_id_seq'),
  user_id INT4 NOT NULL default '1',
  trigger_id INT4 NOT NULL default '1',
  active INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `triggers_users`
--

INSERT INTO triggers_users VALUES (1,1,1,0);

--
-- Table structure for table `types`
--



--
-- Sequences for table TYPES
--

CREATE SEQUENCE types_id_seq;

CREATE TABLE types (
  id INT4 DEFAULT nextval('types_id_seq'),
  description varchar(30) NOT NULL default '',
  severity INT4 NOT NULL default '1',
  text varchar(250) NOT NULL default '',
  generate_alarm INT2 NOT NULL default '0',
  alarm_up INT4 NOT NULL default '1',
  alarm_duration INT4 NOT NULL default '0',
  show_default INT2 NOT NULL default '1',
  show_host INT2 NOT NULL default '1',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `types`
--

INSERT INTO types VALUES (1,'Unknown',2,'<interface> <user> <state> <info>',0,1,0,1,1);
INSERT INTO types VALUES (2,'Configuration',2,'<user>: Changed Configuration from <info> <interface>',0,1,0,1,1);
INSERT INTO types VALUES (3,'Interface Protocol',3,'Interface <interface> Protocol <state> <info> (<client> <interface-description>)',1,1,0,1,1);
INSERT INTO types VALUES (4,'Interface Link',4,'Interface <interface> Link <state> <info> (<client> <interface-description>)',0,1,0,1,1);
INSERT INTO types VALUES (5,'Controller Status',4,'Controller  <info> <interface> <state>',0,1,0,1,1);
INSERT INTO types VALUES (6,'BGP Status',5,'BGP Neighbor <interface> <state> <info> (<client> <interface-description>)',1,1,0,1,1);
INSERT INTO types VALUES (7,'Interface Shutdown',4,'Interface <interface> <info> <state> (<client> <interface-description>)',0,4,0,1,1);
INSERT INTO types VALUES (8,'Command',2,'<user>: <info>',0,1,0,1,1);
INSERT INTO types VALUES (9,'RShell Attempt',14,'RShell attempt from <info> <state>',0,1,0,1,1);
INSERT INTO types VALUES (12,'SLA',14,'<interface> <info> (<client> <interface-description>)',1,1,1800,1,1);
INSERT INTO types VALUES (17,'Clear Counters',14,'<user> Cleared Counters of <interface>  (<client> <interface-description>)',0,1,0,1,1);
INSERT INTO types VALUES (22,'TCP/UDP Service',18,'TCP/UDP Service <interface> <state> (<client> <interface-description>) <info>',1,1,0,1,1);
INSERT INTO types VALUES (25,'Administrative',13,'<interface> <info>',1,1,1800,1,1);
INSERT INTO types VALUES (26,'Environmental',5,'<interface> <state> <info>',1,1,0,1,1);
INSERT INTO types VALUES (28,'PIX Event',14,'<info>',0,1,0,1,1);
INSERT INTO types VALUES (29,'PIX Port',2,'<state> <info> packet from <user> to <interface>',0,1,0,1,1);
INSERT INTO types VALUES (34,'Duplex Mismatch',2,'Duplex Mismatch, <interface> is not full duplex and <user> <info> is full duplex',0,1,0,1,1);
INSERT INTO types VALUES (35,'ACL',14,'ACL <interface> <state> <info> packets from <user>',0,1,0,1,1);
INSERT INTO types VALUES (36,'BGP Notification',14,'Notification <state> <interface> <info>',0,1,0,1,1);
INSERT INTO types VALUES (37,'Excess Collitions',2,'Excess Collitions on Interface <interface>',0,1,0,1,1);
INSERT INTO types VALUES (38,'Application',5,'Application <interface> is <state> <info> (<client> <interface-description>)',1,1,0,1,1);
INSERT INTO types VALUES (39,'TCP Content',18,'Content Response on <interface> is <state> (<client> <interface-description>) <info>',1,1,0,1,1);
INSERT INTO types VALUES (40,'Reachability',5,'Host is <state> with <info>',1,1,0,1,1);
INSERT INTO types VALUES (41,'NTP',14,'<interface> is <state> <info>',1,1,0,1,1);
INSERT INTO types VALUES (42,'Tool Action',5,'<interface> <info> changed to <state> by <user> (<client> <interface-description>)',0,1,0,1,1);
INSERT INTO types VALUES (43,'Internal',14,'<user> <interface> <state> <info>',0,1,0,1,0);
INSERT INTO types VALUES (44,'Syslog',14,'<interface>: <info>',0,1,0,1,1);
INSERT INTO types VALUES (45,'Hide this Event',14,'<interface> <user> <state> <info>',0,1,0,0,1);
INSERT INTO types VALUES (46,'Win Info',14,'<interface>: <info> (ID:<state>)',0,1,0,2,1);
INSERT INTO types VALUES (47,'Win Warning',2,'<interface>: <info> (ID:<state>)',0,1,0,1,1);
INSERT INTO types VALUES (48,'Win Error',3,'<interface>: <info> (ID:<state>)',0,1,0,1,1);
INSERT INTO types VALUES (49,'Win Security',3,'<info> (ID:<state>)',0,1,0,1,1);
INSERT INTO types VALUES (50,'SQL',3,'SQL <interface> is <state> <info>',1,1,0,1,1);
INSERT INTO types VALUES (60,'APC Status',5,'<interface> is <state> <info>',1,1,0,1,1);
INSERT INTO types VALUES (61,'PIX Debug',13,'<info> (ID:<interface>)',0,1,0,2,1);
INSERT INTO types VALUES (62,'PIX Info',14,'<info> (ID:<interface>)',0,1,0,2,1);
INSERT INTO types VALUES (63,'PIX Notif',2,'<info> (ID:<interface>)',0,1,0,2,1);
INSERT INTO types VALUES (64,'PIX Warn',18,'<info> (ID:<interface>)',0,1,0,2,1);
INSERT INTO types VALUES (65,'PIX Error',3,'<info> (ID:<interface>)',0,1,0,2,1);
INSERT INTO types VALUES (66,'PIX Crit',4,'<info> (ID:<interface>)',1,1,0,1,1);
INSERT INTO types VALUES (67,'PIX Alert',5,'<info> (ID:<interface>)',1,1,0,1,1);
INSERT INTO types VALUES (68,'Alteon RServer',3,'Real Server <interface> is <state>',1,1,0,1,1);
INSERT INTO types VALUES (69,'Alteon Service',3,'Real Service <interface> is <state> <info>',1,1,0,1,1);
INSERT INTO types VALUES (70,'Alteon VServer',3,'Virtual Server <interface> is <state> <info>',0,1,0,1,1);
INSERT INTO types VALUES (71,'Brocade FC Port',3,'<interface> <state> (<info>)',1,1,0,1,1);
INSERT INTO types VALUES (72,'ISDN',14,'<interface> <state> <info>',1,1,0,1,1);

--
-- Table structure for table `zones`
--



--
-- Sequences for table ZONES
--

CREATE SEQUENCE zones_id_seq;

CREATE TABLE zones (
  id INT4 DEFAULT nextval('zones_id_seq'),
  zone varchar(60) NOT NULL default '',
  shortname varchar(10) NOT NULL default '',
  image varchar(30) NOT NULL default '',
  seeds varchar(250) NOT NULL default '',
  max_deep INT2 NOT NULL default '2',
  communities varchar(250) NOT NULL default '',
  refresh INT4 NOT NULL default '86400',
  admin_status INT2 NOT NULL default '0',
  show_zone INT2 NOT NULL default '1',
  allow_private INT2 NOT NULL default '0',
  PRIMARY KEY (id)

);

--
-- Dumping data for table `zones`
--

INSERT INTO zones VALUES (1,'Unknown','UNK','unknown.png','',1,'',86400,0,1,0);
INSERT INTO zones VALUES (2,'New Zone','NewZone','unknown.png','',1,'',86400,0,1,1);



--
-- Indexes for table HOSTS
--

CREATE UNIQUE INDEX id_hosts_index ON hosts (id);
CREATE INDEX zone_hosts_index ON hosts (zone);
CREATE INDEX ip_hosts_index ON hosts (ip);
CREATE INDEX ip_tacacs_hosts_index ON hosts (ip_tacacs);
CREATE INDEX autodiscovery_default_customer_hosts_index ON hosts (autodiscovery_default_customer);
CREATE INDEX autodiscovery_hosts_index ON hosts (autodiscovery);
CREATE INDEX satellite_hosts_index ON hosts (satellite);
CREATE INDEX poll_hosts_index ON hosts (poll);

--
-- Indexes for table POLLERS_GROUPS
--

CREATE UNIQUE INDEX id_pollers_groups_index ON pollers_groups (id);

--
-- Indexes for table INTERFACE_TYPES
--

CREATE UNIQUE INDEX id_interface_types_index ON interface_types (id);
CREATE INDEX id_2_interface_types_index ON interface_types (id);
CREATE INDEX autodiscovery_enabled_interface_types_index ON interface_types (autodiscovery_enabled);

--
-- Indexes for table FILTERS
--

CREATE UNIQUE INDEX id_filters_index ON filters (id);
CREATE INDEX id_2_filters_index ON filters (id);

--
-- Indexes for table ZONES
--

CREATE UNIQUE INDEX id_zones_index ON zones (id);
CREATE INDEX id_2_zones_index ON zones (id);

--
-- Indexes for table FILTERS_FIELDS
--

CREATE UNIQUE INDEX id_filters_fields_index ON filters_fields (id);
CREATE INDEX id_2_filters_fields_index ON filters_fields (id);

--
-- Indexes for table ACCT
--

CREATE UNIQUE INDEX id_acct_index ON acct (id);
CREATE INDEX id_2_acct_index ON acct (id);
CREATE INDEX analized_acct_index ON acct (analized);
CREATE INDEX s_name_acct_index ON acct (s_name);

--
-- Indexes for table ALARMS
--

CREATE UNIQUE INDEX id_alarms_index ON alarms (id);
CREATE INDEX type_alarms_index ON alarms (type);
CREATE INDEX interface_alarms_index ON alarms (interface);
CREATE INDEX active_alarms_index ON alarms (active);
CREATE INDEX triggered_alarms_index ON alarms (triggered);

--
-- Indexes for table EVENTS_LATEST
--

CREATE UNIQUE INDEX id_events_latest_index ON events_latest (id);
CREATE INDEX tipo_events_latest_index ON events_latest (type);
CREATE INDEX host_events_latest_index ON events_latest (host);
CREATE INDEX interface_events_latest_index ON events_latest (interface);
CREATE INDEX analized_events_latest_index ON events_latest (analized);
CREATE INDEX DATE_events_latest_index ON events_latest (date);
CREATE INDEX username_events_latest_index ON events_latest (username);
CREATE INDEX ack_events_latest_index ON events_latest (ack);

--
-- Indexes for table TRAPS
--

CREATE UNIQUE INDEX id_traps_index ON traps (id);
CREATE INDEX id_2_traps_index ON traps (id);
CREATE INDEX analized_traps_index ON traps (analized);

--
-- Indexes for table INTERFACE_TYPES_FIELDS
--

CREATE INDEX ftype_itype_interface_types_fields_index ON interface_types_fields (ftype,itype);
CREATE INDEX ftype_interface_types_fields_index ON interface_types_fields (ftype);

--
-- Indexes for table PROFILES
--

CREATE UNIQUE INDEX id_profiles_index ON profiles (id);
CREATE INDEX id_2_profiles_index ON profiles (id);
CREATE INDEX tag_profiles_index ON profiles (profile_option);
CREATE INDEX userid_profiles_index ON profiles (userid);

--
-- Indexes for table HOSTS_CONFIG
--

CREATE UNIQUE INDEX id_hosts_config_index ON hosts_config (id);
CREATE INDEX host_hosts_config_index ON hosts_config (host);

--
-- Indexes for table TOOLS
--

CREATE INDEX itype_tools_index ON tools (itype,pos);

--
-- Indexes for table SATELLITES
--

CREATE INDEX parent_satellites_index ON satellites (parent);
CREATE INDEX sat_type_satellites_index ON satellites (sat_type);

--
-- Indexes for table ALARM_STATES
--

CREATE UNIQUE INDEX id_alarm_states_index ON alarm_states (id);
CREATE INDEX id_2_alarm_states_index ON alarm_states (id);
CREATE INDEX description_alarm_states_index ON alarm_states (description);

--
-- Indexes for table SYSLOG_TYPES
--

CREATE UNIQUE INDEX id_syslog_types_index ON syslog_types (id);
CREATE INDEX id_2_syslog_types_index ON syslog_types (id);

--
-- Indexes for table NAD_NETWORKS
--

CREATE INDEX network_nad_networks_index ON nad_networks (network);
CREATE INDEX parent_nad_networks_index ON nad_networks (parent);
CREATE INDEX seed_nad_networks_index ON nad_networks (seed);

--
-- Indexes for table TRIGGERS_USERS
--

CREATE INDEX user_id_triggers_users_index ON triggers_users (user_id);

--
-- Indexes for table TRAP_RECEIVERS
--

CREATE UNIQUE INDEX id_trap_receivers_index ON trap_receivers (id);
CREATE INDEX id_2_trap_receivers_index ON trap_receivers (id);

--
-- Indexes for table TYPES
--

CREATE UNIQUE INDEX id_types_index ON types (id);
CREATE INDEX id_2_types_index ON types (id);
CREATE INDEX severity_types_index ON types (severity);
CREATE INDEX description_types_index ON types (description);
CREATE INDEX generate_alarm_types_index ON types (generate_alarm);

--
-- Indexes for table ACTIONS
--

CREATE INDEX command_actions_index ON actions (command);

--
-- Indexes for table PROFILES_OPTIONS
--

CREATE UNIQUE INDEX id_profiles_options_index ON profiles_options (id);
CREATE INDEX id_2_profiles_options_index ON profiles_options (id);
CREATE INDEX tag_profiles_options_index ON profiles_options (tag);

--
-- Indexes for table MAPS
--

CREATE UNIQUE INDEX id_maps_index ON maps (id);
CREATE INDEX id_2_maps_index ON maps (id);
CREATE INDEX parent_maps_index ON maps (parent);

--
-- Indexes for table TRAPS_VARBINDS
--

CREATE INDEX trapid_traps_varbinds_index ON traps_varbinds (trapid);

--
-- Indexes for table SLAS_SLA_COND
--

CREATE UNIQUE INDEX id_slas_sla_cond_index ON slas_sla_cond (id);
CREATE INDEX id_2_slas_sla_cond_index ON slas_sla_cond (id);
CREATE INDEX sla_slas_sla_cond_index ON slas_sla_cond (sla);
CREATE INDEX cond_slas_sla_cond_index ON slas_sla_cond (cond);

--
-- Indexes for table AUTODISCOVERY
--

CREATE UNIQUE INDEX id_autodiscovery_index ON autodiscovery (id);

--
-- Indexes for table AUTH
--

CREATE UNIQUE INDEX id_auth_index ON auth (id);
CREATE INDEX usern_auth_index ON auth (usern);

--
-- Indexes for table INTERFACES
--

CREATE UNIQUE INDEX idint_interfaces_index ON interfaces (id);
CREATE INDEX interface_interfaces_index ON interfaces (interface);
CREATE INDEX host_interfaces_index ON interfaces (host);
CREATE INDEX client_interfaces_index ON interfaces (client);
CREATE INDEX poll_interfaces_index ON interfaces (poll);
CREATE INDEX sla_interfaces_index ON interfaces (sla);
CREATE INDEX interfacehost_interfaces_index ON interfaces (interface,host);
CREATE INDEX last_poll_date_interfaces_index ON interfaces (last_poll_date);
CREATE INDEX type_interfaces_index ON interfaces (type);
CREATE INDEX check_status_interfaces_index ON interfaces (check_status);

--
-- Indexes for table POLLERS
--

CREATE UNIQUE INDEX id_pollers_index ON pollers (id);
CREATE INDEX id_2_pollers_index ON pollers (id);

--
-- Indexes for table SLAS
--

CREATE UNIQUE INDEX id_slas_index ON slas (id);
CREATE INDEX id_2_slas_index ON slas (id);
CREATE INDEX state_slas_index ON slas (state);
CREATE INDEX event_type_slas_index ON slas (event_type);

--
-- Indexes for table SEVERITY
--

CREATE UNIQUE INDEX id_severity_index ON severity (id);
CREATE INDEX nivel_severity_index ON severity (level);

--
-- Indexes for table JOURNAL
--

CREATE UNIQUE INDEX id_journal_index ON journal (id);
CREATE INDEX id_2_journal_index ON journal (id);

--
-- Indexes for table NAD_IPS
--

CREATE INDEX host_nad_ips_index ON nad_ips (host,ip);
CREATE INDEX network_nad_ips_index ON nad_ips (network);

--
-- Indexes for table PROFILES_VALUES
--

CREATE UNIQUE INDEX id_profiles_values_index ON profiles_values (id);
CREATE INDEX profile_option_profiles_values_index ON profiles_values (profile_option);

--
-- Indexes for table MAPS_INTERFACES
--

CREATE UNIQUE INDEX id_maps_interfaces_index ON maps_interfaces (id);
CREATE INDEX id2_maps_interfaces_index ON maps_interfaces (id);
CREATE INDEX map_maps_interfaces_index ON maps_interfaces (map);
CREATE INDEX interface_maps_interfaces_index ON maps_interfaces (interface);

--
-- Indexes for table POLLERS_BACKEND
--

CREATE UNIQUE INDEX id_pollers_backend_index ON pollers_backend (id);
CREATE INDEX type_pollers_backend_index ON pollers_backend (type);

--
-- Indexes for table FILTERS_COND
--

CREATE UNIQUE INDEX id_filters_cond_index ON filters_cond (id);
CREATE INDEX id_2_filters_cond_index ON filters_cond (id);
CREATE INDEX filter_filters_cond_index ON filters_cond (filter_id);
CREATE INDEX field_filters_cond_index ON filters_cond (field_id);

--
-- Indexes for table INTERFACES_VALUES
--

CREATE UNIQUE INDEX interface_field_interfaces_values_index ON interfaces_values (interface,field);
CREATE INDEX interface_interfaces_values_index ON interfaces_values (interface);
CREATE INDEX field_interfaces_values_index ON interfaces_values (field);

--
-- Indexes for table TRIGGERS_RULES
--

CREATE INDEX trigger_id_triggers_rules_index ON triggers_rules (trigger_id,pos);

--
-- Indexes for table SLAS_COND
--

CREATE UNIQUE INDEX id_slas_cond_index ON slas_cond (id);
CREATE INDEX id_2_slas_cond_index ON slas_cond (id);

--
-- Indexes for table GRAPH_TYPES
--

CREATE UNIQUE INDEX id_graph_types_index ON graph_types (id);
CREATE INDEX id_2_graph_types_index ON graph_types (id);

--
-- Indexes for table POLLERS_POLLER_GROUPS
--

CREATE UNIQUE INDEX id_pollers_poller_groups_index ON pollers_poller_groups (id);
CREATE INDEX poller_group_pollers_poller_groups_index ON pollers_poller_groups (poller_group);
CREATE INDEX poller_pollers_poller_groups_index ON pollers_poller_groups (poller);
CREATE INDEX backend_pollers_poller_groups_index ON pollers_poller_groups (backend);

--
-- Indexes for table EVENTS
--

CREATE INDEX host_events_index ON events (host);
CREATE INDEX interface_events_index ON events (interface);
CREATE INDEX username_events_index ON events (username);
CREATE INDEX ack_events_index ON events (ack);
CREATE INDEX type_events_index ON events (type);
CREATE INDEX state_events_index ON events (state);
CREATE INDEX DATE_events_index ON events (date);
CREATE INDEX analized_events_index ON events (analized);

--
-- Indexes for table SYSLOG
--

CREATE UNIQUE INDEX id_syslog_index ON syslog (id);
CREATE INDEX analized_syslog_index ON syslog (analized);

--
-- Indexes for table CLIENTS
--

CREATE UNIQUE INDEX id_clients_index ON clients (id);

--
-- Sequences for table HOSTS
--

SELECT SETVAL('hosts_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from hosts));

--
-- Sequences for table POLLERS_GROUPS
--

SELECT SETVAL('pollers_groups_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from pollers_groups));

--
-- Sequences for table INTERFACE_TYPES
--

SELECT SETVAL('interface_types_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from interface_types));

--
-- Sequences for table FILTERS
--

SELECT SETVAL('filters_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from filters));

--
-- Sequences for table TRIGGERS
--

SELECT SETVAL('triggers_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from triggers));

--
-- Sequences for table ZONES
--

SELECT SETVAL('zones_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from zones));

--
-- Sequences for table FILTERS_FIELDS
--

SELECT SETVAL('filters_fields_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from filters_fields));

--
-- Sequences for table ACCT
--

SELECT SETVAL('acct_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from acct));

--
-- Sequences for table ALARMS
--

SELECT SETVAL('alarms_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from alarms));

--
-- Sequences for table EVENTS_LATEST
--

SELECT SETVAL('events_latest_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from events_latest));

--
-- Sequences for table TRAPS
--

SELECT SETVAL('traps_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from traps));

--
-- Sequences for table NAD_HOSTS
--

SELECT SETVAL('nad_hosts_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from nad_hosts));

--
-- Sequences for table INTERFACE_TYPES_FIELDS
--

SELECT SETVAL('interface_types_fields_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from interface_types_fields));

--
-- Sequences for table PROFILES
--

SELECT SETVAL('profiles_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from profiles));

--
-- Sequences for table HOSTS_CONFIG
--

SELECT SETVAL('hosts_config_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from hosts_config));

--
-- Sequences for table TOOLS
--

SELECT SETVAL('tools_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from tools));

--
-- Sequences for table SATELLITES
--

SELECT SETVAL('satellites_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from satellites));

--
-- Sequences for table ALARM_STATES
--

SELECT SETVAL('alarm_states_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from alarm_states));

--
-- Sequences for table INTERFACE_TYPES_FIELD_TYPES
--

SELECT SETVAL('interface_types_field_types_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from interface_types_field_types));

--
-- Sequences for table SYSLOG_TYPES
--

SELECT SETVAL('syslog_types_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from syslog_types));

--
-- Sequences for table NAD_NETWORKS
--

SELECT SETVAL('nad_networks_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from nad_networks));

--
-- Sequences for table TRIGGERS_USERS
--

SELECT SETVAL('triggers_users_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from triggers_users));

--
-- Sequences for table TRAP_RECEIVERS
--

SELECT SETVAL('trap_receivers_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from trap_receivers));

--
-- Sequences for table TYPES
--

SELECT SETVAL('types_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from types));

--
-- Sequences for table PROFILES_OPTIONS
--

SELECT SETVAL('profiles_options_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from profiles_options));

--
-- Sequences for table ACTIONS
--

SELECT SETVAL('actions_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from actions));

--
-- Sequences for table MAPS
--

SELECT SETVAL('maps_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from maps));

--
-- Sequences for table TRAPS_VARBINDS
--

SELECT SETVAL('traps_varbinds_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from traps_varbinds));

--
-- Sequences for table SLAS_SLA_COND
--

SELECT SETVAL('slas_sla_cond_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from slas_sla_cond));

--
-- Sequences for table AUTODISCOVERY
--

SELECT SETVAL('autodiscovery_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from autodiscovery));

--
-- Sequences for table AUTH
--

SELECT SETVAL('auth_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from auth));

--
-- Sequences for table INTERFACES
--

SELECT SETVAL('interfaces_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from interfaces));

--
-- Sequences for table POLLERS
--

SELECT SETVAL('pollers_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from pollers));

--
-- Sequences for table SLAS
--

SELECT SETVAL('slas_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from slas));

--
-- Sequences for table SEVERITY
--

SELECT SETVAL('severity_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from severity));

--
-- Sequences for table JOURNAL
--

SELECT SETVAL('journal_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from journal));

--
-- Sequences for table PROFILES_VALUES
--

SELECT SETVAL('profiles_values_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from profiles_values));

--
-- Sequences for table NAD_IPS
--

SELECT SETVAL('nad_ips_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from nad_ips));

--
-- Sequences for table MAPS_INTERFACES
--

SELECT SETVAL('maps_interfaces_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from maps_interfaces));

--
-- Sequences for table POLLERS_BACKEND
--

SELECT SETVAL('pollers_backend_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from pollers_backend));

--
-- Sequences for table FILTERS_COND
--

SELECT SETVAL('filters_cond_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from filters_cond));

--
-- Sequences for table INTERFACES_VALUES
--

SELECT SETVAL('interfaces_values_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from interfaces_values));

--
-- Sequences for table TRIGGERS_RULES
--

SELECT SETVAL('triggers_rules_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from triggers_rules));

--
-- Sequences for table SLAS_COND
--

SELECT SETVAL('slas_cond_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from slas_cond));

--
-- Sequences for table GRAPH_TYPES
--

SELECT SETVAL('graph_types_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from graph_types));

--
-- Sequences for table POLLERS_POLLER_GROUPS
--

SELECT SETVAL('pollers_poller_groups_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from pollers_poller_groups));

--
-- Sequences for table HOSTS_CONFIG_TYPES
--

SELECT SETVAL('hosts_config_types_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from hosts_config_types));

--
-- Sequences for table EVENTS
--

SELECT SETVAL('events_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from events));

--
-- Sequences for table SYSLOG
--

SELECT SETVAL('syslog_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from syslog));

--
-- Sequences for table CLIENTS
--

SELECT SETVAL('clients_id_seq',(select case when max(id)>0 then max(id)+1 else 1 end from clients));SELECT SETVAL('interface_types_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from interface_types));
SELECT SETVAL('interface_types_fields_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from interface_types_fields));
SELECT SETVAL('interface_types_field_types_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from interface_types_field_types));
SELECT SETVAL('graph_types_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from graph_types));
SELECT SETVAL('alarm_states_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from alarm_states));
SELECT SETVAL('severity_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from severity));
SELECT SETVAL('syslog_types_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from syslog_types));
SELECT SETVAL('trap_receivers_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from trap_receivers));
SELECT SETVAL('types_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from types));
SELECT SETVAL('slas_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from slas));
SELECT SETVAL('slas_cond_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from slas_cond));
SELECT SETVAL('slas_sla_cond_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from slas_sla_cond));
SELECT SETVAL('filters_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from filters));
SELECT SETVAL('filters_fields_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from filters_fields));
SELECT SETVAL('filters_cond_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from filters_cond));
SELECT SETVAL('pollers_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from pollers));
SELECT SETVAL('pollers_groups_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from pollers_groups));
SELECT SETVAL('pollers_backend_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from pollers_backend));
SELECT SETVAL('pollers_poller_groups_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from pollers_poller_groups));
SELECT SETVAL('autodiscovery_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from autodiscovery));
SELECT SETVAL('hosts_config_types_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from hosts_config_types));
SELECT SETVAL('tools_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from tools));
SELECT SETVAL('profiles_options_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from profiles_options));
SELECT SETVAL('actions_id_seq',(select case when max(id)>10000 then max(id) else 10000 end from actions));
SELECT SETVAL('profiles_values_id_seq',(select case when max(id)>299 then max(id) else 299 end from profiles_values));
