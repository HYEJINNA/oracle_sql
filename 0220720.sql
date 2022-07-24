SELECT * FROM EX2_10;

-- P.92
-- SELECT 문 : 데이터 조회시 사용
-- 정렬해서 보고 싶다면 : ORDER BY
SELECT
    EMPLOYEE_ID
    , EMP_NAME
from EMPLOYEES
WHERE salary <30000
ORDER BY EMPLOYEE_ID;

-- 급여가 5000이상, job_id, IT_PROG 사원조회
SELECT EMPLOYEE_ID
    , EMP_NAME
FROM EMPLOYEES
WHERE SALARY > 5000
     AND JOB_ID = 'IT_PROG'
ORDER BY EMPLOYEE_ID;


-- 테이블에 별칭 줄수있음
-- a 원컬럼명(=EMPLOYEES)
SELECT a.EMPLOYEE_ID, a.EMP_NAME, a.DEPARTMENT_ID,
-- b 원컬럼명(=DEPARTMENTS)
b. DEPARTMENT_NAME AS dep_name
FROM
    EMPLOYEES a,
    DEPARTMENTS b
WHERE a.DEPARTMENT_ID = b.DEPARTMENT_ID;

--- INSERT문
스스로

P.101
-- MERGE문, 데이터를 합치기 또는 추가
-- 조건을 비교해서 테이블에 해당조건에 맞는 데이터가 없으면 추가
-- 있으면 UPDATE문을 수행한다

CREATE TABLE ex3_3(
    EMPLOYEE_ID NUMBER
    , bonus_amt number DEFAULT 0
);


INSERT INTO ex3_3(EMPLOYEE_ID)
SELECT e.EMPLOYEE_ID
FROM EMPLOYEES e, SALES s
WHERE e.EMPLOYEE_ID= s.EMPLOYEE_ID
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e. EMPLOYEE_ID; 


SELECT * 
    FROM ex3_3
    order by EMPLOYEE_ID;


-- p.103
-- 서브쿼리 
SELECT EMPLOYEE_ID, MANAGER_ID, SALARY, SALARY * 0.01
    FROM EMPLOYEES
 WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID
    FROM ex3_3)
    AND MANAGER_ID = 146;

SELECT EMPLOYEE_ID, MANAGER_ID, SALARY, SALARY * 0.01
    FROM EMPLOYEES
 WHERE EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID
    FROM ex3_3)
    AND MANAGER_ID = 146;

-- MERGE를 통해서 작성
-- 관리자 사번 146번인 것 중, ex3_3 테이블에 없는
-- 사원의 사번, 관리자 사번, 급여, 급여*0.01 조회
-- ex3_3 테이블의 160번 사원의 보너스 금액은 7.5로 신규입력

SELECT*FROM ex3_3;

MERGE INTO ex3_3 d
    USING(SELECT EMPLOYEE_ID, SALARY, MANAGER_ID
    FROM EMPLOYEES
    WHERE MANAGER_ID = 146) b 
    ON (d.EMPLOYEE_ID = b.EMPLOYEE_ID)
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt+b.salary*0.01
WHEN NOT MATCHED THEN
    INSERT (d.EMPLOYEE_ID, d.bonus_amt) VALUES (B.EMPLOYEE_ID, b.salary*0.01)
    WHERE b.salary < 8000;


SELECT * FROM ex3_3 ORDER BY employee_id;

-- p.106
-- 테이블에 있는 데이터 삭제
-- DROP TABLE ex3_3; (테이블 전체 삭제)
DELETE ex3_3;
SELECT*FROM ex3_3 ORDER BY EMPLOYEE_ID;


-- p.107 실무에서 중요개념
-- commit & ROLLBACK
-- COMMIT은 변경한 데이터를 데이터 베이스에 마지막으로 반영
-- ROLLBACK은 그 반대로 변경한 데이터를 변경하기 이전 상태로 되돌리는 역할

CREATE TABLE ex3_4(
    EMPLOYEE_ID NUMBER
);

INSERT into ex3_4 VALUES (100);

SELECT * FROM ex3_4;

