-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.33 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for ngsi-lt-core
CREATE DATABASE IF NOT EXISTS `ngsi-lt-core` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ngsi-lt-core`;

-- Dumping structure for table ngsi-lt-core.chat_role
CREATE TABLE IF NOT EXISTS `chat_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_role` varchar(50) DEFAULT NULL,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.chat_role: ~3 rows (approximately)
/*!40000 ALTER TABLE `chat_role` DISABLE KEYS */;
INSERT INTO `chat_role` (`id`, `chat_role`, `date_created`) VALUES
	(1, 'admin', '2023-07-17 16:43:49'),
	(2, 'csr', '2023-07-17 16:43:54'),
	(3, 'member', '2023-07-17 16:44:03');
/*!40000 ALTER TABLE `chat_role` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.messages
CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `room_id` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message_type_id` int(11) DEFAULT NULL,
  `message` text,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `message_type` (`message_type_id`) USING BTREE,
  KEY `room_id` (`room_id`) USING BTREE,
  CONSTRAINT `FK_messages_message_type` FOREIGN KEY (`message_type_id`) REFERENCES `message_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_messages_rooms` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`),
  CONSTRAINT `FK_messages_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.messages: ~10 rows (approximately)
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` (`id`, `state`, `room_id`, `user_id`, `message_type_id`, `message`, `date_created`) VALUES
	(4, 'ACTIVE', '64e47c14e847164e47c14e847264e47c14e8473', 11, 1, 'Hi po, may I ask what is your username?', '2023-08-22 17:13:27'),
	(5, 'ACTIVE', '64e47c14e847164e47c14e847264e47c14e8473', 13, 1, 'mevabe', '2023-08-22 17:13:33'),
	(6, 'ACTIVE', '64e47c14e847164e47c14e847264e47c14e8473', 11, 1, 'okay, will approve your account in a second.', '2023-08-22 17:13:46'),
	(7, 'ACTIVE', '266ce6c66c465551ce21c5466d56662e642c666', 2, 1, 'Hi Sir', '2023-09-27 20:58:47'),
	(8, 'ACTIVE', '266ce6c66c465551ce21c5466d56662e642c666', 15, 1, 'Hello po', '2023-09-27 20:58:52'),
	(9, 'ACTIVE', '266ce6c66c465551ce21c5466d56662e642c666', 2, 1, 'What is your favorite billiards-related item that you own?', '2023-09-27 20:58:58'),
	(10, 'ACTIVE', '266ce6c66c465551ce21c5466d56662e642c666', 15, 1, 'Quamofficiaessedo', '2023-09-27 20:59:03'),
	(11, 'ACTIVE', '266ce6c66c465551ce21c5466d56662e642c666', 2, 1, 'Ok sir, login nalang po kayo. Approve ko na\'po account ninyo.', '2023-09-27 20:59:25'),
	(12, 'ACTIVE', '652500d22152b05514645bdd2bb257dd11d5b5b', 11, 1, 'Hi sir, what is your email address po?', '2023-10-04 16:20:56'),
	(13, 'ACTIVE', '652500d22152b05514645bdd2bb257dd11d5b5b', 16, 1, 'qweqwe@seqeqwe.com', '2023-10-04 16:21:04'),
	(14, 'ACTIVE', '652500d22152b05514645bdd2bb257dd11d5b5b', 11, 1, 'Okay sir will accept your account', '2023-10-04 16:21:14');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.message_type
CREATE TABLE IF NOT EXISTS `message_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `message_type` varchar(50) DEFAULT NULL,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.message_type: ~2 rows (approximately)
/*!40000 ALTER TABLE `message_type` DISABLE KEYS */;
INSERT INTO `message_type` (`id`, `state`, `message_type`, `date_created`) VALUES
	(1, 'ACTIVE', 'text', '2023-07-18 09:20:17'),
	(2, 'ACTIVE', 'image', '2023-07-18 09:20:21');
