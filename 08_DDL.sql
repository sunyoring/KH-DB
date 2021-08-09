--DDL
--ALTER : 객체를 수정하는 구문
--ALTER TABLE 테이블명 수정내용
--컬럼추가 /  삭제 / 변경, 제약조건 추가/삭제/변경
--테이블 변경, 제약조건이름 변경

--컬럼 추가
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY
ADD(LNAME VARCHAR(20)); --null값으로 추가가 됨.

--컬럼 삭제

ALTER TABLE DEPT_COPY
DROP COLUMN LNAME;  --LNAME 컬럼 삭제

--컬럼 생성 시 DEFAULT 값 지정
ALTER TABLE DEPT_COPY
ADD (CNAME VARCHAR2(20) DEFAULT '한국'); --'한국'이라는 기본값으로 CNAME컬럼 생성


--제약조건 없이 테이블 생성

CREATE TABLE DEPT_COPY2
AS
SELECT * FROM DEPARTMENT;   --테이블 복사 생성

--컬럼에 제약조건 추가

ALTER TABLE DEPT_COPY2
ADD CONSTRAINT PK_DEPT_ID2 PRIMARY KEY (DEPT_ID); -- DEPT_COPY2테이블에 DEPT_ID를 PRIMARY KEY로 제약조건 추가

ALTER TABLE DEPT_COPY2
ADD CONSTRAINT UN_DEPT_TITLE UNIQUE (DEPT_TITLE); -- DEPT_COPY2테이블에 DEPT_TITLE을 UNIQUE로 제약조건 추가

ALTER TABLE DEPT_COPY2
ADD LOCATION_ID CONSTRAINT NN_LID NOT NULL; --NO NULL제약조건은 이미 걸려있기 때문에

--컬럼자료형 수정   --이미 설정이 되어 있으므로 MODIFY로 수정을 한다.
ALTER TABLE DEPT_COPY2
MODIFY DEPT_ID CHAR(3)
MODIFY DEPT_TITLE VARCHAR2(30)
MODIFY LOCATION_ID VARCHAR2(2);

SELECT * FROM SYS.USER_TAB_COLUMNS WHERE TABLE_NAME = 'DEPT_COPY'; --테이블 조회

--컬럼의 크기 줄이는 경우
--변경하려는 크기를 초과 하는 값이 없을때만 수정가능 (데이터가 손실될 수 있기 때문이다.)
ALTER TABLE DEPT_COPY2
MODIFY DEPT_TITLE VARCHAR2(10); --오류발생


--DEFAULT값 변경

SELECT * FROM DEPT_COPY; --CNAME의 기본값 한국
ALTER TABLE DEPT_COPY
MODIFY CNAME DEFAULT '미국'; ---미국으로 변경

INSERT INTO DEPT_COPY
VALUES('D0','생산부','L2',DEFAULT);  --DEFAULT가 미국으로 행이 삽입되었다.

--컬럼 삭제 : DROP COLUMN 삭제할 컬럼명
--데이터가 기록되어 있어도 삭제되며, 삭제한 컬럼은 복구 불가능.
--테이블에 최소 1개의 행은 존재해야 한다. -> 모든 컬럼 삭제 불가능.

ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_TITLE;

SELECT * FROM DEPT_COPY2;

ALTER TABLE DEPT_COPY2
DROP COLUMN LOCATION_ID;

ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_ID; -- 마지막 한 개 남은 컬럼은 삭제가 불가능 -> 오류 발생
--ORA-12983: cannot drop all columns in a table

CREATE TABLE TB1(
    PK NUMBER PRIMARY KEY,
    FK NUMBER REFERENCES TB1,
    COL1 NUMBER,
    CHECK (PK>0 AND COL1 > 0)
); --순환참조 테이블 :  자기자신을 참조하고 있다. FK가 PK를 참조하고 있다. EMPLOYEE테이블에서 MANAGER_ID가 EMP_ID를 참조했듯이
--컬럼 삭제시 참조하고 있는 컬럼이 있다면 삭제 불가능.
ALTER TABLE TB1
DROP COLUMN PK; --삭제 불가
--제약조건도 함께 삭제해야 한다.

