SELECT table_name FROM user_tables;

-- SQL vs PL/SQL
-- SQL (�м���90% + ������10%)
-- ���α׷��� ������ ����
-- PL/SQL (�м���10%+ ������70%+ DBA)

-- �Թ� : SQL���̺�, �� --> PL/SQL�Լ�, ��������

-- ���̺� ����
/*
CREAT TABLE ���̺��(
Į��1 Į��1_������Ÿ�� ����ġ �������,
)
*/

-- P50
CREATE TABLE ex2_1( 
COLUMN1 CHAR(10),
CULUMN2 VARCHAR(10),
CULUMN3 VARCHAR2(10),
CULUMN4 NUMBER
);

-- ������ �߰� 
INSERT INTO ex2_1 (column1, culumn2) VALUES ('abc', 'abc');

-- ������ ��ȸ
SELECT column1, LENGTH(column1) as len1,
       culumn2, LENGTH(culumn2) as len2
FROM ex2_1;

-- ������ ����
-- ������ ���� 

-- P53
-- ����� �� ���ڴ� 1byte
-- �ѱۿ��� �� ���ڴ� 2byte
CREATE TABLE ex2_2(
    COLUMN1 VARCHAR2(3), -- ����Ʈ���� byte����
    COLUMN2 VARCHAR2(3 byte),
    COLUMN3 VARCHAR2(3 char)
);


-- �����͸� �߰�
INSERT INTO ex2_2 VALUES ('abc', 'abc', 'abc');

SELECT column1, LENGTH(column1) As len1,
       column2, LENGTH(column2) As len2,
       column3, LENGTH(column3) As len3
   FROM ex2_2;
   
-- �ѱ��߰�
INSERT INTO ex2_2 VALUES('ȫ�浿', 'ȫ�浿', 'ȫ�浿');

INSERT INTO ex2_2 (column3) VALUES('ȫ�浿');

SELECT column3
    , LENGTH(column3) AS len3
    , LENGTHB(column3) AS bytelen
FROM ex2_2;

-- ���� ������ Ÿ��
CREATE TABLE ex2_3(
    COL_INT INTEGER,
    COL_DEC DECIMAL,
    COL_NUM NUMBER
);

SELECT column_id
    , column_name
    , data_type
    , data_length
FROM user_tab_cols
WHERE table_name = 'EX2_3'
ORDER BY column_id;

-- SQL vs pl/SQL
-- R dplyr ��Ű��, SQL ����ؼ� �������

-- SELECT �÷���
-- FROM 
-- WHERE 
-- ORDER BY ����

-- ��¥ ������ Ÿ��
CREATE TABLE ex2_5(
    COL_DATE DATE,
    COL_TIMESTAMP TIMESTAMP
    );

INSERT INTO ex2_5 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT *
    FROM ex2_5;
    
-- NULL : ���� ����
-- �ش� Į���� NULL
-- ����ġ ���x : NOT NULL


-- P60
CREATE TABLE ex2_6(
    COL_NULL VARCHAR2(10), -- ����ġ����
    COL_NOT_NULL VARCHAR2(10) NOT NULL -- ����ġ ���X
);

-- �����߻�
INSERT INTO ex2_6 VALUES ('AA','');

-- ���������� ���Ե�
INSERT INTO ex2_6 VALUES ('','BB');
SELECT * FROM ex2_6;

INSERT INTO ex2_6 VALUES ('AA','BB');
SELECT * FROM ex2_6;


SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'EX2_6';

-- UNIQUE
-- �ߺ��� ���

CREATE TABLE ex2_7(
    COL_UNIQUE_NULL VARCHAR2(10) UNIQUE
    , COL_UNIQUE_NNULL VARCHAR2(10) UNIQUE NOT NULL
    , COL_UNIQUE VARCHAR2(10)
    , CONSTRAINTS unique_nm1 UNIQUE (COL_UNIQUE)
);

SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'EX2_7';


INSERT INTO ex2_7 VALUES('AA','AA','AA');
INSERT INTO ex2_7 VALUES('','BB','CC');

-- �⺻Ű
-- Primary Key
-- UNIQUE(�ߺ� ��� �ȵ�), NOT NULL(����ġ ��� �ȵ�)
-- ���̺� �� 1���� �⺻Ű�� ��������

CREATE TABLE ex2_8(
COL1 VARCHAR2(10) PRIMARY KEY
, COL2 VARCHAR2(10)
);

INSERT INTO ex2_8 VALUES('AA','AA');

SELECT * FROM user_constraints;

SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'JOBS';


-- �ܷ�Ű : ���̺� ���� ���� �������� ���Ἲ�� ���� ��������
-- ���� ���Ἲ�� �����Ѵ�
-- �߸��� ������ �ԷµǴ� ���� �����Ѵ�

-- Check
-- �÷��� �ԷµǴ� �����͸� üũ�� Ư�����ǿ� �´� �����͸� �Է��Ѵ�

CREATE TABLE ex2_9(
    num1 NUMBER
    , CONSTRAINTS check1 CHECK (num1 BETWEEN 1 AND 9)
    , gender VARCHAR2(10)
    , CONSTRAINTS check2 CHECK (gender IN ('MALE','FEMALE'))
    );
    
 SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'ex2_9'; 

INSERT INTO ex2_9 VALUES(10,'MAN');
INSERT INTO ex2_9 VALUES(5,'FEMALE');

-- Default
alter session set nls_date_format='YYYY/MM/DD HH24:MI:SS';
CREATE TABLE ex2_10(
    Col1 VARCHAR2(10) NOT NULL
    , Col2 VARCHAR2(10) NULL
    , Create_date DATE DEFAULT SYSDATE
);

INSERT INTO ex2_10(col1, col2) VALUES('AA','BB');

SELECT * FROM ex2_10;

-- ���̺� ����
-- ALTER TABLE 
ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;
SELECT * FROM ex2_10;

DESC ex2_10;

-- �÷� Ÿ�� ����
ALTER TABLE ex2_10 MODIFY Col2 VARCHAR2(30);
DESC ex2_10;

-- �ű� �÷� �߰�
ALTER TABLE ex2_10 ADD Col3 NUMBER;
DESC ex2_10;

-- �÷� ����
ALTER TABLE ex2_10 DROP COLUMN Col3;
DESC ex2_10;

-- ��
CREATE OR REPLACE VIEW emp_dept_vi AS
SELECT a.employee_id
        , a.emp_name
        , a.department_id 
        , b.department_name
FROM employees a
    , departments b
WHERE a.department_id = b.department_id;

DROP VIEW  emp_dept_vi;

