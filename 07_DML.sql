/*
@ 데이터 딕셔너리 (Data Dictionary)
-> 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블
-> 데이터 딕셔너리는 사용자가 테이블을 생성하거나 사용자를 변경하는 등의
작업을 할 때 데이터베이스 서버에 의해 자동으로 갱신되는 테이블
-> 사용자는 데이터 딕셔너리의 내용을 직접 수정하거나 삭제할 수 없음
-> 데이터 딕셔너리 안에는 중요한 정보가 많이 있기 때문에 사용자는 이를 활용하기 위해
데이터 딕셔너리 뷰를 사용하게 됨
	
	※ 뷰(VIEW)는 뒤에 배우겠지만 미리 말씀 드리면 원본 테이블을 
	커스터마이징해서 보여주는 원본테이블의 가상의 TABLE 객체


@ 3개의 데이터 딕셔너리 뷰 (Data Dictionary View)


1. DBA_XXXX : 데이터 베이스 관리자만 접근이 가능한 객체 등의 정보 조회
	(DBA는 모든 접근이 가능하므로 결국 디비에 있는 모든 객체에 대한 조회가 됨) 

2. ALL_XXXX : 자신의 계정이 소유하거나 권한을 부여받은 객체 등에 관한 정보 조회

3. USER_XXXX : 자신의 계정이 소유한 객체 등에 관한 정보 조회

*/
SELECT  * FROM USER_TABLES; --테이블의정보
SELECT * FROM USER_TAB_COLUMNS; --테이블내컬럼정보
SELECT * FROM USER_VIEWS;--뷰정보
SELECT * FROM USER_CONSTRAINTS;--테이블의 제약조건 검색
SELECT * FROM USER_CONS_COLUMNS;--컬럼의 제약조건 검색



-- DML(Data Manupulation Language)
-- INSERT, UPDATE, DELETE, SELECT
-- : 데이터 조작 언어, 테이블에 값을 삽입하거나, 수정하거나,
--   삭제하거나, 조회하는 언어


--INSERT : 새로운행을 추가하는 구문이다. 
--         테이블의 행의 갯수가 증가한다. 

-- 테이블에 모든 컬럼에 대해 값을 INSERT
-- INSERT INTO 테이블명  VALUES(데이터, 데이터,,,,...)

-- 테이블에 일부컬럼에대해 INSERT
-- INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명,....)  VALUES(데이터, 데이터,데이터,,,...)
 
 
 INSERT INTO EMPLOYEE
    VALUES ( 900,'장채현','901123-1080503','jang@kh.co.kr','01055569512',
            'D1' , 'J7' , 'S3', 4300000 , 0.2,
            '200', SYSDATE, NULL, DEFAULT -- 'N'
            );
    
COMMIT;
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME = '장채현';

--INSERT 시 에 VALUES 대신 서브쿼리를 이용할 수 있다.
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR(20)
);

SELECT *
FROM EMP_01;

INSERT INTO EMP_01
    (
        SELECT EMP_ID,EMP_NAME,DEPT_TITLE
        FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    
    );
    
CREATE TABLE EMP_DEPT_D1
AS
SELECT 
    EMP_ID, 
    EMP_NAME,  
    DEPT_CODE,
    HIRE_DATE
FROM EMPLOYEE
WHERE 1=0;

SELECT * FROM EMP_DEPT_D1;

CREATE TABLE EMP_MANAGER
AS
SELECT
    EMP_ID,
    EMP_NAME,
    MANAGER_ID
FROM EMPLOYEE
WHERE 1=0;

SELECT * FROM EMP_MANAGER;
    
 -- EMP_DEPT_D1테이블에 EMPLOYEE 테이블에서 부서코드가 D1인 
-- 직원을 조회해서 사번, 이름 , 소속 부서, 입사일을 삽입하고,
-- EMP_MANAGER 테이블에 EMPLOYEE 테이블에서 부서코드가 D1인 
-- 직원을 조회해서 사번, 이름, 관리자사번을 조회해서 삽입하세요 

INSERT INTO EMP_DEPT_D1
    (
        SELECT
            EMP_ID,
            EMP_NAME,
            DEPT_CODE,
            HIRE_DATE
            FROM EMPLOYEE
            WHERE DEPT_CODE = 'D1'
    );


INSERT INTO EMP_MANAGER
    (   
        SELECT
        EMP_ID,
        EMP_NAME,
        MANAGER_ID
        FROM EMPLOYEE
        WHERE DEPT_CODE ='D1'
    );
    
     
