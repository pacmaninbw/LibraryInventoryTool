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


USE `pacswlibinvtool` ;

-- -----------------------------------------------------
-- function findAuthorKey
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findAuthorKey`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findAuthorKey`(
    firstName VARCHAR(20),
    lastName VARCHAR(20)
) RETURNS INT
BEGIN
    
    SET @authorKey = 0;
    
    SELECT COUNT(*) INTO @authorCount FROM authorstab;
    IF @authorCount > 0 THEN
        SELECT authorstab.idAuthors INTO @authorKey
            FROM authorstab
            WHERE authorsTab.LastName = lastName AND authorsTab.FirstName = firstName;
        IF @authorKey IS NULL THEN
            SET @authorKey = 0;
        END IF;
    END IF;

    RETURN @authorKey;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findbkStatusKey
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findbkConditionKey`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findbkConditionKey`(
    bkConditionStr VARCHAR(20)
) RETURNS INT
BEGIN
    
    SET @bkConditionKey = 0;
    
    SELECT bkconditions.idBkConditions INTO @bkConditionKey
        FROM bkconditions
        WHERE bkconditions.ConditionOfBookStr = bkConditionStr;
    IF @bkConditionKey IS NULL THEN
        SET @bkConditionKey = 0;
    END IF;

    RETURN @bkConditionKey;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findbkStatusKey
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findbkStatusKey`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findbkStatusKey`(
    bkStatusStr VARCHAR(20)
) RETURNS INT
BEGIN
    
    SET @bkStatusKey = 0;
    
    SELECT bkstatuses.idBkStatus INTO @bkStatusKey
        FROM bkstatuses
        WHERE bkstatuses.BkStatusStr = bkStatusStr;
    IF @bkStatusKey IS NULL THEN
        SET @bkStatusKey = 0;
    END IF;

    RETURN @bkStatusKey;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findBookKey
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findBookKey`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findBookKey`(
    authorLast VARCHAR(20),
    authorFirst VARCHAR(20),
    titleStr VARCHAR(128),
    formatStr VARCHAR(45)
) RETURNS INT
BEGIN

    SET @bookKey = 0;
    
    SET @authorKey = findauthorKey(authorFirst, authorLast);
    
    SET @titleKey = findTitleKey(titleStr);
    
    SET @formatKey = findFormatKeyFromStr(formatStr);
    
    IF @authorKey > 0 AND @titleKey > 0 THEN
        SET @bookKey = findBookKeyFromKeys(@authorKey, @titleKey, @formatKey);
    END IF;
    
    RETURN @bookKey;
        
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findBookKeyFast
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findBookKeyFast`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findBookKeyFast`(
    authorLast VARCHAR(20),
    authorFirst VARCHAR(20),
    titleStr VARCHAR(128),
    formatStr VARCHAR(45)
) RETURNS INT
BEGIN

    /*
     * There may be multiple copies of a book in the library, one of each format.
     * Specifying the format makes it distinct.
     */

    SELECT BKI.idBookInfo INTO @bookKey FROM bookinfo as BKI
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        WHERE a.LastName = authorLast AND a.FirstName = authorFirst AND t.TitleStr = titleStr and bf.FormatName = formatStr;

    IF @bookKey IS NULL THEN
        SET @bookKey = 0;
    END IF;

    
    RETURN @bookKey;
        
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findBookKeyFromKeys
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findBookKeyFromKeys`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findBookKeyFromKeys`(
    authorKey INT,
    titleKey INT,
    formatKey INT
) RETURNS INT
BEGIN

    SET @bookKey = 0;
    
    IF authorKey > 0 AND titleKey > 0 then
        SELECT bookinfo.idBookInfo INTO @bookKey 
            FROM BookInfo 
            WHERE bookinfo.AuthorFKbi = authorKey AND bookinfo.TitleFKbi = titleKey AND bookinfo.BookFormatFKbi = formatKey;
        IF @bookKey IS NULL THEN
            SET @bookKey = 0;
        END IF;
    END IF;
    
    RETURN @bookKey;
        
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findTitleKey
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findTitleKey`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findTitleKey`(
    TitleStr VARCHAR(128)
) RETURNS INT
BEGIN

    SELECT title.idTitle INTO @titleKey FROM title WHERE title.TitleStr = TitleStr;
    IF @titleKey IS NULL THEN
        SET @titleKey = 0;
    END IF;
    
    RETURN @titleKey;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function insertTitleIfNotExist
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`insertTitleIfNotExist`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `insertTitleIfNotExist`(
    titleStr VARCHAR(128)
) RETURNS INT
BEGIN

    SET @titleKey = findTitleKey(titleStr);

    if @titleKey < 1 THEN
        INSERT INTO title (title.TitleStr) VALUES(titleStr);
        SET @titleKey := LAST_INSERT_ID();
    END IF;
    
    RETURN @titleKey;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findCategoryKeyFromStr
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findCategoryKeyFromStr`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findCategoryKeyFromStr`
(
    categoryName VARCHAR(45)
)
RETURNS INT
BEGIN

    SET @categoryKey = 0;

    SELECT COUNT(*) INTO @categoryCount FROM bookcategories;
    IF @categoryCount > 0 THEN
        SELECT bookcategories.idBookCategories INTO @categoryKey
            FROM bookcategories
            WHERE bookcategories.CategoryName = categoryName;
        IF @categoryKey IS NULL THEN
            SET @categoryKey = 0;
        END IF;
    END IF;

    RETURN @categoryKey;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findFormatKeyFromStr
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findFormatKeyFromStr`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findFormatKeyFromStr`(
    bookFormatStr VARCHAR(45)
)
RETURNS INT
BEGIN

    SET @formatKey = 0;
    
    SELECT COUNT(*) INTO @formatCount FROM bookformat;
    IF @formatCount > 0 THEN
        SELECT bookformat.idFormat INTO @formatKey
            FROM bookformat
            WHERE bookformat.FormatName = bookFormatStr;
        IF @formatKey IS NULL THEN
            SET @formatKey = 0;
        END IF;
    END IF;
    
    RETURN @formatKey;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findSeriesKey
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findSeriesKey`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findSeriesKey` 
(
    authorFirst VARCHAR(20),
    authorLast VARCHAR(20),
    seriesTitle VARCHAR(128)
)
RETURNS INT
BEGIN

    SET @authorKey = findAuthorKey(authorFirst, authorLast);
    
    SET @seriesKey = findSeriesKeyByAuthKeyTitle(@authorKey, seriesTitle);
        
    RETURN @seriesKey;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findSeriesKeyByAuthKeyTitle
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP function IF EXISTS `pacswlibinvtool`.`findSeriesKeyByAuthKeyTitle`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE FUNCTION `findSeriesKeyByAuthKeyTitle`
(
    authorKey INT,
    seriesTitle VARCHAR(128)
)
RETURNS INT
BEGIN

    SET @seriesKey = 0;
        
    IF authorKey > 0 THEN
        SELECT series.idSeries INTO @seriesKey FROM series WHERE series.AuthorOfSeries = authorKey AND series.SeriesName = seriesTitle;
        IF @seriesKey IS NULL THEN
            SET @seriesKey = 0;
        END IF;
    END IF;
    
    RETURN @seriesKey;

END$$

DELIMITER ;
/*
 * Data inserts, deletions and updates.
 */

