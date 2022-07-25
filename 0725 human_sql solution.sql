-- SQL 서브쿼리 연습문제
-- 문제 1. 2015년 평균 기대수명보다 높은 모든 정보를 조회하세요.
-- 테이블명 : populations
SELECT
    *
FROM populations
WHERE life_expectancy > (SELECT AVG(life_expectancy) FROM populations WHERE year = 2015)
	  AND year = 2015;
      

-- SQL 서브쿼리 연습문제
-- 문제 1. 2015년 평균 기대수명보다 높은 모든 정보를 조회하세요.
-- 테이블명 : populations
SELECT
    *
FROM populations
WHERE life_expectancy > (SELECT AVG(life_expectancy) FROM populations WHERE year = 2015)
	  AND year = 2015;
  
      
-- 문제 3. 
-- 조건 1. economies 테이블에서 country code, inflation rate, unemployment rate를 조회한다.
-- 조건 2. inflation rate 오름차순으로 정렬한다.
-- 조건 3. subquery_countries 테이블내 gov_form 컬럼에서 Constitutional Monarchy 또는 `Republic`이 들어간 국가는 제외한다.
-- Select fields
-- 데이터셋
SELECT code, inflation_rate, unemployment_rate
FROM economies
  WHERE year = 2015 AND code NOT IN
  	(SELECT code
  	 FROM subquery_countries
  	 WHERE (GOV_FORM = 'Constitutional Monarchy' OR GOV_FORM LIKE '%Republic%'))
ORDER BY inflation_rate;



-- 문제 4. 2010년 각 대륙별 inflation_rate가 가장 심한 국가와 inflation_rate를 구하세요. 
-- 힌트 1. 아래 쿼리 실행
SELECT name, continent, inflation_rate
  FROM subquery_countries 
  	INNER JOIN economies
    USING (code)
WHERE year = 2010;
SELECT * FROM subquery_countries;

-- 각 대륙별 inflation_rate가 가장 높은 나라를 추출하는 코드를 작성한다. 
SELECT sc.name, sc.continent, ec.inflation_rate
  FROM subquery_countries sc
	INNER JOIN economies ec
	ON sc.code = ec.code
  WHERE year = 2015
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT sc.name, sc.continent, ec.inflation_rate
             FROM subquery_countries sc
             INNER JOIN economies ec
             -- Using(code) 대신 ON 쿼리를 작성합니다.
             ON sc.code = ec.code
             WHERE year = 2015)
        GROUP BY continent);



-- SQL 윈도우 함수 연습문제
-- 문제 1. 각 행에 숫자를 1, 2, 3, ..., 형태로 추가한다. (row_n 으로 표시)
-- row_n 기준으로 오름차순으로 출력
-- 테이블명에 alias를 적용한다. 
SELECT 
    ROWNUM as row_n
    , sm.*
FROM summer_medals sm;



-- 문제 2. 올림픽 년도를 오름차순 순번대로 작성을 한다. 
-- 힌트 : 서브쿼리와 윈도우 함수를 이용한다. 
SELECT 
    Year, 
    ROW_NUMBER() OVER(ORDER BY Year) AS Row_N
FROM (
    SELECT DISTINCT Year
    FROM summer_medals
) Years;


-- 문제 3. 
-- (1) WITH 절 사용하여 각 운동선수들이 획득한 메달 갯수를 내림차순으로 정렬하도록 합니다. 
-- (2) (1) 쿼리를 활용하여 그리고 선수들의 랭킹을 추가한다. 
-- 상위 5개만 추출 : OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
-- WITH AS (1번 쿼리)
-- 2번 쿼리

WITH medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM summer_medals
  GROUP BY Athlete)

SELECT
  Medals, 
  Athlete,
  ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM medals
ORDER BY Medals DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


-- 문제 4
-- 다음쿼리를 실행한다. 
-- 남자 69KG 역도 경기에서 매년 금메달리스트 조회하도록 합니다. 
SELECT
    Year,
    Country AS champion
  FROM summer_medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold';
    
    
-- 기존 쿼리에서 매년 전년도 챔피언도 같이 조회하도록 합니다.
-- LAG & WITH 절 사용
WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM summer_medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')

SELECT
  Year, Champion,
  LAG(Champion) OVER
    (ORDER BY Year ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;
    