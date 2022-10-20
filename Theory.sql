/*   VArray  Related SQL Queries */
/* ======================================================*/

CREATE TYPE price_arr AS VARRAY(10) OF NUMBER(12,2);

/

CREATE TABLE pricelist (pno INTEGER, prices price_arr);

INSERT INTO pricelist VALUES (1, price_arr(2.50, 3.75, 4.23));


SELECT * FROM pricelist;

SELECT pno, s.COLUMN_VALUE price
FROM pricelist  p, TABLE(p.prices)  s;

/*========================================================================*/

CREATE TYPE excharray AS VARRAY(5) OF VARCHAR(12)

CREATE TYPE share_t AS OBJECT
(
   cname varchar(12), 
   cprice number(6,2),
   exchanges excharray,
   dividend number(4,2), 
   earnings number(6,2)
)

/*=========================================================================*/
/**
*
*
*
*/
/* Nested Table*/

CREATE TYPE BeerType AS OBJECT(

    name CHAR(20),
    kind CHAR(10),
    colour char(10)
)
/

CREATE TYPE BeerTableType AS 
    TABLE OF  BeerType

CREATE TABLE Manfs(
     name CHAR(30),
     addr CHAR(50),
     beers BeerTableType
)

NESTED TABLE beers STORE AS beer_table;


/*Example 2*/

CREATE TYPE proj_t AS OBJECT
(
    projno NUMBER,
    projname VARCHAR(15)
);

CREATE TYPE proj_list AS TABLE OF proj_t;

CREATE TYPE employee_t AS OBJECT
(
    eno NUMBER,
    projects proj_list
)

CREATE TABLE employees of employee_t(eno PRIMARY KEY)
NESTED TABLE projects STORE AS employees_proj_table


INSERT INTO employees VALUES
(
    100,
    proj_list
    (
        proj_t(101, 'Avionics'),
        proj_t(102, 'Cruise control')
    )
);

SELECT * 
FROM TABLE(SELECT t.projects FROM employees t WHERE t.eno = 100)


INSERT INTO TABLE(SELECT e.projects FROM employees e WHERE e.eno = 100)
VALUES (103,'Project Neptune');



UPDATE INTO TABLE(SELECT e.projects FROM employees e )
SET e.projname ='Project pluto' WHERE e.eno = 100;


DELETE TABLE (SELECT e.project FROM employee e)
WHERE e.projno = 103;

/*Multilevel Collection Types*/
CREATE TYPE sat_t AS OBJECT 
(
    name VARCHAR(20),
    orbit NUMBER
);

/
CREATE TYPE sat_ntt AS TABLE OF sat_t
/

CREATE TYPE planet_t AS OBJECT 
(
    name VARCHAR2(20),
    mass NUMBER,
    satellites sat_t
)
/

CREATE TYPE planet_ntt AS TABLE OF planet_t;
/

CREATE TYPE star_t AS OBJECT 
(
    name VARCHAR2(20),
    age NUMBER,
    planets price_arr
)
/

CREATE TABLE star_tab OF share_t 
(
    name PRIMARY KEY
) 
NESTED TABLE planets STORE AS planets_nttab
(NESTED TABLE satellites STORE AS satellites_nttab);

INSERT INTO stars


/* member method */
ALTER TYPE stock_type
ADD MEMBER FUNCTION yield return  float 
cascade
/

CREATE OR REPLACE type body stock_type as 
member function yeild retrun float is
    begin
        ((self.ldivided/selft.cprice)*100);
    
    end yeild;
memebr function AUDtoUSD(rate float) return float is
    begin
        return  self.currentPrice * rate;
    
    end AUDtoUSD;
memeber function no_trades return integer is
    count integer;
    begin
        select  count(e.column_value)into count;
        from  table(selft.exchanges_varray)e
        
        return count;
    end no_trades;
end;
/


select s.yeild(), s.AUDtoUSD(7,8)
from stock s

select s.company,e.column_value, s.yield(),s.AUDtoUSD(0.74)
from stock_tbl s , table(s.exchanges_varray)e 