/*!40000 ALTER TABLE `message_type` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.rooms
CREATE TABLE IF NOT EXISTS `rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` varchar(255) DEFAULT NULL,
  `state` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_by` int(11) DEFAULT NULL COMMENT 'csr user id',
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_rooms_users` (`created_by`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `FK_rooms_users` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.rooms: ~0 rows (approximately)
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` (`id`, `room_id`, `state`, `created_by`, `date_created`) VALUES
	(2, '64e47c14e847164e47c14e847264e47c14e8473', 'ACTIVE', 11, '2023-08-22 17:12:52'),
	(3, '651161e0c6516651161e0c6517651161e0c6518', 'ACTIVE', 2, '2023-09-25 18:33:04'),
	(4, '266ce6c66c465551ce21c5466d56662e642c666', 'ACTIVE', 2, '2023-09-27 20:58:14'),
	(5, '652500d22152b05514645bdd2bb257dd11d5b5b', 'ACTIVE', 11, '2023-10-04 16:20:33');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.rooms_mapping
CREATE TABLE IF NOT EXISTS `rooms_mapping` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `room_id` varchar(255) DEFAULT NULL,
  `chat_role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `invited_by` int(11) DEFAULT NULL,
  `date_joined` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `room_id` (`room_id`),
  KEY `chat_role_id` (`chat_role_id`),
  KEY `user_id` (`user_id`),
  KEY `invited_by` (`invited_by`),
  CONSTRAINT `FK_rooms_mapping_chat_role` FOREIGN KEY (`chat_role_id`) REFERENCES `chat_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_rooms_mapping_rooms` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_rooms_mapping_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_rooms_mapping_users_2` FOREIGN KEY (`invited_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.rooms_mapping: ~8 rows (approximately)
/*!40000 ALTER TABLE `rooms_mapping` DISABLE KEYS */;
INSERT INTO `rooms_mapping` (`id`, `state`, `room_id`, `chat_role_id`, `user_id`, `invited_by`, `date_joined`) VALUES
	(3, 'ACTIVE', '64e47c14e847164e47c14e847264e47c14e8473', 2, 11, 11, '2023-08-22 17:12:52'),
	(4, 'ACTIVE', '64e47c14e847164e47c14e847264e47c14e8473', 3, 13, 11, '2023-08-22 17:12:52'),
	(5, 'ACTIVE', '651161e0c6516651161e0c6517651161e0c6518', 2, 2, 2, '2023-09-25 18:33:04'),
	(6, 'ACTIVE', '651161e0c6516651161e0c6517651161e0c6518', 3, 14, 2, '2023-09-25 18:33:04'),
	(7, 'ACTIVE', '266ce6c66c465551ce21c5466d56662e642c666', 2, 2, 2, '2023-09-27 20:58:14'),
	(8, 'ACTIVE', '266ce6c66c465551ce21c5466d56662e642c666', 3, 15, 2, '2023-09-27 20:58:14'),
	(9, 'ACTIVE', '652500d22152b05514645bdd2bb257dd11d5b5b', 2, 11, 11, '2023-10-04 16:20:33'),
	(10, 'ACTIVE', '652500d22152b05514645bdd2bb257dd11d5b5b', 3, 16, 11, '2023-10-04 16:20:33');
