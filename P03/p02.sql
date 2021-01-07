--SET SERVEROUTPUT ON;
--SET ECHO ON;
START catalog.sql;
/*
1.Procedure Create_Account(p_first, p_last, p_email, p_error_msg)
Add a new user to the Users table. If the new user cannot be added, return a meaningful error
message.
*/


create or replace PROCEDURE Create_Account(
p_first IN Users.first%type, 
p_last  IN Users.last%type, 
p_email IN Users.email%type,
p_error_msg IN OUT VARCHAR2
)
is
BEGIN
If (p_first is null and p_last is null) then
   
   
    p_error_msg := 'Both first and last name can not be Empty!'; 
    dbms_output.put_line(p_error_msg);
   
ELSE
   
    Insert into Users Values (user_seq.nextval, p_email, p_first,p_last);
    p_error_msg := 'Account Created Successfully!';
    dbms_output.put_line(p_error_msg);
    Commit;
   
END IF;
--EXCEPTION
--WHEN OTHERS THEN
 --   p_error_msg := 'The Email Is Already In Used!';
 --   dbms_output.put_line(p_error_msg);
END;
/

/*
2.Function find_user(p_email_address)
Return the user number of the given user or -1 if the user is not found.
*/
CREATE OR REPLACE FUNCTION find_user(p_email_address IN Users.email%type)
   
 RETURN Users.User_no%type
IS
  user_numb Users.User_no%type;    
BEGIN
    SELECT
           User_No
    INTO
           user_numb
    FROM
           Users
    WHERE
           p_email_address = Users.email
    ;
Return user_numb;      

EXCEPTION
WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line('TOO MANY ROWS (Users) RETURNED');
WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('NO DATA (Users)/ NO ROWS FOUND'); 
    Return -1;
WHEN OTHERS THEN
   dbms_output.put_line('SOMETHING WENT CATASTROPHICALLY WRONG');
END;
/
SHOW errors;

/*
3.Procedure add_to_catalog(p_book_no, user_no, p_error_msg)
Add the given book to the user’s catalog. If the book may not be added, return a meaningful error
message.
*/
create or replace PROCEDURE add_to_catalog(
    p_book_no IN Catalog.ISBN%type,
    p_user_no IN Catalog.User_no%type, 
    p_error_msg out varchar2)
    is
    V_book Books%rowtype;
    V_User Users%rowtype;
BEGIN
If (p_book_no is null or P_user_no is null) then
   
    p_error_msg := 'Book or User Number Can not be Empty!'; 
    dbms_output.put_line(p_error_msg);
   
ELSE
    Select ISBN    Into V_book.ISBN    FROM BOOKS WHERE ISBN = p_book_no;
    Select User_no Into V_User.User_no FROM Users WHERE User_no = p_User_no;
    Insert into Catalog(ISBN,User_No,Status) Values (p_book_no,P_user_no,'Want to Read');
    p_error_msg := 'Book Added to Catalog Successful';
    dbms_output.put_line(p_error_msg);
    Commit;
END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    p_error_msg := 'NO DATA (Book or User)/ NO ROWS FOUND!';
    dbms_output.put_line(p_error_msg);
--WHEN OTHERS THEN
 --   p_error_msg := 'Book is already Added!';
 --   dbms_output.put_line(p_error_msg);
END;
/
SHOW errors;

/*
4.Procedure remove_from_catalog(p_book_no, p_user_no, p_error_msg)
Remove the given book to the user’s catalog. If the book may not be removed, return a meaningful
error message.
*/

create or replace PROCEDURE remove_from_catalog(
p_book_no IN Catalog.ISBN%type,
p_user_no IN Catalog.User_no%type,
p_error_msg OUT Varchar2)
is
 V_cat Catalog%rowtype;
BEGIN
Select ISBN,User_No Into V_cat.ISBN,V_cat.User_No FROM Catalog WHERE ISBN = p_book_no and User_no = p_user_no;
delete from Catalog
where p_book_no = ISBN and p_user_no = User_no;
p_error_msg := 'Delete Successful';
dbms_output.put_line(p_error_msg);

