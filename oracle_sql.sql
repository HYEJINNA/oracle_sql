SELECT table_name FROM user_tables;

-- SQL vs PL/SQL
-- SQL (분석가90% + 개발자10%)
-- 프로그래밍 성격이 얕음
-- PL/SQL (분석가10%+ 개발자70%+ DBA)

-- 입문 : SQL테이블, 뷰 --> PL/SQL함수, 프러시저

-- 테이블 생성
/*
CREAT TABLE 테이블명(
칼럼1 칼럼1_데이터타입 결측치 허용유무,
)
*/

-- P50
CREATE TABLE ex2_1( 
COLUMN1 CHAR(10),
CULUMN2 VARCHAR(10),
CULUMN3 VARCHAR2(10),
CULUMN4 NUMBER
);

-- 데이터 추가 
INSERT INTO ex2_1 (column1, culumn2) VALUES ('abc', 'abc');

-- 데이터 조회
SELECT column1, LENGTH(column1) as len1,
       culumn2, LENGTH(culumn2) as len2
FROM ex2_1;

-- 데이터 수정
-- 데이터 삭제 

-- P53
-- 영어에서 한 문자는 1byte
-- 한글에서 한 문자는 2byte
CREATE TABLE ex2_2(
    COLUMN1 VARCHAR2(3), -- 디폴트값이 byte적용
    COLUMN2 VARCHAR2(3 byte),
    COLUMN3 VARCHAR2(3 char)
);


-- 데이터를 추가
INSERT INTO ex2_2 VALUES ('abc', 'abc', 'abc');

SELECT column1, LENGTH(column1) As len1,
       column2, LENGTH(column2) As len2,
       column3, LENGTH(column3) As len3
   FROM ex2_2;
   
-- 한글추가
INSERT INTO ex2_2 VALUES('홍길동', '홍길동', '홍길동');

INSERT INTO ex2_2 (column3) VALUES('홍길동');

SELECT column3
    , LENGTH(column3) AS len3
    , LENGTHB(column3) AS bytelen
FROM ex2_2;

-- 숫자 데이터 타입
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
-- R dplyr 패키지, SQL 모방해서 만들었음

-- SELECT 컬럼명
-- FROM 
-- WHERE 
-- ORDER BY 정렬

-- 날짜 데이터 타입
CREATE TABLE ex2_5(
    COL_DATE DATE,
    COL_TIMESTAMP TIMESTAMP
    );

INSERT INTO ex2_5 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT *
    FROM ex2_5;
    
-- NULL : 값이 없음
-- 해당 칼럼은 NULL
-- 결측치 허용x : NOT NULL


-- P60
CREATE TABLE ex2_6(
    COL_NULL VARCHAR2(10), -- 결측치없음
    COL_NOT_NULL VARCHAR2(10) NOT NULL -- 결측치 허용X
);

-- 에러발생
INSERT INTO ex2_6 VALUES ('AA','');

-- 정상적으로 삽입됨
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
-- 중복값 허용

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

-- 기본키
-- Primary Key
-- UNIQUE(중복 허용 안됨), NOT NULL(결측치 허용 안됨)
-- 테이블 당 1개의 기본키만 설정가능

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


-- 외래키 : 테이블 간의 참조 데이터의 무결성을 위한 제약조건
-- 참조 무결성을 보장한다
-- 잘못된 정보가 입력되는 것을 방지한다

-- Check
-- 컬럼에 입력되는 데이터를 체크해 특정조건에 맞는 데이터를 입력한다

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

-- 테이블 변경
-- ALTER TABLE 
ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;
SELECT * FROM ex2_10;

DESC ex2_10;

-- 컬럼 타입 변경
ALTER TABLE ex2_10 MODIFY Col2 VARCHAR2(30);
DESC ex2_10;

-- 신규 컬럼 추가
ALTER TABLE ex2_10 ADD Col3 NUMBER;
DESC ex2_10;

-- 컬럼 삭제
ALTER TABLE ex2_10 DROP COLUMN Col3;
DESC ex2_10;

-- 뷰
CREATE OR REPLACE VIEW emp_dept_vi AS
SELECT a.employee_id
        , a.emp_name
        , a.department_id 
        , b.department_name
FROM employees a
    , departments b
WHERE a.department_id = b.department_id;

DROP VIEW  emp_dept_vi;

