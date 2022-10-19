/*
*Sri Lanka Institute of Information Technology
*Deparment of Computer Science and Software Engineering
*SE3060-Database-System
*Ashen DUnusinghe
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


