220721
-- 기본 집계함수
SELECT COUNT(*)
    FROM employees;

SELECT COUNT(DISTINCT department_id)
    FROM employees;

-- 기초통계량(p154)
-- 합계, 평균, 최소, 최대, 분산, 표준편차
-- SQL> 통계도구 & 머신러닝, 데이터 과학 도구로 통합하는 추세
SELECT SUM(salary)
FROM employees;

-- 평균값 반환
SELECT SUM(salary), SUM(DISTINCT salary)
    FROM employees;

SELECT AVG(salary), AVG(DISTINCT salary)
    FROM employees;

-- 분산, 표준편차
SELECT VARIANCE(salary), STDDEV(salary)
    FROM employees;

-- GROUP BY
-- 그전까지는 전체데이터를 기준으로 집계
SELECT department_id, SUM(salary)
FROM employees 
GROUP BY department_id 
ORDER BY department_id;

SELECT *
    FROM kor_loan_status;

SELECT period, region, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status 
    WHERE period LIKE '2013%'
    GROUP BY period, region 
    ORDER BY period, region;

-- GROUP BY 표현식이 아님
SELECT period, region, SUM(loan_jan_amt) totl_jan 
    FROM kor_loan_status 
    WHERE period = '201311'
    GROUP BY region 
    ORDER BY region;

-- period 제거하면 정상출력됨
SELECT region, SUM(loan_jan_amt) totl_jan 
    FROM kor_loan_status 
    WHERE period = '201311'
    GROUP BY region 
    ORDER BY region;


SELECT period, region, SUM(loan_jan_amt) totl_jan 
    FROM kor_loan_status 
    WHERE period = '201311'
    GROUP BY period, region 
    HAVING SUM(loan_jan_amt)>100000
    ORDER BY region;

-- ROLLUP절과 CUBE절
SELECT period, gubun, SUM(loan_jan_amt) totl_jan 
    FROM kor_loan_status 
    WHERE period LIKE '2013%'
    GROUP BY period, gubun 
    ORDER BY period;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan 
    FROM kor_loan_status 
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(period, gubun);
    

SELECT period, gubun, SUM(loan_jan_amt) totl_jan 
    FROM kor_loan_status 
    WHERE period LIKE '2013%'
    GROUP BY period, ROLLUP(gubun);


-- CUBE
SELECT period, gubun, SUM(loan_jan_amt) totl_jan 
    FROM kor_loan_status 
    WHERE period LIKE '2013%'
    GROUP BY CUBE(period, gubun);

-- 집합연산자
CREATE TABLE exp_goods_asia (
           country VARCHAR2(10),
           seq     NUMBER,
           goods   VARCHAR2(80));

    INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
    INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
    INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
    INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
    INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
    INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
    INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
    INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
    INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
    INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

    INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
    INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
    INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
    INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
    INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
    INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
    INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
    INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
    INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
    INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');
commit;

SELECT * FROM exp_goods_asia;

-- UNION 합집합
SELECT goods 
    FROM exp_goods_asia 
    WHERE country = '한국'
    UNION 
    SELECT goods 
    FROM exp_goods_asia 
    WHERE country = '일본';

-- UNION ALL
-- 중복된 항목도 조회된다
SELECT goods 
    FROM exp_goods_asia 
    WHERE country = '한국'
    UNION ALL
    SELECT goods 
    FROM exp_goods_asia 
    WHERE country = '일본';

-- INTERSECT 교집합
SELECT goods 
    FROM exp_goods_asia 
    WHERE country = '한국'
    INTERSECT
    SELECT goods 
    FROM exp_goods_asia 
    WHERE country = '일본';

-- MINUS 차집합
SELECT goods 
    FROM exp_goods_asia 
    WHERE country = '한국'
   MINUS
    SELECT goods 
    FROM exp_goods_asia 
    WHERE country = '일본';

-- GROUPING SETS절

SELECT period, gubun, region, SUM(loan_jan_amt) totl_jan 
    FROM kor_loan_status 
    WHERE period LIKE '2013%'
    AND region IN ('서울','경기')
    GROUP BY GROUPING SETS(period, (gubun,region));

-- 조인의 종류
-- 동등조인
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
    FROM employees a,
        departments b 
    WHERE a.department_id = b.department_id;

-- 세미조인
-- 서브쿼리를 이용해 서브쿼리에 존재하는 데이터만 메인 쿼리에사 추출
-- EXISTS
SELECT department_id, department_name 
    FROM departments a 
    WHERE EXISTS(SELECT * FROM employees b
    WHERE a.department_id = b.department_id 
    AND b.salary>3000)
