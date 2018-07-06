SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema pacswlibinvtool
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pacswlibinvtool` ;

-- -----------------------------------------------------
-- Schema pacswlibinvtool
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pacswlibinvtool` DEFAULT CHARACTER SET utf8 ;
USE `pacswlibinvtool` ;

-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`authorstab`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`authorstab` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`authorstab` (
    `idAuthors` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `LastName` VARCHAR(20) NOT NULL,
    `FirstName` VARCHAR(20) NOT NULL,
    `MiddleName` VARCHAR(20) NULL DEFAULT NULL,
    `YearOfBirth` VARCHAR(4) NULL DEFAULT NULL,
    `YearOfDeath` VARCHAR(4) NULL DEFAULT NULL,
    PRIMARY KEY (`idAuthors`, `LastName`, `FirstName`),
    UNIQUE INDEX `idAuthors_UNIQUE` (`idAuthors` ASC),
    INDEX `LastName` (`LastName` ASC),
    INDEX `LastCMFirst` (`LastName` ASC, `FirstName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`bookcategories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`bookcategories` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`bookcategories` (
    `idBookCategories` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `CategoryName` VARCHAR(45) NOT NULL COMMENT 'This will be strings like Non-Fiction, Mystery, Science-Fiction, Fantasy, Poetry, Art etc.',
    PRIMARY KEY (`idBookCategories`, `CategoryName`),
    UNIQUE INDEX `idBookCategories_UNIQUE` (`idBookCategories` ASC),
    INDEX `CategoryNames` (`CategoryName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`bookformat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`bookformat` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`bookformat` (
    `idFormat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `FormatName` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`idFormat`, `FormatName`),
    UNIQUE INDEX `idFormat_UNIQUE` (`idFormat` ASC),
    UNIQUE INDEX `FormatName_UNIQUE` (`FormatName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`title`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`title` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`title` (
    `idTitle` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `TitleStr` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`idTitle`, `TitleStr`),
    UNIQUE INDEX `idTitle_UNIQUE` (`idTitle` ASC),
    INDEX `TitleStr` (`TitleStr` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`bookinfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`bookinfo` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`bookinfo` (
    `idBookInfo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `TitleFKbi` INT UNSIGNED NOT NULL,
    `AuthorFKbi` INT UNSIGNED NOT NULL COMMENT 'Foreign Key Into Author Table',
    `CategoryFKbi` INT UNSIGNED NOT NULL,
    `BookFormatFKbi` INT UNSIGNED NOT NULL COMMENT 'Foreign Key Into Format Table',
    `SeriesFKBi` INT UNSIGNED NOT NULL COMMENT 'Foreign Key into Series Table',
    PRIMARY KEY (`idBookInfo`, `TitleFKbi`, `AuthorFKbi`),
    UNIQUE INDEX `idBookInfo_UNIQUE` (`idBookInfo` ASC),
    INDEX `CategoryFKbI` (`CategoryFKbi` ASC),
    INDEX `AuthorFKbi` (`AuthorFKbi` ASC),
    INDEX `BookFormatFKBi` (`BookFormatFKbi` ASC),
    INDEX `SeriesFKBi` (`SeriesFKBi` ASC),
    INDEX `TitleFKbi` (`TitleFKbi` ASC),
    CONSTRAINT `BkCatBookFK`
        FOREIGN KEY (`CategoryFKbi`)
        REFERENCES `pacswlibinvtool`.`bookcategories` (`idBookCategories`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `BkFormatBookFK`
        FOREIGN KEY (`BookFormatFKbi`)
        REFERENCES `pacswlibinvtool`.`bookformat` (`idFormat`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `TitleBookFK`
        FOREIGN KEY (`TitleFKbi`)
        REFERENCES `pacswlibinvtool`.`title` (`idTitle`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `BkAuthorBookFK`
        FOREIGN KEY (`AuthorFKbi`)
        REFERENCES `pacswlibinvtool`.`authorstab` (`idAuthors`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`bksynopsis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`bksynopsis` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`bksynopsis` (
    `BookFKsyop` INT UNSIGNED NOT NULL,
    `StoryLine` VARCHAR(1024) NULL DEFAULT NULL,
    PRIMARY KEY (`BookFKsyop`),
    INDEX `BookFKsYnop` (`BookFKsyop` ASC),
    CONSTRAINT `BookInfoFKSynopsis`
        FOREIGN KEY (`BookFKsyop`)
        REFERENCES `pacswlibinvtool`.`bookinfo` (`idBookInfo`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`forsale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`forsale` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`forsale` (
    `BookFKfs` INT UNSIGNED NOT NULL,
    `IsForSale` TINYINT NOT NULL DEFAULT '0',
    `AskingPrice` DOUBLE NOT NULL DEFAULT '0',
    `EstimatedValue` DOUBLE NOT NULL DEFAULT '0',
    PRIMARY KEY (`BookFKfs`),
    UNIQUE INDEX `BookFKfs_UNIQUE` (`BookFKfs` ASC),
    INDEX `BookFKfs` (`BookFKfs` ASC),
    CONSTRAINT `fsBookFK`
        FOREIGN KEY (`BookFKfs`)
        REFERENCES `pacswlibinvtool`.`bookinfo` (`idBookInfo`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`owned`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`owned` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`owned` (
    `BookFKo` INT UNSIGNED NOT NULL,
    `IsOwned` TINYINT NOT NULL,
    `IsWishListed` TINYINT NOT NULL,
    PRIMARY KEY (`BookFKo`),
    INDEX `BookFKo` (`BookFKo` ASC),
    INDEX `ownedindex` (`IsOwned` ASC),
    INDEX `wishindex` (`IsWishListed` ASC),
    CONSTRAINT `ownedBookFK`
        FOREIGN KEY (`BookFKo`)
        REFERENCES `pacswlibinvtool`.`bookinfo` (`idBookInfo`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`publishinginfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`publishinginfo` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`publishinginfo` (
    `BookFKPubI` INT UNSIGNED NOT NULL COMMENT 'Foreign Key into the Book Info Table.',
    `ISBNumber` VARCHAR(32) NULL DEFAULT NULL COMMENT 'This was previously the only data field in the isbn table, it has been moved here and the isbn table has been removed.',
    `Copyright` VARCHAR(4) NOT NULL,
    `Edition` INT UNSIGNED NULL DEFAULT NULL,
    `Printing` INT UNSIGNED NULL DEFAULT NULL COMMENT 'A book may be printed may times. This will indicate which printing it is. Check the back of the title page.',
    `Publisher` VARCHAR(45) NULL DEFAULT NULL,
    `OutOfPrint` TINYINT NULL DEFAULT NULL COMMENT 'Is the book still being printed or has it lapsed.',
    PRIMARY KEY (`BookFKPubI`),
    UNIQUE INDEX `ISBNumber_UNIQUE` (`ISBNumber` ASC),
    INDEX `BookFKPubI` (`BookFKPubI` ASC),
    INDEX `ISBNindex` (`ISBNumber` ASC),
    CONSTRAINT `bookDataFKpub`
        FOREIGN KEY (`BookFKPubI`)
        REFERENCES `pacswlibinvtool`.`bookinfo` (`idBookInfo`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`purchaseinfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`purchaseinfo` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`purchaseinfo` (
    `BookFKPurI` INT UNSIGNED NOT NULL,
    `PurchaseDate` DATE NULL DEFAULT NULL,
    `ListPrice` DOUBLE NULL DEFAULT NULL,
    `PaidPrice` DOUBLE NULL DEFAULT NULL,
    `Vendor` VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (`BookFKPurI`),
    INDEX `BookFKPurI` (`BookFKPurI` ASC),
    INDEX `DateBoughtIndex` (`PurchaseDate` ASC),
    CONSTRAINT `purBookFK`
        FOREIGN KEY (`BookFKPurI`)
        REFERENCES `pacswlibinvtool`.`bookinfo` (`idBookInfo`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`series`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`series` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`series` (
    `idSeries` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `AuthorOfSeries` INT UNSIGNED NOT NULL COMMENT 'Foriegn Key into Author Table',
    `SeriesName` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`idSeries`, `AuthorOfSeries`, `SeriesName`),
    UNIQUE INDEX `idSeries_UNIQUE` (`idSeries` ASC),
    INDEX `AuthorFKs` (`AuthorOfSeries` ASC),
    INDEX `SeriesTitle` (`SeriesName` ASC),
    CONSTRAINT `authorfksidx`
        FOREIGN KEY (`AuthorOfSeries`)
        REFERENCES `pacswlibinvtool`.`authorstab` (`idAuthors`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`volumeinseries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`volumeinseries` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`volumeinseries` (
    `BookFKvs` INT UNSIGNED NOT NULL,
    `SeriesFK` INT UNSIGNED NOT NULL,
    `VolumeNumber` INT UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`BookFKvs`),
    INDEX `BookFKvsidx` (`BookFKvs` ASC),
    INDEX `SeriesFKvsidx` (`SeriesFK` ASC),
    CONSTRAINT `BookInfoFKvolumeS`
        FOREIGN KEY (`BookFKvs`)
        REFERENCES `pacswlibinvtool`.`bookinfo` (`idBookInfo`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `SeriesFKVolumeS`
        FOREIGN KEY (`SeriesFK`)
        REFERENCES `pacswlibinvtool`.`series` (`idSeries`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`ratings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`ratings` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`ratings` (
    `BookFKRats` INT UNSIGNED NOT NULL COMMENT 'Primary Key, but also foreign key to the bookinfo table.',
    `MyRatings` DOUBLE NULL DEFAULT NULL COMMENT '1 to 5 star rating based on my feelings about the book.',
    `AmazonRatings` DOUBLE NULL DEFAULT NULL COMMENT '1 to 5 star rating from Amazon.com',
    `GoodReadsRatings` DOUBLE NULL DEFAULT NULL COMMENT '1 to 5 star rating from the GoodReads.com website',
    PRIMARY KEY (`BookFKRats`),
    UNIQUE INDEX `BookFKRats_UNIQUE` (`BookFKRats` ASC),
    INDEX `MyRatings_idx` (`MyRatings` ASC),
    INDEX `AmazonRatings_idx` (`AmazonRatings` ASC),
    INDEX `GoodReadsRats_idx` (`GoodReadsRatings` ASC),
    CONSTRAINT `BookFKRats`
        FOREIGN KEY (`BookFKRats`)
        REFERENCES `pacswlibinvtool`.`bookinfo` (`idBookInfo`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`bkconditions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`bkconditions` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`bkconditions` (
    `idBkConditions` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key of Book Conditions table.\nBook Conditions are Excellent, Good, Fair, Poor. They are used to partially describe the condition of the book.\nThis table will be used to create a dictionary of book conditions in a UI/Tool.',
    `ConditionOfBookStr` VARCHAR(16) NOT NULL COMMENT 'This string will contain 1 of 4 conditions for the book, Execellent, Good, Fair or Poor. This is a rating of the physical condition of the book.',
    PRIMARY KEY (`idBkConditions`),
    UNIQUE INDEX `idbkconditions_UNIQUE` (`idBkConditions` ASC),
    UNIQUE INDEX `ConditionOfBook_UNIQUE` (`ConditionOfBookStr` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO pacswlibinvtool.bkconditions
    (ConditionOfBookStr)
    VALUES
        ('Not In Library'),
        ('Excellent'),
        ('Good'),
        ('Fair'),
        ('Poor');

-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`bkstatuses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`bkstatuses` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`bkstatuses` (
    `idBkStatus` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key of the book status. \nBook statuses are New or Usedr. They are used to partially describe the condition of the book.\nThis table will be used to create a dictionary of book conditions in a UI/Tool.',
    `BkStatusStr` VARCHAR(45) NULL DEFAULT NULL COMMENT 'This string will contain one of two values, either New or Used.',
    PRIMARY KEY (`idBkStatus`),
    UNIQUE INDEX `idbkstatus_UNIQUE` (`idBkStatus` ASC),
    UNIQUE INDEX `BkStatusStr_UNIQUE` (`BkStatusStr` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO pacswlibinvtool.bkstatuses
    (BkStatusStr)
    VALUES
        ('Not In Library'),
        ('New'),
        ('Used');

-- -----------------------------------------------------
-- Table `pacswlibinvtool`.`bookcondition`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pacswlibinvtool`.`bookcondition` ;

CREATE TABLE IF NOT EXISTS `pacswlibinvtool`.`bookcondition` (
    `BookFKCond` INT UNSIGNED NOT NULL COMMENT 'BookFKCond is a foreign key into the bookinfo table. There will be one bookcondition for each book in the library.',
    `ConditionOfBook` INT UNSIGNED NOT NULL COMMENT 'This is a foreign key into the bkconditions table. It will be an integer between 1 and 4 representing the condition of the book.',
    `NewOrUsed` INT UNSIGNED NOT NULL COMMENT 'This integer is a foreign key into the bkstatuses table. It will have a value of either 1 or 2.',
    `PhysicalDescriptionStr` VARCHAR(256) NULL DEFAULT NULL COMMENT 'The user can provide a brief summary of the books condition.',
    `IsSignedByAuthor` TINYINT NOT NULL COMMENT 'Boolean value, has the author signed the book or not. Replaces the signedbyauthor table in the previous version of the database.',
    `BookHasBeenRead` TINYINT NOT NULL COMMENT 'Boolean Value, has the user read the book.',
    PRIMARY KEY (`BookFKCond`),
    UNIQUE INDEX `BookFKCond_UNIQUE` (`BookFKCond` ASC),
    INDEX `IsReadIndex` (`BookHasBeenRead` ASC),
    INDEX `IsSignedIndex` (`IsSignedByAuthor` ASC),
    INDEX `statusindexfk_idx` (`NewOrUsed` ASC),
    INDEX `conditionindexfk_idx` (`ConditionOfBook` ASC),
    CONSTRAINT `statusindexfk`
        FOREIGN KEY (`NewOrUsed`)
        REFERENCES `pacswlibinvtool`.`bkstatuses` (`idBkStatus`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `conditionindexfk`
        FOREIGN KEY (`ConditionOfBook`)
        REFERENCES `pacswlibinvtool`.`bkconditions` (`idBkConditions`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `condbookinfoidxfk`
        FOREIGN KEY (`BookFKCond`)
        REFERENCES `pacswlibinvtool`.`bookinfo` (`idBookInfo`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
