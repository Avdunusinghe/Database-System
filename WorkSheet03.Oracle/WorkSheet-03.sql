/*
*Sri Lanka Institute of Information Technology
*Deparment of Computer Science and Software Engineering
*SE3060-Database-System
*Ashen Dunusinghe
*/

/*
*@Worksheet-03
*/

/*
* (A)
*The tables of information shown below are the same as in Practical 1. Create suitable object types and tables for recording this information. 
*/
CREATE TYPE exchanges_varray AS VARRAY(10) OF VARCHAR(20);
/
CREATE TYPE stock_t AS OBJECT
(
    COMPANY CHAR(7),
    CURRENTPRICE NUMBER(8,2),
    EXCHANGESTRADED exchanges_varray,
    LASTDIVIDEND NUMBER(4,2),
    EARNINGPERSHARE NUMBER(4,2)
)
/
CREATE TYPE address_t AS OBJECT
(
    STREETNO CHAR(10),
    STREETNAME CHAR(20),
    SUBURB CHAR(20),
    STATE CHAR(20),
    PIN CHAR(10)
)

/
CREATE TYPE invesment_t AS OBJECT 
(
    COMPANY REF stock_t,
    PIRCHASEPRICE NUMBER(6,2),
    PURCHASEDATE DATE,
    QTY NUMBER(6)
)
/
CREATE TYPE invesment_nested_table_type  AS TABLE OF invesment_t
/
CREATE TYPE client_t AS OBJECT
(
    CLNO CHAR(3),
    NAME VARCHAR(30),
    ADDRESS  address_t,
    INVESMENT invesment_nested_table_type
)
/
CREATE TABLE stocks OF stock_t
(
    CONSTRAINT stocks_pk PRIMARY KEY (COMPANY)
)
/
CREATE TABLE clients of client_t
(
    CONSTRAINT client_pk PRIMARY KEY(CLNO)
)
NESTED TABLE INVESMENT STORE AS INVESTMENTS_TABLE
/
ALTER TABLE INVESTMENTS_TABLE
    ADD SCOPE FOR(COMPANY) IS STOCKS
/

/*
* (2)
*Create the required types and object tables in your database, and insert the given sample data.
*/

INSERT INTO stocks VALUES 
(
    stock_t
    (
        'BHP',
        10.50,
        exchanges_varray('Sydney', 'New York'),
        1.50,
        3.20
    )
)
/
INSERT INTO stocks VALUES 
(
    stock_t
    (
        'IBM',
        70.00,
        exchanges_varray ('New York', 'London', 'Tokyo'),
        4.25,
        10.00
    )
)
/
INSERT INTO stocks VALUES 
(
    stock_t
    (
        'INTEL',
        10.50,
        exchanges_varray('New York', 'London'),
        5.00,
        12.40
    )
)
/
INSERT INTO stocks VALUES 
(
    stock_t
    (
        'FORD',
        40.00,
        exchanges_varray('New York'),
        2.00,
        8.50
    )
)
/
INSERT INTO stocks VALUES 
(
    stock_t
    (
        'GM',
        60.00,
        exchanges_varray('New York'),
        2.50,
        9.20
    )
)
/
INSERT INTO stocks VALUES 
(
    stock_t
    (
        'INFOSYS',
        45.00 ,
        exchanges_varray('New York'),
        3.00,
        7.80
    )
)
/

INSERT INTO clients VALUES
(
    client_t
    (
        'A01',
        'John Smith',
        address_t
        (
           '3',
           'East Av',
           'Bentley',
           'WA',
           '6102'
        ),
        invesment_nested_table_type
        (
            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'BHP'),
                12.00,
                '02-OCT-2001',
                1000
            ),

            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'BHP'),
                10.50,
                '08-JUN-2002',
                2000
            ),

            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'IBM'),
                58.00,
                '12-FEB-2000',
                500
            ),

            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'IBM'),
                65.00,
                '10-APR-2001',
                1200
            ),

            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'INFOSYS'),
                64.00,
                '11-AUG-2001',
                1000
            )
        )

    )
)

/
INSERT INTO clients VALUES
(
    client_t
    (
        'A02',
        'Jill Brody',
        address_t
        (
           '42',
           'Bent St',
           'Perth',
           'WA',
           '6001'
        ),
        invesment_nested_table_type
        (
            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'INTEL'),
                35.00,
                '30-JAN-2000',
                300
            ),

            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'INTEL'),
                 54.00,
                '30-JAN-2001',
                 400
            ),

            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'INTEL'),
                60.00,
                '02-OCT-2001',
                200
            ),

            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'IBM'),
                40.00,
                '05-OCT-1999',
                300
            ),

            invesment_t
            (
                (SELECT REF(s) FROM stocks s WHERE s.COMPANY = 'GM'),
                55.50,
                '12-DEC-2000',
                500
            )
        )

    )
)


/*
* (3)
*The queries given below are the same as in Practical 1. Answer the queries using the object 
*relational tables you have created in the previous step. Use dot expressions instead of joins 
*wherever possible
*/


/*
*(A)
*For each client, get the client’s name, and the list of the client’s investments with stock name, 
*current price, last dividend and earnings per share. 
*/

SELECT c.NAME,  i.
FROM client c TABLE (c.INVESMENT) i