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

/*==================================================================================================*/


 ALTER TYPE stock_t
 ADD MEMBER FUNCTION yield RETURN FLOAT cascade
 /

 CREATE OR REPLACE TYPE stock_t AS
 MEMEBER FUNCTION yield RETURN FLOAT IS
    BEGIN
        RETURN((SELF.DIVIDEND/SELF.CURRENTPRICE) * 100);
    END yield;
MEMEBER FUNCTION AUDtoUSD(rate FLOAT) RETURN FLOAT IS
    BEGIN
        RETURN SELF.CURRENTPRICE * rate;
    END AUDtoUSD;
MEMEBER FUNCTION no_trades RETURN INTEGER IS
     count INTEGER;
    BEGIN   
        SELECT COUNT(e.COLUMN_VALUE) INTO COUNT;
        FROM TABLE(SELF.exchanges_varray) e

        RETURN count;
    END no_trades;
END;
         
/