EXCEPTION
WHEN TOO_MANY_ROWS THEN
    p_error_msg := 'TOO MANY ROWS RETURNED';
    dbms_output.put_line(p_error_msg);
WHEN NO_DATA_FOUND THEN
    p_error_msg := 'NO DATA (Book Or User)/ NO ROWS FOUND';
    dbms_output.put_line(p_error_msg);
--WHEN OTHERS THEN
--    p_error_msg := 'SOMETHING WENT CATASTROPHICALLY WRONG';
 ----   dbms_output.put_line(p_error_msg);
END;
/
SHOW errors;

/*
5.Procedure rate_book(p_book_no, user_no, p_rating, p_comment, p_error_msg)
Add a record to the review table. The rating must be valid. The comment may be empty. If the
review may not be added, return a meaningful error message.
*/

create or replace PROCEDURE rate_book(
p_book_no IN Reviews.ISBN%type,
p_user_no IN Reviews.User_no%type,
p_rating  IN Reviews.rating%type,
p_comment IN Reviews.review%type,
p_error_msg OUT VARCHAR2)
is
BEGIN
If (p_book_no is null or p_user_no is null or p_rating is null) then

    p_error_msg := 'Book, User, or Rating can not be Empty!'; 
    dbms_output.put_line(p_error_msg);

ELSIF (p_rating < 1 or p_rating > 4) THEN

    p_error_msg := 'Rating must be between 1 and 4'; 
    dbms_output.put_line(p_error_msg);

ELSE
   
    Insert into Reviews Values (p_book_no, p_user_no, p_rating, p_comment);
    p_error_msg := 'Review Added Successfully!';
    dbms_output.put_line(p_error_msg);
    Commit;
   
END IF;
--EXCEPTION
--WHEN OTHERS THEN
--    p_error_msg := 'User already has a review for the requested book!';
 --   dbms_output.put_line(p_error_msg);

END;
/
SHOW errors;

/*
6.Procedure update_status(p_book_no, p_user_no, p_status, p_error_msg)
Change the status of the given book in the user’s catalog. If the status may not be changed, return
a meaningful error message.
*/

create or replace PROCEDURE update_status(
p_book_no IN Catalog.ISBN%type,
p_user_no IN Catalog.User_no%type,
p_status IN VARCHAR2,
p_error_msg OUT VARCHAR2)
is
V_cat Catalog%rowtype ;
BEGIN
If (p_book_no is null or P_user_no is null) then
   
    p_error_msg := 'Book or User Number Can not be Empty!'; 
    dbms_output.put_line(p_error_msg);
   
ELSE
    Select ISBN,User_No INTO V_cat.ISBN, V_cat.User_No From Catalog Where p_book_no = ISBN and p_user_no = User_No;
    UPDATE Catalog
    SET status = p_status
    WHERE p_book_no = ISBN and p_user_no = User_no;
    Commit;
    p_error_msg := 'Status Updated!'; 
    dbms_output.put_line(p_error_msg);
End if;

EXCEPTION
WHEN TOO_MANY_ROWS THEN
    p_error_msg := 'TOO MANY ROWS RETURNED';
    dbms_output.put_line(p_error_msg);
WHEN NO_DATA_FOUND THEN
    p_error_msg := 'NO DATA (Book Or User)/ NO ROWS FOUND';
    dbms_output.put_line(p_error_msg);
--WHEN OTHERS THEN
--    p_error_msg := 'SOMETHING WENT CATASTROPHICALLY WRONG';
 --   dbms_output.put_line(p_error_msg);
END;
/
SHOW errors;
/*
7.Function add_friend(p_user_no, p_friend_no)
Add a record to the Friends table. The function returns a Boolean answering if the operation was
successful or not.
*/

CREATE OR REPLACE FUNCTION add_friend(
p_user_no IN Friends.User_no%type,
p_friend_no IN Friends.Friend_no%type)
Return BOOLEAN
IS
V_use Users%rowtype;
p_error_msg Varchar2(50);
BEGIN
If (p_user_no is null or p_friend_no is null) then
    p_error_msg := 'User(YOU) Number or Friend User Number Can not be Empty!'; 
    dbms_output.put_line(p_error_msg);
    Return False;