/*!40000 ALTER TABLE `rooms_mapping` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_type_id` int(11) NOT NULL DEFAULT '1',
  `approved_by` int(11) DEFAULT '0',
  `state` enum('ACTIVE','INACTIVE','DECLINED') DEFAULT 'INACTIVE',
  `first_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `mobile_number` varchar(50) DEFAULT NULL,
  `permanent_address` text,
  `birth_date` datetime DEFAULT NULL,
  `place_of_birth` text,
  `nationality` varchar(50) DEFAULT NULL,
  `nature_of_work` varchar(50) DEFAULT NULL,
  `source_of_income` enum('Employed','Self-Employed','Business') DEFAULT NULL,
  `facebook_link` text,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `email_address` text,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_type_id` (`user_type_id`),
  KEY `approved_by` (`approved_by`),
  CONSTRAINT `FK_users_user_type` FOREIGN KEY (`user_type_id`) REFERENCES `user_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.users: ~13 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `user_type_id`, `approved_by`, `state`, `first_name`, `middle_name`, `last_name`, `mobile_number`, `permanent_address`, `birth_date`, `place_of_birth`, `nationality`, `nature_of_work`, `source_of_income`, `facebook_link`, `username`, `password`, `email_address`, `date_created`) VALUES
	(1, 3, 1, 'ACTIVE', 'admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '123456', NULL, '2023-07-20 17:24:49'),
	(2, 2, 1, 'ACTIVE', 'csr1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr1', '123456', NULL, '2023-07-20 17:25:03'),
	(3, 2, 1, 'ACTIVE', 'csr2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr2', '123456', NULL, '2023-07-20 17:25:03'),
	(4, 2, 1, 'ACTIVE', 'csr3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr3', '123456', NULL, '2023-07-20 17:25:03'),
	(5, 2, 1, 'ACTIVE', 'csr4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr4', '123456', NULL, '2023-07-20 17:25:03'),
	(6, 2, 1, 'ACTIVE', 'csr5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr5', '123456', NULL, '2023-07-20 17:25:03'),
	(7, 2, 1, 'ACTIVE', 'csr6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr6', '123456', NULL, '2023-07-20 17:25:03'),
	(8, 2, 1, 'ACTIVE', 'csr7', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr7', '123456', NULL, '2023-07-20 17:25:03'),
	(9, 2, 1, 'ACTIVE', 'csr8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr8', '123456', NULL, '2023-07-20 17:25:03'),
	(10, 2, 1, 'ACTIVE', 'csr9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr9', '123456', NULL, '2023-07-20 17:25:03'),
	(11, 2, 1, 'ACTIVE', 'csr10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csr10', '123456', NULL, '2023-07-20 17:25:03'),
	(13, 1, 11, 'ACTIVE', 'Sonya', 'KarynKirby', 'Henry', '09091231231', 'Qui unde animi duci', '2002-08-01 00:00:00', 'Duis sunt cupiditate', 'Eosesseofficiaet', 'Corporisvoluptates', 'Employed', 'https://facebook.com/RyanJames', 'mevabe', '123456', 'biwu@mailinator.com', '2023-08-22 17:12:27'),
	(14, 1, 0, 'ACTIVE', 'Asher', 'JocelynGibson', 'Roberts', '09999999999', 'Irure deserunt obcae', '2002-09-03 00:00:00', 'Veritatis mollitia v', 'Erroreteosnostru', 'Laboriosamlaborios', 'Employed', '', 'ximavyze', '123456', 'pygivyqe@mailinator.com', '2023-09-25 18:03:45'),
	(15, 1, 2, 'ACTIVE', 'Lionel', 'JeromeCastaneda', 'Roy', '09999999991', 'Dignissimos repellen', '2002-09-10 00:00:00', 'Enim aut commodo nih', 'Doloremolestiasvol', 'Errorvoluptatesbla', 'Employed', '', 'bubyro', '123456', 'vixifa@mailinator.com', '2023-09-27 20:35:51'),
	(16, 1, 11, 'ACTIVE', 'fsdf', 'sdfsdf', 'sdfsd', '09453453453', 'sdfsdf', '2002-10-03 00:00:00', '123123123', 'asfsdf', 'sdfsdfsdf', 'Employed', '', 'mangboy123', '123qweasd!', 'qweqwe@seqeqwe.com', '2023-10-04 16:19:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.user_payment_accounts
CREATE TABLE IF NOT EXISTS `user_payment_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type_of_payment` varchar(255) DEFAULT NULL,
  `account_number` varchar(255) DEFAULT NULL,
  `account_name` varchar(255) DEFAULT NULL,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `FK_user_payment_accounts_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.user_payment_accounts: ~2 rows (approximately)
/*!40000 ALTER TABLE `user_payment_accounts` DISABLE KEYS */;
INSERT INTO `user_payment_accounts` (`id`, `user_id`, `type_of_payment`, `account_number`, `account_name`, `date_created`) VALUES
	(3, 13, 'LBC', '117', 'LeeStrickland', '2023-08-22 17:12:27'),
	(4, 14, 'Robinsons Bank Corp.', '742', 'TarikPearson', '2023-09-25 18:03:45'),
	(5, 15, 'Camalig Bank (A Rural Bank), Inc', '463', 'RachelJimenez', '2023-09-27 20:35:51'),
	(6, 16, 'Banco Laguna (A Rural Bank), Inc', 'qweqwe', 'qweqweqwe', '2023-10-04 16:19:25');
