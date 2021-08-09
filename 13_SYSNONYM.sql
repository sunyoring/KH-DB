-- 동의어 (SYNONYM)
-- 다른 데이터 베이스가 가진 객체에 대한 별명 혹은 줄임말
-- 여러사용자가 테이블을 공유할경우
-- 다른 사용자가 테이블에 접근할경우 사용자명.테이블명 으로 표현함
-- 동의어를 사용하면 간단하게 접근 가능
-- 삭제 : DROP SYNONYM EMP;
SELECT * FROM USER_SYNONYMS; --EMPLOYEE계정에서 볼 때
SELECT * FROM DBA_SYNONYMS WHERE SYNONYM_NAME = 'EMP'; --시스템계정에서 볼 때
-- 생성방법
--CREATE SYNONYM 줄임말 FOR 사용자명.객체명;
GRANT CREATE SYNONYM TO EMPLOYEE; ---시스템 계정에서 권한을 부여해주기.

CREATE SYNONYM EMP FOR EMPLOYEE; --EMPLOYEE테이블에 별칭(줄임말)을 준다고 생각하자.
--동의어에 조회가됨.
SELECT * FROM EMP; --EMP로도 EMPLOYEE테이블 조회가 가능해짐.


-- 동의어의 구분
--1. 비공개 동의어
-- 객체에대한 접근 권한을 부여 받은 사용자가 정의한 동의어
--2. 공개 동의어
-- 모든 권한을 주는 사용자(DBA)가 정의한 동의어  ---시스템 계정에서 수행하는 것.
-- 모든 사용자가 사용할수 있음 (PUBLIC)
-- 예) DUAL

/*
--시스템계정에서 테스트하기
SELECT * FROM DEPARTMENT; --시스템 계정에서 에러
SELECT * FROM EMPLOYEE.DEPARTMENT; -- 사용자계정.테이블명

CREATE PUBLIC SYNONYM DEPT FOR EMPLOYEE.DEPARTMENT;

SELECT * FROM DEPT; --EMPLOYEE, 시스템 둘 다 조회됨.

*/