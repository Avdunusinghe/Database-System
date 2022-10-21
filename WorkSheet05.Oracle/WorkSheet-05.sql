/* Example 01 : Your first PL/SQL Program*/

DECLARE
BEGIN   
    DBMS_OUTPUT.PUT_LINE('This is my first PL/SQL Programe');
END;
/

/*Example 02 : Using variables*/

DECLARE 
    var_cname VARCHAR(12);
    var_clno CHAR(3) := 'c01';
BEGIN
    SELECT c.name INTO var_cname
    FROM client c 
    WHERE c.clno = var_clno

    DBMS_OUTPUT.PUT_LINE('Name of the client with clno : ' || var_clno || 'is' || var_cname);
END;
/

/*Exercise 01*/

/*
Write a PL/SQL to get the current price of a stock belongs to company ‘IBM’. Store the company 
name (‘IBM’) in a variable.*/

DECLARE
    var_company_name CHAR(3):='IBM'
    var_current_price NUMBER(6,2);
BEGIN
    SELECT s.price INTO var_current_price
    FROM stock s 
    WHERE s.company = var_company_name

    DBMS_OUTPUT.PUT_LINE(var_company_name ||'Current Stock Price is ' || var_current_price);
END;


/*Scope of Variables*/

DECLARE 
    var_num1 NUMBER;
    var_num2 NUMBER;
    BEGIN
        var_num1:=100;
        var_num2:=200;
        DECLARE
        var_mult number;
            BEGIN
            var_mult := var_num1 * var_num2; 
           
            END;
        END;


/*Declaring a record*/
DECLARE 
 client_rec client%ROWTYPE;
 var_clno client.clno%TYPE := 'c01';
BEGIN
 select * into client_rec 
 from client c
 WHERE c.clno = var_clno ;
 
 DBMS_OUTPUT.PUT_LINE('Client No : ' || client_rec.clno ); 
 DBMS_OUTPUT.PUT_LINE('Name : ' || client_rec.name ); 
 DBMS_OUTPUT.PUT_LINE('Address : ' || client_rec.address ); 
END; 
/

/*Exercise 02*/
DECLARE
    var_company_name CHAR(3):='IBM'
    var_current_price NUMBER(6,2);
BEGIN
    SELECT s.price INTO var_current_price
    FROM stock s 
    WHERE s.company = var_company_name

    DBMS_OUTPUT.PUT_LINE(var_company_name ||'Current Stock Price is ' || var_current_price);

    IF (var_current_price < 45) THEN 
        DBMS_OUTPUT.PUT_LINE('Current price is very low !');
    ELSIF (45<=Current price < 55) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is low !');
    ELSIF (55<=Current price < 65) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is medium !');
    ELSIF (65<=Current price < 75) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is medium high !');
    ELSIF (75<=Current price) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is high !');
    END IF     
END;


/*Exercise 03*/

BEGIN
    FOR x IN REVERSE 1..9 LOOP
        FOR y IN 1..x LOOP  
            DBMS_OUTPUT.PUT(x || ' ');
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;

/*Example 4 : Implicit Cursor*/
DECLARE
    var_rows NUMBER(5);
BEGIN  
    UPDATE purchase p
    SET p.qty = p.qty + 100;

    IF SQL%NOTFOUND THEN    
        DBMS_OUTPUT.PUT_LINE('None of the quantities were updated');
    ELSIF SQL%FOUND THEN
        var_rows := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('quntities for ' || var_rows || ' purchases were updated');
    END IF;
END;