ELSE
    dbms_output.put_line(p_user_no || '     ' || p_friend_no);
    Select User_No INTO V_use.User_No From Users Where  User_no = P_user_no ;
    Select User_No INTO V_use.User_No From Users Where  User_no = P_friend_no;
    Insert into Friends Values (p_user_no ,p_friend_no );
    Commit;
    Return True;
    p_error_msg := 'Friend Added Successful Updated!'; 
    dbms_output.put_line(p_error_msg);
End if;

EXCEPTION
WHEN TOO_MANY_ROWS THEN
    p_error_msg := 'TOO MANY ROWS RETURNED';
    dbms_output.put_line(p_error_msg);
    Return False;
WHEN NO_DATA_FOUND THEN
    p_error_msg := 'NO DATA Found For:(User(You) Or User(Friend)) / NO ROWS FOUND';
    dbms_output.put_line(p_error_msg);
    Return False;
--WHEN OTHERS THEN
--    p_error_msg := 'SOMETHING WENT CATASTROPHICALLY WRONG';
--   dbms_output.put_line(p_error_msg);
 --   Return False;
END;
/
SHOW errors;
/*
Triggers
Create two triggers described below. 

8.Review Notification
Develop a trigger that notifies every friend when a user publishes a book review. The trigger will
prepare a message and add the message to the Messages table. The message will include the first
and last name of the user who published the review and the title of the book. For example:
Bob Jones published a review for “Clear and Present Danger”.
*/

create or replace TRIGGER F_Pub_Review
AFTER INSERT ON Reviews
FOR EACH ROW
Declare
V_user Users%rowtype;
V_book Books%rowtype; 
Begin
dbms_output.put_line('Added To Messages');
Select First, Last Into V_user.First, V_user.last From Users Where :NEW.User_No = User_no;
Select title Into V_book.title From Books Where :NEW.ISBN = ISBN;
dbms_output.put_line(:NEW.ISBN);
Insert into Messages Values (Mesg_seq.nextval,:NEW.User_No ,V_user.First|| ' ' || V_user.last || ' published a review for "'||V_book.title || '"' );
EXCEPTION
WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line('TOO MANY ROWS RETURNED');
WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('NO DATA / NO ROWS FOUND');
--WHEN OTHERS THEN
--    dbms_output.put_line('SOMETHING WENT CATASTROPHICALLY WRONG');
END;
/
SHOW errors;

/*
9.Prevent Review
Develop a trigger that prevents users from publishing a review of a book the user has not finished
reading. 
*/

create or replace TRIGGER Prevent_Review
Before INSERT ON Reviews
FOR EACH ROW
Declare
V_cat Catalog%rowtype;
EXCEPT_NOTREAD EXCEPTION;
PRAGMA EXCEPTION_INIT (EXCEPT_NOTREAD, -200000);
BEGIN  
dbms_output.put_line('In Prevent Review!!!!!!!!!!!!!!!!!!!!!!!!!!!');
dbms_output.put_line(:NEW.User_No);
dbms_output.put_line(:NEW.ISBN);
--dbms_output.put_line(User_No);
V_cat.status := 'Want to Read';
Select status Into V_cat.status From Catalog Where :NEW.User_No = User_No  and :New.ISBN = ISBN;

IF(V_cat.status != 'Read' ) THEN
    dbms_output.put_line('Error PREVENT');
     raise_application_error(
    -20000, 
    'User must have fully read the book' 
    , FALSE
);

End IF;
dbms_output.put_line(v_cat.status);
dbms_output.put_line('END PREVENT');
EXCEPTION
WHEN TOO_MANY_ROWS THEN
   dbms_output.put_line('TOO MANY ROWS RETURNED');
WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('NO DATA / NO ROWS FOUND');
    raise_application_error(
    -20000, 
    'User must have book in Catalog and be fully read' 
    , FALSE
); 
WHEN EXCEPT_NOTREAD THEN
    dbms_output.put_line('Book is Not Fully Read');

--WHEN OTHERS THEN
--   dbms_output.put_line('SOMETHING WENT CATASTROPHICALLY WRONG');
END;
/
SHOW errors;