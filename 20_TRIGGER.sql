-- 트리거(TRIGGER)
--> 데이터베이스가 미리 정해놓은 조건을 만족하거나 어떠한 동작이 수행되면
--자동적으로 수행되는 객체를 의미
--	- 트리거의 사전적 의미 : 연쇄 반응
--> 트리거는 테이블이나 뷰가 INSERT, UPDATE, DELETE등의 DML문에 의해 데이터가 입력,수정,삭제
--될 경우 자동으로 실행 됨 

--ex) 회원 탈퇴가 이루어질 경우 회원 탈퇴 테이블에 기존 회원정보가 자동으로 입력 되도록 설정
--	- 관리자가 수동적으로 하게 되면 작업 하는 시점을 맞추기가 너무 어려움



-- 트리거의 실행 시점
--> 트리거 실행 시점을 이벤트 전(BEFORE)이나 이벤트 후(AFTER)로 지정하여 설정

-- 트리거의 이벤트
--> 트리거의 이벤트는 사용자가 어떤 DML(INSERT, UPDATE, DELETE)문을 실행했을 때 트리거를
--발생시킬 것인지를 결정

-- 트리거의 몸체
--> 트리거의 몸체는 해당 타이밍에 해당 이벤트가 발생했을 때 실행될 기본 로직이
--포함되는 부분으로 BEGIN ~ END에 안에 작성함

-- 트리거의 유형
--> 트리거의 유형은 FOR EACH ROW에 의해 문장 레벨 트리거와 행 레벨 트리거로 나뉨
--> FOR EACH ROW가 생략되면 "문장 레벨 트리거"
--> FOR EACH ROW가 정의되면 "행 레벨 트리거"
--> 문장 레벨 트리거는 어떤 사용자가 트리거가 설정되어 있는 테이블에 대해
--DML(INSERT, UPDATE, DELETE)문을 실행시킬 때 트리거를 단 한번 발생 시킴
--> 행 레벨 트리거는 DML(INSERT,UPDATE,DELETE)에 의해서 여러 개의 행이 변경된다면
--각 행이 변경될때마다 트리거를 발생시키는 방법
--	(만약 5개의 행이 변경되면 5번의 트리거가 발생함)

-- 트리거의 조건
--> 트리거의 조건은 행 레벨 트리거에서만 설정할 수 있으며 트리거 이벤트에 정의된
--테이블에 이벤트가 발생할 때보다 구체적인 데이터 검색 조건을 부여할 때 사용됨

--트리거 확인하기
SELECT * FROM ALL_TRIGGERS;
SELECT * FROM USER_TRIGGERS;

--단순 메세지 출력 트리거 작성(문장 트리거)
--사원 테이블에 새로운 데이터가 들어오면 신입사원이 입사하였습니다. 를 출럭

CREATE OR REPLACE TRIGGER TRG_01 AFTER
    INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사하였습니다.');
END;
/

SET SERVEROUTPUT ON;

INSERT INTO EMPLOYEE
VALUES
    (300,'유야호','650512-1151432','gil@kh.or.kh','01012345567',
    'D5','J3','S5',3000000,0.1,200,SYSDATE,NULL,DEFAULT
    );
    
--제품이 입고될 때마다 상품재고 테이블의 수치를 관리자가 수동으로 관리하면 불편하다.
--이 때 트리거를 이용하면 재고가 입출고시 자동으로 입력 되도록 할 수 있다.

--제품 테이블 생성
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY,
    PNAME VARCHAR2(30),
    BRAND VARCHAR2(30),
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 0 
);

SELECT * FROM PRODUCT;

--제품 입출고 테이블 생성
CREATE TABLE PRO_DETAIL (
    DCODE NUMBER PRIMARY KEY,
    PCODE NUMBER,
    PDATE DATE,
    AMOUNT NUMBER,
    STATUS VARCHAR2(10) CHECK(STATUS IN('입고','출고')),
    FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE)    
);

SELECT * FROM PRO_DETAIL;

--SEQUENCE생성
CREATE SEQUENCE SEQ_PCODE;
CREATE SEQUENCE SEP_DCODE;

INSERT INTO PRODUCT
VALUES (SEQ_PCODE.NEXTVAL, '갤럭시노트10', 'SS',900000,DEFAULT);

INSERT INTO PRODUCT
VALUES (SEQ_PCODE.NEXTVAL, '아이폰', 'AP',900000,DEFAULT);

INSERT INTO PRODUCT
VALUES (SEQ_PCODE.NEXTVAL, '샤오미', 'SOM',900000,DEFAULT);

SELECT * FROM PRODUCT;
SELECT * FROM PRO_DETAIL;

--바인드 변수 2가지
--FOR EACH ROW 사용
-- NEW : -새로 입력된 (INSERT, UPDATE) 데이터
-- OLD : -기존 데이터

CREATE OR REPLACE TRIGGER TRG_02 AFTER
    INSERT ON PRO_DETAIL
    FOR EACH ROW    
BEGIN
    IF :NEW.STATUS = '입고'
    THEN
        UPDATE PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT
        WHERE DCODE = NEW.DCODE;
    END IF;
    
    IF :NEW.STATUS = '출고'
    THEN
        UPDATE PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

SELECT * FROM PRODUCT;
SELECT * FROM PRO_DETAIL;

INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 5, '입고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 10, '입고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 20, '입고');

INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 1, '출고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 5, '출고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 13, '출고');