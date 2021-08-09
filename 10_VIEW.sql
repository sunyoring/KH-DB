--VIEW (뷰)
--SELECT 쿼리문을 저장한 객체이다
--실질적인 데이터를 저장하고 있지않음
--테이블을 사용하는 것과 동일하게 사용할수있다.
--매번 자주 사용하는 쿼리문을 정의 해 두고 싶을때 뷰를 생성
--VIEW 를 한번 만들어두고 마치 테이블처럼 사용한다고 생각!
--CREATE [OR REPLACE] VIEW 뷰이름 AS 서브쿼리 

--[OR REPLACE]: 뷰 생성시 기존에 중복된 뷰가 있다면 해당뷰를 변경하고 기존에 중복된 뷰가 없다면 새로 뷰를 생성
GRANT CREATE VIEW TO EMPLOYEE; --시스템계정으로 권한을 부여하기

CREATE OR REPLACE VIEW V_EMP --EMPLOYEE계정으로 실행.
    (사번, 이름, 부서)
    AS
    SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE;
    
SELECT * FROM V_EMP; --테이블 조회처럼 뷰 조회도 가능하다.
DROP VIEW V_EMP; --DROP은 뷰나 테이블 행같은 객체들을 사용할 때 쓴다.


--사번, 이름, 직급명, 부서명, 근무지역을 조회하고 그 결과를 V_RESULT_EMP라는 뷰를 생성해 저장하라.


CREATE OR REPLACE VIEW V_RESULT_EMP --EMPLOYEE계정으로 실행.
    AS
    SELECT EMP_ID,EMP_NAME, JOB_NAME, DEPT_TITLE,LOCAL_NAME
    FROM EMPLOYEE LEFT JOIN JOB USING(JOB_CODE)
    LEFT JOIN DEPARTMENT ON EMPLOYEE.DEPT_CODE = DEPARTMENT.DEPT_ID
    LEFT JOIN LOCATION ON DEPARTMENT.LOCATION_ID = LOCATION.LOCAL_CODE;
    
SELECT * FROM V_RESULT_EMP; --테이블 조회처럼 뷰 조회도 가능하다.

SELECT * FROM SYS.USER_VIEWS; -- VIEW정보를 확인하는 데이터 딕셔너리

COMMIT;

--뷰 조회
SELECT *
FROM V_RESULT_EMP
WHERE EMP_ID = '205';


--베이스 테이블의 정보가 변경이 되면 VIEW도 같이 변경된다.
SELECT *
FROM EMPLOYEE
WHERE EMP_ID = '205';

UPDATE EMPLOYEE
SET EMP_NAME = '정중앙'
WHERE EMP_ID = '205';

ROLLBACK;

DROP VIEW V_RESULT_EMP; -- VIEW삭제

--뷰 서브쿼리 안에서 연산의 결과도 포함이 가능하다 - 별칭 부여 필수 
CREATE OR REPLACE VIEW V_EMP_JOB
--(사번, 이름, 직급명, 성별, 근무년수 ) -- 1번 방법
AS 
SELECT
    A.EMP_ID 사번 ,  -- 2번 방법
    A.EMP_NAME 이름,
    B.JOB_NAME 직급명,
    DECODE(SUBSTR(A.EMP_NO,8,1),1,'남',2,'여') 성별,
    EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM A.HIRE_DATE) 근무년수
FROM EMPLOYEE A
LEFT JOIN JOB B ON A.JOB_CODE = B.JOB_CODE;

SELECT * FROM V_EMP_JOB;

CREATE OR REPLACE VIEW V_JOB
AS
SELECT
    JOB_CODE,
    JOB_NAME
FROM JOB;

SELECT * FROM JOB;
SELECT * FROM V_JOB;


--생성된 뷰를 이용해서 DML(INSERT, UPDATE, DELETE) 사용 가능
--뷰를 통해 변경하게 되면 실제 데이터가 담겨있는 베이스 테이블에도 적용된다.

--뷰에 INSERT
INSERT INTO V_JOB
VALUES
    ('J8','인턴'); --뷰에 추가한것이 베이스테이블에도 반영되었다.
    
--뷰에 UPDATE
UPDATE V_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';--뷰에 수정이 베이스테이블에도 반영되었다.

--뷰에 DELETE
DELETE V_JOB WHERE JOB_CODE='J8';--뷰에 수정이 베이스테이블에도 반영되었다.



