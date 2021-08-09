-- 시퀀스(SEQUENCE)
-- 자동 번호 발생기 역할을 하는 객체
-- 순차적으로 정수값을 자동으로 생성해줌
/*
  CRAETE SEQUENCE 시퀀스이름
  [START WITH 숫자] -- 처음 발생시킬 값 지정, 생략하면 자동 1 기본
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정(10의 27승)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE]  -- 값순환 여부
  [CACHE 바이트크기 | NOCACHE] -- 캐시사용여부 (기본값은 20바이트, 최소는 2바이트)
  
  /*
  1 2 3 4 5   --> 시퀀스 
  12345 678910 --> 캐쉬는 미리 생성되어있음 
  1 2 3  11 -->껏다키고 다시 시작하면 캐쉬 생성된 다음 인 11 부터 시작 
    */
    
CREATE SEQUENCE SEQ_EMPID --SEQ_EMPID 시퀀스 객체 생성
START WITH 300            --시작번호 300부터
INCREMENT BY 5            --5씩 증가하며 
MAXVALUE 310              --최대 310까지
NOCYCLE                   --310이후에는 증가하지 않고 에러 발생      
NOCACHE;                  --캐시를 사용하지 않는다. 
--시퀀스 정보에 생성되어 들어가 있다. 조회가 가능


-- NEXTVAL,CURRVAL
--CURRVAL : 현재 값을 반환   -- 주의 : 현재 값을 시퀀스를 생성한 후에 바로 조회하면 조회가 불가하고 에러가 발생.
--NEXTVAL : 현재 시퀀스의 다음 값을 반환

--(처음 실행)
SELECT SEQ_EMPID.CURRVAL FROM DUAL; --ORA-08002: sequence SEQ_EMPID.CURRVAL is not yet defined in this session
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 300 시작 값이 생김.
--(두번째 실행)
SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- NEXTVAL을 한 번 실행한 후에 실행해야 에러없이 현재 값을 가지고 올 수 있다.


SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 310
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- MAXVALUE값을 넘어서면서 에러가 발생.

SELECT * FROM USER_SEQUENCES;

--시퀀스 변경
--START WITH 변결 불가능 - 변경하고자 한다면 DROP(삭제) 후 다시 생성
ALTER SEQUENCE SEQ_EMPID
INCREMENT BY 10
MAXVALUE 400
NOCYCLE
NOCACHE;

SELECT * FROM USER_SEQUENCES; -- 변경사항 조회 됨.

DROP SEQUENCE SEQ_EMPID; --시작 넘버를 변경하기 위해 삭제

CREATE SEQUENCE SEQ_EMPID  -- 재생성
START WITH 900
INCREMENT BY 1
MAXVALUE 1000
NOCYCLE
NOCACHE;

SELECT * FROM USER_SEQUENCES; -- 변경사항 조회 됨.


-- NEXTVAL, CURRVAL 을 사용할 수 있는 경우
--> 서브 쿼리가 아닌 SELECT문
--> INSERT문의 SELECT 절
--> INSERT문의 VALUE 절
--> UPDATE문의 SET 절

-- NEXTVAL, CURRVAL 을 사용할 수 없는 경우
-- 서브쿼리의 SELECT문에서 사용 불가
-- VIEW의 SELECT절에서 사용 불가
-- DISTINCT 키워드가 있는 SELECT문에서 사용 불가
-- GROUP BY , HAVING절이 있는 SELECT문에서 사용 불가
-- ORDER BY 절에서 사용 불가
-- CREATE TABLE, ALTER TABLE의 DEFAULT값으로 사용 불가

CREATE TABLE SEQ_TEST
    (NO NUMBER PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    AGE NUMBER NOT NULL);  --TEST 테이블 생성
    
CREATE SEQUENCE SEQ_TEST_NO 
START WITH 1
INCREMENT BY 1
MAXVALUE 100
NOCYCLE
NOCACHE;   -- TEST 시퀀스 생성

SELECT * FROM SEQ_TEST;
INSERT INTO SEQ_TEST VALUES (SEQ_TEST_NO.NEXTVAL, '홍길동',20);  -- 첫번째 값부터 NEXTVAL을 사용한다.현재 값은 생성되지 않았기 때문!
INSERT INTO SEQ_TEST VALUES (SEQ_TEST_NO.NEXTVAL, '유재석',30);    
INSERT INTO SEQ_TEST VALUES (SEQ_TEST_NO.NEXTVAL, '홍길순',40);
