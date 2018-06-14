
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema booklibinventory
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `booklibinventory` DEFAULT CHARACTER SET utf8 ;
USE `booklibinventory` ;

-- -----------------------------------------------------
-- Table `booklibinventory`.`authorstab`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`authorstab` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`authorstab` (
  `idAuthors` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
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
-- Table `booklibinventory`.`bookcategories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`bookcategories` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`bookcategories` (
  `idBookCategories` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CategoryName` VARCHAR(45) NOT NULL COMMENT 'This will be strings like Non-Fiction, Mystery, Science-Fiction, Fantasy, Poetry, Art etc.',
  PRIMARY KEY (`idBookCategories`, `CategoryName`),
  UNIQUE INDEX `idBookCategories_UNIQUE` (`idBookCategories` ASC),
  INDEX `CategoryNames` (`CategoryName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`bookdescription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`bookdescription` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`bookdescription` (
  `BookFKbd` INT(10) UNSIGNED NOT NULL,
  `BookDescription` VARCHAR(1024) NULL DEFAULT NULL,
  PRIMARY KEY (`BookFKbd`),
  INDEX `BookFKbD` (`BookFKbd` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`bookformat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`bookformat` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`bookformat` (
  `idFormat` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `FormatName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idFormat`, `FormatName`),
  UNIQUE INDEX `idFormat_UNIQUE` (`idFormat` ASC),
  UNIQUE INDEX `FormatName_UNIQUE` (`FormatName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`bookinfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`bookinfo` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`bookinfo` (
  `idBookInfo` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `TitleFKbi` INT(10) UNSIGNED NOT NULL,
  `AuthorFKbi` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign Key Into Author Table',
  `CategoryFKbi` INT(10) UNSIGNED NOT NULL,
  `BookFormatBi` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign Key Into Format Table',
  `SeriesFKBi` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign Key into Series Table',
  PRIMARY KEY (`idBookInfo`, `TitleFKbi`, `AuthorFKbi`),
  UNIQUE INDEX `idBookInfo_UNIQUE` (`idBookInfo` ASC),
  INDEX `CategoryFKbI` (`CategoryFKbi` ASC),
  INDEX `AuthorFKbi` (`AuthorFKbi` ASC),
  INDEX `BookFormatFKBi` (`BookFormatBi` ASC),
  INDEX `SeriesFKBi` (`SeriesFKBi` ASC),
  INDEX `TitleFKbi` (`TitleFKbi` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`forsale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`forsale` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`forsale` (
  `BookFKfs` INT(10) UNSIGNED NOT NULL,
  `IsForSale` TINYINT(4) NOT NULL DEFAULT '0',
  `AskingPrice` DOUBLE NOT NULL DEFAULT '0',
  `EstimatedValue` DOUBLE NOT NULL DEFAULT '0',
  PRIMARY KEY (`BookFKfs`),
  INDEX `BookFKfs` (`BookFKfs` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`haveread`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`haveread` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`haveread` (
  `BookFKhr` INT(10) UNSIGNED NOT NULL,
  `HaveReadBook` TINYINT(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`BookFKhr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`isbn`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`isbn` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`isbn` (
  `BookFKiSBN` INT(10) UNSIGNED NOT NULL,
  `ISBNumber` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`ISBNumber`, `BookFKiSBN`),
  INDEX `ISBNumber` (`ISBNumber` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`owned`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`owned` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`owned` (
  `BookFKo` INT(10) UNSIGNED NOT NULL,
  `IsOwned` TINYINT(4) NOT NULL,
  `IsWishListed` TINYINT NOT NULL,
  PRIMARY KEY (`BookFKo`),
  INDEX `BookFKo` (`BookFKo` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`publishinginfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`publishinginfo` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`publishinginfo` (
  `BookFKPubI` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign Key into the Book Info Table.',
  `Copyright` VARCHAR(4) NOT NULL,
  `Edition` INT(10) UNSIGNED NULL DEFAULT NULL,
  `Publisher` VARCHAR(45) NULL DEFAULT NULL,
  `OutOfPrint` TINYINT(4) NULL DEFAULT NULL COMMENT 'Is the book still being printed or has it lapsed.',
  `Printing` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'A book may be printed may times. This will indicate which printing it is. Check the back of the title page.',
  PRIMARY KEY (`BookFKPubI`),
  INDEX `BookFKPubI` (`BookFKPubI` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`purchaseinfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`purchaseinfo` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`purchaseinfo` (
  `BookFKPurI` INT(10) UNSIGNED NOT NULL,
  `PuchaseDate` DATE NULL DEFAULT NULL,
  `ListPrice` DOUBLE NULL DEFAULT NULL,
  `PaidPrice` DOUBLE NULL DEFAULT NULL,
  `Vendor` VARCHAR(64) NULL DEFAULT NULL,
  PRIMARY KEY (`BookFKPurI`),
  INDEX `BookFKPurI` (`BookFKPurI` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`series`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`series` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`series` (
  `idSeries` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `AuthorFK` INT(10) UNSIGNED NOT NULL COMMENT 'Foriegn Key into Author Table',
  `SeriesName` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`idSeries`, `AuthorFK`, `SeriesName`),
  UNIQUE INDEX `idSeries_UNIQUE` (`idSeries` ASC),
  INDEX `AuthorFKs` (`AuthorFK` ASC),
  INDEX `SeriesTitle` (`SeriesName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`signedbyauthor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`signedbyauthor` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`signedbyauthor` (
  `BookFKsba` INT(10) UNSIGNED NOT NULL,
  `IsSignedByAuthor` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`BookFKsba`),
  INDEX `BookFKsba` (`BookFKsba` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`title`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`title` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`title` (
  `idTitle` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `TitleStr` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`idTitle`, `TitleStr`),
  UNIQUE INDEX `idTitle_UNIQUE` (`idTitle` ASC),
  INDEX `TitleStr` (`TitleStr` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `booklibinventory`.`volumeinseries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `booklibinventory`.`volumeinseries` ;

CREATE TABLE IF NOT EXISTS `booklibinventory`.`volumeinseries` (
  `BookFKvs` INT(10) UNSIGNED NOT NULL,
  `SeriesFK` INT(10) UNSIGNED NOT NULL,
  `VolumeNumber` INT(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`BookFKvs`),
  INDEX `BookFKvs` (`BookFKvs` ASC),
  INDEX `SeriesFKvs` (`SeriesFK` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `booklibinventory` ;

-- -----------------------------------------------------
-- procedure UpdateAuthor
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`UpdateAuthor`;

DELIMITER $$
USE `booklibinventory`$$
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

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addAuthor`;

DELIMITER $$
USE `booklibinventory`$$
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
-- procedure addBookToLibrary
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addBookToLibrary`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addBookToLibrary`
(
    IN categoryName VARCHAR(45),
    IN authorLastName VARCHAR(20),
    IN authorFirstName VARCHAR(20),
    IN titleStr VARCHAR(128), 
    IN bookFormatStr VARCHAR(45),
    IN copyright VARCHAR(4),
    IN edition INT,
    IN printing INT,
    IN publisher VARCHAR(45),
    IN outOfPrint TINYINT,
    IN seriesName VARCHAR(128),
    IN volumeNumber INT,
    IN iSBNumber VARCHAR(32),
    IN iSignedByAuthor TINYINT,
    IN isOwned TINYINT,
    IN isWishListed TINYINT,
    IN isForSale TINYINT,
    IN askingPrice DOUBLE,
    IN estimatedValue DOUBLE,
    IN haveRead TINYINT,
    IN bookDescription VARCHAR(1024),
    OUT bookKey INT
)
BEGIN

    -- All book data except for purchasing data will be added directly or indirectly from this procedure.
    -- Purchasing data will be handled outside of this procedure because the book may be added to a wishlist
    -- instead of added to the library.
    -- Each independent portion of the data will have it's own add procedure that will be called here.

    DECLARE authorKey, categoryKey,  formatKey, seriesKey, titleKey INT default 0;

    SET @bookKey = 0;

    SET @authorKey = findAuthorKey(authorFirstName, authorLastName);
    
    -- If the author isn't found then the user has to add the author before they add any books or
    -- Series by the author.
    if @authorKey IS NOT NULL then
        SET @formatKey = getformatKeyFromStr(BookFormatStr);
        IF @formatKey IS NOT NULL THEN
            SET @seriesKey = findSeriesKeyByAuthKeyTitle(@authorKey, @SeriesName);
            SET @titleKey = InsertTitleIfNotExist(titleStr);
            SET @categoryKey = getCategoryKeyFromStr(categoryName);
            
            SET @bookKey = findbookKeyFromKeys(@authorKey, @titleKey, @formatKey);
            IF @bookKey IS NULL THEN
                -- Don't add a book if it is already in the library. There will be special cases such as when a book has been signed by the author
                -- but these will be added later.
                INSERT INTO bookinfo (bookinfo.AuthorFKbi, bookinfo.TitleFKbi, bookinfo.CategoryFKbi, bookinfo.BookFormatFKbi, bookinfo.SeriesFKbi)
                    VALUES (@authorKey, @titleKey, @categoryKey, @formatKey, @seriesKey);

                SET bookKey = findbookKeyFromKeys(@authorKey, @titleKey, @formatKey);
                
                CALL addOrUpdatePublishing(@bookKey, copyright, edition, printing, publisher, outOfPrint);
                IF iSBNumber IS NOT NULL OR LENGTH(iSBNumber) > 1 THEN
                    -- Books older than 1985 may not have an isbn printed on them any where.
                    CALL addOrUpdateISBN(@bookKey, iSBNumber);
                END IF;
                CALL addOrUpdateOwned(@bookKey, isOwned, isWishListed);
                CALL addOrUpdateHaveRead(@bookKey, haveRead);
                CALL addOrUpdateVolumeInSeries(@bookKey, volumeNumber);
                IF isOwned > 0 AND haveRead > 0 THEN
                    CALL addOrUpdateForSale(@bookKey, isForSale, askingPrice, estimatedValue);
                END IF;
                CALL addOrUpdateIsSignedByAuthor(@bookKey, iSignedByAuthor);
                IF bookDescription IS NOT NULL OR LENGTH(bookDescription) < 1 THEN
                    -- Try to save space if there is no description.
                    CALL addOrUpdateBookDescription(@bookKey, bookDescription);
                END IF;
            END IF;
            
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buyBook
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`buyBook`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `buyBook`
(
    IN categoryName VARCHAR(45),
    IN authorLastName VARCHAR(20),
    IN authorFirstName VARCHAR(20),
    IN titleStr VARCHAR(128), 
    IN bookFormatStr VARCHAR(45),
    IN copyright VARCHAR(4),
    IN edition INT,
    IN printing INT,
    IN publisher VARCHAR(45),
    IN outOfPrint TINYINT,
    IN seriesName VARCHAR(128),
    IN volumeNumber INT,
    IN iSBNumber VARCHAR(32),
    IN iSignedByAuthor TINYINT,
    IN isOwned TINYINT,
    IN isWishListed TINYINT,
    IN isForSale TINYINT,
    IN askingPrice DOUBLE,
    IN estimatedValue DOUBLE,
    IN haveRead TINYINT,
    IN bookDescription VARCHAR(1024),
    IN purchaseDate DATE,
    IN listPrice DOUBLE,
    IN pricePaid DOUBLE,
    IN vendor VARCHAR(64)
)
BEGIN

    DECLARE bookKey INT;
    
    CALL addBookToLibrary(
        categoryName,
        authorLastName,
        authorFirstName,
        titleStr, 
        bookFormatStr,
        copyright,
        edition,
        printing,
        publisher,
        outOfPrint,
        seriesName,
        volumeNumber,
        iSBNumber,
        iSignedByAuthor,
        isOwned,
        isWishListed,
        isForSale,
        askingPrice,
        estimatedValue,
        haveRead,
        bookDescription,
        @bookKey
    );
    
    IF @bookKey IS NOT NULL AND @bookKey > 0 THEN
        CALL addOrUpdatePurchaseInfo(@bookKey, purchaseDate, listPrice, pricePaid, vendor);
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findAuthorKey
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findAuthorKey`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `findAuthorKey`(
    firstName VARCHAR(20),
    lastName VARCHAR(20)
) RETURNS INT
BEGIN
    
    DECLARE authorKeyKey, authorCount INT;
    
    SELECT COUNT(*) INTO authorCount FROM authorstab;
    IF authorCount > 0 THEN
        SELECT authorstab.idAuthors INTO @authorKey
            FROM authorstab
            WHERE authorsTab.LastName = lastName AND authorsTab.FirstName = firstName;
        IF @authorKey IS NULL THEN
            SET @authorKey = 0;
        END IF;
    ELSE
        SET @authorKey = 0;
    END IF;

    RETURN @authorKey;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findbookKey
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findbookKey`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `findbookKey`(
    authorLast VARCHAR(20),
    authorFirst VARCHAR(20),
    titleStr VARCHAR(128),
    formatStr VARCHAR(45)
) RETURNS int(11)
BEGIN

    DECLARE bookKey, authorKey, titleKey, formatKey INT DEFAULT NULL;
    
    SET @authorKey = findauthorKey(authorFirst, authorLast);
    
    SET @titleKey = findtitleKey(titleStr);
    
    SET @formatKey = getformatKeyFromStr(formatStr);
    
    IF authorKey > 0 AND titleKey > 0 THEN
        SET bookKey = findbookKeyFromKeys(@authorKey, @titleKey, @formatKey);
    END IF;
    
    RETURN @bookKey;
        
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findbookKeyFromKeys
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findbookKeyFromKeys`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `findbookKeyFromKeys`(
    authorKey INT,
    titleKey INT,
    formatKey INT
) RETURNS int(11)
BEGIN

    DECLARE bookKey INT DEFAULT NULL;
    
    IF authorKey IS NOT NULL AND titleKey IS NOT NULL then
        SELECT bookinfo.idBookInfo INTO @bookKey 
            FROM BookInfo 
            WHERE bookinfo.AuthorFKbi = authorKey AND bookinfo.TitleFKbi = titleKey AND bookinfo.FormatFKbi = formatKey;
    END IF;
    
    RETURN bookKey;
        
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findtitleKey
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findtitleKey`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `findtitleKey`(
    TitleStr VARCHAR(128)
) RETURNS int(11)
BEGIN

    DECLARE titleKey INT DEFAULT NULL;
    
    SELECT title.idTitle INTO titleKey FROM title WHERE title.TitleStr = TitleStr;
    
    RETURN titleKey;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksInLib
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllBooksInLib`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllBooksInLib`()
BEGIN

    DECLARE whereClaus VARCHAR(256);
    
    SET @whereClause = 'o.IsOwned = 1';

    CALL getAllBookDataWhere(@whereClause);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllSeriesByThisAuthor
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllSeriesByThisAuthor`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllSeriesByThisAuthor`(
    IN AuthorLastName VARCHAR(20),
    IN AuthorFirstName VARCHAR(20)
)
BEGIN

    DECLARE authorKey INT DEFAULT NULL;
    
    SET authorKey = findauthorKey(AuthorFirstName, AuthorLastName);
    
    SELECT series.SeriesName FROM series WHERE series.AuthorFK = authorKey;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllSeriesData
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllSeriesData`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllSeriesData`()
BEGIN

    SELECT a.LastName, a.FirstName, s.SeriesName
        FROM series AS s
        INNER JOIN authorstab AS a
        ON a.idAuthors = s.AuthorFK
        ORDER BY a.LastName, a.FirstName, s.SeriesName;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getBookData
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getBookData`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getBookData`(
    IN authorLast VARCHAR(20),
    IN authorFirst VARCHAR(20),
    IN titleStr VARCHAR(128),
    IN formatStr VARCHAR(45)
)
BEGIN

    DECLARE bookKey INT;
    DECLARE whereClause VARCHAR(256);
    
    SET @bookKey = findbookKey(authorLast, authorFirst, titleStr, formatStr);
    
    SET @whereClause = CONCAT('tmp.idBookInfo = ', @bookKey);
    
    CALL getAllBooDataWhere(@whereClause);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getWishListBooks
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getWishListBooks`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getWishListBooks`()
BEGIN

CREATE temporary table tmp engine=memory
    SELECT idBookInfo, AuthorFK, TitleFK, SeriesFK, BookFormatFK from BookInfo LEFT JOIN (Owned)
    ON (BookInfo.idBookInfo = Owned.BookFK)
    WHERE Owned.IsOwned = 0;
 
SELECT a.LastName, a.FirstName, t.TitleStr, i.ISBNumber, pub.Copyright, s.SeriesName, v.VolumeNumber
    FROM tmp
    LEFT JOIN (AuthorsTab AS a, Title AS t, ISBN AS i, PublishingInfo AS pub, Series AS s, VolumeInSeries AS v)
        ON (tmp.AuthorFK = a.idAuthors, tmp.TitleFK = t.idTitle, tmp.idBookInfo = i.BookFK, 
            tmp.idBookInfo = pub.BookFK, tmp.SeriesFK = Series.idSeries, tmp.idBookInfo = v.idVolumeInSeries)
    ORDER BY (a.LastName, a.FirstName) ASC;
    
    drop temporary table if exists tmp;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function insertTitleIfNotExist
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`insertTitleIfNotExist`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `insertTitleIfNotExist`(
    TitleStr VARCHAR(128)
) RETURNS int(11)
BEGIN

    DECLARE titleKey INT DEFAULT NULL;

    SET titleKey = findtitleKey(TitleStr);
    if titleKey IS NULL then
        INSERT INTO title (title.TitleStr) VALUES(TitleStr);
        SET titleKey = findtitleKey(titleStr);
    END IF;
    
    RETURN titleKey;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksByThisAuthor
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllBooksByThisAuthor`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllBooksByThisAuthor` 
(
    IN authorLastName VARCHAR(20),
    IN authorFirstName VARCHAR(20)
)
BEGIN

    DECLARE authorKey INT DEFAULT NULL;
    DECLARE whereClause VARCHAR(256);
    
    SET @authorKey = findauthorKey(authorFirstName, authorLastName);
    SET @whereClause = CONCAT('tmp.AuthorFKbi = ', @authorKey);

    CALL getAllBooDataWhere(@whereClause);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBookDataWhere
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllBookDataWhere`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllBookDataWhere` 
(
    IN whereClause VARCHAR(256)
)
BEGIN

    /*
     * This procedure is called by a number of procedures that have a specific where clause.
     * The fields being selected and the tables being joined will always be the same.
     * To prevent indexes from being returned fields are specified rather than * in the select.
     *  To add a field being selected edit the allBooksSelectedFields function.
     *  To add a table edit the allBooksJoinOnFields and allBooksDataTables functions.
     *  In the C# GUI the user can choose what fields to display in most cases.
     */
    
    DECLARE finalQuery VARCHAR(4096);
    DECLARE selectedFields, leftJoinTables, joinOnFields VARCHAR(1024);
    
    SET @selectedFields = allBooksSelectedFields();
    SET @joinOnFields = allBooksJoinOnFields();
    SET @leftJoinTables = allBooksDataTables();
    
    SET @finalQuery = CONCAT(
        'SELECT ',
            @selectedFields,
        ' FROM bookinfo AS tmp LEFT JOIN (',
            @leftJoinTables,
        ') ON (',
            @joinOnFields,
        ') WHERE (',
            @whereClause,
        ') ORDER BY (a.LastName, a.FirstName, t.TitleStr) ASC;');
        
    PREPARE stmt FROM @finalQuery;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- function allBooksSelectFields
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`allBooksSelectFields`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `allBooksSelectFields` ()
RETURNS VARCHAR(1024)
BEGIN

    DECLARE selectFields VARCHAR(1024);

    -- To add a field to be selected add a CONCAT statement.

    SET @selectFields = 'a.LastName, ';
    SET @selectFields = CONCAT(@selectFields, 'a.FirstName, ');
    SET @selectFields = CONCAT(@selectFields, 't.TitleStr, ');
    SET @selectFields = CONCAT(@selectFields, 'bf.FormatName, ');
    SET @selectFields = CONCAT(@selectFields, 'BCat.CategoryName, ');
    SET @selectFields = CONCAT(@selectFields, 'i.ISBNumber, ');
    SET @selectFields = CONCAT(@selectFields, 'pub.Copyright, ');
    SET @selectFields = CONCAT(@selectFields, 'pub.Edition, ');
    SET @selectFields = CONCAT(@selectFields, 'pub.Publisher, ');
    SET @selectFields = CONCAT(@selectFields, 'pub.OutOfPrint, ');
    SET @selectFields = CONCAT(@selectFields, 'pub.Printing, ');
    SET @selectFields = CONCAT(@selectFields, 's.SeriesName, ');
    SET @selectFields = CONCAT(@selectFields, 'v.VolumeNumber, ');
    SET @selectFields = CONCAT(@selectFields, 'pur.PurchaseDate, ');
    SET @selectFields = CONCAT(@selectFields, 'pur.ListPrice, ');
    SET @selectFields = CONCAT(@selectFields, 'pur.PaidPrice, ');
    SET @selectFields = CONCAT(@selectFields, 'pur.Vendor, ');
    SET @selectFields = CONCAT(@selectFields, 'sba.Printing, ');
    SET @selectFields = CONCAT(@selectFields, 'o.IsOwned, ');
    SET @selectFields = CONCAT(@selectFields, 'o.IsWishListed, ');
    SET @selectFields = CONCAT(@selectFields, 'hr.HaveReadBook, ');
    SET @selectFields = CONCAT(@selectFields, 'fs.IsForSale, ');
    SET @selectFields = CONCAT(@selectFields, 'fs.AskingPrice, ');
    SET @selectFields = CONCAT(@selectFields, 'fs.EstimatedValue, ');
    SET @selectFields = CONCAT(@selectFields, 'BDesc.BookDescription ');

    RETURN @selectFields;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function allBooksJoinOnFields
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`allBooksJoinOnFields`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `allBooksJoinOnFields` ()
RETURNS VARCHAR(1024)
BEGIN

    DECLARE joinOnFields VARCHAR(1024);
    
    -- To add a table to be joined add a CONCAT statement.

    SET @joinOnFields = 'a.idAuthors = tmp.AuthorFKib, ';
    SET @joinOnFields = CONCAT(@joinOnFields, 't.idTitle = tmp.TitleFK, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'bf.idFormat = tmp.BookFormatFKBi, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'BCat.idBookCategories = tmp.CategoryFKbI, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 's.idSeries = tmp.SeriesFK, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'v.BookFK = tmp.idBookInfo, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'sba.BookFKsba = tmp.idBookInfo, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'pub.BookFKPubI = tmp.idBookInfo, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'o.BookFK = tmp.idBookInfo, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'fr.BookFK = tmp.idBookInfo, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'hr.BookFK = tmp.idBookInfo, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'i.BookFK = tmp.idBookInfo, ');
    SET @joinOnFields = CONCAT(@joinOnFields, 'BDesk.BookFKbd = tmp.idBookInfo ');
    
    RETURN @joinOnFields;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function allBooksDataTables
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`allBooksDataTables`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `allBooksDataTables` ()
RETURNS VARCHAR(1024)
BEGIN

    DECLARE leftJoinTables VARCHAR(1024);

    -- To add a table to be joined add a CONCAT statement.

    SET @leftJoinTables = '`AuthorsTab AS a, ';
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'title AS t, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'isbn AS i, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'bookformat AS bf, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'bookcategories AS BCat, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'signedbyauthor AS sba, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'purchasinfo AS pur, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'publishinginfo AS pub, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'series AS s, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'volumeinseries AS v, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'owned AS o, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'forsale AS fs, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'haveread AS hr, ');
    SET @leftJoinTables = CONCAT(@leftJoinTables, 'bookdescription AS BDesk ');
    
    RETURN @leftJoinTables;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addOrUpdatePublishing
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdatePublishing`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdatePublishing` 
(
    IN bookKey INT,
    IN copyright VARCHAR(4),
    IN edition INT,
    IN printing INT,
    IN publisher VARCHAR(45),
    IN outOfPrint TINYINT
)
BEGIN

    DECLARE testCopyright VARCHAR(4);
    
    SELECT publishinginfo.Copyright INTO @testCopyright FROM publishinginfo WHERE publishinginfo.BookFK = bookKey;
    
    IF @testCopyright IS NULL THEN
        INSERT INTO publishinginfo (
                publishinginfo.BookFK,
                publishinginfo.Copyright,
                publishinginfo.Edition,
                publishinginfo.Printing,
                publishinginfo.Publisher,
                publishinginfo.OutOfPrint
            )
            VALUES(
                bookKey,
                copyright,
                edition,
                printing,
                publisher,
                outOfPrint
            )
        ;
    ELSE
        UPDATE publishinginfo
            SET
                publishinginfo.Copyright = copyright,
                publishinginfo.Edition = edition,
                publishinginfo.Printing = printing,
                publishinginfo.Publisher = publisher,
                publishinginfo.Copyright = outOfPrint
            WHERE publishinginfo.BookFK = bookKey;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addOrUpdateOwned
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdateOwned`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdateOwned` 
(
    IN bookKey INT,
    IN isOwned TINYINT,
    IN isWishListed TINYINT
)
BEGIN

    DECLARE testKey INT;
    
    SELECT owned.BookFKo INTO @testKey FROM owned WHERE owned.BookFKo = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO owned (
                owned.BookFKo,
                owned.IsOwned,
                owned.IsWishListed
            )
            VALUES(
                bookKey,
                isOwned,
                isWishListed
            )
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
-- procedure addOrUpdateHaveRead
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdateHaveRead`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdateHaveRead`
(
    IN bookKey INT,
    IN haveRead TINYINT
)
BEGIN

    DECLARE testKey INT;
    
    SELECT haveread.BookFKhr INTO @testKey FROM haveread WHERE haveread.BookFKhr = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO haveread (
                haveread.BookFKhr,
                haveread.HaveReadBook
            )
            VALUES(
                bookKey,
                haveRead
            )
        ;
    ELSE
        UPDATE HaveRead
            SET
                haveread.HaveReadBook = haveRead
            WHERE haveread.BookFKhr = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addOrUpdateVolumeInSeries
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdateVolumeInSeries`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdateVolumeInSeries` 
(
    IN bookKey INT,
    IN volumeNumber INT,
    IN seriesKey INT
)
BEGIN

    DECLARE testKey INT;
    
    SELECT volumeinseries.BookFKo INTO @testKey FROM volumeinseries WHERE volumeinseries.BookFKo = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO volumeinseries (
                volumeinseries.BookFKvs,
                volumeinseries.SeriesFK,
                volumeinseries.VolumeNumber
            )
            VALUES(
                bookKey,
                seriesKey,
                volumeNumber
            )
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
-- procedure addOrUpdateForSale()
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdateForSale()`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdateForSale()`
(
    IN bookKey INT,
    IN isForSale TINYINT,
    IN askingPrice DOUBLE,
    IN estimatedValue DOUBLE
)
BEGIN

    DECLARE testKey INT;
    
    SELECT forsale.BookFKfs INTO @testKey FROM forsale WHERE forsale.BookFKfs = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO forsale (
                forsale.BookFKcs,
                forsale.IsForSale,
                forsale.AskingPrice,
                forsale.EstimatedValue
            )
            VALUES(
                bookKey,
                isForSale,
                askingPrice,
                estimatedValue
            )
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
-- procedure addOrUpdateIsSignedByAuthor
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdateIsSignedByAuthor`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdateIsSignedByAuthor` 
(
    IN bookKey INT,
    IN isSignedByAuthor TINYINT
)
BEGIN

    DECLARE testKey INT;
    
    SELECT signedbyauthor.BookFKsba INTO @testKey FROM signedbyauthor WHERE signedbyauthor.BookFKsba = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO signedbyauthor (
                signedbyauthor.BookFKsba,
                signedbyauthor.IsSignedByAuthor
            )
            VALUES(
                bookKey,
                isSignedByAuthor
            )
        ;
    ELSE
        UPDATE signedbyauthor
            SET
                signedbyauthor.IsSignedByAuthor = isSignedByAuthor
            WHERE signedbyauthor.BookFKsba = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addOrUpdateBookDescription
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdateBookDescription`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdateBookDescription`
(
    IN bookKey INT,
    IN bookDescription VARCHAR(1024)
)
BEGIN

    DECLARE testKey INT;
    
    SELECT bookdescription.BookFKbd INTO @testKey FROM bookdescription WHERE bookdescription.BookFKbd = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO bookdescription (
                bookdescription.BookFKbd,
                bookdescription.BookDescription
            )
            VALUES(
                bookKey,
                bookDescription
            )
        ;
    ELSE
        UPDATE bookdescription
            SET
                bookdescription.BookDescription = bookDescription
            WHERE bookdescription.BookFKbd = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addOrUpdateISBN
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdateISBN`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdateISBN`
(
    IN bookKey INT,
    iSBNumber VARCHAR(30)
)
BEGIN

    DECLARE testKey INT;
    
    SELECT isbn.BookFKiSBN INTO @testKey FROM isbn WHERE isbn.BookFKiSBN = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO isbn (
                isbn.BookFKiSBN,
                isbn.ISBNumber
            )
            VALUES(
                bookKey,
                iSBNumber
            )
        ;
    ELSE
        UPDATE HaveRead
            SET
                isbn.ISBNumber = iSBNumber
            WHERE isbn.BookFKiSBN = bookKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addOrUpdatePurchaseInfo
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addOrUpdatePurchaseInfo`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addOrUpdatePurchaseInfo`
(
    IN bookKey INT,
    IN purchaseDate DATE,
    IN listPrice DOUBLE,
    IN pricePaid DOUBLE,
    vendor VARCHAR(64)
)
BEGIN

    DECLARE testKey INT;
    
    SELECT purchaseinfo.BookFKPurI INTO @testKey FROM purchaseinfo WHERE purchaseinfo.BookFK = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO purchaseinfo
            (
                purchaseinfo.BookFKPurI,
                purchaseinfo.PurchaseDate,
                purchaseinfo.ListPrice,
                purchaseinfo.PaidPrice,
                purchaseinfo.Vendor
            )
            VALUES(
                bookKey,
                purchaseDate,
                listPrice,
                pricePaid,
                vendor
            )
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
-- function getCategoryKeyFromStr
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`getCategoryKeyFromStr`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `getCategoryKeyFromStr`
(
    categoryName VARCHAR(45)
)
RETURNS INT
BEGIN
    DECLARE categoryKey, categoryCount INT DEFAULT NULL;
    
    SELECT COUNT(*) INTO categoryCount FROM bookcategories;
    IF categoryCount > 0 THEN
        SELECT bookcategories.idBookCategories INTO @categoryKey
            FROM bookcategories
            WHERE bookcategories.CategoryName = categoryName;
        IF @categoryKey IS NULL THEN
            SET @categoryKey = 0;
        END IF;
    ELSE
        SET @categoryKey = 0;
    END IF;

    RETURN @categoryKey;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addCategory
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addCategory`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addCategory`
(
    categoryName VARCHAR(45)
)
BEGIN

    DECLARE categoryKey INT;

    SET @categoryKey = getCategoryKeyFromStr(categoryName);
    
    -- Prevent adding the same category again to avoid breaking the unique key structure.
    IF @categoryKey < 1 THEN
        INSERT INTO bookcategories (bookcategories.CategoryName) VALUES(categoryName);
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBookCategoriesWithKeys
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllBookCategoriesWithKeys`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllBookCategoriesWithKeys` ()
BEGIN

/*
 * Example usage would be to get all the categories to CREATE a control that embeds the primary key rather than the text.
 */

    SELECT bookcategories.CategoryName, bookcategories.idBookCategories FROM bookcategories;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- function getFormatKeyFromStr
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`getFormatKeyFromStr`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `getFormatKeyFromStr`(
    bookFormatStr VARCHAR(45)
) RETURNS int(11)
BEGIN

    DECLARE formatKey, formatCount INT DEFAULT NULL;
    
    SELECT COUNT(*) INTO formatCount FROM bookformat;
    IF formatCount > 0 THEN
        SELECT bookformat.idFormat INTO @formatKey
            FROM bookformat
            WHERE bookformat.FormatName = bookFormatStr;
    ELSE
        SET @formatKey = 0;
    END IF;
    
    RETURN @formatKey;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addFormat
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addFormat`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addFormat` (IN bookFormatStr VARCHAR(45))
BEGIN

    DECLARE formatKey INT;
    
    SET @formatKey = getFormatKeyFromStr(bookFormatStr);
    
    -- Prevent adding the same format again to avoid breaking the unique key structure.
    IF @formatKey < 1 THEN
        INSERT INTO bookformat (bookformat.FormatName) VALUES(bookFormatStr);
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBookFormatsWithKeys
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllBookFormatsWithKeys`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllBookFormatsWithKeys`()
BEGIN

/*
 * Example usage would be to get all the formats to CREATE a control embeds the primary key rather than the text.
 */

    SELECT bookformat.FormatName, bookformat.idFormat FROM bookformat;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addAuthorSeries
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addAuthorSeries`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `addAuthorSeries`
(
    IN authorFirst VARCHAR(20),
    IN authorLast VARCHAR(20),
    IN seriesTitle VARCHAR(128)
)
BEGIN

    DECLARE authorKey, seriesKey INT;
    
    SET @authorKey = findAuthorKey(authorFirst, authorLast);
    
    IF @authorKey > 0 THEN
        SET @seriesKey = findSeriesKeyByAuthKeyTitle(@authorKey, seriesTitle);
    
        IF @seriesKey < 1 THEN
            INSERT INTO series (series.AuthorFK, series.SeriesName) VALUES(@authorKey, seriesTitle);
        END IF;
    END IF;

    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findSeriesKey
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findSeriesKey`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `findSeriesKey` 
(
    authorFirst VARCHAR(20),
    authorLast VARCHAR(20),
    seriesTitle VARCHAR(128)
)
RETURNS INT
BEGIN

    DECLARE authorKey, seriesKey INT DEFAULT NULL;
    
    SET @authorKey = findAuthorKey(authorFirst, authorLast);
    
    SET @seriesKey = findSeriesKeyByAuthKeyTitle(@authorKey, seriesTitle);
        
    RETURN @seriesKey;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function findSeriesKeyByAuthKeyTitle
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findSeriesKeyByAuthKeyTitle`;

DELIMITER $$
USE `booklibinventory`$$
CREATE FUNCTION `findSeriesKeyByAuthKeyTitle`
(
    authorKey INT,
    seriesTitle VARCHAR(128)
)
RETURNS INT
BEGIN

    DECLARE seriesKey INT DEFAULT NULL;
        
    IF authorKey > 0 THEN
        SELECT series.idSeries INTO @seriesKey FROM series WHERE series.AuthorFK = authorKey AND series.SeriesName = seriesTitle;
        IF @seriesKey IS NULL THEN
            SET @seriesKey = 0;
        END IF;
    ELSE
        SET @seriesKey = 0;
    END IF;
    
    RETURN @seriesKey;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteAuthor
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`deleteAuthor`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `deleteAuthor`
(
    IN authorFirst VARCHAR(20),
    IN authorMiddle VARCHAR(20),
    IN authorLast VARCHAR(20)
)
BEGIN
    -- This procedure deletes everything associated with the specified author
    -- including books, series and volumes in series. It affects almost every table
    -- in this database.
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllAuthorsData
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllAuthorsData`;

DELIMITER $$
USE `booklibinventory`$$
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

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAuthorDataByLastName`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAuthorDataByLastName`
(
    IN authorLastName VARCHAR(20)
)
BEGIN

    SELECT * FROM authorstab WHERE authorstab.LastName = authorLastName;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getThisAuthorsData
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getThisAuthorsData`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getThisAuthorsData`
(
    IN authorLastName VARCHAR(20),
    IN authorFirstName VARCHAR(20)
)
BEGIN

    SELECT * FROM authorstab WHERE authorstab.LastName = authorLastName AND authorstab.FirstName = authorFirstName;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure initBookInventoryTool
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`initBookInventoryTool`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `initBookInventoryTool` ()
BEGIN

-- Initialize some basic formats, user can add more later.
    CALL addFormat('Hard Cover');
    CALL addFormat('Trade Paperback');
    CALL addFormat('Mass Market Paperback');
    CALL addFormat('eBook PDF');
    CALL addFormat('eBook Kindle');
    CALL addFormat('eBook iBooks');
    CALL addFormat('eBook EPUB');
    CALL addFormat('eBook HTML');
SELECT COUNT(*) FROM booklibinventory.bookformat;

-- Initialize some basic categories, user can add more later.
    CALL addCategory('None Fiction');
    CALL addCategory('None Fiction: Biography');
    CALL addCategory('None Fiction: Biology');
    CALL addCategory('None Fiction: Computer');
    CALL addCategory('None Fiction: Electrical Engineering');
    CALL addCategory('None Fiction: History');
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
SELECT COUNT(*) FROM booklibinventory.bookcategories;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sellBook
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`sellBook`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `sellBook` 
(
    IN authorFirstName VARCHAR(20),
    IN authorLastName VARCHAR(20),
    IN bookTitle VARCHAR(128),
    IN bookFormat VARCHAR(45)
)
BEGIN

    DECLARE bookKey INT;
    
    SET @bookKey = findbookKey(authorLastName, authorFirstName, bookTitle, bookFormat);
    
    UPDATE owned 
        SET 
            owned.IsOwned = 0
        WHERE
            owned.BookFKo = @bookKey;
    
        DELETE FROM forsale 
        WHERE
            forsale.BookFKfs = @bookKey;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure readBook
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`readBook`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `readBook` (
    IN authorFirstName VARCHAR(20),
    IN authorLastName VARCHAR(20),
    IN bookTitle VARCHAR(128),
    IN bookFormat VARCHAR(45)
)
BEGIN

    DECLARE bookKey INT;
    
    SET @bookKey = findbookKey(authorLastName, authorFirstName, bookTitle, bookFormat);
    
    UPDATE haveread 
        SET 
            haveread.HaveReadBook = 1
        WHERE
            haveread.BookFKhr = @bookKey;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzTestAddAuthors
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzTestAddAuthors`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `zzzTestAddAuthors` ()
BEGIN

    DECLARE authorCount, authorKey INT DEFAULT 0;
    
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
    
    -- SELECT COUNT(*) INTO @authorCount FROM authorstab;
    SELECT COUNT(*) FROM authorstab;
    
    CALL getAllAuthorsData();

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzTestAddAuthorSeries
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzTestAddAuthorSeries`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `zzzTestAddAuthorSeries` ()
BEGIN

    CALL addAuthorSeries('David', 'Weber', 'Safehold');
    CALL addAuthorSeries('David', 'Weber', 'Honor Harrington');
    CALL addAuthorSeries('David', 'Weber', 'Honorverse');
    CALL addAuthorSeries('Marion', 'Zimmer Bradley', 'Darkover');
    CALL addAuthorSeries('Isaac', 'Asimov', 'Foundation');
    CALL addAuthorSeries('Stephen', 'Baxter', 'Northland');


    SELECT COUNT(*) FROM series;
    
    CALL getAllSeriesByThisAuthor('Weber', 'David');
    CALL getAllSeriesData();
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzTestAddBookToLibrary
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzTestAddBookToLibrary`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `zzzTestAddBookToLibrary` ()
BEGIN

    DECLARE bookKey INT;

    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'On Basilisk Station',  'Mass Market Paperback', '1993', 1, 9, 'Baen Books', 0, 'Honor Harrington', 1,
        '0-7434-3571-0', 0, 1, 0, 0, 8.99, 8.99, 1, 'bookDescription', @bookKey);
    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'Honor of the Queen',  'Mass Market Paperback', '1993', 1, 10, 'Baen Books', 0, 'Honor Harrington', 2,
        '978-0-7434-3572-7', 0, 1, 0, 0, 6.99, 6.99, 1, NULL, @bookKey);
    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'Short Victorious War',  'Mass Market Paperback', '1994', 1, 8, 'Baen Books', 0, 'Honor Harrington', 3,
        '0-7434-3573-7', 0, 1, 0, 0, 6.99, 6.99, 1, NULL, @bookKey);
    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'Field of Dishonor',  'Mass Market Paperback', '1994', 1, 6, 'Baen Books', 0, 'Honor Harrington', 4,
        '0-7434-3574-5', 0, 1, 0, 0, 7.99, 7.99, 1, NULL, @bookKey);
    CALL addBookToLibrary('Fiction: Science Fiction', 'Norton', 'Andre', 'Star Guard',  'Mass Market Paperback', '1955', 1, NULL, 'Harcourt', 0, NULL, NULL,
        NULL, 0, 0, 1, NULL, NULL, NULL, 1, NULL, @bookKey);
        
    SELECT COUNT(*) FROM bookinfo;
    
    SELECT * FROM bookinfo;
    
    Call getAllBooksInLib();


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure putBookUpForSale
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`putBookUpForSale`;

DELIMITER $$
USE `booklibinventory`$$
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

    DECLARE bookKey INT;
    
    SET @bookKey = findBookKey(authorLastName, authorLastName, bookTitle, bookFormat);
    
    CALL addOrUpdateForSale(@bookKey, 1, askingPrice, estimatedValue);

END$$

DELIMITER ;

CALL booklibinventory.initBookInventoryTool();
CALL booklibinventory.getAllBookCategoriesWithKeys();
CALL booklibinventory.getAllBookFormatsWithKeys();
CALL booklibinventory.zzzTestAddAuthors();
CALL booklibinventory.zzzTestAddAuthorSeries();

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