-- -----------------------------------------------------
-- procedure UpdateAuthor
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`UpdateAuthor`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `UpdateAuthor`(
    IN LastName VARCHAR(20),
    IN FirstName VARCHAR(20),
    IN MiddleName VARCHAR(20),
    IN DOB VARCHAR(4),
    IN DOD VARCHAR(4)
)
BEGIN

    UPDATE authorstab 
        SET 
            authorstab.MiddleName = MiddleName,
            authorstab.YearOfBirth = DOB,
            authorstab.YearOfDeath = DOD
        WHERE authorstab.LastName = LastName AND authorstab.FirstName = FirstName;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addAuthor
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`addAuthor`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `addAuthor`(
    IN authorLastName VARCHAR(20),
    IN authorFirstName VARCHAR(20),
    IN authorMiddleName VARCHAR(20),
    IN dob VARCHAR(4),
    IN dod VARCHAR(4)
)
BEGIN

    INSERT INTO authorstab (authorstab.LastName, authorstab.FirstName, authorstab.MiddleName, authorstab.YearOfBirth, authorstab.YearOfDeath)
        VALUES(authorLastName, authorFirstName, authorMiddleName, dob, dod);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addOrUpdateBookDataInTables
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`addOrUpdateBookDataInTables`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `addOrUpdateBookDataInTables`
(
    IN categoryKey INT,
    IN authorKey INT,
    IN titleKey INT,
    IN formatKey INT,
    IN copyright VARCHAR(4), IN iSBNumber VARCHAR(32), IN edition INT, IN printing INT, IN publisher VARCHAR(45), IN outOfPrint TINYINT,
    IN seriesKey INT, IN volumeNumber INT,
    IN bkStatusKey INT, IN bkConditionKey INT, physicalDescStr VARCHAR(256), IN iSignedByAuthor TINYINT, IN haveRead TINYINT,
    IN isOwned TINYINT, IN isWishListed TINYINT,
    IN isForSale TINYINT, IN askingPrice DOUBLE, IN estimatedValue DOUBLE,
    IN bookDescription VARCHAR(1024),
    IN myRating DOUBLE, IN amazonRating DOUBLE, IN goodReadsRating DOUBLE,
    OUT bookKey INT
)
BEGIN

    -- All book data that can be converted to keys have been converted, insert or update tables as necessary.
    -- All book data except for purchasing data will be added directly or indirectly from this procedure.
    -- Purchasing data will be added in the buyBook Procedure, that calls this procedure.
    -- Each independent portion of the data will have it's own add procedure that will be called here.

    -- If the author isn't found then the user has to add the author before they add any books or Series by the author.
    if @authorKey > 0 AND @formatKey > 0 THEN
        SET bookKey = findBookKeyFromKeys(authorKey, titleKey, formatKey);
        IF bookKey < 1 THEN
            INSERT INTO bookinfo (bookinfo.AuthorFKbi, bookinfo.TitleFKbi, bookinfo.CategoryFKbi, bookinfo.BookFormatFKbi, bookinfo.SeriesFKbi)
                VALUES (authorKey, titleKey, categoryKey, formatKey, seriesKey);
            SET bookKey := LAST_INSERT_ID();
        ELSE
            UPDATE bookinfo
            SET
                bookinfo.AuthorFKbi = authorKey,
                bookinfo.TitleFKbi = titleKey,
                bookinfo.CategoryFKbi = categoryKey,
                bookinfo.BookFormatFKbi = formatKey,
                bookinfo.SeriesFKbi = seriesKey
            WHERE bookinfo.idBookInfo = bookKey;
        END IF;

        CALL insertOrUpdatePublishing(bookKey, copyright, iSBNumber, edition, printing, publisher, outOfPrint);
        CALL insertOrUpdateOwned(bookKey, isOwned, isWishListed);
        CALL insertOrUpdateBookCondition(bookKey, bkStatusKey, bkConditionKey, physicalDescStr, iSignedByAuthor, haveRead);
        IF seriesKey > 0 THEN
            CALL insertOrUpdateVolumeInSeries(bookKey, volumeNumber, seriesKey);
        END IF;
        IF isOwned > 0 THEN
                CALL insertOrUpdateForSale(bookKey, isForSale, askingPrice, estimatedValue);
        END IF;
        IF myRating IS NOT NULL THEN
                CALL insertOrUpdateBookRatings(bookKey, myRating, amazonRating, goodReadsRating);
        END IF;
        IF bookDescription IS NOT NULL OR LENGTH(bookDescription) > 0 THEN
                -- Try to save space if there is no description.
                CALL insertOrUpdateSynopsis(bookKey, bookDescription);
        END IF;
            
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addBookToLibrary
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`addBookToLibrary`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `addBookToLibrary`
(
    IN categoryName VARCHAR(45),
    IN authorLastName VARCHAR(20), IN authorFirstName VARCHAR(20),
    IN titleStr VARCHAR(128), 
    IN bookFormatStr VARCHAR(45),
    IN copyright VARCHAR(4), IN iSBNumber VARCHAR(32), IN edition INT, IN printing INT, IN publisher VARCHAR(45), IN outOfPrint TINYINT,
    IN seriesName VARCHAR(128), IN volumeNumber INT,
    IN bkStatus VARCHAR(45), IN bkCondition VARCHAR(16), physicalDescStr VARCHAR(256), IN iSignedByAuthor TINYINT, IN haveRead TINYINT,
    IN isOwned TINYINT, IN isWishListed TINYINT,
    IN isForSale TINYINT, IN askingPrice DOUBLE, IN estimatedValue DOUBLE,
    IN bookDescription VARCHAR(1024),
    IN myRating DOUBLE, IN amazonRating DOUBLE, IN goodReadsRating DOUBLE,
    OUT bookKey INT
)
BEGIN

    -- Convert all strings that are keys in other tables to the key value and add or update the book info.

    SET @titleKey = 0, @formatKey = 0, @authorKey = 0, @seriesKey = 0;
    SET @authorKey = findAuthorKey(authorFirstName, authorLastName);
    SET @formatKey = findFormatKeyFromStr(BookFormatStr);
    
    -- If the author isn't found then the user has to add the author before they add any books or Series by the author.
    IF @authorKey > 0 AND @formatKey > 0 THEN
        SET @seriesKey = findSeriesKeyByAuthKeyTitle(@authorKey, SeriesName);
        SET @titleKey = insertTitleIfNotExist(titleStr);
        SET @categoryKey = findCategoryKeyFromStr(categoryName);
        Set @conditionKey = findbkConditionKey(bkCondition);
        Set @statusKey = findbkStatusKey(bkStatus);

        CALL addOrUpdateBookDataInTables(@categoryKey, @authorKey, @titleKey, @formatKey, copyright, iSBNumber, edition, printing, publisher, outOfPrint,
            @seriesKey, volumeNumber, @statusKey, @conditionKey, physicalDescStr, iSignedByAuthor, haveRead, isOwned, isWishListed,
            isForSale, askingPrice, estimatedValue, bookDescription, myRating, amazonRating, goodReadsRating, bookKey
        );
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buyBook
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`buyBook`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `buyBook`
(
    IN categoryName VARCHAR(45),
    IN authorLastName VARCHAR(20), IN authorFirstName VARCHAR(20),
    IN titleStr VARCHAR(128), 
    IN bookFormatStr VARCHAR(45),
    IN copyright VARCHAR(4), IN iSBNumber VARCHAR(32), IN edition INT, IN printing INT, IN publisher VARCHAR(45), IN outOfPrint TINYINT,
    IN seriesName VARCHAR(128), IN volumeNumber INT,
    IN physicalDescStr VARCHAR(256), IN iSignedByAuthor TINYINT,
    IN bookDescription VARCHAR(1024),
    IN purchaseDate DATE, IN listPrice DOUBLE, IN pricePaid DOUBLE, IN vendor VARCHAR(64),
    OUT bookKey INT    -- allows the calling program or procedure to test for failure.
)
BEGIN

    -- Assumptions when the book has just been bought.
    SET @estimatedValue = listPrice - 1.00;
    SET @haveRead = 0, @IsOwned = 1, @IsForSale = 0, @IsWishListed = 0;
    SET @bkStatus = 'New', @bkCondition = 'Excellent';

    CALL addBookToLibrary(categoryName, authorLastName, authorFirstName, titleStr, bookFormatStr, copyright, iSBNumber, edition, printing, publisher, outOfPrint,
        seriesName, volumeNumber, @bkStatus, @bkCondition, physicalDescStr, iSignedByAuthor, @haveRead, @IsOwned, @IsWishListed, @IsForSale, @estimatedValue, @estimatedValue, 
        bookDescription, NULL, NULL, NULL, bookKey -- No book ratings when a new book is purchased.
    );
    IF bookKey IS NOT NULL AND bookKey > 0 THEN
        CALL insertOrUpdatePurchaseInfo(bookKey, purchaseDate, listPrice, pricePaid, vendor);
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteAuthor
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`deleteAuthor`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `deleteAuthor`
(
    IN authorLast VARCHAR(20),
    IN authorFirst VARCHAR(20),
    IN authorMiddle VARCHAR(20)
)
BEGIN
    -- This procedure deletes everything associated with the specified author
    -- including books, series and volumes in series. It affects almost every table
    -- in this database.
    -- Do not delete formats and categories.

    DELETE a, BKI, s, v, bc, pub, pur, o, fs, BDesk
        FROM authorstab AS a 
        LEFT JOIN series AS s ON s.AuthorOfSeries = a.idAuthors
        LEFT JOIN volumeinseries AS v ON v.SeriesFK = s.idSeries
        INNER JOIN bookinfo AS BKI ON BKI.AuthorFKbi = a.idAuthors
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        WHERE a.LastName = authorLast AND a.FirstName = authorFirst AND a.MiddleName = authorMiddle;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteBook
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`deleteBook`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `deleteBook`
(
    IN authorLast VARCHAR(20),
    IN authorFirst VARCHAR(20),
    IN titleStr VARCHAR(128),
    IN formatStr VARCHAR(45)
)
BEGIN
    -- Do not delete authors, titles, series, formats or categories. These may be shared with other books.

    DELETE BKI, bc, pub, pur, v, o, fs, BDesk
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        WHERE a.LastName = authorLast AND a.FirstName = authorFirst AND t.TitleStr = titleStr and bf.FormatName = formatStr;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdatePublishing
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`insertOrUpdatePublishing`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `insertOrUpdatePublishing` 
(
    IN bookKey INT,
    IN copyright VARCHAR(4),
    IN iSBNumber VARCHAR(30),
    IN edition INT,
    IN printing INT,
    IN publisher VARCHAR(45),
    IN outOfPrint TINYINT
)
BEGIN

   --  DECLARE testCopyright VARCHAR(4);
    
    SET @testKey = NULL;
    SELECT publishinginfo.Copyright INTO @testCopyright FROM publishinginfo WHERE publishinginfo.BookFKPubI = bookKey;
    
    IF @testCopyright IS NULL THEN
        INSERT INTO publishinginfo (publishinginfo.BookFKPubI, publishinginfo.Copyright, publishinginfo.ISBNumber, publishinginfo.Edition, publishinginfo.Printing, publishinginfo.Publisher, publishinginfo.OutOfPrint)
            VALUES(bookKey, copyright, iSBNumber, edition, printing, publisher, outOfPrint)
        ;
    ELSE
        UPDATE publishinginfo
            SET
                publishinginfo.Copyright = copyright,
                publishinginfo.ISBNumber = iSBNumber,
                publishinginfo.Edition = edition,
                publishinginfo.Printing = printing,
                publishinginfo.Publisher = publisher,
                publishinginfo.OutOfPrint = outOfPrint
            WHERE publishinginfo.BookFKPubI = bookKey;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdateOwned
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`insertOrUpdateOwned`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `insertOrUpdateOwned` 
(
    IN bookKey INT,
    IN isOwned TINYINT,
    IN isWishListed TINYINT
)
BEGIN

    SET @testKey = NULL;
    SELECT owned.BookFKo INTO @testKey FROM owned WHERE owned.BookFKo = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO owned (owned.BookFKo, owned.IsOwned, owned.IsWishListed)
            VALUES(bookKey, isOwned, isWishListed)
        ;
    ELSE
        UPDATE Owned
            SET
                owned.isOwned = isOwned,
                owned.IsWishListed = isWishListed
            WHERE owned.BookFKo = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdateBookCondition
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`insertOrUpdateBookCondition`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `insertOrUpdateBookCondition`
(
    IN bookKey INT,
    IN statusKey INT,
    IN conditionKey INT,
    IN physicalDescStr VARCHAR(256),
    IN signedByAuthor TINYINT,
    IN haveRead TINYINT
)
BEGIN

    SET @testKey = NULL;
    SELECT bookcondition.BookFKCond INTO @testKey FROM bookcondition WHERE bookcondition.BookFKCond = bookKey;

    IF @testKey IS NULL THEN
        INSERT INTO bookcondition (bookcondition.BookFKCond, bookcondition.NewOrUsed, bookcondition.ConditionOfBook, bookcondition.PhysicalDescriptionStr, bookcondition.IsSignedByAuthor, bookcondition.BookHasBeenRead)
            VALUES(bookKey, statusKey, conditionKey, physicalDescStr, signedByAuthor, haveRead)
        ;
    ELSE
        UPDATE bookcondition
            SET
                bookcondition.NewOrUsed = statusKey,
                bookcondition.ConditionOfBook = conditionKey,
                bookcondition.PhysicalDescriptionStr = physicalDescStr,
                bookcondition.IsSignedByAuthor = signedByAuthor,
                bookcondition.BookHasBeenRead = haveRead
            WHERE bookcondition.BookFKCond = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdateVolumeInSeries
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`insertOrUpdateVolumeInSeries`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `insertOrUpdateVolumeInSeries` 
(
    IN bookKey INT,
    IN volumeNumber INT,
    IN seriesKey INT
)
BEGIN

    SET @testKey = NULL;
    SELECT volumeinseries.BookFKvs INTO @testKey FROM volumeinseries WHERE volumeinseries.BookFKvs = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO volumeinseries (volumeinseries.BookFKvs, volumeinseries.SeriesFK, volumeinseries.VolumeNumber)
            VALUES(bookKey, seriesKey, volumeNumber)
        ;
    ELSE
        UPDATE volumeinseries
            SET
                volumeinseries.SeriesFK = seriesKey,
                volumeinseries.VolumeNumber = volumeNumber
            WHERE VolumeInSeries.BookFKvs = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdateForSale()
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`insertOrUpdateForSale`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `insertOrUpdateForSale`
(
    IN bookKey INT,
    IN isForSale TINYINT,
    IN askingPrice DOUBLE,
    IN estimatedValue DOUBLE
)
BEGIN

    SET @testKey = NULL;
    SELECT forsale.BookFKfs INTO @testKey FROM forsale WHERE forsale.BookFKfs = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO forsale (forsale.BookFKfs, forsale.IsForSale, forsale.AskingPrice, forsale.EstimatedValue)
            VALUES(bookKey, isForSale, askingPrice, estimatedValue)
        ;
    ELSE
        UPDATE forsale
            SET
                forsale.isForSale = isForSale,
                forsale.AskingPrice = askingPrice,
                forsale.EstimatedValue = estimatedValue
            WHERE forsale.BookFKfs = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdateSynopsis
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`insertOrUpdateSynopsis`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `insertOrUpdateSynopsis`
(
    IN bookKey INT,
    IN bookDescription VARCHAR(1024)
)
BEGIN

    SET @testKey = NULL;
    SELECT bksynopsis.BookFKsyop INTO @testKey FROM bksynopsis WHERE bksynopsis.BookFKsyop = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO bksynopsis (bksynopsis.BookFKsyop, bksynopsis.StoryLine)
            VALUES(bookKey, bookDescription)
        ;
    ELSE
        UPDATE bksynopsis
            SET
                bksynopsis.StoryLine = bookDescription
            WHERE bksynopsis.BookFKsyop = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdatePurchaseInfo
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`insertOrUpdatePurchaseInfo`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `insertOrUpdatePurchaseInfo`
(
    IN bookKey INT,
    IN purchaseDate DATE,
    IN listPrice DOUBLE,
    IN pricePaid DOUBLE,
    vendor VARCHAR(64)
)
BEGIN

    SET @testKey = NULL;
    SELECT purchaseinfo.BookFKPurI INTO @testKey FROM purchaseinfo WHERE purchaseinfo.BookFKPurI = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO purchaseinfo
            (purchaseinfo.BookFKPurI, purchaseinfo.PurchaseDate, purchaseinfo.ListPrice, purchaseinfo.PaidPrice, purchaseinfo.Vendor)
            VALUES(bookKey, purchaseDate, listPrice, pricePaid, vendor)
        ;
    ELSE
        UPDATE purchaseinfo
            SET
                purchaseinfo.PurchaseDate = purchaseDate,
                purchaseinfo.ListPrice = listPrice,
                purchaseinfo.PaidPrice = pricePaid,
                purchaseinfo.Vendor = vendor
            WHERE purchaseinfo.BookFKPurI = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdateBookRatings
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`insertOrUpdateBookRatings`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `insertOrUpdateBookRatings`
(
    IN bookKey INT,
    IN myRatings DOUBLE,
    IN amazonRatings DOUBLE,
    IN goodReadsRatings DOUBLE
)
BEGIN

    SET @testKey = NULL;
    SELECT ratings.BookFKRats INTO @testKey FROM ratings WHERE ratings.BookFKRats = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO ratings
            (ratings.BookFKRats, ratings.MyRatings, ratings.AmazonRatings, ratings.GoodReadsRatings)
            VALUES(bookKey, myRatings, amazonRatings, goodReadsRatings)
        ;
    ELSE
        UPDATE ratings
            SET
                ratings.MyRatings = myRatings,
                ratings.AmazonRatings = amazonRatings,
                ratings.GoodReadsRatings = goodReadsRatings
            WHERE ratings.BookFKRats = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addCategory
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`addCategory`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `addCategory`
(
    categoryName VARCHAR(45)
)
BEGIN

    SET @categoryKey = NULL;

    SELECT bookcategories.idBookCategories INTO @categoryKey
        FROM bookcategories
        WHERE bookcategories.CategoryName = categoryName;

    -- Prevent adding the same category again to avoid breaking the unique key structure.

    IF @categoryKey IS NULL THEN
        INSERT INTO bookcategories (bookcategories.CategoryName) VALUES(categoryName);
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addFormat
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`addFormat`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `addFormat` (IN bookFormatStr VARCHAR(45))
BEGIN

    SET @formatKey = findFormatKeyFromStr(bookFormatStr);
    
    -- Prevent adding the same format again to avoid breaking the unique key structure.
    IF @formatKey < 1 THEN
        INSERT INTO bookformat (bookformat.FormatName) VALUES(bookFormatStr);
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addAuthorSeries
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`addAuthorSeries`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `addAuthorSeries`
(
    IN authorFirst VARCHAR(20),
    IN authorLast VARCHAR(20),
    IN seriesTitle VARCHAR(128)
)
BEGIN