/*!40000 ALTER TABLE `user_payment_accounts` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.user_secret_question
CREATE TABLE IF NOT EXISTS `user_secret_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `secret_question` text,
  `secret_answer` text,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`),
  CONSTRAINT `FK_user_secret_question_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.user_secret_question: ~2 rows (approximately)
/*!40000 ALTER TABLE `user_secret_question` DISABLE KEYS */;
INSERT INTO `user_secret_question` (`id`, `user_id`, `secret_question`, `secret_answer`, `date_created`) VALUES
	(3, 13, 'What is the name of the billiards commentator or analyst you enjoy listening to the most?', 'Consequuntursintad', '2023-08-22 17:12:27'),
	(4, 14, 'What is the most difficult billiards shot you\\\'ve ever seen made?', 'Eoseosquisquamid', '2023-09-25 18:03:45'),
	(5, 15, 'What is your favorite billiards-related item that you own?', 'Quamofficiaessedo', '2023-09-27 20:35:51'),
	(6, 16, 'Who is your favorite billiards player and why?', 'hjkdhfgjsdhfk', '2023-10-04 16:19:25');
/*!40000 ALTER TABLE `user_secret_question` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.user_type
CREATE TABLE IF NOT EXISTS `user_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_type` varchar(50) DEFAULT NULL,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.user_type: ~3 rows (approximately)
/*!40000 ALTER TABLE `user_type` DISABLE KEYS */;
INSERT INTO `user_type` (`id`, `user_type`, `date_created`) VALUES
	(1, 'player', '2023-07-17 16:38:17'),
	(2, 'csr', '2023-07-17 16:38:41'),
	(3, 'admin', '2023-07-17 16:38:46');
/*!40000 ALTER TABLE `user_type` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.user_uploads
CREATE TABLE IF NOT EXISTS `user_uploads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `id_code` varchar(50) DEFAULT NULL,
  `file_name` text,
  `file_extension` varchar(50) DEFAULT NULL,
  `file_path` text,
  `remarks` text,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`),
  KEY `id_code` (`id_code`),
  CONSTRAINT `FK_user_uploads_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_user_uploads_valid_ids` FOREIGN KEY (`id_code`) REFERENCES `valid_ids` (`id_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.user_uploads: ~2 rows (approximately)
/*!40000 ALTER TABLE `user_uploads` DISABLE KEYS */;
INSERT INTO `user_uploads` (`id`, `user_id`, `id_code`, `file_name`, `file_extension`, `file_path`, `remarks`, `date_created`) VALUES
	(3, 13, 'nbi-clearance', 'NBI Clearance *', 'png', 'http://ngsi-luckytaya-registration.test/assets/uploads/user_valid_ids/64e47bfa94be5_64e47bfa94be6_64e47bfa94be7.png', 'User Valid ID Upload', '2023-08-22 17:12:27'),
	(4, 14, 'prc-id', 'Professional Regulation Commission (PRC) ID *', 'jpg', 'http://lt-core-front-end.test/assets/uploads/user_valid_ids/65115b0105467_65115b0105469_65115b010546a.jpg', 'User Valid ID Upload', '2023-09-25 18:03:45'),
	(5, 15, 'prc-id', 'Professional Regulation Commission (PRC) ID *', 'png', 'http://lt-core-front-end.test/assets/uploads/user_valid_ids/651421a7cc9fe_651421a7cc9ff_651421a7cca00.png', 'User Valid ID Upload', '2023-09-27 20:35:51'),
	(6, 16, 'barangay-id', 'Barangay ID *', 'png', 'http://ngsi-lt-core-front-end.test/assets/uploads/user_valid_ids/651d200da51bf_651d200da51c0_651d200da51c1.png', 'User Valid ID Upload', '2023-10-04 16:19:25');
