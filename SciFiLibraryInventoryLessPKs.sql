
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
  `BookFormatFKbi` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign Key Into Format Table',
  `SeriesFKBi` INT(10) UNSIGNED NOT NULL COMMENT 'Foreign Key into Series Table',
  PRIMARY KEY (`idBookInfo`, `TitleFKbi`, `AuthorFKbi`),
  UNIQUE INDEX `idBookInfo_UNIQUE` (`idBookInfo` ASC),
  INDEX `CategoryFKbI` (`CategoryFKbi` ASC),
  INDEX `AuthorFKbi` (`AuthorFKbi` ASC),
  INDEX `BookFormatFKBi` (`BookFormatFKbi` ASC),
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
  `PurchaseDate` DATE NULL DEFAULT NULL,
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
-- function findBookKey
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findBookKey`;

DELIMITER $$
USE `booklibinventory`$$
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
-- function findBookKeyFromKeys
-- -----------------------------------------------------

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findBookKeyFromKeys`;

DELIMITER $$
USE `booklibinventory`$$
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

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findTitleKey`;

DELIMITER $$
USE `booklibinventory`$$
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

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`insertTitleIfNotExist`;

DELIMITER $$
USE `booklibinventory`$$
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

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findCategoryKeyFromStr`;

DELIMITER $$
USE `booklibinventory`$$
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

USE `booklibinventory`;
DROP function IF EXISTS `booklibinventory`.`findFormatKeyFromStr`;

DELIMITER $$
USE `booklibinventory`$$
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

    SET @seriesKey = 0;
        
    IF authorKey > 0 THEN
        SELECT series.idSeries INTO @seriesKey FROM series WHERE series.AuthorFK = authorKey AND series.SeriesName = seriesTitle;
        IF @seriesKey IS NULL THEN
            SET @seriesKey = 0;
        END IF;
    END IF;
    
    RETURN @seriesKey;

END$$