SET @procName = 'addAuthorSeries';

    SET @authorKey = findAuthorKey(authorFirst, authorLast);

    IF @authorKey > 0 THEN
        SET @seriesKey = findSeriesKeyByAuthKeyTitle(@authorKey, seriesTitle);
    
        IF @seriesKey < 1 THEN
            INSERT INTO series (series.AuthorOfSeries, series.SeriesName) VALUES(@authorKey, seriesTitle);
        END IF;
    END IF;

    
END$$

DELIMITER ;

/*
 * Data retrieval functions and queries.
 */

-- -----------------------------------------------------
-- procedure getAllBookDataSortedByMyRatings
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBookDataSortedByMyRatings`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBookDataSortedByMyRatings`()
BEGIN

    SELECT
            BKI.idBookInfo, a.*, t.*, bf.*, BCat.*,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.*, v.VolumeNumber,
            pur.PurchaseDate, pur.ListPrice, pur.PaidPrice, pur.Vendor,
            bc.IsSignedByAuthor, bCondStr.ConditionOfBookStr, bstat.BkStatusStr, bc.PhysicalDescriptionStr,
            o.IsOwned, o.IsWishListed,
            fs.IsForSale, fs.AskingPrice, fs.EstimatedValue,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings,
            BDesk.StoryLine
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN bkconditions AS bCondStr ON bc.ConditionOfBook = bCondStr.idBkConditions
        LEFT JOIN bkstatuses AS bstat ON bc.NewOrUsed = bstat.idBkStatus
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        ORDER BY rts.MyRatings DESC, a.LastName ASC, a.FirstName ASC, s.SeriesName ASC, v.VolumeNumber ASC, t.TitleStr ASC;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getRatedBooksSortedByMyRating
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getRatedBooksSortedByMyRating`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getRatedBooksSortedByMyRating`()
BEGIN

    SELECT
            a.LastName, a.FirstName, t.TitleStr, BCat.CategoryName,
            pub.ISBNumber, pub.Copyright,
            s.SeriesName, v.VolumeNumber,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings,
            BDesk.StoryLine
        FROM bookinfo AS BKI
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        WHERE rts.BookFKRats IS NOT NULL
        ORDER BY rts.MyRatings DESC; -- 5 stars being best and 1 star being worst.
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getRatedBooksSortedByAmazonRating
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getRatedBooksSortedByAmazonRating`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getRatedBooksSortedByAmazonRating`()
BEGIN

    SELECT
            a.LastName, a.FirstName, t.TitleStr, BCat.CategoryName,
            pub.ISBNumber, pub.Copyright,
            s.SeriesName, v.VolumeNumber,
            rts.AmazonRatings, rts.MyRatings, rts.GoodReadsRatings,
            BDesk.StoryLine
        FROM bookinfo AS BKI
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        WHERE rts.BookFKRats IS NOT NULL
        ORDER BY rts.AmazonRatings DESC; -- 5 stars being best and 1 star being worst.
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getRatedBooksSortedByGoodReadsRating
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getRatedBooksSortedByGoodReadsRating`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getRatedBooksSortedByGoodReadsRating`()
BEGIN

    SELECT
            a.LastName, a.FirstName, t.TitleStr, BCat.CategoryName,
            pub.ISBNumber, pub.Copyright,
            s.SeriesName, v.VolumeNumber,
            rts.GoodReadsRatings, rts.MyRatings, rts.AmazonRatings, 
            BDesk.StoryLine
        FROM bookinfo AS BKI
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        WHERE rts.BookFKRats IS NOT NULL
        ORDER BY rts.GoodReadsRatings DESC; -- 5 stars being best and 1 star being worst.
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksForSale
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBooksForSale`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBooksForSale`()
BEGIN

    SELECT
            a.LastName, a.FirstName,
            t.TitleStr,
            bf.FormatName, BCat.CategoryName,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.SeriesName, v.VolumeNumber,
            bc.IsSignedByAuthor, bCond.ConditionOfBookStr, bstat.BkStatusStr, bc.PhysicalDescriptionStr,
            fs.AskingPrice, fs.EstimatedValue,
            BDesk.StoryLine
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN bkconditions AS bCond ON bc.ConditionOfBook = bCond.idBkConditions
        LEFT JOIN bkstatuses AS bstat ON bc.NewOrUsed = bstat.idBkStatus
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        WHERE o.IsOwned = 1 AND fs.IsForSale = 1 AND bc.BookHasBeenRead = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksSignedByAuthor
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBooksSignedByAuthor`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBooksSignedByAuthor`()
BEGIN

    SELECT
            a.LastName, a.FirstName,
            t.TitleStr,
            bf.FormatName, BCat.CategoryName,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.SeriesName, v.VolumeNumber,
            bc.IsSignedByAuthor, bCondStr.ConditionOfBookStr, bstat.BkStatusStr, bc.PhysicalDescriptionStr, bc.BookHasBeenRead,
            pur.PurchaseDate, pur.ListPrice, pur.PaidPrice, pur.Vendor,
            o.IsOwned, o.IsWishListed,
            fs.IsForSale, fs.AskingPrice, fs.EstimatedValue,
            BDesk.StoryLine
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN bkconditions AS bCondStr ON bc.ConditionOfBook = bCondStr.idBkConditions
        LEFT JOIN bkstatuses AS bstat ON bc.NewOrUsed = bstat.idBkStatus
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        WHERE bc.IsSignedByAuthor = 1
        ORDER BY BCat.CategoryName, a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksWithKeys
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBooksWithKeys`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBooksWithKeys`()
BEGIN

    SELECT
            BKI.idBookInfo, a.*, t.*, bf.*, BCat.*,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.*, v.VolumeNumber,
            pur.PurchaseDate, pur.ListPrice, pur.PaidPrice, pur.Vendor,
            bc.IsSignedByAuthor, bCondStr.ConditionOfBookStr, bstat.BkStatusStr, bc.PhysicalDescriptionStr, bc.BookHasBeenRead,
            o.IsOwned, o.IsWishListed,
            fs.IsForSale, fs.AskingPrice, fs.EstimatedValue,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings,
            BDesk.StoryLine
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN bkconditions AS bCondStr ON bc.ConditionOfBook = bCondStr.idBkConditions
        LEFT JOIN bkstatuses AS bstat ON bc.NewOrUsed = bstat.idBkStatus
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        ORDER BY BCat.CategoryName, a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooks
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBooks`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBooks`()
BEGIN

    SELECT
            a.LastName, a.FirstName,
            t.TitleStr,
            bf.FormatName, BCat.CategoryName,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.SeriesName, v.VolumeNumber,
            pur.PurchaseDate, pur.ListPrice, pur.PaidPrice, pur.Vendor,
            bc.IsSignedByAuthor, bCondStr.ConditionOfBookStr, bstat.BkStatusStr, bc.PhysicalDescriptionStr, bc.BookHasBeenRead,
            o.IsOwned, o.IsWishListed,
            fs.IsForSale, fs.AskingPrice, fs.EstimatedValue,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings,
            BDesk.StoryLine
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN bkconditions AS bCondStr ON bc.ConditionOfBook = bCondStr.idBkConditions
        LEFT JOIN bkstatuses AS bstat ON bc.NewOrUsed = bstat.idBkStatus
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        ORDER BY BCat.CategoryName, a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksNoKeysInLib
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBooksNoKeysInLib`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBooksNoKeysInLib`()
BEGIN

    SELECT
            a.LastName, a.FirstName,
            t.TitleStr,
            bf.FormatName, BCat.CategoryName,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.SeriesName, v.VolumeNumber,
            pur.PurchaseDate, pur.ListPrice, pur.PaidPrice, pur.Vendor,
            bc.IsSignedByAuthor, bCondStr.ConditionOfBookStr, bstat.BkStatusStr, bc.PhysicalDescriptionStr, bc.BookHasBeenRead,
            o.IsOwned, o.IsWishListed,
            fs.IsForSale, fs.AskingPrice, fs.EstimatedValue,
            BDesk.StoryLine,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN bkconditions AS bCondStr ON bc.ConditionOfBook = bCondStr.idBkConditions
        LEFT JOIN bkstatuses AS bstat ON bc.NewOrUsed = bstat.idBkStatus
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        WHERE o.IsOwned = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksWithKeysInLib
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBooksWithKeysInLib`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBooksWithKeysInLib`()
BEGIN

    SELECT
            BKI.idBookInfo, a.*, t.*, bf.*, BCat.*,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.*, v.VolumeNumber,
            pur.PurchaseDate, pur.ListPrice, pur.PaidPrice, pur.Vendor,
            bc.IsSignedByAuthor, bCondStr.ConditionOfBookStr, bstat.BkStatusStr, bc.PhysicalDescriptionStr, bc.BookHasBeenRead,
            o.IsOwned, o.IsWishListed,
            fs.IsForSale, fs.AskingPrice, fs.EstimatedValue,
            BDesk.StoryLine,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN bkconditions AS bCondStr ON bc.ConditionOfBook = bCondStr.idBkConditions
        LEFT JOIN bkstatuses AS bstat ON bc.NewOrUsed = bstat.idBkStatus
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        WHERE o.IsOwned = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllSeriesByThisAuthor
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllSeriesByThisAuthor`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllSeriesByThisAuthor`(
    IN AuthorLastName VARCHAR(20),
    IN AuthorFirstName VARCHAR(20)
)
BEGIN

    SELECT series.SeriesName, series.idSeries FROM series WHERE series.AuthorOfSeries = findauthorKey(AuthorFirstName, AuthorLastName);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllSeriesData
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllSeriesData`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllSeriesData`()
BEGIN

    SELECT a.LastName, a.FirstName, s.SeriesName
        FROM series AS s
        INNER JOIN authorstab AS a
        ON a.idAuthors = s.AuthorOfSeries
        ORDER BY a.LastName, a.FirstName, s.SeriesName;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getBookData
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getBookData`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getBookData`(
    IN authorLast VARCHAR(20),
    IN authorFirst VARCHAR(20),
    IN titleStr VARCHAR(128),
    IN formatStr VARCHAR(45)
)
BEGIN

    -- No order by clause because it's returning only a single book.
    SELECT
            a.LastName, a.FirstName,
            t.TitleStr,
            bf.FormatName, BCat.CategoryName,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.SeriesName, v.VolumeNumber,
            bc.IsSignedByAuthor, bCondStr.ConditionOfBookStr, bstat.BkStatusStr, bc.PhysicalDescriptionStr, bc.BookHasBeenRead,
            pur.PurchaseDate, pur.ListPrice, pur.PaidPrice, pur.Vendor,
            o.IsOwned, o.IsWishListed,
            fs.IsForSale, fs.AskingPrice, fs.EstimatedValue,
            BDesk.StoryLine,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN bkconditions AS bCondStr ON bc.ConditionOfBook = bCondStr.idBkConditions
        LEFT JOIN bkstatuses AS bstat ON bc.NewOrUsed = bstat.idBkStatus
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        WHERE a.LastName = authorLast AND a.FirstName = authorFirst AND t.TitleStr = titleStr and bf.FormatName = formatStr;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllWishListBooks
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllWishListBooks`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllWishListBooks`()
BEGIN

    SELECT
            a.LastName, a.FirstName,
            t.TitleStr,
            BCat.CategoryName,
            pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            s.SeriesName, v.VolumeNumber,
            bc.BookHasBeenRead,
            o.IsOwned, o.IsWishListed
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        WHERE o.IsWishListed = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksByThisAuthor
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBooksByThisAuthor`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBooksByThisAuthor` 
(
    IN authorLastName VARCHAR(20),
    IN authorFirstName VARCHAR(20)
)
BEGIN

    SET @authorKey = findauthorKey(authorFirstName, authorLastName);

    SELECT
            a.LastName, a.FirstName,
            t.TitleStr,
            BCat.CategoryName,
            pub.ISBNumber, pub.Copyright, pub.Edition, pub.Publisher, pub.OutOfPrint, pub.Printing,
            bc.IsSignedByAuthor, bc.BookHasBeenRead,
            s.SeriesName, v.VolumeNumber,
            BDesk.StoryLine,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        WHERE BKI.AuthorFKbi = @authorKey
        ORDER BY s.SeriesName, v.VolumeNumber, t.TitleStr;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksThatWereRead
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBooksThatWereRead`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBooksThatWereRead` 
(
)
BEGIN

    SELECT
            a.LastName, a.FirstName,
            t.TitleStr,
            BCat.CategoryName,
            s.SeriesName, v.VolumeNumber,
            BDesk.StoryLine,
            rts.MyRatings, rts.AmazonRatings, rts.GoodReadsRatings
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN bookcondition AS bc ON bc.BookFKCond = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN bksynopsis AS BDesk ON BDesk.BookFKsyop = BKI.idBookInfo 
        LEFT JOIN ratings AS rts ON rts.BookFKRats = BKI.idBookInfo 
        WHERE bc.BookHasBeenRead = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBookCategoriesWithKeys
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBookCategoriesWithKeys`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBookCategoriesWithKeys` ()
BEGIN

