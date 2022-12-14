/*
*Sri Lanka Institute of Information Technology
*Deparment of Computer Science and Software Engineering
*SE3060-Database-System
*Ashen Dunusinghe
*/

/*
*@Worksheet-02
*/

/*
* (A)
*Define object types emp_t and dept_t with attributes of EMP and DEPT respectively. Use REF types for workdept (of EMP), and mgrno and admrdept (of DEPT)
*/


CREATE TYPE dept_t
/

CREATE TYPE emp_t AS OBJECT
(
    EMPNO CHAR(6),
    FIRSTNAME VARCHAR(12),
    LASTNAME VARCHAR(15),
    WORKDEPT REF dept_t,
    SEX CHAR(1),
    BIRTHDAY DATE,
    SALARY NUMBER(8,2)

)
/
CREATE TYPE dept_t AS OBJECT
(
 DEPTNO CHAR(3),
 DEPTNAME VARCHAR(36),
 MGRNO REF emp_t,
 ADMRDEMPT REF dept_t
)
/

/*===============================================================================================*/

/*
*(B)
*Create tables (named as OREMP and ORDEPT) using the object types defined in (a), with appropriate primary keys and referential constraints.
*
*/
CREATE TABLE OREMP OF emp_t
(
    CONSTRAINT OREMP_PK PRIMARY KEY(EMPNO),
    CONSTRAINT OREMP_FIRSTNAME_NN FIRSTNAME NOT NULL,
    CONSTRAINT OREMP_LASTNAME_NN LASTNAME NOT NULL ,
    CONSTRAINT OREMP_SEX_CK CHECK (SEX='M' OR SEX='F' OR SEX='m'OR SEX='f')
)
/
CREATE TABLE ORDEPT OF dept_t
(
    CONSTRAINT DEPTNO_PK PRIMARY KEY(DEPTNO),
    CONSTRAINT ORDEPT_DEPTNAME_NN DEPTNAME NOT NULL,
    CONSTRAINT ORDEPT_MGRNO_FK FOREIGN KEY(MGRNO) REFERENCES OREMP,
    CONSTRAINT ORDEPT_ADMRDEMPT_FK FOREIGN KEY(ADMRDEMPT) REFERENCES ORDEPT
)
/

ALTER TABLE OREMP
ADD CONSTRAINT OREMP_WORKDEPT_FK FOREIGN KEY(WORKDEPT) REFERENCES ORDEPT

/*===============================================================================================*/



/*
*(C)
*Insert data into the object relational tables created in (b), using the data in EMP and DEPT tables given 
*below. (First insert rows into oremp with null for workdept and rows into ordept with null for admrdept. 
*Then update oremp and ordept with actual REF values for workdept and admrdept.)
*
*/


INSERT INTO ORDEPT VALUES
(   
    dept_t
    (
        'A00',
        'SPIFFY COMPUTER SERVICE DIV',
        NULL,
        NULL
    )
)


INSERT INTO ORDEPT VALUES
(   
    dept_t
    (
        'B01',
        'PLANNING',
        NULL,
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'A00')
    )
)

INSERT INTO ORDEPT VALUES
(   
    dept_t
    (
        'C01',
        'INFORMATION CENTRE',
        NULL,
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'A00')
    )
)

INSERT INTO ORDEPT VALUES
(   
    dept_t
    (
        'D01',
        'DEVELOPMENT CENTRE',
        NULL,
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'C01')
    )
)

UPDATE ORDEPT d
SET d.ADMRDEMPT = (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'A00')
WHERE d.DEPTNO = 'A00'

INSERT INTO OREMP VALUES
(   
    emp_t
    (
        '000010',
        'CHRISTINE',
        'HAAS',
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'A00'),
        'F',
        '14-AUG-1953',
        72750
    )
)

INSERT INTO OREMP VALUES
(   
    emp_t
    (
        '000020',
        'MICHAEL',
        'THOMPSON',
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'B01'),
        'M',
        '02-FEB-1968',
        61250
    )
)

INSERT INTO OREMP VALUES
(   
    emp_t
    (
        '000030',
        'SALLY',
        'KWAN',
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'C01'),
        'F',
        '11-MAY-1971',
        58250
    )
)

