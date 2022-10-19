/*
*Sri Lanka Institute of Information Technology
*Deparment of Computer Science and Software Engineering
*SE3060-Database-System
*Ashen DUnusinghe
*/

/*
*@Worksheet-01
*/

/*
* (1)
* Create the relational tables in Oracle with suitable primary and foreign keys, and insert the sample data given below
*/
CREATE TABLE client
(
    clno CHAR(3),
    name VARCHAR(12),
     address VARCHAR(30),

    CONSTRAINTS client_PK PRIMARY KEY(clno)
)
/
CREATE TABLE stock
(
    company CHAR(7),
    price NUMBER(6,2),
     dividend NUMBER(4,2),
    eps NUMBER(4,2),

    CONSTRAINTS stock_PK PRIMARY KEY(company)
)
/
CREATE TABLE trading 
(
    company CHAR(7),
    exchange VARCHAR(12),

   CONSTRAINTS trading_PK PRIMARY KEY(company, exchange),
   CONSTRAINTS trading_exchange_FK FOREIGN KEY(company) REFERENCES stock
)

/
CREATE TABLE purchase 
(
    clno CHAR(3),
    company CHAR(7),
    pdate DATE,
    qty NUMBER(6),
    price NUMBER(6,2),

    CONSTRAINTS purchase_PK PRIMARY KEY(clno, company, pdate),
    CONSTRAINTS purchase_FK1 FOREIGN KEY(clno) REFERENCES client,
    CONSTRAINTS purchase_FK2 FOREIGN KEY(company) REFERENCES stock
)

INSERT INTO client VALUES ('100', 'John Smith', '3 East Av Bentley WA 6102');
INSERT INTO client VALUES ('101', 'Jill Brody', '442 Bent St PerthWA 6001 Bentley WA 6102');

INSERT INTO stock VALUES ('BHP', 10.50, 1.50, 3.20);
INSERT INTO stock VALUES ('IBM', 70.00, 4.25, 10.00);
INSERT INTO stock VALUES ('INTEL', 76.00, 5.00, 12.40);
INSERT INTO stock VALUES ('FORD', 40.00, 2.00, 8.50);
INSERT INTO stock VALUES ('GM', 60.00, 2.50, 9.20);
INSERT INTO stock VALUES ('INFOSYS', 45.00, 3.00, 7.80);

INSERT INTO trading VALUES ('BHP', 'Sydney');
INSERT INTO trading VALUES ('BHP', 'New York');
INSERT INTO trading VALUES ('IBM', 'New York');
INSERT INTO trading VALUES ('IBM', 'London');
INSERT INTO trading VALUES ('IBM', 'Tokyo');
INSERT INTO trading VALUES ('INTEL', 'Tokyo');
INSERT INTO trading VALUES ('FORD', 'New York');
INSERT INTO trading VALUES ('GM', 'New York');
INSERT INTO trading VALUES ('INFOSYS', 'New York');

INSERT INTO purchase VALUES ('100', 'BHP', DATE '2022-10-02', 1000, 12.00);
INSERT INTO purchase VALUES ('100', 'BHP', DATE '2022-06-02', 2000, 10.50);
INSERT INTO purchase VALUES ('100', 'IBM', DATE '2022-02-12', 500, 58.00);
INSERT INTO purchase VALUES ('100', 'IBM', DATE '2020-04-10', 1200, 65.00);
INSERT INTO purchase VALUES ('100', 'INFOSYS', DATE '2020-08-11', 1000, 64.00);
INSERT INTO purchase VALUES ('101', 'INTEL', DATE '2020-01-30', 300, 35.00);
INSERT INTO purchase VALUES ('101', 'INTEL', DATE '2021-01-30', 400, 54.00);
INSERT INTO purchase VALUES ('101', 'INTEL', DATE '2020-10-02', 200, 60.00);
INSERT INTO purchase VALUES ('101', 'FORD', DATE '2020-10-05', 300, 40.00);
INSERT INTO purchase VALUES ('101', 'GM', DATE '2020-12-12', 500, 55.50);


/*
* (3)
* For each client, get the client’s name, and the list of the client’s investments with stock name, current price, last dividend and earnings per share. 
*/
SELECT DISTINCT c.name, p.company, s.price, s.dividend, s.eps
FROM client c , purchase p, stock s
WHERE c.clno, = p.clno and p.company = s.company

/*
* (B)
* Get the list of all clients and their share investments, showing the client name, and for each stock held by the client, the name of the stock, total number of shares held, and the average purchase
*/
SELECT c.name, p.company, SUM(p.qty) total_qty, sum(p.qty * p.price)/SUM(p.qty) APP
FROM client c, purchase p
WHERE c.clno = p.clno
GROUP BY c.name, p.company


/*
* (C)
* price paid by the client for the stock. Average price is the total purchase value paid by a client for a given stock (value=qty*price) divided by the total quantity held by the client.
*/

SELECT p.company,c.name,SUM(p.qty) AS TOT_QTY,SUM(p.qty*s.price) AS current_value
From trading t,stock s,client c,purchase p
Where s.company = t.company AND c.clno = p.clno AND p.company = s.company AND t.exchange = 'New York'
GROUP BY p.company,c.name;


/*
* (D)
*  Find the total purchase value of investments for all clients. Display client name and total purchase value of the client’s portfolio.
*/
SELECT c.name, SUM(p.qty * p.price) AS total_purches_value
FROM purchase p , client c 
WHERE p.clno = c.clno
GROUP BY c.name, p.compan

/*
* (E)
* For each client, list the book profit (or loss) on the total share investment. Book profit is the total value of all stocks based on the current prices less the total amount paid for purchasing them
*/
SELECT c.name, SUM(p.qty*s.dividend) - SUM(p.qty *(p.price - s.price)) AS profit
FROM client c, stock s, trading t, purchase p
WHERE s.company = t.company AND p.clno = c.clno
GROUP BY c.nam