/*
 * Example usage would be to get all the categories to CREATE a control that embeds the primary key rather than the text.
 */

    SELECT bookcategories.CategoryName, bookcategories.idBookCategories FROM bookcategories;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBookFormatsWithKeys
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllBookFormatsWithKeys`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllBookFormatsWithKeys`()
BEGIN

/*
 * Example usage would be to get all the formats to CREATE a control that embeds the primary key rather than the text.
 */

    SELECT bookformat.FormatName, bookformat.idFormat FROM bookformat;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllStatusesWithKeys
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllStatusesWithKeys`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllStatusesWithKeys`()
BEGIN

/*
 * Example usage would be to get all the statuses to CREATE a control that embeds the primary key rather than the text.
 */

    SELECT bkstatuses.BkStatusStr, bkstatuses.idBkStatus FROM bkstatuses;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllConditionsWithKeys
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllConditionsWithKeys`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllConditionsWithKeys`()
BEGIN

/*
 * Example usage would be to get all the conditions to CREATE a control that embeds the primary key rather than the text.
 */

    SELECT bkconditions.ConditionOfBookStr, bkconditions.idBkConditions FROM bkconditions;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllAuthorsData
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAllAuthorsData`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAllAuthorsData` ()
BEGIN

/*
 * Could be used to create a select control of authors for a book or possibly a typing completion text control.
 */

    SELECT * FROM authorstab
        ORDER BY authorstab.LastName, authorstab.FirstName, authorstab.MiddleName;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAuthorDataByLastName
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getAuthorDataByLastName`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getAuthorDataByLastName`
(
    IN authorLastName VARCHAR(20)
)
BEGIN
    
    /*
     * Will return multiple authors with the same last name, e.g. if the last name is Herbert
     * it will return both Frank Herbert and Brian Herbert.
     */
    SELECT * FROM authorstab WHERE authorstab.LastName = authorLastName;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getThisAuthorsData
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`getThisAuthorsData`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `getThisAuthorsData`
(
    IN authorLastName VARCHAR(20),
    IN authorFirstName VARCHAR(20)
)
BEGIN

    SELECT * FROM authorstab WHERE authorstab.LastName = authorLastName AND authorstab.FirstName = authorFirstName;

