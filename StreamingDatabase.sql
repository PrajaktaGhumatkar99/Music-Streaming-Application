-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema StreamingDatabase
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `StreamingDatabase` ;

-- -----------------------------------------------------
-- Schema StreamingDatabase
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `StreamingDatabase` DEFAULT CHARACTER SET utf8 ;
USE `StreamingDatabase` ;

-- -----------------------------------------------------
-- Table `StreamingDatabase`.`playlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StreamingDatabase`.`playlist` ;

CREATE TABLE IF NOT EXISTS `StreamingDatabase`.`playlist` (
  `playlistId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `status` ENUM('Public', 'Private') NOT NULL,
  PRIMARY KEY (`playlistId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StreamingDatabase`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StreamingDatabase`.`user` ;

CREATE TABLE IF NOT EXISTS `StreamingDatabase`.`user` (
  `userId` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(64) NOT NULL,
  `lastName` VARCHAR(64) NOT NULL,
  `email` VARCHAR(128) NOT NULL,
  `phone` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StreamingDatabase`.`payment_plan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StreamingDatabase`.`payment_plan` ;

CREATE TABLE IF NOT EXISTS `StreamingDatabase`.`payment_plan` (
  `date` DATE NOT NULL,
  `paymentId` INT NOT NULL AUTO_INCREMENT,
  `amount` INT NOT NULL,
  `type` ENUM("Monthly", "Yearly", "Free") NOT NULL,
  PRIMARY KEY (`paymentId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StreamingDatabase`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StreamingDatabase`.`genre` ;

CREATE TABLE IF NOT EXISTS `StreamingDatabase`.`genre` (
  `genreId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`genreId`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StreamingDatabase`.`songs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StreamingDatabase`.`songs` ;

CREATE TABLE IF NOT EXISTS `StreamingDatabase`.`songs` (
  `songId` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `release` DATE NOT NULL,
  `duration` INT NOT NULL,
  PRIMARY KEY (`songId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StreamingDatabase`.`album`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StreamingDatabase`.`album` ;

CREATE TABLE IF NOT EXISTS `StreamingDatabase`.`album` (
  `albumId` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `release` DATE NOT NULL,
  `albumcol` VARCHAR(45) NULL,
  PRIMARY KEY (`albumId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StreamingDatabase`.`artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StreamingDatabase`.`artist` ;

CREATE TABLE IF NOT EXISTS `StreamingDatabase`.`artist` (
  `artistId` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(128) NOT NULL,
  `lastName` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`artistId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StreamingDatabase`.`playlistSong`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StreamingDatabase`.`playlistSong` ;

CREATE TABLE IF NOT EXISTS `StreamingDatabase`.`playlistSong` (
  `playlistId` INT NOT NULL,
  `songId` INT NOT NULL,
  PRIMARY KEY (`playlistId`, `songId`),
  INDEX `songId_idx` (`songId` ASC) VISIBLE,
  CONSTRAINT `playlistId`
    FOREIGN KEY (`playlistId`)
    REFERENCES `StreamingDatabase`.`playlist` (`playlistId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `songId`
    FOREIGN KEY (`songId`)
    REFERENCES `StreamingDatabase`.`songs` (`songId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
