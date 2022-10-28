-- 2.5.1. Database Setup: Tables (book, author, patron, reference_books, genre, loan) --

-- Create book table. 
CREATE TABLE book (
   book_id INT AUTO_INCREMENT PRIMARY KEY,
   author_id INT,
   title VARCHAR(255),
   isbn INT,
   available BOOL,
   genre_id INT
);

-- Verify book table.--
SELECT *
FROM book;


-- Create author table. 
CREATE TABLE author (
   author_id INT AUTO_INCREMENT PRIMARY KEY,
   first_name VARCHAR(255),
   last_name VARCHAR(255),
   birthday DATE,
   deathday DATE
);

-- Verify author table.--
SELECT *
FROM author;


-- Create patron table.
CREATE TABLE patron (
   patron_id INT AUTO_INCREMENT PRIMARY KEY,
   first_name VARCHAR(255),
   last_name VARCHAR(255),
   loan_id INT
);

-- Verify patron table.--
SELECT *
FROM patron;


-- Create reference_books table.
CREATE TABLE reference_books (
   reference_id INT AUTO_INCREMENT PRIMARY KEY,
   edition INT,
   book_id INT,
   FOREIGN KEY (book_id)
      REFERENCES book(book_id)
      ON UPDATE SET NULL
      ON DELETE SET NULL
);

-- Use book-provided code to fil the table with a row of data. --
INSERT INTO reference_books(edition, book_id)
VALUE (5,32);

-- Verify reference_books table --
SELECT * 
FROM reference_books;


-- Create genre table.
CREATE TABLE genre (
   genre_id INT PRIMARY KEY,
   genres VARCHAR(100)
);

-- Verify genre table.--
SELECT *
FROM genre;


-- Create loan table. 
CREATE TABLE loan (
   loan_id INT AUTO_INCREMENT PRIMARY KEY,
   patron_id INT,
   date_out DATE,
   date_in DATE,
   book_id INT,
   FOREIGN KEY (book_id)
      REFERENCES book(book_id)
      ON UPDATE SET NULL
      ON DELETE SET NULL
);

-- Verify loan table.--
SELECT *
FROM loan;


-- 2.5.2 Warm-up Queries --

-- 1 - Return the mystery book titles and their ISBNs. --
-- I actually added genres column to my SELECT statement to show the "Mystery" word. --
SELECT title, isbn, genres
FROM book, genre
WHERE genres = "Mystery" AND genre.genre_id = book.genre_id;

	-- Jayde did it this/different way -- 
	SELECT title, isbn, genres
	FROM book, genre
	WHERE genre.genre_id = book.genre_id AND genres LIKE 'Mystery';

-- 2 - Return all of the titles and author’s first and last names for books written by authors who are currently living. --
SELECT title, first_name, last_name
FROM book, author
WHERE book.author_id = author.author_id AND author.deathday IS NULL; 

	-- Jayde did it this/different way -- 
	SELECT book.title, author.first_name, author.last_name
	FROM book
	INNER JOIN author ON book.author_id = author.author_id
	WHERE author.deathday IS NULL;


-- 2.5.3. Loan Out a Book --
-- A big function that you need to implement for the library is a script that updates the database when a book is loaned out.
-- You can use any patron and book that strikes your fancy to create this script!
-- I chose Book 10 "Sense and Sensibility".

-- 1 - Change available to FALSE for the appropriate book & use SELECT to verify.
UPDATE book
SET available = false
WHERE book_id = 10;

	SELECT * FROM book;

-- 2 - Add a new row to the loan table with today’s date as the date_out and the ids in the row matching the appropriate patron_id and book_id & use SELECT to verify. --
INSERT INTO loan (patron_id, book_id, date_out)
VALUES (5, 10, Curdate());

	SELECT * FROM loan;

-- 3 - Update the appropriate patron with the loan_id from the new row created in the loan table & use SELECT to verify. --
UPDATE patron
SET loan_id = (SELECT loan_id FROM loan WHERE patron_id = 5)
WHERE patron_id = 5;
 
	SELECT * FROM patron;
    
    
-- 2.5.4. Check a Book Back In --

-- 1 - Change available to TRUE for the appropriate book  & use SELECT to verify.
UPDATE book
SET available = true
WHERE book_id = 10;

	SELECT * FROM book;


-- 2 - Update the appropriate row in the loan table with today’s date as the date_in  & use SELECT to verify.
UPDATE loan
SET date_in = Curdate()
WHERE patron_id = 5 AND book_id = 10 AND date_in IS NULL;

	SELECT * FROM loan;

-- 3 - Update the appropriate patron changing loan_id back to null & use SELECT to verify.
UPDATE patron
SET loan_id = NULL
WHERE patron_id = 5;

	SELECT * FROM patron;

-- EXTRA - Once you have created these scripts, loan out 5 new books to 5 different patrons.
	-- Did NOT do this part. 


-- 2.5.5. Wrap-up Query --

-- 1 - Write a query to wrap up the studio. This query should return the names of the patrons with the genre of every book they currently have checked out.
	-- Did NOT do this one, since we did not do the EXTRA. 
	-- Jayde did NOT do this one either in Studio Review.


-- 2.5.6. Bonus Mission --

-- 1 - Return the counts of the books of each genre. Check out the documentation to see how this could be done!
SELECT genres, Count(*) 
FROM genre, book 
WHERE genre.genre_id = book.genre_id
GROUP BY genres;

	-- This returns the counts for one specific genre.
	SELECT count(title)
	FROM book, genre
	WHERE book.genre_id = genre.genre_id AND genre.genres = "Romance";


-- 2 - A reference book cannot leave the library. How would you modify either the reference_book table or the book table to make sure that doesn’t happen? Try to apply your modifications.
	-- Did NOT do this one, but it might involve available column in the book table, using things like: UPDATE book, SET available = false by default.

-- NOTE: Supposedly a fellow student shared that this code below should reset all tables to original state after modifications, (should you make a mistake updating), but I have not tested it. --
	-- SET SQL_SAFE_UPDATES=0;