END$$

DELIMITER ;

/*
 * Start of procedures that allow the user to update books in a limited manner.
 */

-- -----------------------------------------------------
-- procedure bookSold
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`bookSold`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `bookSold` 
(
    IN authorFirstName VARCHAR(20),
    IN authorLastName VARCHAR(20),
    IN bookTitle VARCHAR(128),
    IN bookFormat VARCHAR(45)
)
BEGIN

    SET @isOwned = 0, @isWishListed = 0;

    SET @bookKey = findBookKeyFast(authorLastName, authorFirstName, bookTitle, bookFormat);
    
    CALL insertOrUpdateOwned(@bookKey, @isOwned, @isWishListed);

    DELETE FROM forsale WHERE forsale.BookFKfs = @bookKey;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure finishedReadingBook
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`finishedReadingBook`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `finishedReadingBook` (
    IN authorFirstName VARCHAR(20),
    IN authorLastName VARCHAR(20),
    IN bookTitle VARCHAR(128),
    IN bookFormat VARCHAR(45)
)
BEGIN

    SET @haveReadBook = 1;

    SET @bookKey = findBookKeyFast(authorLastName, authorFirstName, bookTitle, bookFormat);

    UPDATE bookcondition
        SET
            bookcondition.BookHasBeenRead = @haveReadBook
        WHERE bookcondition.BookFKCond = @bookKey;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure putBookUpForSale
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`putBookUpForSale`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `putBookUpForSale`
(
    IN authorFirstName VARCHAR(20),
    IN authorLastName VARCHAR(20),
    IN bookTitle VARCHAR(128),
    IN bookFormat VARCHAR(45),
    IN askingPrice DOUBLE,
    IN estimatedValue DOUBLE
)
BEGIN

    SET @isForSale = 1;

    SET @bookKey = findBookKeyFast(authorLastName, authorFirstName, bookTitle, bookFormat);

    CALL insertOrUpdateForSale(@bookKey, @isForSale, askingPrice, estimatedValue);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure rateThisBook
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`rateThisBook`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `rateThisBook`
(
    IN authorFirstName VARCHAR(20),
    IN authorLastName VARCHAR(20),
    IN bookTitle VARCHAR(128),
    IN bookFormat VARCHAR(45),
    IN myRating DOUBLE,
    IN amazonRating DOUBLE,
    IN goodReadsRating DOUBLE
)
BEGIN

    SET @bookKey = findBookKeyFast(authorLastName, authorFirstName, bookTitle, bookFormat);

    CALL insertOrUpdateBookRatings(@bookKey, myRating, amazonRating, goodReadsRating);

END$$

DELIMITER ;

/*
 * Once only code called during installation or testing.
 */

-- -----------------------------------------------------
-- procedure initBookInventoryTool
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`initBookInventoryTool`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `initBookInventoryTool` ()
BEGIN

-- Initialize some basic formats, user can add more later.
    IF (SELECT COUNT(*) FROM bookformat) < 1 THEN
        CALL addFormat('Not In Library');
        CALL addFormat('Hardcover');
        CALL addFormat('Trade Paperback');
        CALL addFormat('Mass Market Paperback');
        CALL addFormat('eBook PDF');
        CALL addFormat('eBook Kindle');
        CALL addFormat('eBook iBooks');
        CALL addFormat('eBook EPUB');
        CALL addFormat('eBook HTML');
    END IF;

-- Initialize some basic categories, user can add more later.
    IF (SELECT COUNT(*) FROM bookcategories) < 1 THEN
        CALL addCategory('Non-Fiction');
        CALL addCategory('Non-Fiction: Biography');
        CALL addCategory('Non-Fiction: Biology');
        CALL addCategory('Non-Fiction: Computer');
        CALL addCategory('Non-Fiction: Electrical Engineering');
        CALL addCategory('Non-Fiction: History');
        CALL addCategory('Textbook');
        CALL addCategory('Poetry');
        CALL addCategory('Art');
        CALL addCategory('Dictionary');
        CALL addCategory('Encyclopedia');
        CALL addCategory('Fiction');
        CALL addCategory('Fiction: Anime');
        CALL addCategory('Fiction: Fantasy');
        CALL addCategory('Fiction: Horror');
        CALL addCategory('Fiction: Romance');
        CALL addCategory('Fiction: Science Fiction');
        CALL addCategory('Fiction: Western');
    END IF;

