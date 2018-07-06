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

