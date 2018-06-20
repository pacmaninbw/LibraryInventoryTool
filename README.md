# LibraryInventoryTool
A MySQL Database with a C# user interface application for maintaining an iventory for library of books.

# Unit Testing of the database
There are multiple unit tests of the stored procedures and stored functions implemented as stored procedures.
The estimated lines of code of the unit tests is 425, including comments.

# Background
Two of my hobbies are reading science fiction and designing and coding solutions. I decided to combine these for a project;

I have well over 1500 Science Fiction and Fantasy books that I have accumulated over the years. Some of them are signed by the authors. Most of them are Mass Market Paperbacks. Quite a few of them are in a series by the author.
(Insert photos here.)

Over the years I have occasionally purchased the same book twice because I didn’t realize I already had it. I don’t actually know how many books I own. At some point I may want to sell some or all of the books. I don’t have a clue about the value of the library. It became obvious that a catalog or inventory of the all SF and F books I owned was necessary.

Six months ago a Microsoft excel spread sheet of books was started. I found I kept adding columns to the spreadsheet, and the spreadsheet seemed like it was insufficient to do the job. Some of the issues included multiple data entries for the same book in different lists for wish lists or for selling or buying books.
The user has the ability to add formats and categories. Formats and categories can’t be deleted once they are in use. The user can add and delete authors, books and author series. A book can be bought or sold. A book can be added to the wish list. A book on the wish list is updated when it is bought. A book may be borrowed from the library and read. Since these books started being purchased in 1968 the purchase information may not be available for all books. Deleting an author deletes all the authors’ series and books.

This database is the first part of the project, I couldn’t really create a friendly user interface until the database is working.
Due to feature creep this database can now handle other kinds of books besides science fiction and fantasy. A future version of this database will have an additional table for the status of the book (new or user) and the condition of the book (Excellent, Good, Fair, Poor).

For books there is no single identifying item, or rather the ISBN is the single identifying item based on author, title, format and edition, but some books printed in the 1960’s and 1970’s don’t have an ISBN on the book itself. This database uses the author title and format together as the identity of the book.

There are about 2790 lines of code and comments in this database. The first 240 lines are the data definitions of the tables. There are 1849 lines of stored procedures implementing the insert, update, delete and retrieval stored procedures. The last 701 line of code are unit tests in an attempt to make sure the stored procedures and functions work when I start developing the user interface.

This is the first relational schema I have designed from scratch. A year ago I wouldn’t have used any stored procedures because I didn’t know about the benefits of using stored procedures.

When I started this project I didn’t know about database partitioning, I learned about table normalization in the university and that is what I tried to do. The current design allows for addition of fields at a later time without modifying any existing tables. This solution requires additional joins when generating reports, but existing data won’t be invalidated.