END$$

DELIMITER ;

/*
 * Unit testing procedures.
 */

-- -----------------------------------------------------
-- procedure zzzUnitTestAddAuthors
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzUnitTestAddAuthors`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzUnitTestAddAuthors` ()
BEGIN
SET @procName = 'zzzUnitTestAddAuthors';

    CALL addAuthor('Heinlein', 'Robert', 'Anson', '1907', '1988');
    CALL addAuthor('Asimov', 'Isaac', NULL, '1920', '1992');
    CALL addAuthor('Clarke', 'Arthur', 'Charles', '1917', '2008');
    CALL addAuthor('Le Guin', 'Ursula', 'Kroeber', '1929', '2018');
    CALL addAuthor('Bradbury', 'Ray', 'Douglas ', '1920', '2012');
    CALL addAuthor('Dick', 'Philip', 'Kindred', '1928', '1982');
    CALL addAuthor('Wells', 'Herbert', 'George', '1866', '1946');
    CALL addAuthor('Silverberg', 'Robert', NULL, '1935', NULL);
    CALL addAuthor('Zimmer Bradley', 'Marion', 'Eleanor', '1930', '1999');
    CALL addAuthor('Norton', 'Andre', 'Alice', '1912', '2005');
    CALL addAuthor('Drake', 'David', NULL, '1945', NULL);
    CALL addAuthor('Weber', 'David', 'Mark', '1952', NULL);
    CALL addAuthor('Baxter', 'Stephen', NULL, '1957', NULL);
    CALL addAuthor('Knuth', 'Donald', 'Ervin', '1938', NULL);
    
    IF (SELECT COUNT(*) FROM authorstab) != 14 THEN
        SELECT @procName, COUNT(*) FROM series;
        SELECT * FROM series;
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestAddAuthorSeries
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzUnitTestAddAuthorSeries`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzUnitTestAddAuthorSeries` ()
BEGIN
SET @procName = 'zzzUnitTestAddAuthorSeries';

    CALL addAuthorSeries('David', 'Weber', 'Safehold');
    CALL addAuthorSeries('David', 'Weber', 'Honor Harrington');
    CALL addAuthorSeries('David', 'Weber', 'Honorverse');
    CALL addAuthorSeries('Marion', 'Zimmer Bradley', 'Darkover');
    CALL addAuthorSeries('Isaac', 'Asimov', 'Foundation');
    CALL addAuthorSeries('Stephen', 'Baxter', 'Northland');
    CALL addAuthorSeries('Donald', 'Knuth', 'The Art of Computer Programming');
-- The follow statement should fail to insert the series since John Ringo has not been added to authorstab.
    CALL addAuthorSeries('John', 'Ringo', 'Kildar');

    IF (SELECT COUNT(*) FROM series) != 7 THEN
        SET @procName = CONCAT(@procName, ' Expected 7 Series, got ');
        SELECT @procName, COUNT(*) FROM series;
        SELECT * FROM series;
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestAddBookToLibrary
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzUnitTestAddBookToLibrary`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzUnitTestAddBookToLibrary` ()
BEGIN
/*
 * The following procedures are tested by this procedure.
 *      addBookToLibrary
 *      insertOrUpdatePublishing
 *      insertOrUpdateOwned
 *      insertOrUpdateHaveRead
 *      insertOrUpdateVolumeInSeries
 *      insertOrUpdateForSale()
 *      insertOrUpdateIsSignedByAuthor
 *      insertOrUpdateSynopsis
 *      insertOrUpdateISBN
 *      insertOrUpdatePurchaseInfo
 *
 * The following functions are tested by this procedure:
 *      findAuthorKey
 *      findFormatKeyFromStr
 *      findSeriesKeyByAuthKeyTitle
 *      insertTitleIfNotExist
 *      findCategoryKeyFromStr
 *      findBookKeyFromKeys
 *
 */

    DECLARE bookKey INT;

SET @procName = 'zzzUnitTestAddBookToLibrary';

    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'On Basilisk Station', 'Mass Market Paperback', '1993', '0-7434-3571-0', 1, 9, 'Baen Books', 0,
        'Honor Harrington', 1, 'Used', 'Good', 'Cover bent.', 0, 1, 1, 0, 0, 8.99, 8.99, 'bookDescription', 4.1, 4.5, 4.12, bookKey);
    IF (bookKey != 1) THEN
        SET @eMsg = 'Unable to add On Basilisk Station';
        SELECT @procName, bookKey, @eMsg;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'Honor of the Queen', 'Mass Market Paperback', '1993', '0-7434-3572-0', 1, 10, 'Baen Books', 0,
        'Honor Harrington', 2, 'Used', 'Good', 'Cover bent.', 0, 1, 1, 0, 0, 6.99, 6.99, NULL, 4.4, 4.6, 4.21, bookKey);
    IF (bookKey != 2) THEN
        SET @eMsg = 'Unable to add Honor of the Queen';
        SELECT @procName, bookKey, @eMsg;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'Short Victorious War', 'Mass Market Paperback', '1994', '0-7434-3573-7', 1, 8, 'Baen Books', 0,
        'Honor Harrington', 3, 'Used', 'Good', 'Cover bent.', 0, 1, 1, 0, 0, 6.99, 6.99, NULL,  4.5, 4.5, 4.17, bookKey);
    IF (bookKey != 3) THEN
        SET @eMsg = 'Unable to add Short Victorious War';
        SELECT @procName, bookKey, @eMsg;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL addBookToLibrary(
	'Fiction: Science Fiction', 'Weber', 'David', 'Field of Dishonor', 'Mass Market Paperback', '1994', '0-7434-3574-5', 1, 6, 'Baen Books', 0,
        'Honor Harrington', 4, 'Used', 'Good', 'Cover bent.', 0, 1, 1, 0, 0, 7.99, 7.99, NULL, 4.6, 4.6, 4.2, bookKey);
    IF (bookKey != 4) THEN
        SET @eMsg = 'Unable to add Field of Dishonor';
        SELECT @procName, bookKey, @eMsg;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL addBookToLibrary( 'Fiction: Science Fiction', 'Norton', 'Andre', 'Star Guard', 'Not In Library', '1955', NULL, 1, NULL, 'Harcourt', 0,
        NULL, NULL, 'Not In Library', 'Not In Library', NULL, 0, 1, 0, 1, 0, 7.99, 7.99, NULL , NULL, NULL, NULL, bookKey);
    IF (bookKey != 5) THEN
        SET @eMsg = 'Unable to Andre Norton Star Guard';
        SELECT @procName, bookKey, @eMsg;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    -- The following statement should fail to add a book since David Brin is not in authorstab.
    -- The failure is indicated by bookKey being zero.
    CALL addBookToLibrary('Fiction: Science Fiction', 'Brin', 'David', 'Uplift War', 'Not In Library', '1987', '0-932096-44-1', 1, 1, 'Phantasia Press', 0,
        NULL, NULL, 'Used', 'Good In Library', 'Dust Jacket Dusty', 1, 1, 1, 0, 0, 100.00, 100.00, NULL, NULL, NULL, NULL, bookKey);
    IF (bookKey != 0) THEN
        SET @eMsg = 'Added David Brin Uplift War';
        SELECT @procName, bookKey, @eMsg;
        SELECT COUNT(*) FROM bookinfo;
    END IF;
    IF (SELECT COUNT(*) FROM bookinfo) != 5 THEN
        SET @eMsg = 'Expected 5 entries in bookinfo got ';
        SELECT @procName, @eMsg, COUNT(*) FROM bookinfo;
        SELECT * FROM bookInfo;
    END IF;

    IF (SELECT COUNT(*) FROM publishinginfo) != 5 THEN
        SET @eMsg = 'Expected 5 entries in publishinginfo got ';
        SELECT @procName, @emsg, COUNT(*) FROM publishinginfo;
        SELECT * FROM publishinginfo;
    END IF;

    IF (SELECT COUNT(*) FROM bksynopsis) != 1 THEN
        SET @eMsg = 'Expected 1 entries in bksynopsis got ';
        SELECT @procName, @emsg, COUNT(*) FROM bksynopsis;
        SELECT * FROM bksynopsis;
    END IF;

    IF (SELECT COUNT(*) FROM forsale) != 4 THEN
        SET @eMsg = 'Expected 4 entries in forsale got ';
        SELECT @procName, @emsg, COUNT(*) FROM forsale;
        SELECT * FROM forsale;
    END IF;

    IF (SELECT COUNT(*) FROM bookcondition) != 5 THEN
        SET @eMsg = 'Expected 5 entries in bookcondition got ';
        SELECT @procName, @emsg, COUNT(*) FROM bookcondition;
        SELECT * FROM bookcondition;
    END IF;

    IF (SELECT COUNT(*) FROM owned) != 5 THEN
        SET @eMsg = 'Expected 5 entries in owned got ';
        SELECT @procName, @emsg, COUNT(*) FROM owned;
        SELECT * FROM owned;
    END IF;

    IF (SELECT COUNT(*) FROM purchaseinfo) != 0 THEN
        SET @eMsg = 'Expected 0 entries in purchaseinfo got ';
        SELECT @procName, @emsg, COUNT(*) FROM purchaseinfo;
        SELECT * FROM purchaseinfo;
    END IF;

    IF (SELECT COUNT(*) FROM title) != 5 THEN
        SET @eMsg = 'Expected 5 entries in title got ';
        SELECT @procName, @emsg, COUNT(*) FROM title;
        SELECT * FROM title;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestUserUpdates
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzUnitTestUserUpdates`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzUnitTestUserUpdates` ()
BEGIN

    DECLARE bookKey INT;
    SET @procName = 'zzzUnitTestUserUpdates';

    SELECT COUNT(*) INTO @forSaleCount FROM forsale WHERE forsale.IsForSale = 1;
    CALL putBookUpForSale('David', 'Weber', 'Honor of the Queen', 'Mass Market Paperback', 10.99, 7.99);
    IF (SELECT COUNT(*) FROM forsale WHERE forsale.IsForSale = 1) != (@forSaleCount + 1) THEN
        SELECT @procName, COUNT(*) FROM forsale;
        SELECT * FROM forsale;
    END IF;
    SELECT COUNT(*) INTO @forSaleCount FROM forsale;
    
    SELECT COUNT(*) INTO @haveReadCount FROM bookcondition WHERE bookcondition.BookHasBeenRead = 1;
    CALL finishedReadingBook('Stephen', 'Baxter', 'Stone Spring', 'Mass Market Paperback');
    CALL finishedReadingBook('Stephen', 'Baxter', 'Bronze Summer', 'Mass Market Paperback');
    IF (SELECT COUNT(*) FROM bookcondition WHERE bookcondition.BookHasBeenRead = 1) != (@haveReadCount + 2) THEN
        SELECT @procName, COUNT(*) FROM bookcondition;
        SELECT * FROM bookcondition;
    END IF;

    CALL bookSold('David', 'Weber', 'Honor of the Queen', 'Mass Market Paperback');
    IF (SELECT COUNT(*) FROM forsale) != (@forSaleCount - 1) THEN
        SELECT @procName, COUNT(*) FROM forsale;
        SELECT * FROM forsale;
    END IF;

    -- Test update buy buying wish listed book.
    Set @buyDate = CURDATE();
    CALL buyBook('Fiction: Science Fiction', 'Norton', 'Andre', 'Star Guard',  'Mass Market Paperback', '1955', '978-0-345-35036-7', 3, 4, 'Harcourt', 0,
        NULL, NULL, NULL, 0, 'Testing 1 2 3', @buyDate, 7.99, 7.99, 'Amazon', bookKey);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestBuyBook
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzUnitTestBuyBook`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzUnitTestBuyBook` ()
BEGIN
/*
 * This procedure tests the buyBook procedure. Since the buyBook procedure call addBookToLibrary, everything tested
 * by zzzUnitTestAddBookToLibrary is also tested by this procedure.
 *
 */

    DECLARE bookKey INT;
    DECLARE buyDate DATE;

