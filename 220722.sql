220722
-- p198
-- 서브쿼리
-- SELECT, FROM, WHERE
-- FROM : 인라인뷰
-- 메인쿼리 : 사원테이블에서는 id, name출력
--            부서테이블에서는 부서ID, 부서명 출력
--            사원테이블의 급여가 기획부서의 평균급여보다 높은 사원
-- 서브쿼리 : 기획부사의 평균급여 

SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
    FROM employees a, 
    departments b, 
    (SELECT AVG(c.salary) AS avg_salary 
    FROM departments b, 
    employees c 
    WHERE b.parent_id = 90 
    AND b.department_id = c.department_id)d 
WHERE a.department_id = b.department_id 
AND a.salary>d.avg_salary;

SELECT 
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM employees a
            , departments b 
            , (SELECT AVG(c.salary) AS avg_salary
               FROM departments b
                           , employees c
               WHERE b.parent_id = 90
                    AND b.department_id = c.department_id) d
WHERE a.department_id = b.department_id
    AND a.salary > d.avg_salary;

-- 2000년 이탈리아 평균 매출액 (연평균)보다 큰 월이 평균 매출액을 구하는 것
SELECT 
    a.sales_month
    , ROUND(AVG(a.amount_sold)) AS month_avg 
FROM 
    sales a 
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID 
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
GROUP BY a.sales_month;
        


-- 연평균 매출액 쿼리
SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy'; -- 이탈리아     



