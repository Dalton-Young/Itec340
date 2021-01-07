SET SERVEROUTPUT ON;
SET ECHO ON;
START p02.sql;



--Create_Account TEST
Declare
Message Varchar2(50);
Friend1 Boolean;
Friend2 Boolean;
Begin
dbms_output.put_line('Create_Account TEST');
 --Create_Account('','','notdy@radford',Message); --Empty
 Create_Account('Dalton','Young','dy@radford',Message);
 Create_Account('Woot','Woot','woot@radford',Message);  
 Create_Account('Fake','Reviews','FakeReviews@radford',Message);
 --Create_Account('Daltonasdfasdfa','Young','dadsfay@radford',Message); -User End Length
 --Create_Account('Impost','Young','dy@radford',Message); --Same Email as Above

--find_user TEST 
dbms_output.put_line('find_user TEST'); 
dbms_output.put_line(find_user('woot@radford'));--Good
dbms_output.put_line(find_user('dy@radford')); --Good
--dbms_output.put_line(find_user('NOTHEREdy@radford')); --Not Found
 
--add_to_catalog TEST
dbms_output.put_line('add_to_catalog TEST');
Insert into Books Values(isbn_seq.nextval,'Oh My Goodness',1,2019,'A book','NOTREAL.COM',45,'Not A Author');
Insert into Books Values(isbn_seq.nextval,'Oh NO',1,2020,'NOT A book','TOTALLYREAL.COM',100,'Not THE Author');
Insert into Books Values(isbn_seq.nextval,'Clear',1,1920,'Danger','TOMS.COM',1000,'Tom Clancy');

add_to_catalog(5000,find_user('woot@radford'),Message);--Good
add_to_catalog(5001,find_user('dy@radford'),Message);--Good
--add_to_catalog(5002,find_user('dy@radford'),Message);-- No Book Found
--add_to_catalog(5001,find_user('NOTHEREdy@radford'),Message);--No USER

--remove_from_catalog TEST
dbms_output.put_line('remove_from_catalog TEST'); 
 remove_from_catalog(5000,find_user('woot@radford'),Message);
 remove_from_catalog(5001,find_user('dy@radford'),Message);
 --remove_from_catalog(5001,find_user('dy@radford'),Message); -- Already Deleted, No ISBN found
 --remove_from_catalog(5001,find_user('NOTHEREdy@radford'),Message); -- No User Found

--update_status TEST
dbms_output.put_line('update_status TEST');
add_to_catalog(5000,find_user('woot@radford'),Message);
add_to_catalog(5001,find_user('dy@radford'),Message);
update_status(5000,find_user('woot@radford'),'Reading',Message); --Good
update_status(5001,find_user('dy@radford'),'Read',Message); --Good

--add_friend TEST
dbms_output.put_line('add_friend TEST');
Friend1 := add_friend(find_user('woot@radford'),find_user('dy@radford'));--Good
Friend2 := add_friend(find_user('dy@radford'),find_user('woot@radford'));--Good
--Found Bool to Int from: https://stackoverflow.com/questions/40124414/dbms-output-cannot-print-boolean
dbms_output.put_line(sys.diutil.bool_to_int(Friend1));
dbms_output.put_line(sys.diutil.bool_to_int(Friend2));

--rate_book TEST
dbms_output.put_line('rate_book TEST');

rate_book(5001,find_user('dy@radford'),1,'Wow What a Garbage Book!',Message);

-- Thows Exception That a user has not fully read book.
--rate_book(5000,find_user('woot@radford'),4,'',Message); --Reading
--rate_book(5000,find_user('FakeReviews@radford'),1,'Wow This Book Stinks!',Message); --Never Added to Catalog

End;
/