SET @procName = 'zzzUnitTestBuyBook';

    Set buyDate = CURDATE();

    CALL buyBook('Fiction: Science Fiction', 'Baxter', 'Stephen', 'Stone Spring',  'Mass Market Paperback', '2010', '978-0-451-46446-0', 1, 1, 'Roc', 0,
        'Northland', 1, 'New book, what could be wrong?', 0, 'The start of the Great Wall of Northland.', buyDate, 7.99, 7.19, 'Barnes & Noble', bookKey);
    IF (bookKey != 6) THEN
        SET @eMsg = CONCAT(@procName, ' Expected value is 6');
        SELECT @eMsg, bookKey, COUNT(*) FROM bookinfo;
    END IF;

    CALL buyBook('Fiction: Science Fiction', 'Baxter', 'Stephen', 'Bronze Summer',  'Mass Market Paperback', '2011', '978-0-451-41486-1', 1, 1, 'Roc', 0,
        'Northland', 2, NULL, 0, 'The Golden Age of Northland', buyDate, 9.99, 8.99, 'Barnes & Noble', bookKey);
    IF (bookKey != 7) THEN
        SET @eMsg = CONCAT(@procName, ' Expected value is 7');
        SELECT @eMsg, bookKey, COUNT(*) FROM bookinfo;
    END IF;

    CALL buyBook('Fiction: Science Fiction', 'Baxter', 'Stephen', 'Iron Winter',  'Mass Market Paperback', '2012', '978-0-451-41919-4', 1, 1, 'Roc', 0,
        'Northland', 3, NULL, 0, NULL, buyDate, 7.99, 7.19, 'Barnes & Noble', bookKey);
    IF (bookKey != 8) THEN
        SET @eMsg = CONCAT(@procName, ' Expected value is 8');
        SELECT @eMsg, bookKey, COUNT(*) FROM bookinfo;
    END IF;

    IF (SELECT COUNT(*) FROM bookinfo) != 8 THEN
        SELECT @procName, COUNT(*) FROM bookInfo;
        SELECT * FROM bookInfo;
    END IF;

    IF (SELECT COUNT(*) FROM publishinginfo) != 8 THEN
        SELECT @procName, COUNT(*) FROM publishinginfo;
        SELECT * FROM publishinginfo;
    END IF;

    IF (SELECT COUNT(*) FROM bksynopsis) != 3 THEN
        SELECT @procName, COUNT(*) FROM bksynopsis;
        SELECT * FROM bksynopsis;
    END IF;

    IF (SELECT COUNT(*) FROM forsale) != 7 THEN
        SELECT @procName, COUNT(*) FROM forsale;
        SELECT * FROM forsale;
    END IF;

    IF (SELECT COUNT(*) FROM bookcondition) != 8 THEN
        SELECT @procName, COUNT(*) FROM bookcondition;
        SELECT * FROM bookcondition;
    END IF;

    IF (SELECT COUNT(*) FROM owned) != 8 THEN
        SELECT @procName, COUNT(*) FROM owned;
        SELECT * FROM owned;
    END IF;

    IF (SELECT COUNT(*) FROM purchaseinfo) != 3 THEN
        SELECT @procName, COUNT(*) FROM purchaseinfo;
        SELECT * FROM purchaseinfo;
    END IF;

    IF (SELECT COUNT(*) FROM title) != 8 THEN
        SELECT @procName, COUNT(*) FROM title;
        SELECT * FROM title;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestInitProcedure
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzUnitTestInitProcedure`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzUnitTestInitProcedure` ()
BEGIN

SET @procName = 'zzzUnitTestInitProcedure';

    CALL initBookInventoryTool();
    SELECT COUNT(*) INTO @formatCount FROM pacswlibinvtool.bookformat;
    IF @formatCount != 9 THEN
        SELECT @procName, @formatCount;
        SELECT * FROM bookformat;
    END IF;
    -- the following call to addFormat should result in no changed to the database
    -- since eBook PDF is already in the database.
    CALL addFormat('eBook PDF');
    IF (SELECT COUNT(*) FROM bookformat) != @formatCount THEN
        SELECT @procName, @formatCount, COUNT(*) FROM bookformat;
        SELECT * FROM bookformat;
    END IF;

    SELECT COUNT(*) INTO @categoryCount FROM bookcategories;
    IF @categoryCount != 18 THEN
        SELECT @procName, @categoryCount;
        SELECT * FROM bookcategories;
    END IF;
    -- Should not be added a second time.
    CALL addCategory('Non-Fiction: Electrical Engineering');
    IF (SELECT COUNT(*) FROM bookcategories) != @categoryCount THEN
        SELECT @procName, @categoryCount, COUNT(*) FROM bookcategories;
        SELECT * FROM bookcategories;
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestFunctions
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzUnitTestFunctions`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzUnitTestFunctions` ()
BEGIN

SET @procName = 'zzzUnitTestFunctions';

    /*
     * The functions not explicitly tested here are tested indirectly 
     * through the function calls here with the exception of insertTitleIfNotExist
     */

    SET @authorKey = findAuthorKey('Arthur','Clarke');
    IF @authorKey != 3 THEN
        SELECT @procName, @authorKey;
        SELECT authorstab.FirstName, authorstab.LastName FROM authorstab WHERE idAuthors = @authorKey;
    END IF;

    SET @bookKey = findBookKeyFast('Baxter', 'Stephen', 'Stone Spring', 'Mass Market Paperback');
    IF (@bookKey != 6) THEN
        SELECT @procName, @bookKey;
        SELECT * FROM bookinfo WHERE bookinfo.idBookInfo = @bookKey;
    END IF;

    SET @titleKey = findTitleKey('Star Guard');
    IF (@titleKey != 5) THEN
        SELECT @procName, @titleKey;
        SELECT * FROM title WHERE title.idTitle = @titleKey;
    END IF;

    SET @categoryKey = findCategoryKeyFromStr('Non-Fiction: Electrical Engineering');
    IF (@categoryKey != 5) THEN
        SELECT @procName, @categoryKey;
        SELECT * FROM bookcategories; -- WHERE bookcategories.idBookCategories = @categoryKey;
    END IF;

    SET @formatKey = findFormatKeyFromStr('Mass Market Paperback');
    IF (@formatKey != 4) THEN
        SELECT @procName, @formatKey;
        SELECT * FROM bookformat WHERE bookformat.idFormat = @formatKey;
    END IF;

    SET @seriesKey = findSeriesKey('David', 'Weber', 'Honorverse');
    IF (@seriesKey != 3) THEN
        SELECT @procName, @seriesKey;
        SELECT * FROM series WHERE series.idSeries = @seriesKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addMoreBooksForInterst
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`addMoreBooksForInterst`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `addMoreBooksForInterst` ()
BEGIN

    DECLARE bookKey INT;