DELIMITER ;

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

    SET @bookKey = 0, @titleKey = 0, @formatKey = 0, @authorKey = 0, @seriesKey = 0;

    SET @authorKey = findAuthorKey(authorFirstName, authorLastName);
    
    -- If the author isn't found then the user has to add the author before they add any books or
    -- Series by the author.
    if @authorKey > 0 then
        SET @formatKey = findFormatKeyFromStr(BookFormatStr);
        IF @formatKey > 0 THEN
            SET @seriesKey = findSeriesKeyByAuthKeyTitle(@authorKey, SeriesName);
            SET @titleKey = insertTitleIfNotExist(titleStr);
            SET @categoryKey = findCategoryKeyFromStr(categoryName);
            
            SET @bookKey = findBookKeyFromKeys(@authorKey, @titleKey, @formatKey);
            IF @bookKey < 1 THEN
                -- Don't add a book if it is already in the library. There will be special cases such as when a book has been signed by the author
                -- but these will be added later.
                INSERT INTO bookinfo (bookinfo.AuthorFKbi, bookinfo.TitleFKbi, bookinfo.CategoryFKbi, bookinfo.BookFormatFKbi, bookinfo.SeriesFKbi)
                    VALUES (@authorKey, @titleKey, @categoryKey, @formatKey, @seriesKey);
                SET @bookKey := LAST_INSERT_ID();
                
                CALL insertOrUpdatePublishing(@bookKey, copyright, edition, printing, publisher, outOfPrint);
                IF iSBNumber IS NOT NULL OR LENGTH(iSBNumber) > 1 THEN
                    -- Mass Market Paperback Books older than 1985 may not have an isbn printed on them any where.
                    CALL insertOrUpdateISBN(@bookKey, iSBNumber);
                END IF;
                CALL insertOrUpdateOwned(@bookKey, isOwned, isWishListed);
                CALL insertOrUpdateHaveRead(@bookKey, haveRead);
                CALL insertOrUpdateVolumeInSeries(@bookKey, volumeNumber, @seriesKey);
                IF isOwned > 0 THEN
                    CALL insertOrUpdateForSale(@bookKey, isForSale, askingPrice, estimatedValue);
                END IF;
                CALL insertOrUpdateIsSignedByAuthor(@bookKey, iSignedByAuthor);
                IF bookDescription IS NOT NULL OR LENGTH(bookDescription) > 0 THEN
                    -- Try to save space if there is no description.
                    CALL insertOrUpdateBookDescription(@bookKey, bookDescription);
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
    IN bookDescription VARCHAR(1024),
    IN purchaseDate DATE,
    IN listPrice DOUBLE,
    IN pricePaid DOUBLE,
    IN vendor VARCHAR(64),
    OUT bookKey INT    -- allows the calling program or procedure to test for failure.
)
BEGIN

    
    -- Some fields such as IsOwned are added by default because the book was purchased.
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
        1,  -- IsOwned
        0,  -- IsWishlisted
        0,  -- IsForsale
        listPrice - 1.00,  -- Asking Price
        listPrice - 1.00,  -- Estimated Value
        0,  -- HaveReadBook
        bookDescription,
        @bookKey
    );
    
    IF @bookKey IS NOT NULL AND @bookKey > 0 THEN
        CALL insertOrUpdatePurchaseInfo(@bookKey, purchaseDate, listPrice, pricePaid, vendor);
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksForSale
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllBooksForSale`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllBooksForSale`()
BEGIN

    SELECT
            a.LastName,
            a.FirstName,
            t.TitleStr,
            bf.FormatName,
            BCat.CategoryName,
            i.ISBNumber,
            pub.Copyright,
            pub.Edition,
            pub.Publisher,
            pub.OutOfPrint,
            pub.Printing,
            s.SeriesName,
            v.VolumeNumber,
            pur.PurchaseDate,
            pur.ListPrice,
            pur.PaidPrice,
            pur.Vendor,
            sba.IsSignedByAuthor,
            o.IsOwned,
            o.IsWishListed,
            hr.HaveReadBook,
            fs.IsForSale,
            fs.AskingPrice,
            fs.EstimatedValue,
            BDesk.BookDescription
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN isbn AS i ON i.BookFKiSBN = BKI.idBookInfo
        LEFT JOIN signedbyauthor AS sba ON sba.BookFKsba = BKI.idBookInfo
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN haveread AS hr ON hr.BookFKhr = BKI.idBookInfo
        LEFT JOIN bookdescription AS BDesk ON BDesk.BookFKbd = BKI.idBookInfo 
        WHERE o.IsOwned = 1 AND fs.IsForSale = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
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

    SELECT
            a.LastName,
            a.FirstName,
            t.TitleStr,
            bf.FormatName,
            BCat.CategoryName,
            i.ISBNumber,
            pub.Copyright,
            pub.Edition,
            pub.Publisher,
            pub.OutOfPrint,
            pub.Printing,
            s.SeriesName,
            v.VolumeNumber,
            pur.PurchaseDate,
            pur.ListPrice,
            pur.PaidPrice,
            pur.Vendor,
            sba.IsSignedByAuthor,
            o.IsOwned,
            o.IsWishListed,
            hr.HaveReadBook,
            fs.IsForSale,
            fs.AskingPrice,
            fs.EstimatedValue,
            BDesk.BookDescription
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN isbn AS i ON i.BookFKiSBN = BKI.idBookInfo
        LEFT JOIN signedbyauthor AS sba ON sba.BookFKsba = BKI.idBookInfo
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN haveread AS hr ON hr.BookFKhr = BKI.idBookInfo
        LEFT JOIN bookdescription AS BDesk ON BDesk.BookFKbd = BKI.idBookInfo 
        WHERE o.IsOwned = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
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

    SELECT series.SeriesName FROM series WHERE series.AuthorFK = findauthorKey(AuthorFirstName, AuthorLastName);

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

    SET @bookKey = findBookKey(authorLast, authorFirst, titleStr, formatStr);
    
    SELECT
            a.LastName,
            a.FirstName,
            t.TitleStr,
            bf.FormatName,
            BCat.CategoryName,
            i.ISBNumber,
            pub.Copyright,
            pub.Edition,
            pub.Publisher,
            pub.OutOfPrint,
            pub.Printing,
            s.SeriesName,
            v.VolumeNumber,
            pur.PurchaseDate,
            pur.ListPrice,
            pur.PaidPrice,
            pur.Vendor,
            sba.IsSignedByAuthor,
            o.IsOwned,
            o.IsWishListed,
            hr.HaveReadBook,
            fs.IsForSale,
            fs.AskingPrice,
            fs.EstimatedValue,
            BDesk.BookDescription
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN isbn AS i ON i.BookFKiSBN = BKI.idBookInfo
        LEFT JOIN signedbyauthor AS sba ON sba.BookFKsba = BKI.idBookInfo
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN haveread AS hr ON hr.BookFKhr = BKI.idBookInfo
        LEFT JOIN bookdescription AS BDesk ON BDesk.BookFKbd = BKI.idBookInfo 
        WHERE BKI.idBookInfo = @bookKey;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllWishListBooks
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllWishListBooks`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllWishListBooks`()
BEGIN

    SELECT
            a.LastName,
            a.FirstName,
            t.TitleStr,
            BCat.CategoryName,
            pub.Copyright,
            pub.Edition,
            pub.Publisher,
            pub.OutOfPrint,
            pub.Printing,
            s.SeriesName,
            v.VolumeNumber,
            o.IsOwned,
            o.IsWishListed,
            hr.HaveReadBook
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN haveread AS hr ON hr.BookFKhr = BKI.idBookInfo
        WHERE o.IsWishListed = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;
    
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

    SET @authorKey = findauthorKey(authorFirstName, authorLastName);

    SELECT
            a.LastName,
            a.FirstName,
            t.TitleStr,
            bf.FormatName,
            BCat.CategoryName,
            i.ISBNumber,
            pub.Copyright,
            pub.Edition,
            pub.Publisher,
            pub.OutOfPrint,
            pub.Printing,
            s.SeriesName,
            v.VolumeNumber,
            pur.PurchaseDate,
            pur.ListPrice,
            pur.PaidPrice,
            pur.Vendor,
            sba.IsSignedByAuthor,
            o.IsOwned,
            o.IsWishListed,
            hr.HaveReadBook,
            fs.IsForSale,
            fs.AskingPrice,
            fs.EstimatedValue,
            BDesk.BookDescription
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN isbn AS i ON i.BookFKiSBN = BKI.idBookInfo
        LEFT JOIN signedbyauthor AS sba ON sba.BookFKsba = BKI.idBookInfo
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN haveread AS hr ON hr.BookFKhr = BKI.idBookInfo
        LEFT JOIN bookdescription AS BDesk ON BDesk.BookFKbd = BKI.idBookInfo 
        WHERE BKI.AuthorFKbi = @authorKey
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllBooksThatWereRead
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`getAllBooksThatWereRead`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `getAllBooksThatWereRead` 
(
)
BEGIN

    SELECT
            a.LastName,
            a.FirstName,
            t.TitleStr,
            bf.FormatName,
            BCat.CategoryName,
            i.ISBNumber,
            pub.Copyright,
            pub.Edition,
            pub.Publisher,
            pub.OutOfPrint,
            pub.Printing,
            s.SeriesName,
            v.VolumeNumber,
            pur.PurchaseDate,
            pur.ListPrice,
            pur.PaidPrice,
            pur.Vendor,
            sba.IsSignedByAuthor,
            o.IsOwned,
            o.IsWishListed,
            hr.HaveReadBook,
            fs.IsForSale,
            fs.AskingPrice,
            fs.EstimatedValue,
            BDesk.BookDescription
        FROM bookinfo AS BKI 
        INNER JOIN authorsTab AS a ON a.idAuthors = BKI.AuthorFKbi
        INNER JOIN title AS t ON t.idTitle = BKI.TitleFKbi
        INNER JOIN bookformat AS bf ON bf.idFormat = BKI.BookFormatFKBi
        INNER JOIN bookcategories AS BCat ON BCat.idBookCategories = BKI.CategoryFKbI
        LEFT JOIN isbn AS i ON i.BookFKiSBN = BKI.idBookInfo
        LEFT JOIN signedbyauthor AS sba ON sba.BookFKsba = BKI.idBookInfo
        LEFT JOIN publishinginfo AS pub ON pub.BookFKPubI = BKI.idBookInfo
        LEFT JOIN purchaseinfo AS pur ON pur.BookFKPurI = BKI.idBookInfo
        LEFT JOIN series AS s ON s.idSeries = BKI.SeriesFKbi
        LEFT JOIN volumeinseries AS v ON v.BookFKvs = BKI.idBookInfo
        LEFT JOIN owned AS o ON o.BookFKo = BKI.idBookInfo
        LEFT JOIN forsale AS fs ON fs.BookFKfs = BKI.idBookInfo
        LEFT JOIN haveread AS hr ON hr.BookFKhr = BKI.idBookInfo
        LEFT JOIN bookdescription AS BDesk ON BDesk.BookFKbd = BKI.idBookInfo 
        WHERE hr.HaveReadBook = 1
        ORDER BY a.LastName, a.FirstName, s.SeriesName, v.VolumeNumber, t.TitleStr;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdatePublishing
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdatePublishing`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdatePublishing` 
(
    IN bookKey INT,
    IN copyright VARCHAR(4),
    IN edition INT,
    IN printing INT,
    IN publisher VARCHAR(45),
    IN outOfPrint TINYINT
)
BEGIN

   --  DECLARE testCopyright VARCHAR(4);
    
    SELECT publishinginfo.Copyright INTO @testCopyright FROM publishinginfo WHERE publishinginfo.BookFKPubI = bookKey;
    
    IF @testCopyright IS NULL THEN
        INSERT INTO publishinginfo (
                publishinginfo.BookFKPubI,
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
            WHERE publishinginfo.BookFKPubI = bookKey;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertOrUpdateOwned
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdateOwned`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdateOwned` 
(
    IN bookKey INT,
    IN isOwned TINYINT,
    IN isWishListed TINYINT
)
BEGIN

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
-- procedure insertOrUpdateHaveRead
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdateHaveRead`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdateHaveRead`
(
    IN bookKey INT,
    IN haveRead TINYINT
)
BEGIN

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
-- procedure insertOrUpdateVolumeInSeries
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdateVolumeInSeries`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdateVolumeInSeries` 
(
    IN bookKey INT,
    IN volumeNumber INT,
    IN seriesKey INT
)
BEGIN

    SELECT volumeinseries.BookFKvs INTO @testKey FROM volumeinseries WHERE volumeinseries.BookFKvs = bookKey;
    
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
-- procedure insertOrUpdateForSale()
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdateForSale`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdateForSale`
(
    IN bookKey INT,
    IN isForSale TINYINT,
    IN askingPrice DOUBLE,
    IN estimatedValue DOUBLE
)
BEGIN

    SELECT forsale.BookFKfs INTO @testKey FROM forsale WHERE forsale.BookFKfs = bookKey;
    
    IF @testKey IS NULL THEN
        INSERT INTO forsale (
                forsale.BookFKfs,
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
-- procedure insertOrUpdateIsSignedByAuthor
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdateIsSignedByAuthor`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdateIsSignedByAuthor` 
(
    IN bookKey INT,
    IN isSignedByAuthor TINYINT
)
BEGIN

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
-- procedure insertOrUpdateBookDescription
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdateBookDescription`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdateBookDescription`
(
    IN bookKey INT,
    IN bookDescription VARCHAR(1024)
)
BEGIN

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
-- procedure insertOrUpdateISBN
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdateISBN`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdateISBN`
(
    IN bookKey INT,
    iSBNumber VARCHAR(30)
)
BEGIN
    
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
-- procedure insertOrUpdatePurchaseInfo
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`insertOrUpdatePurchaseInfo`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `insertOrUpdatePurchaseInfo`
(
    IN bookKey INT,
    IN purchaseDate DATE,
    IN listPrice DOUBLE,
    IN pricePaid DOUBLE,
    vendor VARCHAR(64)
)
BEGIN

    SELECT purchaseinfo.BookFKPurI INTO @testKey FROM purchaseinfo WHERE purchaseinfo.BookFKPurI = bookKey;
    
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

    SET @categoryKey = findCategoryKeyFromStr(categoryName);
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
-- procedure addFormat
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`addFormat`;

DELIMITER $$
USE `booklibinventory`$$
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
-- procedure bookSold
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`bookSold`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `bookSold` 
(
    IN authorFirstName VARCHAR(20),
    IN authorLastName VARCHAR(20),
    IN bookTitle VARCHAR(128),
    IN bookFormat VARCHAR(45)
)
BEGIN

    SET @bookKey = findBookKey(authorLastName, authorFirstName, bookTitle, bookFormat);
    
    CALL insertOrUpdateOwned(@bookKey, 0, 0);

    DELETE FROM forsale WHERE forsale.BookFKfs = @bookKey;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure finishedReadingBook
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`finishedReadingBook`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `finishedReadingBook` (
    IN authorFirstName VARCHAR(20),
    IN authorLastName VARCHAR(20),
    IN bookTitle VARCHAR(128),
    IN bookFormat VARCHAR(45)
)
BEGIN

    SET @bookKey = findBookKey(authorLastName, authorFirstName, bookTitle, bookFormat);

    CALL insertOrUpdateHaveRead(@bookKey, 1);
    
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

    SET @bookKey = findBookKey(authorLastName, authorLastName, bookTitle, bookFormat);

SELECT @bookKey, authorLastName;
    
    CALL insertOrUpdateForSale(@bookKey, 1, askingPrice, estimatedValue);

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
    CALL addFormat('Hardcover');
    CALL addFormat('Trade Paperback');
    CALL addFormat('Mass Market Paperback');
    CALL addFormat('eBook PDF');
    CALL addFormat('eBook Kindle');
    CALL addFormat('eBook iBooks');
    CALL addFormat('eBook EPUB');
    CALL addFormat('eBook HTML');

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

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestAddAuthors
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzUnitTestAddAuthors`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `zzzUnitTestAddAuthors` ()
BEGIN

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
    
    IF (SELECT COUNT(*) FROM authorstab) != 13 THEN
        SELECT COUNT(*) FROM series;
        SELECT * FROM series;
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestAddAuthorSeries
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzUnitTestAddAuthorSeries`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `zzzUnitTestAddAuthorSeries` ()
BEGIN

    CALL addAuthorSeries('David', 'Weber', 'Safehold');
    CALL addAuthorSeries('David', 'Weber', 'Honor Harrington');
    CALL addAuthorSeries('David', 'Weber', 'Honorverse');
    CALL addAuthorSeries('Marion', 'Zimmer Bradley', 'Darkover');
    CALL addAuthorSeries('Isaac', 'Asimov', 'Foundation');
    CALL addAuthorSeries('Stephen', 'Baxter', 'Northland');
-- The follow statement should fail to insert the series since John Ringo has not been added to authorstab.
    CALL addAuthorSeries('John', 'Ringo', 'Kildar');

    IF (SELECT COUNT(*) FROM series) != 6 THEN
        SELECT COUNT(*) FROM series;
        SELECT * FROM series;
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestAddBookToLibrary
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzUnitTestAddBookToLibrary`;

DELIMITER $$
USE `booklibinventory`$$
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
 *      insertOrUpdateBookDescription
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

    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'On Basilisk Station',  'Mass Market Paperback', '1993', 1, 9, 'Baen Books', 0, 'Honor Harrington', 1,
        '0-7434-3571-0', 0, 1, 0, 0, 8.99, 8.99, 1, 'bookDescription', bookKey);
    IF (bookKey != 1) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'Honor of the Queen',  'Mass Market Paperback', '1993', 1, 10, 'Baen Books', 0, 'Honor Harrington', 2,
        '978-0-7434-3572-7', 0, 1, 0, 0, 6.99, 6.99, 1, NULL, bookKey);
    IF (bookKey != 2) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'Short Victorious War',  'Mass Market Paperback', '1994', 1, 8, 'Baen Books', 0, 'Honor Harrington', 3,
        '0-7434-3573-7', 0, 1, 0, 0, 6.99, 6.99, 1, NULL, bookKey);
    IF (bookKey != 3) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL addBookToLibrary('Fiction: Science Fiction', 'Weber', 'David', 'Field of Dishonor',  'Mass Market Paperback', '1994', 1, 6, 'Baen Books', 0, 'Honor Harrington', 4,
        '0-7434-3574-5', 0, 1, 0, 0, 7.99, 7.99, 1, NULL, bookKey);
    IF (bookKey != 4) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL addBookToLibrary('Fiction: Science Fiction', 'Norton', 'Andre', 'Star Guard',  'Mass Market Paperback', '1955', 1, NULL, 'Harcourt', 0, NULL, NULL,
        NULL, 0, 0, 1, NULL, NULL, NULL, 1, NULL, bookKey);
    IF (bookKey != 5) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    -- The following statement should fail to add a book since David Brin is not in authorstab.
    -- The failure is indicated by bookKey being zero.
    CALL addBookToLibrary('Fiction: Science Fiction', 'Brin', 'David', 'Uplift War',  'Hard Cover', '1987', 1, 1, 'Phantasia Press', 0, NULL, NULL,
        0-932096-44-1, 1, 1, 0, 0, 100.00, 100.00, 1, NULL, bookKey);
    IF (bookKey != 0) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;
    IF (SELECT COUNT(*) FROM bookinfo) != 5 THEN
        SELECT COUNT(*) FROM bookInfo;
        SELECT * FROM bookInfo;
    END IF;

    IF (SELECT COUNT(*) FROM publishinginfo) != 5 THEN
        SELECT COUNT(*) FROM publishinginfo;
        SELECT * FROM publishinginfo;
    END IF;

    IF (SELECT COUNT(*) FROM bookdescription) != 1 THEN
        SELECT COUNT(*) FROM bookdescription;
        SELECT * FROM bookdescription;
    END IF;

    IF (SELECT COUNT(*) FROM forsale) != 4 THEN
        SELECT COUNT(*) FROM forsale;
        SELECT * FROM forsale;
    END IF;

    IF (SELECT COUNT(*) FROM haveread) != 5 THEN
        SELECT COUNT(*) FROM haveread;
        SELECT * FROM haveread;
    END IF;

    IF (SELECT COUNT(*) FROM owned) != 5 THEN
        SELECT COUNT(*) FROM owned;
        SELECT * FROM owned;
    END IF;

    IF (SELECT COUNT(*) FROM signedbyauthor) != 5 THEN
        SELECT COUNT(*) FROM signedbyauthor;
        SELECT * FROM signedbyauthor;
    END IF;

    IF (SELECT COUNT(*) FROM isbn) != 4 THEN
        SELECT COUNT(*) FROM isbn;
        SELECT * FROM isbn;
    END IF;

    IF (SELECT COUNT(*) FROM purchaseinfo) != 0 THEN
        SELECT COUNT(*) FROM purchaseinfo;
        SELECT * FROM purchaseinfo;
    END IF;

    IF (SELECT COUNT(*) FROM title) != 5 THEN
        SELECT COUNT(*) FROM title;
        SELECT * FROM title;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestBuyBook
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzUnitTestBuyBook`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `zzzUnitTestBuyBook` ()
BEGIN
/*
 * This procedure tests the buyBook procedure. Since the buyBook procedure call addBookToLibrary, everything tested
 * by zzzUnitTestAddBookToLibrary is also tested by this procedure.
 *
 */

    DECLARE bookKey INT;
    DECLARE buyDate DATE;
    Set buyDate = CURDATE();

    CALL buyBook('Fiction: Science Fiction', 'Baxter', 'Stephen', 'Stone Spring',  'Mass Market Paperback', '2010', 1, 1, 'Roc', 0, 'Northland', 1,
        '978-0-451-46446-0', 0, 'The start of the Great Wall of Northland.', buyDate, 7.99, 7.19, 'Barnes & Noble', bookKey);
    IF (bookKey != 6) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL buyBook('Fiction: Science Fiction', 'Baxter', 'Stephen', 'Bronze Summer',  'Mass Market Paperback', '2011', 1, 1, 'Roc', 0, 'Northland', 2,
        '978-0-451-41486-1', 0, 'The Golden Age of Northland', buyDate, 9.99, 8.99, 'Barnes & Noble', bookKey);
    IF (bookKey != 7) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    CALL buyBook('Fiction: Science Fiction', 'Baxter', 'Stephen', 'Iron Winter',  'Mass Market Paperback', '2012', 1, 1, 'Roc', 0, 'Northland', 3,
        '978-0-451-41919-4', 0, NULL, buyDate, 7.99, 7.19, 'Barnes & Noble', bookKey);
    IF (bookKey != 8) THEN
        SELECT bookKey;
        SELECT COUNT(*) FROM bookinfo;
    END IF;

    IF (SELECT COUNT(*) FROM bookinfo) != 8 THEN
        SELECT COUNT(*) FROM bookInfo;
        SELECT * FROM bookInfo;
    END IF;

    IF (SELECT COUNT(*) FROM publishinginfo) != 8 THEN
        SELECT COUNT(*) FROM publishinginfo;
        SELECT * FROM publishinginfo;
    END IF;

    IF (SELECT COUNT(*) FROM bookdescription) != 3 THEN
        SELECT COUNT(*) FROM bookdescription;
        SELECT * FROM bookdescription;
    END IF;

    IF (SELECT COUNT(*) FROM forsale) != 7 THEN
        SELECT COUNT(*) FROM forsale;
        SELECT * FROM forsale;
    END IF;

    IF (SELECT COUNT(*) FROM haveread) != 8 THEN
        SELECT COUNT(*) FROM haveread;
        SELECT * FROM haveread;
    END IF;

    IF (SELECT COUNT(*) FROM owned) != 8 THEN
        SELECT COUNT(*) FROM owned;
        SELECT * FROM owned;
    END IF;

    IF (SELECT COUNT(*) FROM signedbyauthor) != 8 THEN
        SELECT COUNT(*) FROM signedbyauthor;
        SELECT * FROM signedbyauthor;
    END IF;

    IF (SELECT COUNT(*) FROM isbn) != 7 THEN
        SELECT COUNT(*) FROM isbn;
        SELECT * FROM isbn;
    END IF;

    IF (SELECT COUNT(*) FROM purchaseinfo) != 3 THEN
        SELECT COUNT(*) FROM purchaseinfo;
        SELECT * FROM purchaseinfo;
    END IF;

    IF (SELECT COUNT(*) FROM title) != 8 THEN
        SELECT COUNT(*) FROM title;
        SELECT * FROM title;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestInitProcedure
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzUnitTestInitProcedure`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `zzzUnitTestInitProcedure` ()
BEGIN

    CALL initBookInventoryTool();
    SELECT COUNT(*) INTO @formatCount FROM booklibinventory.bookformat;
    IF @formatCount != 8 THEN
        SELECT @formatCount;
        SELECT * FROM bookformat;
    END IF;
    -- the following call to addFormat should result in no changed to the database
    -- since eBook PDF is already in the database.
    CALL addFormat('eBook PDF');
    IF (SELECT COUNT(*) FROM bookformat) != @formatCount THEN
        SELECT @formatCount, COUNT(*) FROM bookformat;
        SELECT * FROM bookformat;
    END IF;

    SELECT COUNT(*) INTO @categoryCount FROM bookcategories;
    IF @categoryCount != 18 THEN
        SELECT @categoryCount;
        SELECT * FROM bookcategories;
    END IF;
    -- Should not be added a second time.
    CALL addCategory('None Fiction: Electrical Engineering');
    IF (SELECT COUNT(*) FROM bookcategories) != @categoryCount THEN
        SELECT @categoryCount, COUNT(*) FROM bookcategories;
        SELECT * FROM bookcategories;
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzUnitTestFunctions
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzUnitTestFunctions`;

DELIMITER $$
USE `booklibinventory`$$
CREATE PROCEDURE `zzzUnitTestFunctions` ()
BEGIN

    /*
     * The functions not explicitly tested here are tested indirectly 
     * through the function calls here with the exception of insertTitleIfNotExist
     */

    SET @authorKey = findAuthorKey('Arthur','Clarke');
    IF @authorKey != 3 THEN
        Select authorstab.FirstName, authorstab.LastName FROM authorstab WHERE idAuthors = @authorKey;
    END IF;

    SET @bookKey = findBookKey('Baxter', 'Stephen', 'Stone Spring', 'Mass Market Paperback');
    IF (@bookKey != 6) THEN
        Select * FROM bookinfo WHERE bookinfo.idBookInfo = @bookKey;
    END IF;

    SET @titleKey = findTitleKey('Star Guard');
    IF (@titleKey != 5) THEN
        Select * FROM title WHERE title.idTitle = @titleKey;
    END IF;

    SET @categoryKey = findCategoryKeyFromStr('None Fiction: Electrical Engineering');
    IF (@categoryKey != 5) THEN
        Select * FROM categories WHERE categories.idCategories = @categoryKey;
    END IF;

    SET @formatKey = findFormatKeyFromStr('Mass Market Paperback');
    IF (@formatKey != 3) THEN
        Select * FROM bookformat WHERE bookformat.idFormat = @formatKey;
    END IF;

    SET @seriesKey = findSeriesKey('David', 'Weber', 'Honorverse');
    IF (@seriesKey != 3) THEN
        Select * FROM series WHERE series.idSeries = @seriesKey;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure zzzRunAllUnitTests
-- -----------------------------------------------------

USE `booklibinventory`;
DROP procedure IF EXISTS `booklibinventory`.`zzzRunAllUnitTests`;

DELIMITER $$
USE `booklibinventory`$$
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

    CALL zzzUnitTestInitProcedure();
    CALL zzzUnitTestAddAuthors();
    CALL zzzUnitTestAddAuthorSeries();
    CALL zzzUnitTestAddBookToLibrary();
    CALL zzzUnitTestBuyBook();
    CALL zzzUnitTestFunctions();

    -- Test all the data retrieval procedures to see that they return data rows.
    -- These tests by default will provide output.
    CALL getAllBookFormatsWithKeys();
    CALL getAllBookCategoriesWithKeys();
    CALL getAllBooksInLib(); -- Test selecting all fields
    CALL getAllBooksByThisAuthor('Baxter', 'Stephen');
    CALL getAllWishListBooks();
    CALL getAllBooksThatWereRead();
    CALL getThisAuthorsData('Norton','Andre');
    CALL getAllSeriesByThisAuthor('Weber', 'David');
    CALL getAllSeriesData();
    CALL getAllAuthorsData();
    CALL getBookData('Weber', 'David', 'Honor of the Queen', 'Mass Market Paperback');
    CALL getAuthorDataByLastName('Asimov'); -- This could be changed if more authors are added, such as all the Greens.
    CALL putBookUpForSale('David', 'Weber', 'Honor of the Queen', 'Mass Market Paperback', 10.99, 7.99);
    CALL finishedReadingBook('Stephen', 'Baxter', 'Stone Spring', 'Mass Market Paperback');
    CALL finishedReadingBook('Stephen', 'Baxter', 'Bronze Summer', 'Mass Market Paperback');
    CALL getAllBooksThatWereRead();
    CALL getAllBooksForSale();
    CALL getAllBooksInLib(); -- Test selecting all fields

END$$

DELIMITER ;

CALL booklibinventory.zzzRunAllUnitTests();

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