ORDER BY a.department_name;


-- IN
SELECT department_id, department_name 
    FROM departments a 
    WHERE a.department_id IN (SELECT b.department_id FROM employees b
    WHERE b.salary>3000)
ORDER BY a.department_name;


SELECT a. department_id, a.department_name 
    FROM departments a, employees b 
    WHERE a.department_id = b.department_id 
    AND b.salary>3000
ORDER BY a.department_name;

-- 안티조인
-- 세미조인의 반대 개념
-- NOT IN, NOT EXISTS을 사용
SELECT a. employee_id, a.emp_name, a.department_id, b.department_name 
    FROM employees a, departments b 
    WHERE a.department_id = b.department_id 
    AND a.department_id NOT IN (SELECT department_id 
                                    FROM departments 
                                    WHERE manager_id IS NULL);


-- 셀프조인
SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id 
    FROM employees a, employees b 
    WHERE a.employee_id < b.employee_id 
    AND a.department_id = b.department_id 
    AND a.department_id = 20;

-- p181
-- 일반조인
SELECT a.department_id, a.department_name, b.job_id, b.department_id 
    FROM departments a,
    job_history b 
    WHERE a.department_id = b.department_id;

-- 외부조인
SELECT a.department_id, a.department_name, b.job_id, b.department_id 
    FROM departments a, 
    job_history b 
    WHERE a.department_id = b.department_id(+);


SELECT a.employee_id, a.emp_name, b.job_id, b.department_id 
    FROM employees a, 
    job_history b 
    WHERE a.employee_id = b.employee_id(+)
    AND a.department_id = b.department_id;

-- ANSI 조인
-- ANSI 내부조인 (기억하기)
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name 
    FROM employees a 
    INNER JOIN departments b 
    ON (a.department_id = b.department_id)
  WHERE a.hire_date<=TO_DATE('2003-01-01', 'YYYY-MM-DD');

  -- ANSI 외부조인
  SELECT a.employee_id, a.emp_name, b.job_id, b.department_id 
    FROM employees a
    LEFT OUTER JOIN job_history b 
    ON (a.employee_id = b.employee_id(+))
    and a.department_id = b.department_id;

-- RIGHT JOIN
ELECT a.employee_id, a.emp_name, b.job_id, b.department_id 
    FROM employees a 
    LEFT JOIN job_history b 
    ON (a.employee_id = b.employee_id
        and a.department_id = b.department_id);


SELECT a.employee_id, a.emp_name, b.job_id, b.department_id 
    FROM job_history b 
    RIGHT OUTER JOIN employees a 
    ON (a.employee_id = b.EMPLOYEE_ID
        and a.department_id = b.department_id);

-- 서브쿼리
-- SQL수업의 하이라이트
-- SELECT, FROM, WHERE

SELECT count(*)
    FROM employees 
    WHERE salary >= (SELECT AVG(salary)
    FROM employees);


SELECT count(*)
    FROM employees 
    WHERE department_id IN (SELECT department_id
                            FROM departments 
                            WHERE parent_id IS NULL);


SELECT employee_id, emp_name, job_id 
    FROM employees 
    WHERE (employee_id, job_id) IN (SELECT employee_id, job_id 
                                            FROM job_history);



-- 서브쿼리 SELCECT 뿐 아니라 UPDATE, DELETE문
-- 전 사원의 급여를 평균 금액으로 갱신 
-- commit 금지 
UPDATE employees 
    SET salary = (SELECT AVG(salary)
                    FROM employees);


-- 연관성있는 서브쿼리
SELECT a.department_id, a.department_name 
    FROM departments a 
    WHERE EXISTS(SELECT 1 
                    FROM job_history b 
                    WHERE a.department_id = b.department_id);



SELECT a.employee_id, 
        (SELECT b.emp_name 
        FROM employees b 
        WHERE a.employee_id = b.employee_id) AS emp_name, 
        a.department_id, 
        (SELECT b.department_name 
        FROM departments b 
        WHERE a.department_id = b.department_id) AS dep_name 
    FROM job_history a;





SELECT a.department_id, a.department_name 
    FROM departments a 
    WHERE EXISTS (SELECT 1 
                    FROM employees b 
                    WHERE a.department_id = b.department_id 
                    AND b.salary > (SELECT AVG(salary) 
                                        FROM employees)
                                        );

-- 서브쿼리 잘하는 방법 : 분할하고 다시 합치기 


-- p196
-- 메인쿼리
SELECT department_id, AVG(salary) 
    FROM employees a 
    WHERE department_id IN (SELECT department_id 
                                FROM departments 
                                WHERE parent_id = 90)
GROUP BY department_id;