SET @procName = 'addMoreBooksForInterst';

    -- These 3 books are not included in the previous testing.
    CALL addBookToLibrary('Non-Fiction: Computer', 'Knuth', 'Donald', 'Fundamental Algorithms',  'Hardcover', '1973', '0-201-03809-9', 2, NULL, 'Addison Wesley', 0,
        'The Art of Computer Programming', 1, 'Used', 'Good', 'No dust jacket, like new.', 0, 1, 1, 0, 0.00, 0.00, 1, NULL, NULL, NULL, NULL, bookKey);
    IF bookKey = 0 THEN
        SET @emsg = 'Failed to add Fundamental Algorithms';
        SELECT emsg;
    END IF;
    CALL addBookToLibrary('Non-Fiction: Computer', 'Knuth', 'Donald', 'Seminumerical Algorithms',  'Hardcover', '1981', '0-201-03822-6', 2, NULL, 'Addison Wesley', 0,
	'The Art of Computer Programming', 2, 'Used', 'Good', 'No dust jacket, like new.', 0, 1, 1, 0, 0.00, 0.00, 1, NULL, NULL, NULL, NULL, bookKey);
    IF bookKey = 0 THEN
        SET @emsg = 'Failed to add Seminumerical Algorithms';
        SELECT emsg;
    END IF;
    CALL addBookToLibrary('Non-Fiction: Computer', 'Knuth', 'Donald', 'Sorting and Searching',  'Hardcover', '1973', '0-201-03803-X', 2, NULL, 'Addison Wesley', 0, 
        'The Art of Computer Programming', 3, 'Used', 'Good', 'No dust jacket, like new.', 0, 1, 1, 0, 0.00, 0.00, 1, NULL, NULL, NULL, NULL, bookKey);
    IF bookKey = 0 THEN
        SET @emsg = 'Failed to add Sorting and Searching';
        SELECT emsg;
        SELECT * from authorstab;
        SELECT * from series;
    END IF;
    CALL addAuthor('Brin', 'David', 'Glen', '1950', NULL);
    CALL addAuthorSeries('David', 'Brin', 'The Uplift Saga');
    CALL addBookToLibrary('Fiction: Science Fiction', 'Brin', 'David', 'Uplift War', 'HardCover', '1987', '0-932096-44-1', 1, 1, 'Phantasia Press', 0,
        NULL, NULL, 'Used', 'Good', 'Dust Jacket Dusty', 1, 1, 1, 0, 0, 100.00, 100.00, NULL, NULL, NULL, NULL, bookKey);
    CALL rateThisBook('David', 'Brin', 'Uplift War', 'HardCover', 4.7, 4.4, 4.06);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestDelete
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzUnitTestDelete`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzUnitTestDelete` ()
BEGIN
        
    SELECT COUNT(*) INTO @bookCount FROM bookinfo;

    CALL deleteBook('Weber', 'David', 'Honor of the Queen', 'Mass Market Paperback');

    IF (SELECT COUNT(*) FROM bookinfo) != (@bookCount - 1) THEN
        SELECT * FROM bookinfo;
    END IF;
    SET @bookCount = @bookCount - 1;
    IF (SELECT COUNT(*) FROM bookcondition) > @bookCount THEN
        SELECT * FROM bookcondition;
    END IF;
    IF (SELECT COUNT(*) FROM forsale) > @bookCount THEN
        SELECT * FROM forsale;
    END IF;
    IF (SELECT COUNT(*) FROM owned) > @bookCount THEN
        SELECT * FROM owned;
    END IF;
    IF (SELECT COUNT(*) FROM purchaseinfo) > @bookCount THEN
        SELECT * FROM purchaseinfo;
    END IF;
    IF (SELECT COUNT(*) FROM publishinginfo) > @bookCount THEN
        SELECT * FROM publishinginfo;
    END IF;

    SELECT COUNT(*) INTO @bookCount FROM bookinfo;
    SELECT COUNT(*) INTO @seriesCount FROM series;
    SELECT COUNT(*) INTO @authorCount FROM authorstab;

    CALL deleteAuthor('Knuth', 'Donald', 'Ervin');

    IF (SELECT COUNT(*) FROM bookinfo) != (@bookCount - 3) THEN
        SELECT * FROM bookinfo;
    END IF;
    IF (SELECT COUNT(*) FROM series) != (@seriesCount - 1) THEN
        SELECT * FROM series;
    END IF;
    IF (SELECT COUNT(*) FROM authorstab) != (@authorsCount - 1) THEN
        SELECT * FROM authors;
    END IF;
    SET @bookCount = @bookCount - 3;
    IF (SELECT COUNT(*) FROM bookcondition) > @bookCount THEN
        SELECT * FROM bookcondition;
    END IF;
    IF (SELECT COUNT(*) FROM forsale) > @bookCount THEN
        SELECT * FROM forsale;
    END IF;
    IF (SELECT COUNT(*) FROM owned) > @bookCount THEN
        SELECT * FROM owned;
    END IF;
    IF (SELECT COUNT(*) FROM purchaseinfo) > @bookCount THEN
        SELECT * FROM purchaseinfo;
    END IF;
    IF (SELECT COUNT(*) FROM publishinginfo) > @bookCount THEN
        SELECT * FROM publishinginfo;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzRunAllUnitTests
-- -----------------------------------------------------

USE `pacswlibinvtool`;
DROP procedure IF EXISTS `pacswlibinvtool`.`zzzRunAllUnitTests`;

DELIMITER $$
USE `pacswlibinvtool`$$
CREATE PROCEDURE `zzzRunAllUnitTests` ()
BEGIN
    /*
     * The unit tests are in a specific order. Data from the early test procedures
     * is required by the later test procedures.
     *
     * The general functionality of the unit tests is to run the procedures or functions
     * and then test values that would be affected by the routine. If the test failed
     * then a select is run to show the error. No output means no errors.
     */

    SET @ShowAllResults = 1; -- To disable most output by queries change this to zero.

    CALL zzzUnitTestInitProcedure();
    CALL zzzUnitTestAddAuthors();
    CALL zzzUnitTestAddAuthorSeries();
    CALL zzzUnitTestAddBookToLibrary();
    CALL zzzUnitTestBuyBook();
    CALL zzzUnitTestFunctions();

    CALL addMoreBooksForInterst();
    SET @unitTestDone = 'All Unit Tests Completed! If there are any querys run before this point one or more unit tests failed.';
    SELECT @unitTestDone;

    -- Test all the data retrieval procedures to see that they return data rows.
    -- These tests by default will provide output. Visually check output, make sure every query has at least one line, check that all expected fields are showing.
    IF @showAllResults > 0 THEN
        CALL getAllBookFormatsWithKeys();
        CALL getAllBookCategoriesWithKeys();
        CALL getAllConditionsWithKeys();
        CALL getAllStatusesWithKeys();
        CALL getAllBooksNoKeysInLib(); -- Test selecting all fields except keys
        CALL getAllBooksByThisAuthor('Baxter', 'Stephen');
        CALL getAllWishListBooks();
        CALL getAllBooksThatWereRead();
        CALL getThisAuthorsData('Norton','Andre');
        CALL getAllSeriesByThisAuthor('Weber', 'David');
        CALL getAllSeriesData();
        CALL getAllBooksForSale();
        CALL getAllAuthorsData();
        CALL getBookData('Weber', 'David', 'Honor of the Queen', 'Mass Market Paperback');
        CALL getAuthorDataByLastName('Asimov'); -- This could be changed if more authors are added, such as all the Greens.
        CALL getAllBooksSignedByAuthor();
        CALL getRatedBooksSortedByMyRating();
        CALL getRatedBooksSortedByAmazonRating();
        CALL getRatedBooksSortedByGoodReadsRating();
        CALL getAllBookDataSortedByMyRatings();
    END IF;

    CALL zzzUnitTestUserUpdates();
    CALL getAllBooks(); -- Test selecting all fields all books
    CALL zzzUnitTestDelete ();
    CALL getAllBooks(); -- Test selecting all fields all books
    CALL getAllBooksWithKeysInLib(); -- Test selecting all fields except keys
    CALL getAllBooksWithKeys(); -- Test selecting all fields except keys

END$$

DELIMITER ;

CALL pacswlibinvtool.zzzRunAllUnitTests();

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