SELECT a.*
FROM (SELECT 
                 a.sales_month
                , ROUND(AVG(a.amount_sold)) AS month_avg 
            FROM 
                sales a 
                , customers b
                , countries c
            WHERE a.sales_month BETWEEN '200001' AND '200012'
                AND a.cust_id = b.CUST_ID 
                AND b.COUNTRY_ID = c.COUNTRY_ID
                AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
                GROUP BY a.sales_month) a
                , (SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy') b
WHERE a.month_avg > b.year_avg;


-- 계층형 쿼리
-- p208 부서정보
-- p211 
-- STRAT WITH 조건 & CONNECT BY 조건
-- parent_id == 상위부서 정보를 가지고 있음
-- CONNECT BY PRIOR department_id = parent_id 
SELECT
    department_id 
    , LPAD('',3*(LEVEL-1))||department_name, LEVEL 
FROM departments 
START WITH parent_id is NULL 
CONNECT BY PRIOR department_id = parent_id;

-- 사원테이블에 있는 manager_id, employee_id 
SELECT a.employee_id, LPAD('',3*(LEVEL-1))||a.emp_name, 
            LEVEL, b.department_name 
FROM employees a, departments b 
WHERE a.department_id = b.department_id
START WITH a.manager_id is NULL 
CONNECT BY PRIOR a.employee_id = a.manager_id;


-- p213
SELECT a.employee_id, LPAD('',3*(LEVEL-1))||a.emp_name as empname,
            LEVEL, b.department_name, a.DEPARTMENT_ID  
FROM employees a, departments b 
WHERE a.department_id = b.department_id
AND a.department_id = 30
START WITH a.manager_id is NULL 
CONNECT BY PRIOR a.employee_id = a.manager_id;



SELECT a.employee_id, LPAD('',3*(LEVEL-1))||a.emp_name,
            LEVEL, b.department_name, a.DEPARTMENT_ID  
FROM employees a, departments b 
WHERE a.department_id = b.department_id
START WITH a.manager_id is NULL 
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id
    AND a.department_id = 30;


-- 계층형 쿼리 심화학습
-- 계층형 쿼리 정렬 ORDER BY 정렬가능
-- ORDER SIBLINGD BY

SELECT department_id, LPAD('',3*(level-1))||department_name, LEVEL 
    FROM departments 
    START WITH parent_id IS NULL 
    CONNECT BY PRIOR department_id = parent_id 
    ORDER BY department_name;

-- 연산자
-- CONNECT_BY_ROOT 
SELECT department_id, LPAD('',3*(level-1))||department_name, LEVEL,
    CONNECT_BY_ROOT department_name AS root_name 
FROM departments 
START WITH parent_id IS NULL 
CONNECT BY PRIOR department_id = parent_id;


-- p220
-- 계층형 쿼리 응용
CREATE TABLE ax7_1 AS 
SELECT ROWNUM seq,
        '2014'|| LPAD(CEIL(ROWNUM/1000), 2, '0') month, 
        ROUND(DBMS_RANDOM.VALUE(100,1000)) amt 
    FROM DUAL 
CONNECT BY LEVEL <= 12000;

SELECT * 
    FROM ax7_1;


SELECT month, SUM(amt)
    FROM ax7_1
    GROUP BY month 
    ORDER BY month;


--P226
-- WITH 절 
-- 서브쿼리의 가독성 향상
-- 연도별, 최종, 월별

WITH b2 AS(
    SELECT 
        period
        , region 
        , sum(loan_jan_amt)jan_amt 
        FROM kor_loan_status  
        GROUP BY period, region 
)

SELECT b2.*FROM b2;

SELECT SALARY FROM EMPLOYEES;

SELECT * FROM 


-- p231
-- 분석함수와 window 함수
-- 문법과 결과가 어떻게 달라지는지 확인
-- 분석함수(매개변수) OVER(PARTITION BY....)
-- ROW_NUMBER() / ROWNUM 

SELECT department_id, emp_name,
        ROW_NUMBER() OVER(PARTITION BY department_id
        ORDER BY department_id, emp_name)dep_rows
    FROM employees;


SELECT department_id, emp_name,
        salary,
        RANK()OVER(PARTITION BY department_id
        ORDER BY salary)dep_rank
    FROM employees;


-- p234
with temp AS (
SELECT 
    department_id
    , emp_name
    , salary
    -- , RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
    , DENSE_RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
FROM employees)

SELECT * 
FROM (SELECT 
    department_id
    , emp_name
    , salary
    -- , RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
    , DENSE_RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
FROM employees)
WHERE dep_rank <= 3;


-- CUME_DIST(): 상대적인 누적 분포도 값을 반환
SELECT department_id emp_name,
        salary, 
        CUME_DIST() OVER(PARTITION BY department_id 
                        ORDER BY salary) dep_dist 
FROM employees;

-- 백분위 순위 반환
-- 60번 부서에 대한 CUME_DIST(),PERCENT_RANK()값을 조회

SELECT department_id, emp_name,
        salary, 
        rank() OVER (PARTITION BY department_id 
                    ORDER BY salary)ranking 
        , CUME_DIST() OVER(PARTITION BY department_id 
                    ORDER BY salary)cume_dist_value 
        , PERCENT_RANK()OVER(PARTITION BY department_id 
                            ORDER BY salary ) percentile 
        FROM employees 
        WHERE department_id = 60;

-- NITILE
SELECT department_id, emp_name, 
        salary 
        , NTILE(4) OVER (PARTITION BY department_id 
                            ORDER BY salary 
                            ) NTILES 
        FROM employees 
        WHERE department_id IN (30,60);

-- LAG, LEAD 
SELECT emp_name, hire_date, salary, 
        LAG(salary, 1, 0) OVER (ORDER BY hire_date) AS prev_sal, 
        LEAD(salary, 1, 0) OVER (ORDER BY hire_date) AS next_sal 
    FROM employees
    WHERE department_id = 30;

SELECT emp_name, hire_date, salary, 
        LAG(salary, 2, 0) OVER (ORDER BY hire_date)AS prev_sal, 
        LEAD(salary, 2, 0) OVER (ORDER BY hire_date) AS next_sal 
FROM employees 
WHERE department_id = 30;

--  p240
-- window절
-- 정렬은 입사일자 순으로 처리
-- 급여, UNBOUNED PRECEING 부서별 입사일자가 가장 빠른 사원 
        UNBOUNED FOLLOWING 부서별 입사일자가 가장 늦은 사원
-- 누적합계 

SELECT department_id, emp_name, hire_date, salary,
        SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_Date 
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
                            ) AS all_salary, 
        SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_Date 
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
                            ) AS first_current_sal,
        SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_Date 
                            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                            ) AS current_end_sal
 FROM employees 
WHERE department_id IN (30,90);

