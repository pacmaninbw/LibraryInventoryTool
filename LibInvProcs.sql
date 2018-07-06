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

