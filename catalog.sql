--
-- Database I -- ITEC 340
-- Summer 2020
--
-- Catalog System -- class project

--SET ECHO ON;


DROP TABLE Catalog;
DROP TABLE Reviews;
DROP TABLE Messages;
DROP TABLE Friends;
DROP TABLE Shelves;
DROP TABLE Books;
DROP TABLE Users;

DROP SEQUENCE user_seq;
DROP SEQUENCE isbn_seq;
DROP SEQUENCE Mesg_seq;


CREATE TABLE Books
(
    ISBN	     NUMBER
,   title	     VARCHAR2(25)
,   edition	     NUMBER(2)
,   pub_year	     NUMBER(4)
,   description      VARCHAR2(25)
,   link	     VARCHAR2(15)
,   num_pages	     NUMBER(5)
,   primary_author   VARCHAR2(20)
, CONSTRAINT Books_PK PRIMARY KEY(ISBN)
, CONSTRAINT CK_Pages CHECK(num_pages > 0)
);

CREATE TABLE Users
(
    User_no	NUMBER
,   email	VARCHAR2(20)
,   first	VARCHAR2(8)
,   last	VARCHAR2(12)
, CONSTRAINT Users_PK PRIMARY KEY(User_no)
, CONSTRAINT Email_UK UNIQUE(email)
);

CREATE TABLE Friends
(
    User_no	NUMBER
,   Friend_no	NUMBER
, CONSTRAINT Friends_PK PRIMARY KEY(User_no, Friend_no)
, CONSTRAINT User_Friend_FK FOREIGN KEY(User_no) REFERENCES Users
, CONSTRAINT Friend_User_FK FOREIGN KEY(Friend_no) REFERENCES Users
);

CREATE TABLE Shelves
(
    User_no	  NUMBER
,   Name	  VARCHAR2(8)
,   description   VARCHAR(20)
, CONSTRAINT Shelves_PK PRIMARY KEY(User_no, Name)
);


CREATE TABLE Messages
(
    Msg_no	NUMBER
,   User_no	NUMBER
,   message	VARCHAR2(140)
, CONSTRAINT Msg_PK PRIMARY KEY(Msg_no)
, CONSTRAINT Msg_User_FK FOREIGN KEY(User_no) REFERENCES Users
);

CREATE TABLE Reviews
(
    ISBN	NUMBER
,   User_no	NUMBER
,   rating	NUMBER(1)
,   review	VARCHAR2(140)
, CONSTRAINT Reviews_PK PRIMARY KEY(ISBN, User_no)
, CONSTRAINT Book_Reviews_FK FOREIGN KEY(ISBN) REFERENCES Books
, CONSTRAINT User_Review_FK FOREIGN KEY(User_no) REFERENCES Users
, CONSTRAINT CK_Rating CHECK(rating BETWEEN 1 and 4)
);


CREATE TABLE Catalog
(
    ISBN	   NUMBER
,   User_no	   NUMBER
,   status	   VARCHAR2(12)
,   end_date	   DATE
,   start_date	   DATE
,   page_num	   NUMBER(5)
,   percent_done   NUMBER(3)
,   shelf	   VARCHAR2(8)
, CONSTRAINT Catalog_PK PRIMARY KEY(ISBN, User_no)
, CONSTRAINT Catalog_Book_FK  FOREIGN KEY(ISBN) REFERENCES Books
, CONSTRAINT Catalog_Users_FK FOREIGN KEY(User_no) REFERENCES Users
, CONSTRAINT Catalog_Shelves_FK FOREIGN KEY(User_no, Shelf) REFERENCES Shelves
, CONSTRAINT CK_Status CHECK(status IN ('Want to Read', 'Reading', 'Read'))
);

CREATE SEQUENCE user_seq
  START WITH 100;


CREATE SEQUENCE isbn_seq
  START WITH 5000;

CREATE SEQUENCE Mesg_seq
  START WITH 10000;