DELETE FROM EMP_DEPT_D1;
DELETE FROM EMP_MANAGER;

--INSERT ALL: INSERT시에 사용하는 서브쿼리가 같은경우 
--            두개이상의 테이블에 INSERT ALL 을 이용하여 
--            한번에 데이터를 삽입할수 있다. 
--            단, 각 서브쿼리의 조건절이 같아야 한다. 

INSERT ALL          ---조건이 같기 때문에 한번에 처리해줄 수 있다.
    INTO EMP_DEPT_D1
    VALUES (EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER
    VALUES (EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT 
        EMP_ID,
        EMP_NAME,
        DEPT_CODE,
        HIRE_DATE,
        MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';
    
    
SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;


--EMPLOYEE 테이블에서 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의 사번, 이름, 입사일, 급여를 조회하여
--EMP_OLD 테이블에 삽입하고 그 이후에 입사한 사원은 EMP_NEW 테이블에 삽입하세요

CREATE TABLE EMP_OLD
AS
SELECT
    EMP_ID,
    EMP_NAME,
    HIRE_DATE,
    SALARY
FROM EMPLOYEE
WHERE 1=0;


CREATE TABLE EMP_NEW
AS
SELECT
    EMP_ID,
    EMP_NAME,
    HIRE_DATE,
    SALARY
FROM EMPLOYEE
WHERE 1=0;


INSERT ALL
    WHEN HIRE_DATE < '2000/01/01'
    THEN INTO EMP_OLD
    VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    WHEN HIRE_DATE >= '2000/01/01'
    THEN INTO EMP_NEW
    VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT 
        EMP_ID,
        EMP_NAME,
        HIRE_DATE,
        SALARY
    FROM EMPLOYEE;
    
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;


--UPDATE 테이블명 SET 컬럼명 = 바꿀 값, 컬럼명 = 바꿀값,컬럼명 .....
--[WHERE 컬럼명 비교연산자 비교값]; 
CREATE TABLE DEPT_COPY
AS
SELECT * FROM DEPARTMENT;


SELECT *
FROM DEPT_COPY
WHERE DEPT_ID = 'D9';

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

--UPDATE에도 서브쿼리 사용가능
--UPDATE 테이블명
--SET 컬럼명 = ( 서브쿼리 )
--[WHERE 컬럼명 비교연산자 비교값];

CREATE TABLE EMP_SALARY
AS
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY,
    BONUS
FROM EMPLOYEE;


SELECT
    *
FROM EMP_SALARY
WHERE EMP_NAME IN ('유재식','방명수');

--평상시 유재식 사원을 부러워하던 방명수 사원의 급여와 보너스율을 유재식 사원과 동일하게 변경해주기로 했다.
--이를 반영하는 UPDATE문을 작성해보세요


UPDATE EMP_SALARY
SET SALARY=(SELECT SALARY
            FROM EMPLOYEE
            WHERE EMP_NAME =  '유재식'
            ), -- 유재식의 급여를 조회하여 가져옴.
    BONUS=(SELECT BONUS
            FROM EMPLOYEE
            WHERE EMP_NAME =  '유재식'
            )  --유재식의 보너스를 조회해서 가쟈옴
WHERE EMP_NAME = '방명수'; --변경하고자 하는 사원의 이름



--다중열 서브쿼리를 이용한 UPDATE 문
--방명수 사원의 급여 인상소식을 전해들은 다른 직원들이 단체로 파업을 진행했다.
--노옹철, 전형돈, 정중하, 하동운 사원의 급여와 보너스를 유재식 사원의 급여와 보너스를 같게 변경하는 UPDATE문을 작성하시오.


UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS  --순서 똑같이 
                        FROM EMPLOYEE
                        WHERE EMP_NAME =  '유재식'
                       )
WHERE EMP_NAME IN ('노옹철','전형돈','정중하','하동운');

SELECT
    *
FROM EMP_SALARY
WHERE EMP_NAME IN ('유재식','방명수','노옹철','전형돈','정중하','하동운');

--다중행 서브쿼리를 이용한 업데이트
--EMP_SALARY 테이블에서 아시아 근무지역에 근무하는 직원의 보너스를 0.5로 변경하시오

UPDATE EMP_SALARY   --업데이트 할 테이블명 기술
SET BONUS = 0.5    -- 보너스를 0.5로 셋팅해줌
WHERE EMP_ID IN (SELECT EMP_ID
                    FROM EMPLOYEE A
                    JOIN DEPARTMENT B ON A.DEPT_CODE = DEPT_ID
                    JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
                    WHERE LOCAL_NAME LIKE 'ASIA%');
                    
COMMIT;
--UPDATE시 변경할 값은 해당 컬럼에 대한 제약조건에 위배되지 않아야 한다.

UPDATE EMPLOYEE
SET DEPT_CODE = '65' --FOREIGN KEY 제약조건에 위배됨
WHERE DEPT_CODE = 'D6';
                
                
UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200;

UPDATE EMPLOYEE
SET EMP_NO = '621235-1985634' --UNIQUE 제약 조건에 위배됨.
WHERE EMP_NO = 201;

ROLLBACK;


-- DELETE : 테이블의 행을 삭제하는 구문이다.
-- 테이블의 행의 갯수가 줄어든다
-- DELETE FROM 테이블명 WHERE 조건설정
-- 만약 WHERE 절에 조건을 설정하지 않으면 모든행이 삭제

DELETE FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;

ROLLBACK;

SELECT * FROM EMPLOYEE WHERE EMP_NAME = '장채현'; --조회되는 것 확인후 
DELETE FROM EMPLOYEE WHERE EMP_NAME = '장채현'; -- 삭제진행

--FOREIGN KEY 제약조건이 설정되어 있는 경우
--참조되고 있는 값에 대해서는 삭제할 수 없다.
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;--중복을 제거하여 사원테이블에서 사용하고 있는 부서코드 조회

DELETE FROM DEPARTMENT WHERE DEPT_ID = 'D1'; --EMPLOYEE테이블에서 참조해서 사용하고 있으므로 삭제가 안됨.
DELETE FROM DEPARTMENT WHERE DEPT_ID = 'D3';  --참조되고 있지 않은 값은 삭제가 가능하다.

SELECT * FROM DEPARTMENT;

--삭제 시 FOREIGN KEY 제약조건으로 컬럼 삭제가 불가능한 경우 제약 조건을 비활성화 할 수 있다.

ALTER TABLE EMPLOYEE
DISABLE CONSTRAINT SYS_C007198 CASCADE; --DEPARTMENT에 걸려있는 제약조건

DELETE FROM DEPARTMENT WHERE DEPT_ID = 'D1';
SELECT * FROM DEPARTMENT;

ROLLBACK;

--비활성화된 제약조건 다시 활성화
ALTER TABLE EMPLOYEE
ENABLE CONSTRAINT SYS_C007198;


--TRUNCADE : 테이블의 전체 행을 삭제할시 사용
--DELETE 보다 수행속도가 빠르다
--ROLLBACK를 통해 복구가 불가능하다

DELETE FROM EMP_SALARY;  --DELETE는 롤백을 복구가 가능
ROLLBACK;

TRUNCATE TABLE EMP_SALARY;  --'잘렸습니다.'
ROLLBACK;

SELECT * FROM EMP_SALARY; -- 값이모두 삭제 됨 , 사용안하는 게 좋음!

--MARGE : 구조가 같은 두개의 테이블을 하나로 합치는 기능을 한다.
--테이블에서 지정하는 조건의 값이 존재하면 UPDATE
--조건의 값이 없으면 INSERT 됨


CREATE TABLE M_TEST01(
    ID CHAR(20),
    NAME VARCHAR2(20)
);


INSERT INTO M_TEST01 VALUES('user11','최선호');
INSERT INTO M_TEST01 VALUES('user22','황서연');
INSERT INTO M_TEST01 VALUES('user33','홍영은');

CREATE TABLE M_TEST02(
    ID CHAR(20),
    NAME VARCHAR2(20)
);


INSERT INTO M_TEST02 VALUES('user12','박서형');
INSERT INTO M_TEST02 VALUES('user22','박용수');
INSERT INTO M_TEST02 VALUES('user32','문대훈');


SELECT * FROM M_TEST01;
SELECT * FROM M_TEST02;


MERGE INTO M_TEST01 M1 USING M_TEST02 M2 ON (M1.ID = M2. ID)
WHEN MATCHED THEN -- 위 ON이 참이면 UPDATE 실행
UPDATE
SET M1.NAME = M2.NAME
WHEN NOT MATCHED THEN -- 위 ON이 참이 아니면 INSERT 실행
INSERT
    (M1.ID, M1.NAME)
VALUES
    (M2.ID, M2.NAME);








