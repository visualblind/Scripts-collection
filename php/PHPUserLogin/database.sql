DROP TABLE IF EXISTS `php_users_login`;
CREATE TABLE IF NOT EXISTS `php_users_login` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `content` text,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


INSERT INTO `php_users_login` (`id`,`email`,`password`,`name`,`phone`,`content`) VALUES
(1,'demo1@demo.com','pass','Demo 1', '+0123456789','text content for Demo1 user.'),
(2,'demo2@demo.com','pass','Demo 2', '+9876543210','another text content for Demo2 user');