INSERT INTO OREMP VALUES
(   
    emp_t
    (
        '000060',
        'IRVING',
        'STERN',
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'D01'),
        'M',
        '07-JUL-1965',
        55555
    )
)

INSERT INTO OREMP VALUES
(   
    emp_t
    (
        '000070',
        'EVA',
        'PULASKI',
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'D01'),
        'F',
        '26-MAY-1973',
        56170
    )
)

INSERT INTO OREMP VALUES
(   
    emp_t
    (
        '000050',
        'JOHN',
        'GEYER',
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'C01'),
        'M',
        '15-SEP-1955',
        60175
    )
)

INSERT INTO OREMP VALUES
(   
    emp_t
    (
        '000090',
        'EILEEN',
        'HENDERSON',
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'B01'),
        'F',
        '15-MAY-1961',
        49750
    )
)

INSERT INTO OREMP VALUES
(   
    emp_t
    (
        '000100',
        'THEODORE',
        'SPENSER',
        (SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'B01'),
        'M',
        '15-MAY-1976',
        46150
    )
)

UPDATE ORDEPT d 
SET d.MGRNO = (SELECT REF(e) FROM OREMP e WHERE e.EMPNO = '000010')
WHERE d.DEPTNO = 'A00'

UPDATE ORDEPT d 
SET d.MGRNO = (SELECT REF(e) FROM OREMP e WHERE e.EMPNO = '000020')
WHERE d.DEPTNO = 'B01'

UPDATE ORDEPT d 
SET d.MGRNO = (SELECT REF(e) FROM OREMP e WHERE e.EMPNO = '000030')
WHERE d.DEPTNO = 'B01'

UPDATE ORDEPT d 
SET d.MGRNO = (SELECT REF(e) FROM OREMP e WHERE e.EMPNO = '000060')
WHERE d.DEPTNO = 'B01'


/*
*(2)
*Answer the following queries using OREMP and ORDEPT tables
*
*/

/*
*(A)
*Get the department name and manager???s lastname for all departments
*/

SELECT 
    d.DEPTNAME, 
    d.MGRNO.LASTNAME AS Manager
FROM ORDEPT d


/*
*(B)
*Get the employee number, lastname and the department name of every employe
*/

SELECT 
    e.EMPNO, 
    e.LASTNAME, 
    e.WORKDEPT.DEPTNAME AS DepatmentName
FROM OREMP e 

/*
*(C)
*For each department, display the department number, department name, and name of the administrative department.
*/

SELECT 
    d.DEPTNO, 
    d.DEPTNAME, 
    d.ADMRDEMPT.DEPTNAME AS AdminstrativeDepatmentName
FROM ORDEPT d

/*
*(D)
* For each department, display the department number, department name, the name of the administrative department and the last name of the manager of the administrative department.
*/

SELECT 
    d.DEPTNO, 
    d.DEPTNAME, 
    d.ADMRDEMPT.DEPTNAME AS ADMRNAME, 
    d.ADMRDEMPT.MGRNO.LASTNAME AS ADMANAGER
FROM ORDEPT d

/*
*(E)
*Display the employee number, firstname, lastname and salary of every employee, along with lastname and salary of the manager of the employee???s work department
*/
SELECT 
       e.EMPNO,
       e.FIRSTNAME,
       e.LASTNAME,
       e.SALARY,
       e.WORKDEPT.MGRNO.LASTNAME AS ManagerName,
       e.WORKDEPT.MGRNO.SALARY   AS ManagerSalary
FROM OREMP e


/*
*(F)
*Show the average salary for men and the average salary for women for each department. Identify the department by both department number and name. 
*/
 

SELECT 
    e.WORKDEPT.DEPTNO   AS DeparmentNo, 
    e.WORKDEPT.DEPTNAME AS DepatmentName, 
    e.SEX, AVG(e.SALARY) AS AverageSalary
FROM OREMP e
GROUP BY e.WORKDEPT.DEPTNO, e.WORKDEPT.DEPTNAME, e.SEX