-- DML 명령어로 조작이 불가능한 경우
-- 1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
-- 2. 뷰에 포함되지 않은 컬럼 중에,
--    베이스가 되는 테이블 컬럼이 NOT NULL 제약조건이 지정된 경우
-- 3. 산술표현식으로 정의된 경우
-- 4. JOIN을 이용해 여러 테이블을 연결한 경우
-- 5. DISTINCT 포함한 경우
-- 6. 그룹함수나 GROUP BY 절을 포함한 경우


-- 1) 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW V_JOB2
AS
SELECT JOB_CODE FROM JOB;

--뷰에 정의도어있지 않은 컬럼(JOB_NAME)을 조작
INSERT INTO V_JOB2
    (JOB_CODE,JOB_NAME)
    VALUES
    ('J8','인턴'); --에러발생  SQL 오류: ORA-00904: "JOB_NAME": invalid identifier
    
UPDATE V_JOB2
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J1'; -- 에러발생 SQL 오류: ORA-00904: "JOB_NAME": invalid identifier

DELETE V_JOB2
WHERE JOB_NAME = '대리';  -- 에러발생 SQL 오류: ORA-00904: "JOB_NAME": invalid identifier

-- 2) 뷰에 포함되지 않은 컬럼 중에,
--    베이스가 되는 테이블 컬럼이 NOT NULL 제약조건이 지정된 경우

CREATE OR REPLACE VIEW V_JOB3
AS
SELECT JOB_NAME FROM JOB;

INSERT INTO V_JOB3
(JOB_NAME)
VALUES('인턴'); --ORA-01400: cannot insert NULL into ("EMPLOYEE"."JOB"."JOB_CODE")
--VIEW에는 JOB_CODE가 없지만 베이스테이블에는 NOT NULL제약조건이 걸려있으므로 값이 꼭 있어야 한다.

UPDATE V_JOB3
SET JOB_NAME = '사원'
WHERE JOB_NAME = '인턴';  --기존에 있었던 값을 바꾸는 것은 가능

SELECT * FROM V_JOB3;

DELETE FROM V_JOB3 WHERE JOB_NAME = '인턴';


-- 3) 산술표현(연산)식으로 정의된 경우
CREATE OR REPLACE VIEW EMP_SAL
AS
SELECT
    EMP_ID,
    EMP_NAME,
    SALARY,
    (SALARY + (SALARY *NVL(BONUS,0)))*12 연봉
FROM EMPLOYEE;

SELECT * FROM EMP_SAL;

INSERT INTO EMP_SAL
VALUES(800,'정진훈',3000000,40000000); -- SQL 오류: ORA-01733: virtual column not allowed here
-- 연봉은 이미 계산식이 지정되어 있는 것이기 때문에 값을 바로 넣을 수 없다.

UPDATE EMP_SAL
SET 연봉 = 8000000
WHERE EMP_ID = '200'; -- SQL 오류: ORA-01733: virtual column not allowed here

--UPDATE(산술연산과 무관한 걸럼을 UPDATE하는 것은 가능함)
UPDATE EMP_SAL
SET EMP_NAME = '정중하'
WHERE EMP_ID = '200';

ROLLBACK;

--DELETE 할 때에는 상관 없음
DELETE FROM EMP_SAL WHERE 연봉 = 124800000;
ROLLBACK;

-- 4) JOIN을 이용해 여러 테이블을 연결한 경우
CREATE OR REPLACE VIEW V_JOINEMP
AS
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID;

SELECT * FROM V_JOINEMP; --부서명이 들어간 가상 테이블 생성. EMPLOYEE와 DEPARTMENT가 JOIN한 테이블

SELECT * FROM V_JOINEMP WHERE EMP_ID = '219';
SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE WHERE EMP_ID = '219';

INSERT INTO V_JOINEMP
VALUES
    (888,'조세오','인사관리부'); --에러발생 SQL 오류: ORA-01776: cannot modify more than one base table through a join view
    
UPDATE V_JOINEMP
SET DEPT_TITLE = '인사관리부'
WHERE EMP_ID = '219'; -- SQL 오류: ORA-01779: cannot modify a column which maps to a non key-preserved table

--하나의 베이스 테이블에만 적용이 된다.
DELETE FROM V_JOINEMP WHERE EMP_ID = 219; --EMPLOYEE테이블에만 영향이 간다.

SELECT * FROM EMPLOYEE; --219번이 삭제됨.
ROLLBACK; 

-- 5) DISTINCT 포함한 경우
CREATE OR REPLACE VIEW V_DT_EMP
AS
SELECT DISTINCT JOB_CODE FROM EMPLOYEE; -- 중복 제거하고 EMPLOYEE에서 사용하고 있는 JOB_CODE

