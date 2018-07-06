
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