-- P.110
-- ROWNUM
SELECT 
ROWNUM, EMPLOYEE_ID
FROM EMPLOYEES;


SELECT ROWNUM, EMPLOYEE_ID
    FROM EMPLOYEES
WHERE ROWNUM < 5;

-- ROWID
SELECT ROWNUM, EMPLOYEE_ID, ROWID
    FROM EMPLOYEES
WHERE RONUM < 5;

-- 연산자
-- OPERATOR 연산수행
-- 수식 연산자 & 문자연산자
-- '||' 두문자를 붙이는 연결 연산자

-- 표현식
-- 조건문, if 조건문(PL/SQL)
-- CASE 표현식

SELECT EMPLOYEE_ID, SALARY,
    CASE WHEN SALARY <= 5000 THEN 'C등급'
         WHEN SALARY > 5000 AND SALARY <= 15000 THEN 'B등급'
         ELSE 'A등급'
    END AS SALARY_GRADE
FROM EMPLOYEES

-- 조건식 (중요)
-- TRUE, FALSE, UNKNOWN 세 가지 타입으로 반환 
-- 비교조건식 
-- 분석가, DB 데이터를 추출할 시, 서브쿼리 

-- ANY : 제시한 부분 중 하나라도 일치하는 모든사원을 추출
SELECT EMPLOYEE_ID, salary
    FROM EMPLOYEES
   WHERE salary = ANY (2000, 3000, 4000)
   ORDER BY EMPLOYEE_ID;

SELECT EMPLOYEE_ID, salary
    FROM EMPLOYEES
   WHERE salary = 2000
      OR salary = 3000
      OR salary = 4000
   ORDER BY EMPLOYEE_ID;

-- 2000, 3000, 4000모두 포함되어야 해서 조회되는 직원이 없다 
SELECT EMPLOYEE_ID, salary
    FROM EMPLOYEES
   WHERE salary = ALL (2000, 3000, 4000)
   ORDER BY EMPLOYEE_ID;   

-- SOME : ANY와 비슷하게 동작
SELECT EMPLOYEE_ID, salary
    FROM EMPLOYEES
   WHERE salary = SOME (2000, 3000, 4000)
   ORDER BY EMPLOYEE_ID;  

-- 논리 조건식
SELECT EMPLOYEE_ID, SALARY
  FROM EMPLOYEES
 WHERE NOT(SALARY >= 2500)
ORDER BY EMPLOYEE_ID;

SELECT EMPLOYEE_ID, SALARY
  FROM EMPLOYEES
 WHERE SALARY BETWEEN 2000 AND 2500
 ORDER BY EMPLOYEE_ID;

-- IN 조건식 (많이 사용)
-- 조건절에 명시한 값이 포함된 건을 반환하는데 ANY와 비슷하다
SELECT EMPLOYEE_ID, SALARY
  FROM EMPLOYEES
 WHERE SALARY IN (2000,3000,4000)
 ORDER BY EMPLOYEE_ID;

--NOT IN : 제시된 조건이 아닌 것 
SELECT EMPLOYEE_ID, SALARY
  FROM EMPLOYEES
 WHERE SALARY NOT IN (2000,3000,4000)
 ORDER BY EMPLOYEE_ID;

-- EXISTS 조건식
-- "서브쿼리"만 올 수 있음
-- 문자열의 패턴을 검색해서 사용하는 조건식

SELECT EMP_NAME
FROM EMPLOYEES
WHERE EMP_NAME LIKE 'A%'
ORDER BY EMP_NAME;

SELECT EMP_NAME
FROM EMPLOYEES
WHERE EMP_NAME LIKE 'Al%'
ORDER BY EMP_NAME;

CREATE TABLE ex3_5(
    names VARCHAR2(30)
);
INSERT INTO ex3_5 VALUES ('홍길동');
INSERT INTO ex3_5 VALUES ('홍길용');
INSERT INTO ex3_5 VALUES ('홍길상');
INSERT INTO ex3_5 VALUES ('홍길미');

SELECT * FROM ex3_5
WHERE name LIKE '홍길%';


-- 4장 숫자함수
--P.126

