/* sp_help_revlogin script 
** Generated Dec  2 2012  1:59AM on SVR07PS */

-- Login: NT AUTHORITY\NETWORK SERVICE
CREATE LOGIN [NT AUTHORITY\NETWORK SERVICE] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: sa_dev
CREATE LOGIN [sa_dev] WITH PASSWORD = 0x0100652B8B023737F89996080D23EC8BFB7B1201C3D7C1E9DF66 HASHED, SID = 0xD9B01B2C8E448F478C915827592CAE3F, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: NT AUTHORITY\LOCAL SERVICE
CREATE LOGIN [NT AUTHORITY\LOCAL SERVICE] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: dlewis
CREATE LOGIN [dlewis] WITH PASSWORD = 0x01001CEB2839533AA15551862AE3EF0C70B3EC7D2E9BDDDC50DD HASHED, SID = 0xD40542B8BB86724488F879DF416EEB50, DEFAULT_DATABASE = [master], CHECK_POLICY = ON, CHECK_EXPIRATION = ON
 
-- Login: cbeck
CREATE LOGIN [cbeck] WITH PASSWORD = 0x0100698C3E6A98D34FBC109E3E58312CF6763A3E9E638FC9D772 HASHED, SID = 0x7A75EFA1C1C56F43AC860E0FE6A809CC, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: sritz3
CREATE LOGIN [sritz3] WITH PASSWORD = 0x0100EF04817C43E97DA7A3CFC8C338ABDE2792A5F4A0B27F166E HASHED, SID = 0x478EBFF75E765647B718DE6B001C8E5C, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: SENTRIC\APP_SQLDBA
CREATE LOGIN [SENTRIC\APP_SQLDBA] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: SENTRIC\taskhandler
CREATE LOGIN [SENTRIC\taskhandler] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: SENTRIC\SQLServices
CREATE LOGIN [SENTRIC\SQLServices] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: SENTRIC\cmarszalek
CREATE LOGIN [SENTRIC\cmarszalek] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: pmeyer2
CREATE LOGIN [pmeyer2] WITH PASSWORD = 0x01005815E68245A55E20C1FEBD84217B009A97DD81A1079CEC69 HASHED, SID = 0x596E9DDC21CC7F4BBE3B639F1C0DEF1F, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: DYNSA
CREATE LOGIN [DYNSA] WITH PASSWORD = 0x0100604796FAE9517601159DC3F62B4ED3B6FF862153663FC461 HASHED, SID = 0x428CA58D73A91E43A8845C1B58F64674, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: odyssey
CREATE LOGIN [odyssey] WITH PASSWORD = 0x010038B522F6B3B4EA42A6DE6A2EE6C06953EF78BFFFF378B306 HASHED, SID = 0xB2A26792E4A43045819CA09AAF92C0A1, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: sa_gp
CREATE LOGIN [sa_gp] WITH PASSWORD = 0x01005115A1EC7B2CB1DB1F1EEE9249D49ED9BE9186A61265719A HASHED, SID = 0xDD6B409485562C4290A167E44590A6C1, DEFAULT_DATABASE = [master], CHECK_POLICY = ON, CHECK_EXPIRATION = ON
 
-- Login: SENTRIC\adminjl
CREATE LOGIN [SENTRIC\adminjl] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: SENTRIC\jsmith
CREATE LOGIN [SENTRIC\jsmith] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
 
-- Login: Millennium
CREATE LOGIN [Millennium] WITH PASSWORD = 0x01004C447EC2B1B627B7B25643E9E57D216B6990F14BEE2BE4A4 HASHED, SID = 0x9EF2A50E918AAB4D967CEE7C471E1D02, DEFAULT_DATABASE = [Millennium], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: mmaggs
CREATE LOGIN [mmaggs] WITH PASSWORD = 0x0100FD17DC904630F40F210B3E84F3AF51E30236A01BF7744310 HASHED, SID = 0xA2C0A5ABA300EC439AC9C6169BCCA401, DEFAULT_DATABASE = [Millennium], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: App_FedexUser
CREATE LOGIN [App_FedexUser] WITH PASSWORD = 0x0100B7FBE8A4B5CDD4F8BD88B6DE27CAD07E288B483A56DD66E8 HASHED, SID = 0x286DB2507E7AAA47B3356A8511B9AC2A, DEFAULT_DATABASE = [Millennium], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: APP_AMS
CREATE LOGIN [APP_AMS] WITH PASSWORD = 0x0100E6972A84DD12B58CD1248BE9875B520F1DCBCB77E11617DA HASHED, SID = 0xA19E8110B050754E947D0228730A6159, DEFAULT_DATABASE = [Millennium], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
 
-- Login: SENTRIC\App_SQLViewOnly
CREATE LOGIN [SENTRIC\App_SQLViewOnly] FROM WINDOWS WITH DEFAULT_DATABASE = [Millennium]
 
-- Login: sritz4
CREATE LOGIN [sritz4] WITH PASSWORD = 0x010081C3AF71A058EFB0D4D32B8FCB1540CE2A24C7DC11F7274A HASHED, SID = 0x00AD5721332F6C4B93619B4943932BBE, DEFAULT_DATABASE = [master], CHECK_POLICY = ON, CHECK_EXPIRATION = ON
