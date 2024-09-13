-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: iis
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--
USE iis;

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add player',7,'add_player'),(26,'Can change player',7,'change_player'),(27,'Can delete player',7,'delete_player'),(28,'Can view player',7,'view_player'),(29,'Can add team',8,'add_team'),(30,'Can change team',8,'change_team'),(31,'Can delete team',8,'delete_team'),(32,'Can view team',8,'view_team'),(33,'Can add tournament',9,'add_tournament'),(34,'Can change tournament',9,'change_tournament'),(35,'Can delete tournament',9,'delete_tournament'),(36,'Can view tournament',9,'view_tournament'),(37,'Can add match',10,'add_match'),(38,'Can change match',10,'change_match'),(39,'Can delete match',10,'delete_match'),(40,'Can view match',10,'view_match');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$390000$rKNpMHpRVwpIHTUCj88jWx$Z97E0E7wox4btr0eH2pgfMjWqmvuFM2vJBbZXGy8Xrs=','2022-11-28 15:35:47.332041',1,'xadmin00','','','',1,1,'2022-11-28 02:14:03.153149'),(2,'pbkdf2_sha256$390000$2WK6hosiuXiWi7kw7Kv36N$fORzmIbdSZjAGht261RC8g8vyhB5S9lh0rvfyqsYw4E=','2022-11-28 14:05:54.066381',0,'user123','','','',0,1,'2022-11-28 02:15:37.482566'),(3,'pbkdf2_sha256$390000$CKTrRLcUFHYHSdQwSdcGLR$y4qemwRYpcCHCz9UsnVjA85WgY1aMR3bg/8YbJH4Z3s=','2022-11-28 15:43:50.322141',0,'user2','','','',0,1,'2022-11-28 02:16:11.804028'),(4,'pbkdf2_sha256$390000$OYiE2nKbreNXKVpGgMnDGP$QcM4Y95LHVXwX3ORFUCxj0Vq4xrEizDTiBuvfrli7T4=','2022-11-28 14:10:01.892703',0,'user3','','','',0,1,'2022-11-28 02:16:20.170108'),(5,'pbkdf2_sha256$390000$TI1PVAyCTZxcveiJJk9ZHw$St3jyOx+yiV37EQVaBDMNz4ectgBcxRaDeot8xv52j8=','2022-11-28 15:43:58.496519',0,'user4','','','',0,1,'2022-11-28 02:16:27.703896'),(6,'pbkdf2_sha256$390000$nD2QvqkZXyCUBWgD5zDIw1$6fVGmEIuh/dTw+2ALVf39pF8/Kn5yPTyj8PObmWE1u0=','2022-11-28 02:36:00.013515',0,'user5','','','',0,1,'2022-11-28 02:16:36.855618'),(7,'pbkdf2_sha256$390000$91E0Cfin7vWa3AqkuCKBqn$bo2tmQeEg+WiIlDjJozuYodk4PrDblGe7C4uMIRlQqA=','2022-11-28 15:44:09.533495',0,'user6','','','',0,1,'2022-11-28 02:26:43.361635'),(8,'pbkdf2_sha256$390000$uS0l4q8Op9mzaACD630QLE$EgBIV65zwFyn8mv9aqhmUHNkS1GAeJ97z46/uqtErnY=','2022-11-28 18:00:18.041682',0,'tournament_creator','','','',0,1,'2022-11-28 14:02:24.420294'),(9,'pbkdf2_sha256$390000$iLFU2uQH740XmHqRI28NG1$gZydPgRUZPgFhZDOp26J6vkaMdNGsekJQ9Pg94ykMM0=','2022-11-28 15:08:29.856090',0,'user7','','','',0,1,'2022-11-28 15:08:29.758568'),(10,'pbkdf2_sha256$390000$zP0pGU0WWeVnHJIcxny6RN$wUInqVQy9xB5zQ8qut41ma1vCErpn0Uvri4fRMvSEBQ=','2022-11-28 18:02:08.850777',0,'team_creator','','','',0,1,'2022-11-28 15:23:30.590232');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_match`
--

DROP TABLE IF EXISTS `base_match`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_match` (
  `id_match` int NOT NULL AUTO_INCREMENT,
  `tournament_id` int DEFAULT NULL,
  `ordinal_number` int DEFAULT NULL,
  `team_first_id` bigint DEFAULT NULL,
  `team_second_id` bigint DEFAULT NULL,
  `player_first_id` bigint DEFAULT NULL,
  `player_second_id` bigint DEFAULT NULL,
  `match_date` date DEFAULT NULL,
  `match_time` time(6) DEFAULT NULL,
  `score_first` int DEFAULT NULL,
  `score_second` int DEFAULT NULL,
  `winner_team_id` bigint DEFAULT NULL,
  `winner_player_id` bigint DEFAULT NULL,
  `loser_team_id` bigint DEFAULT NULL,
  `loser_player_id` bigint DEFAULT NULL,
  `status` varchar(8) NOT NULL,
  PRIMARY KEY (`id_match`),
  KEY `base_match_tournament_id_1f7fa47b_fk_base_tour` (`tournament_id`),
  KEY `base_match_team_first_id_208f694e_fk_base_team_id` (`team_first_id`),
  KEY `base_match_team_second_id_f0e08647_fk_base_team_id` (`team_second_id`),
  KEY `base_match_player_first_id_1da880e7_fk_base_player_id` (`player_first_id`),
  KEY `base_match_player_second_id_36c04f66_fk_base_player_id` (`player_second_id`),
  KEY `base_match_winner_team_id_8cafbe0c_fk_base_team_id` (`winner_team_id`),
  KEY `base_match_winner_player_id_507fac99_fk_base_player_id` (`winner_player_id`),
  KEY `base_match_loser_team_id_8201811c_fk_base_team_id` (`loser_team_id`),
  KEY `base_match_loser_player_id_e9001663_fk_base_player_id` (`loser_player_id`),
  CONSTRAINT `base_match_loser_player_id_e9001663_fk_base_player_id` FOREIGN KEY (`loser_player_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_match_loser_team_id_8201811c_fk_base_team_id` FOREIGN KEY (`loser_team_id`) REFERENCES `base_team` (`id`),
  CONSTRAINT `base_match_player_first_id_1da880e7_fk_base_player_id` FOREIGN KEY (`player_first_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_match_player_second_id_36c04f66_fk_base_player_id` FOREIGN KEY (`player_second_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_match_team_first_id_208f694e_fk_base_team_id` FOREIGN KEY (`team_first_id`) REFERENCES `base_team` (`id`),
  CONSTRAINT `base_match_team_second_id_f0e08647_fk_base_team_id` FOREIGN KEY (`team_second_id`) REFERENCES `base_team` (`id`),
  CONSTRAINT `base_match_tournament_id_1f7fa47b_fk_base_tour` FOREIGN KEY (`tournament_id`) REFERENCES `base_tournament` (`id_tournament`),
  CONSTRAINT `base_match_winner_player_id_507fac99_fk_base_player_id` FOREIGN KEY (`winner_player_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_match_winner_team_id_8cafbe0c_fk_base_team_id` FOREIGN KEY (`winner_team_id`) REFERENCES `base_team` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_match`
--

LOCK TABLES `base_match` WRITE;
/*!40000 ALTER TABLE `base_match` DISABLE KEYS */;
INSERT INTO `base_match` VALUES (1,1,1,NULL,NULL,1,3,'2022-11-28','09:15:00.000000',0,1,NULL,3,NULL,1,'finished'),(2,1,2,NULL,NULL,2,4,'2022-11-28','09:15:00.000000',1,0,NULL,2,NULL,4,'finished'),(3,1,3,NULL,NULL,3,2,'2022-11-28','10:00:00.000000',1,0,NULL,3,NULL,2,'finished'),(4,2,1,3,2,NULL,NULL,'2022-11-28','09:15:00.000000',2,1,3,NULL,2,NULL,'finished'),(5,2,2,4,1,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'pending'),(6,2,3,3,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'pending');
/*!40000 ALTER TABLE `base_match` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_player`
--

DROP TABLE IF EXISTS `base_player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_player` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `login` varchar(30) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `surname` varchar(20) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `height` varchar(3) DEFAULT NULL,
  `weight` varchar(3) DEFAULT NULL,
  `studies_year` varchar(1) DEFAULT NULL,
  `wins` int NOT NULL,
  `losses` int NOT NULL,
  `role` varchar(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_player`
--

LOCK TABLES `base_player` WRITE;
/*!40000 ALTER TABLE `base_player` DISABLE KEYS */;
INSERT INTO `base_player` VALUES (1,'user123','Nameuser1','Surnameuser1','1997-08-07','user1@posta.cz','162','45','3',0,1,'r'),(2,'user2','Nameuser2','Surnameuser2','2000-06-03','user2@icloud.com','185','80','3',1,1,'r'),(3,'user3','Nameuser3','Surnameuser3','1992-02-04','','190','90','1',2,0,'r'),(4,'user4','Nameuser4','Surnameuser4','2001-03-03','user4@google.com','170','67','2',0,1,'r'),(5,'user5','','',NULL,'user5@yahoo.com',NULL,NULL,'2',0,0,'r'),(6,'user6','Nameuser6','',NULL,'',NULL,NULL,NULL,0,0,'r'),(7,'tournament_creator',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'r'),(8,'user7','Nameuser7','Surnameuser7','2000-09-26','email@email.com',NULL,NULL,'1',0,0,'r'),(9,'team_creator','Namecreator','Surnamecreator','1999-02-07','vlad.ren@icloud.com','186','80','3',0,0,'r');
/*!40000 ALTER TABLE `base_player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_player_tournament_approved_list`
--

DROP TABLE IF EXISTS `base_player_tournament_approved_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_player_tournament_approved_list` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `player_id` bigint NOT NULL,
  `tournament_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `base_player_tournament_a_player_id_tournament_id_27739b92_uniq` (`player_id`,`tournament_id`),
  KEY `base_player_tourname_tournament_id_8399581b_fk_base_tour` (`tournament_id`),
  CONSTRAINT `base_player_tourname_player_id_f68b947f_fk_base_play` FOREIGN KEY (`player_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_player_tourname_tournament_id_8399581b_fk_base_tour` FOREIGN KEY (`tournament_id`) REFERENCES `base_tournament` (`id_tournament`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_player_tournament_approved_list`
--

LOCK TABLES `base_player_tournament_approved_list` WRITE;
/*!40000 ALTER TABLE `base_player_tournament_approved_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `base_player_tournament_approved_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_team`
--

DROP TABLE IF EXISTS `base_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_team` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `team_name` varchar(50) NOT NULL,
  `team_captain_id` bigint DEFAULT NULL,
  `logo_image` varchar(100) DEFAULT NULL,
  `wins` int NOT NULL,
  `losses` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `team_name` (`team_name`),
  KEY `base_team_team_captain_id_1569584b_fk_base_player_id` (`team_captain_id`),
  CONSTRAINT `base_team_team_captain_id_1569584b_fk_base_player_id` FOREIGN KEY (`team_captain_id`) REFERENCES `base_player` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_team`
--

LOCK TABLES `base_team` WRITE;
/*!40000 ALTER TABLE `base_team` DISABLE KEYS */;
INSERT INTO `base_team` VALUES (1,'Team1',2,'images/1643230514_12-abrakadabra-fun-p-logo-dlya-kibersportivnoi-komandi-26.png',0,0),(2,'Team2',4,'images/Flag_of_the_Czech_Republic.svg.webp',0,1),(3,'Team3',6,'images/16.webp',1,0),(4,'Team4',9,'images/61f7b493befec_173x173_TeRbYb2.png',0,0);
/*!40000 ALTER TABLE `base_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_team_team_members`
--

DROP TABLE IF EXISTS `base_team_team_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_team_team_members` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `team_id` bigint NOT NULL,
  `player_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `base_team_team_members_team_id_player_id_63f1813a_uniq` (`team_id`,`player_id`),
  KEY `base_team_team_members_player_id_1b9c24c7_fk_base_player_id` (`player_id`),
  CONSTRAINT `base_team_team_members_player_id_1b9c24c7_fk_base_player_id` FOREIGN KEY (`player_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_team_team_members_team_id_4aec4433_fk_base_team_id` FOREIGN KEY (`team_id`) REFERENCES `base_team` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_team_team_members`
--

LOCK TABLES `base_team_team_members` WRITE;
/*!40000 ALTER TABLE `base_team_team_members` DISABLE KEYS */;
INSERT INTO `base_team_team_members` VALUES (1,1,1),(2,1,2),(3,2,3),(4,2,4),(5,3,5),(6,3,6),(7,4,8),(8,4,9);
/*!40000 ALTER TABLE `base_team_team_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_team_tournament_approved_list`
--

DROP TABLE IF EXISTS `base_team_tournament_approved_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_team_tournament_approved_list` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `team_id` bigint NOT NULL,
  `tournament_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `base_team_tournament_app_team_id_tournament_id_aae17975_uniq` (`team_id`,`tournament_id`),
  KEY `base_team_tournament_tournament_id_19143f78_fk_base_tour` (`tournament_id`),
  CONSTRAINT `base_team_tournament_team_id_bc7e0d0e_fk_base_team` FOREIGN KEY (`team_id`) REFERENCES `base_team` (`id`),
  CONSTRAINT `base_team_tournament_tournament_id_19143f78_fk_base_tour` FOREIGN KEY (`tournament_id`) REFERENCES `base_tournament` (`id_tournament`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_team_tournament_approved_list`
--

LOCK TABLES `base_team_tournament_approved_list` WRITE;
/*!40000 ALTER TABLE `base_team_tournament_approved_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `base_team_tournament_approved_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_tournament`
--

DROP TABLE IF EXISTS `base_tournament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_tournament` (
  `id_tournament` int NOT NULL AUTO_INCREMENT,
  `tournament_name` varchar(100) NOT NULL,
  `tournament_date_registration` date DEFAULT NULL,
  `tournament_date_start` date DEFAULT NULL,
  `tournament_date_end` date DEFAULT NULL,
  `tournament_description` longtext,
  `tournament_prize` varchar(100) DEFAULT NULL,
  `tournament_winner_team_id` bigint DEFAULT NULL,
  `tournament_winner_player_id` bigint DEFAULT NULL,
  `tournament_creator_id` bigint DEFAULT NULL,
  `tournament_type` varchar(7) NOT NULL,
  `tournament_number_of_teams` int DEFAULT NULL,
  `tournament_number_of_players_in_team` int DEFAULT NULL,
  `tournament_number_of_players` int DEFAULT NULL,
  `tournament_approved` tinyint(1) NOT NULL,
  `tournament_status` varchar(12) NOT NULL,
  PRIMARY KEY (`id_tournament`),
  KEY `base_tournament_tournament_winner_te_429d3107_fk_base_team` (`tournament_winner_team_id`),
  KEY `base_tournament_tournament_winner_pl_8b13db94_fk_base_play` (`tournament_winner_player_id`),
  KEY `base_tournament_tournament_creator_id_5dd92080_fk_base_player_id` (`tournament_creator_id`),
  CONSTRAINT `base_tournament_tournament_creator_id_5dd92080_fk_base_player_id` FOREIGN KEY (`tournament_creator_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_tournament_tournament_winner_pl_8b13db94_fk_base_play` FOREIGN KEY (`tournament_winner_player_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_tournament_tournament_winner_te_429d3107_fk_base_team` FOREIGN KEY (`tournament_winner_team_id`) REFERENCES `base_team` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_tournament`
--

LOCK TABLES `base_tournament` WRITE;
/*!40000 ALTER TABLE `base_tournament` DISABLE KEYS */;
INSERT INTO `base_tournament` VALUES (1,'players VS players','2022-11-28','2022-11-28','2022-11-28','The chess tournament will start at 9:00 at Božetěchova 1','Ice hockey ticket',NULL,3,7,'players',NULL,NULL,4,1,'finished'),(2,'teams VS teams','2022-11-28','2022-11-28','2022-11-28','I can write a lot of descriptions of the tournament, but it\'s better to come and see this great competition!','plus 1 point to the IIS project',NULL,NULL,7,'teams',4,2,NULL,1,'scheduled');
/*!40000 ALTER TABLE `base_tournament` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_tournament_tournament_players`
--

DROP TABLE IF EXISTS `base_tournament_tournament_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_tournament_tournament_players` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tournament_id` int NOT NULL,
  `player_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `base_tournament_tourname_tournament_id_player_id_77729f57_uniq` (`tournament_id`,`player_id`),
  KEY `base_tournament_tour_player_id_76829447_fk_base_play` (`player_id`),
  CONSTRAINT `base_tournament_tour_player_id_76829447_fk_base_play` FOREIGN KEY (`player_id`) REFERENCES `base_player` (`id`),
  CONSTRAINT `base_tournament_tour_tournament_id_df09bb35_fk_base_tour` FOREIGN KEY (`tournament_id`) REFERENCES `base_tournament` (`id_tournament`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_tournament_tournament_players`
--

LOCK TABLES `base_tournament_tournament_players` WRITE;
/*!40000 ALTER TABLE `base_tournament_tournament_players` DISABLE KEYS */;
INSERT INTO `base_tournament_tournament_players` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4);
/*!40000 ALTER TABLE `base_tournament_tournament_players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_tournament_tournament_teams`
--

DROP TABLE IF EXISTS `base_tournament_tournament_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_tournament_tournament_teams` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tournament_id` int NOT NULL,
  `team_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `base_tournament_tourname_tournament_id_team_id_b42ab5e4_uniq` (`tournament_id`,`team_id`),
  KEY `base_tournament_tour_team_id_4fa35dfb_fk_base_team` (`team_id`),
  CONSTRAINT `base_tournament_tour_team_id_4fa35dfb_fk_base_team` FOREIGN KEY (`team_id`) REFERENCES `base_team` (`id`),
  CONSTRAINT `base_tournament_tour_tournament_id_b572b523_fk_base_tour` FOREIGN KEY (`tournament_id`) REFERENCES `base_tournament` (`id_tournament`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_tournament_tournament_teams`
--

LOCK TABLES `base_tournament_tournament_teams` WRITE;
/*!40000 ALTER TABLE `base_tournament_tournament_teams` DISABLE KEYS */;
INSERT INTO `base_tournament_tournament_teams` VALUES (2,2,1),(3,2,2),(4,2,3),(1,2,4);
/*!40000 ALTER TABLE `base_tournament_tournament_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(10,'base','match'),(7,'base','player'),(8,'base','team'),(9,'base','tournament'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2022-11-28 02:12:31.994438'),(2,'auth','0001_initial','2022-11-28 02:12:32.296219'),(3,'admin','0001_initial','2022-11-28 02:12:32.372907'),(4,'admin','0002_logentry_remove_auto_add','2022-11-28 02:12:32.379712'),(5,'admin','0003_logentry_add_action_flag_choices','2022-11-28 02:12:32.385764'),(6,'contenttypes','0002_remove_content_type_name','2022-11-28 02:12:32.436811'),(7,'auth','0002_alter_permission_name_max_length','2022-11-28 02:12:32.472820'),(8,'auth','0003_alter_user_email_max_length','2022-11-28 02:12:32.491158'),(9,'auth','0004_alter_user_username_opts','2022-11-28 02:12:32.497734'),(10,'auth','0005_alter_user_last_login_null','2022-11-28 02:12:32.536359'),(11,'auth','0006_require_contenttypes_0002','2022-11-28 02:12:32.538806'),(12,'auth','0007_alter_validators_add_error_messages','2022-11-28 02:12:32.544537'),(13,'auth','0008_alter_user_username_max_length','2022-11-28 02:12:32.580165'),(14,'auth','0009_alter_user_last_name_max_length','2022-11-28 02:12:32.623076'),(15,'auth','0010_alter_group_name_max_length','2022-11-28 02:12:32.637459'),(16,'auth','0011_update_proxy_permissions','2022-11-28 02:12:32.645716'),(17,'auth','0012_alter_user_first_name_max_length','2022-11-28 02:12:32.686197'),(18,'sessions','0001_initial','2022-11-28 02:12:32.706094');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('az4gkx0ckvp4in5gnc71mncnaquurgof','.eJxVjDsOgzAQBe_iOrK8fAxLmT5nsHbtJTgfE2FTRbl7QKKhfTPzvsplyTnOycUUiyvxLbnQ--PUANaibXpoao1tbaC_KEdrmdyaZXExqEGhOm1M_ilpB-FB6T5rP6eyRNa7og-a9W0O8roe7ulgojxttTeExgOT2MqIEcauJ6CGWVqmsSM2UFdIEDY0YgBfGYuItmeq2xbU7w8Dwkaq:1ozfkl:QxwxSPs-81yylWQDsNOXIlA30aiEKhLC9TZaEZc5tEM','2022-12-12 15:09:03.966524'),('ojxkju4fehjzsmqghy5r123x8yztvcr2','.eJxVjDsOwyAQRO9CHSEb8OJ1mT5nQLuAY_LBkcFVlLvHllwkxTQzb95bOFrr5NYSF5eCGETbiNNvyeTvMe9LuFG-ztLPuS6J5Y7IYy3yMof4OB_sn2CiMm1vzxTIqBF7g3EE02oFXTOyb4LxjUJgAN0HtkHjqLfsMJsATIyG_C4tsZQ0Z5dyqq6mZyyVni8nhhYAoes7sNIqQIv28wXC70c9:1oziSt:ZAb9wzlu-wqkjvlx9MHe3BgKidVV5wCBowNU99U7Xsc','2022-12-12 18:02:47.739203'),('qa4evwapbml2f59ucjzewnwacqe9jyhr','.eJxVjMsOwiAQRf-FtSGldHh06d5vIANMLWrBFLoy_rs26UK395x7Xszh1ma3VVpdimxkhp1-N4_hTnkH8Yb5Wngoua3J813hB638UiI9zof7F5ixzt93APRRmwFNP0SUIMD0wU9C6wDGS23l5IG01EpLA0QULapeSLAA0Sjco5VqTSW7lFNzLS1UGy5Px0ahlFXDYK3gnVZd16v3B1r2RfQ:1ozevv:GUj5E9re2qmb9ecR-TICy3JldnedubRxJcASDPc6yIA','2022-12-12 14:16:31.096909'),('rv5n87ve8q2l8zbcnf1ejcvfty501fjc','.eJxVjMsOwiAQRf-FtSECHR5duvcbyABTiw8wha6M_65NutDtPeeeF_O49tmvjRafExuZZYffLWC8UdlAumK5VB5r6UsOfFP4Ths_10T30-7-BWZs8_cdAUMydkArh4QKBFgZwySMiWCDMk5NAcgoo42yQETJoZZCgQNIVuMWbdRarsXnkrvv-UGt4-Pp2Si0dhqO0mnuQGkl7fsDWwRF_g:1ozgJU:FG4-Px3OzhH01FtDQGXwivJ4BKvGqT8RSHKooiLFasM','2022-12-12 15:44:56.961728');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-28 19:03:43