/*!40000 ALTER TABLE `user_uploads` ENABLE KEYS */;

-- Dumping structure for table ngsi-lt-core.valid_ids
CREATE TABLE IF NOT EXISTS `valid_ids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_code` varchar(50) DEFAULT NULL,
  `id_name` text,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_code` (`id_code`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ngsi-lt-core.valid_ids: ~25 rows (approximately)
/*!40000 ALTER TABLE `valid_ids` DISABLE KEYS */;
INSERT INTO `valid_ids` (`id`, `id_code`, `id_name`, `date_created`) VALUES
	(1, '4ps-id', '4Ps / Pantawid Pamilya Pilipino Program ID *', '2023-07-18 06:10:38'),
	(2, 'afp-beneficiary-id', 'AFP Beneficiary ID', '2023-07-18 06:10:38'),
	(3, 'afpslai-id', 'AFPSLAI ID *', '2023-07-18 06:10:38'),
	(4, 'barangay-id', 'Barangay ID *', '2023-07-18 06:10:38'),
	(5, 'bir', 'BIR (TIN)', '2023-07-18 06:10:38'),
	(6, 'comelec-id', 'COMELEC / Voter’s ID / COMELEC Registration Form', '2023-07-18 06:10:38'),
	(7, 'drivers-license', 'Driver’s License*', '2023-07-18 06:10:38'),
	(8, 'e-card', 'e-Card / UMID', '2023-07-18 06:10:38'),
	(9, 'employee-id', 'Employee’s ID / Office Id', '2023-07-18 06:10:38'),
	(10, 'firearms-license', 'Firearms License *', '2023-07-18 06:10:38'),
	(11, 'ibp-id', 'Integrated Bar of the Philippines (IBP) ID', '2023-07-18 06:10:38'),
	(12, 'nat-id', 'National ID', '2023-07-18 06:10:38'),
	(13, 'nbi-clearance', 'NBI Clearance *', '2023-07-18 06:10:38'),
	(14, 'pag-ibig-id', 'Pag-ibig ID', '2023-07-18 06:10:38'),
	(15, 'passport', 'Passport *', '2023-07-18 06:10:38'),
	(16, 'phil-id', 'Philippine Identification (PhilID / ePhilID)', '2023-07-18 06:10:38'),
	(17, 'philhealth-id', 'Phil-health ID', '2023-07-18 06:10:38'),
	(18, 'postal-id', 'Philippine Postal ID *', '2023-07-18 06:10:38'),
	(19, 'prc-id', 'Professional Regulation Commission (PRC) ID *', '2023-07-18 06:10:38'),
	(20, 'pvao-id', 'PVAO ID', '2023-07-18 06:10:38'),
	(21, 'pwd-id', 'Person’s With Disability (PWD) ID', '2023-07-18 06:10:38'),
	(22, 'school-id', 'School ID **', '2023-07-18 06:10:38'),
	(23, 'senior-citizen-id', 'Senior Citizen ID', '2023-07-18 06:10:38'),
	(24, 'sss-id', 'SSS ID', '2023-07-18 06:10:38'),
	(25, 'other', 'Other valid government-issued IDs or Documents with picture and signature', '2023-07-18 06:10:38');
/*!40000 ALTER TABLE `valid_ids` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