SELECT ABS(10), ABS(-10), ABS(-10.123)
FROM DUAL;

--CEIL: 매개변수n과 같거나 가장 큰 정수를 반환
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001)
 FROM DUAL;

-- TRUNC : 반올림 하지 않고 n1을 소수점 기준 n2자리에서 무조건 잘라낸 결과를 반환
SELECT TRUNC(115.54), TRUNC(115.154,1), TRUNC(115.154,2), TRUNC(115.155, -2)
 FROM DUAL;

-- POWER
-- POWER함수, SQRT
SELECT POWER(3,2),POWER(3,3),POWER(3,3.0001)
 FROM DUAL;

 -- 제곱근 반환
 SELECT SQRT(2), SQRT(5)
  FROM DUAL;

-- 과거: SQL,DB에서 자료를 조회하는 용도
-- 현재: SQL -> 수학, 통계 도구처럼 진화, 간단한 시각화 가능
-- 오라클 19c부터 머신러닝 지원



-- 문자열 데이터 전처리 (책 잘 정리하기)
-- 게임사
-- 채팅 -> 문자데이터
-- 텍스트 마이닝(반도, 워드 클라우드)
-- 100GB/ RAM32GB, 64GB

SELECT INITCAP('Naver Say Googby')
, INITCAP('Naver6say*Good가Bye')
FROM DUAL;

SELECT LOWER ('NAVER SAY GOOBYE'),UPPER('naver say goodbye')
 FROM DUAL;

SELECT CONCAT('I Have','A Dream'),'I Have' || 'A Dream'
 FROM DUAL;

 SELECT SUBSTR('ABCDEFG', 1, 4), SUBSTR('ABCDEFG', -1, 4)
 FROM DUAL;

 SELECT LTRIM('ABCDEFGABC','ABC')
        , LTRIM('가나다라','가')
        , RTRIM('ABCDEFGABC', 'ABC')
        , RTRIM('가나다라', '라')
FROM DUAL;

CREATE TABLE ex4_1(
    phone_num VARCHAR2(30)
);

INSERT INTO ex4_1 VALUES ('111-1111');
INSERT INTO ex4_1 VALUES ('111-2222');
INSERT INTO ex4_1 VALUES ('111-3333');

SELECT * FROM ex4_1;

SELECT LPAD(phone_num, 12, '(02'))
FROM ex4_1;




-- 날짜함수(p.138)
SELECT SYSDATE, SYSTIMESTAMP
FROM DUAL;

-- ADD_MONTHS
SELECT ADD_MONTHS(SYSDATE,1), ADD_MONTHS(SYSDATE,-1)
FROM DUAL;

SELECT MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE,1)) mon1,
       MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1), SYSDATE) mon2
 FROM DUAL;

-- LAST DAY 
SELECT LAST_DAY(SYSDATE)
 FROM DUAL;

-- ROUND, TRUNC
SELECT SYSDATE, ROUND(SYSDATE,'month'),TRUNC(SYSDATE,'month')
 FROM DUAL;

 -- NEXT DAY 
 SELECT NEXT_DAY(SYSDATE,'금요일')
  FROM DUAL;



  -- NULL(중요)
  -- NVL : 표현식 1이 NULL일때, 표현식 2를 반환한다
-- SELECT manager_id, employee_id FROM DUAL; 

SELECT NVL(manager_id, employee_id)
FROM employees 
WHERE manager_id IS NULL;

NVN2: 표현식1이 NULL이 아니면, 표현식2 출력
      표현식2가 NULL이 이면, 표현식3 출력

SELECT employee_id
                , salary
                , commission_pct
                , NVL2(commission_pct, salary + (salary * commission_pct), salary) AS salary2
FROM employees
WHERE employee_id IN (118, 179);


-- COALESCE
SELECT employee_id, salary, commission_pct,
        COALESCE(salary * commission_pct, salary) AS salary2
    FROM employees;

-- DECODE
SELECT prod_id,
       DECODE(channel_id, 3, 'Direct',
                          9, 'Direct',
                         5, 'Indirect',
                         4, 'Indirect',
                              'Others') decodes
FROM sales
WHERE rownum < 10;