ALTER TABLE TB1
DROP COLUMN PK CASCADE CONSTRAINTS; --제약 조건과 함께 삭제


SELECT * FROM TB1;


--DML 문장 이후 커밋을 하지않고 DDL 문장을 실행시키면 자동으로 커밋이 진행되기 때문에 SAVEPOINT라던가 ROLLBACK등을 수행을 미리 작업해놓고 해야한다.


--제약 조건 삭제
--ON DELETE CASCADE : 삭제되는 외부키에 해당하는 값을 같이 삭제 (참조 무결성 제약조건)
--ON DELETE SET NULL : 삭제되는 외부키를 가지는 값을 NULL로 바꿔준다.


CREATE TABLE CONST_EMP(
  ENAME VARCHAR2(20) NOT NULL,
  ENO VARCHAR2(15) NOT NULL,
  MARRIAGE CHAR(1) DEFAULT 'N',
  EID CHAR(3),
  EMAIL VARCHAR2(30),
  JID CHAR(2),
  MID CHAR(3),
  DID CHAR(2),
  -- 테이블 레벨로 제약조건 설정
  CONSTRAINT CK_MARRIAGE CHECK(MARRIAGE IN ('Y', 'N')),
  CONSTRAINT PK_EID PRIMARY KEY(EID),
  CONSTRAINT UN_ENO UNIQUE(ENO),
  CONSTRAINT UN_EMAIL UNIQUE(EMAIL),
  CONSTRAINT FK_JID FOREIGN KEY(JID)
  REFERENCES JOB(JOB_CODE) ON DELETE SET NULL,
  CONSTRAINT FK_MID FOREIGN KEY(MID)
  REFERENCES CONST_EMP ON DELETE SET NULL,
  CONSTRAINT FK_DID FOREIGN KEY(DID)
  REFERENCES DEPARTMENT ON DELETE CASCADE
);


--제약조건 1개 삭제시
ALTER TABLE CONST_EMP
DROP CONSTRAINT CK_MARRIAGE;

--제약조건 여러 개 삭제 시
ALTER TABLE CONST_EMP
DROP CONSTRAINT FK_DID
DROP CONSTRAINT FK_JID
DROP CONSTRAINT FK_MID;

--NOT NULL 제약조건 삭제 시 MODIFY 사용
ALTER TABLE CONST_EMP
MODIFY(ENAME NULL, ENO NULL); --NOT NULL은 NULL로 수정하여 삭제할 수 있다.

--컬럼 이름 변경
CREATE TABLE DEPT_COPY3
AS SELECT * FROM DEPARTMENT;

ALTER TABLE DEPT_COPY3
RENAME COLUMN DEPT_ID TO DEPT_CODE; --DEPT_ID를 DEPT_CODE로 변경함.

--제약조건 이름 변경
ALTER TABLE DEPT_COPY3
ADD CONSTRAINT PK_DEPT_CODE3 PRIMARY KEY (DEPT_CODE);

ALTER TABLE DEPT_COPY3
RENAME CONSTRAINT PK_DEPT_CODE3 TO PK_CODE;  --PK_DEPT_CODE3 을 PK_CODE로 변경


--테이블 이름 변경
ALTER TABLE DEPT_COPY3
RENAME TO DEPT_TEST;

SELECT * FROM DEPT_TEST; --바뀐 테이블 명으로 조회 가능
SELECT * FROM DEPT_COPY3; -- 이전 테이블 명으로 조회 불가능

--테이블 삭제 CASCADE CONSTRAINT : 삭제할 테이블의 기본키 / UNIQUE키를 참조하는 제약 조건도 함께 삭제
DROP TABLE USER_GRADE2; -- 이미 참조하고 있기 때문에 삭제 불가능

DROP TABLE USER_GRADE2 CASCADE CONSTRAINT; --삭제 됨