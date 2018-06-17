# LibraryInventoryTool
A MySQL Database with a C# user interface application for maintaining an iventory for library of books.

# Unit Testing of the database
There are multiple unit tests of the stored procedures and stored functions implemented as stored procedures.
The estimated lines of code of the unit tests is 425, including comments.

# Background
Two of my hobbies are reading science fiction and designing and coding solutions. I decided to combine these for a project;
I have over 1500 science fiction books as well as hundreds of other books. This repository contains a tool to keep track
of the books I own and the books I want to buy or sell.

So far the repository only contains the SQL file to create the schema, stored procedures and functions.
Currently at least five of the procedures are unit tests. A warning about this SQL file, it executes the unit tests automatically,
you may want to comment out the procedure call at the end of the file if you load it into MySQL.

When completed this repository will containt the SQL to create the database and all the stored procedures as well as
a C# application using MVC architecture to add, delete and update books and authors.