SELECT * FROM V_DT_EMP;

INSERT INTO V_DT_EMP
VALUES
    ('J9'); -- SQL 오류: ORA-01732: data manipulation operation not legal on this view
--베이스 테이블 EMPLOYEE에 J9만 추가될 수 없다.

UPDATE V_DT_EMP 
SET JOB_CODE = 'J9'
WHERE JOB_CODE = 'J7'; --SQL 오류: ORA-01732: data manipulation operation not legal on this view

DELETE FROM V_DT_EMP WHERE JOB_CODE = 'J7'; -- SQL 오류: ORA-01732: data manipulation operation not legal on this view


-- 6) 그룹함수나 GROUP BY 절을 포함한 경우

CREATE OR REPLACE VIEW V_GROUPDEPT
AS
SELECT
    DEPT_CODE,
    SUM(SALARY) 합계,
    AVG(SALARY) 평균
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT * FROM V_GROUPDEPT;

INSERT INTO V_GROUPDET
VALUES
    ('D0',6000000,400000); --SQL 오류: ORA-00942: table or view does not exist

UPDATE V_GROUPDEPT
SET DEPT_CODE = 'D7'
WHERE DEPT_CODE = 'D1'; ---SQL 오류: ORA-01732: data manipulation operation not legal on this view


DELETE FROM V_GROUPDEPT WHERE DEPT_CODE = 'D1'; --SQL 오류: ORA-01732: data manipulation operation not legal on this view


/* VIEW 옵션
    
    [상세 표현식]
    CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰명
    AS SUBQUERY
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1) OR REPLACE 옵션 : 기존에 동일한 뷰가 있을경우 덮어쓰고, 존재하지 않으면 새로이 생성시켜주는
    2) FORCE/NOFORCE 옵션
       FORCE : 서브쿼리에 기술된 테이블이 존재하지 않는 테이블이여도 뷰가 생성
       NOFORCE : 서브쿼리에 기술된 테이블이 존재해야만 뷰가 생성 (생략시 기본값)
    3) WITH CHECK OPTION 옵션 : 서브쿼리에 기술된 조건에 부합하지 않은 값으로 수정하는 경우 오류 발생
    4) WITH READ ONLY 옵션 : 뷰에 대해 조회만 가능 (DML 수행 불가)
*/

-- FORCE : 서브쿼리에 기술된 테이블이 존재하지 않는 테이블이여도 뷰가 생성-- 일반적으로 잘사용되지않음
--> 경고: 컴파일오류와 함께 뷰가 생성되었습니다. 

DROP VIEW V_EMP;
CREATE OR REPLACE FORCE VIEW V_EMP
AS
SELECT
    TCODE,
    TNMAE,
    TCONTENT
FROM TT;  --경고: 컴파일 오류와 함께 뷰가 생성되었습니다. TT라는 테이블은 존재하지 않는다.

SELECT * FROM V_EMP;  --존재하지 않음

DROP TABLE TT;

CREATE TABLE TT(
    TCODE NUMBER,
    TNMAE VARCHAR2(10),
    TCONTENT VARCHAR2(20)
); --TT TABLE을 생성하고 V_EMP 뷰를 생성하면
--------------------------------------------------학습동영상 다시보자





--WITH CHECK OPTION 옵션 : 서브쿼리에 기술된 조건에 부합하지 않은 값으로 수정하는 경우 오류 발생
CREATE OR REPLACE VIEW VW_EMP2
AS
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT * FROM VW_EMP2;

UPDATE VW_EMP2
SET SALARY = 2000000
WHERE EMP_ID = 200;

ROLLBACK;



CREATE OR REPLACE VIEW VW_EMP2 
AS
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000
WITH CHECK OPTION;   --체크 옵션이 걸렸기 때문에

UPDATE VW_EMP2
SET SALARY = 2000000   -- 값을 넣을 수 없음!
WHERE EMP_ID = 200; ---ORA-01402: view WITH CHECK OPTION where-clause violation


--WITH READ ONLY 옵션 : 뷰에 대해 조회만 가능 (DML 수행 불가)
CREATE OR REPLACE VIEW V_DEPT
AS
SELECT * FROM DEPARTMENT
WITH READ ONLY;

SELECT * FROM V_DEPT;
DELETE FROM V_DEPT; --SQL 오류: ORA-42399: cannot perform a DML operation on a read-only view
