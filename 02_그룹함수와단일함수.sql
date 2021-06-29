-- 그룹함수와 단일행함수
--함수(FUNCTION) : 컬럼값을 읽어서 계산한 결과를 리턴함 
--단일행함수 : 컬럼에 기록된 N 개의 값을 읽어서 N 개의 결과를 리턴 
--그룹함수 : 컬럼에 기록된 N 개의 값을 읽어서 한개의 결과를 리턴 

--SELECT 절에 단일행 함수와 그룹함수를 함께 사용하지 못한다.  
--: 결과 행의 갯수가 다르기 때문

-- 함수를 사용할수 있는 위치 : SELECT 절, WHERE 절, GROUP BY 절, HAVING절, ORDER BY 절

-- 단일행 함수
-- 문자관련함수 
-- LENGTH, LENGTHB , SUBSTR,UPPER, LOWER, INSTR....


SELECT
    LENGTH('안녕하세요'),  --길이 : 3
    LENGTHB('안녕하세요')  --바이트 : 9
FROM DUAL;

SELECT
    LENGTH(EMAIL),
    LENGTHB(EMAIL)  --영어로 되어 있으므로 길이 = 바이트
FROM EMPLOYEE;


--DUAL 테이블(가상 테이블) -의미없는 값이 들어가 있음
--한 행으로 결과를 출력하기 위한 테이블
--산술 연산이나 가상 컬럼 등의 값을 한번만 출력하고 싶을 때 많이 사용
--DUMMY : 단 하나의 컬럼에 X(아무 의미 없는 값)라는 하나의 로우를 저장하고 있음
--DB2: SYSIBM.SYSDUMMY1

SELECT * FROM DUAL;   --임의로 값을 뽑아야 할 때 사용할 수 있다. ex) 오늘의 날짜 등
SELECT SYSDATE FROM DUAL;
SELECT 1+3 VAL FROM DUAL;

DESC DUAL;



--INSTR('문자열' | 컬럼명,'문자', 찾을 위치의 시작값 ,[빈도])
/*파라미터			설명
STRING			문자 타입 컬럼 또는 문자열
STR			찾으려는 문자(열)
POSITION		찾을 위치 시작 값 (기본값 1)
			POSITION > 0 : STRING의 시작부터 끝 방향으로 찾음
			POSITION < 0 : STRING의 끝부터 시작 방향으로 찾음
OCCURRENCE		검색된 STR의 순번(기본값 1), 음수 사용 불가

*/

SELECT
    EMAIL,
    INSTR(EMAIL,'@',-1) VAL
FROM EMPLOYEE;


SELECT INSTR('AABAACAABBAA','B') LOC FROM DUAL; --3번째위치
SELECT INSTR('AABAACAABBAA','B',1) LOC FROM DUAL;---1번째 이후에있는 3번째위치
SELECT INSTR('AABAACAABBAA','B',4) LOC FROM DUAL;--4번째 이후에있는 B는 처음부터 9번째
SELECT INSTR('AABAACAABBAA','B',1,2) LOC FROM DUAL;--앞에서부터 1번째 이후에있는 2번째 'B' 의 위치 앞에서부터 세어보면 9번째 
SELECT INSTR('AABAACAABBAA','B',-1,2) LOC FROM DUAL;--뒤에서부터 1번째 이후에있는 2번째 'B' 의 위치 앞에서부터 세어보면 9번째 


SELECT
    EMAIL,
    INSTR(EMAIL,'h',-1,1) VAL
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 사원명, 이메일, 
--@ 이후를 제외한 아이디 조회

SELECT
    EMP_NAME,
    EMAIL,
    SUBSTR(EMAIL, 1, INSTR(EMAIL,'@')-1) VAL ---SUBSTR('문자열',시작위치,자를 길이
FROM EMPLOYEE;

--LAPD/RPAD : 주어진 컬럼 문자열에 임의의 문자열을 덧붙여 길이 N의 문자열을 반환하는 함수

SELECT
    LPAD(EMAIL, 20, '#') VAL
FROM EMPLOYEE;

SELECT
    RPAD(EMAIL, 20, '#') VAL
FROM EMPLOYEE;
    
--LTRIM/RTRIM : 주어진 컬럼이나 문자열 왼쪽/오른쪽에 지정한 문자 혹은 문자열을 제거한 나머지를 반환하는 함수
SELECT LTRIM('  KH') FROM DUAL;
SELECT LTRIM('  KH',' ') FROM DUAL;
SELECT LTRIM('000123456','0') FROM DUAL;
SELECT LTRIM('123123KH','123') FROM DUAL;
SELECT LTRIM('123123KH123','123') FROM DUAL;
SELECT LTRIM('ACABACCKH','ABC') FROM DUAL;
SELECT LTRIM('5782KH','0123456789') FROM DUAL;

SELECT RTRIM('KH  ') FROM DUAL;
SELECT RTRIM('KH  ',' ') FROM DUAL;
SELECT RTRIM('123456000','0') FROM DUAL;
SELECT RTRIM('KH123123','123') FROM DUAL;
SELECT RTRIM('123123KH123','123') FROM DUAL;
SELECT RTRIM('KHACABACC','ABC') FROM DUAL;
SELECT RTRIM('KH5782','0123456789') FROM DUAL;

--TRIM : 주어진 컬럼이나 문자열의 앞/뒤에 지정한 문자를 제거

SELECT TRIM('   KH  ') FROM DUAL;
SELECT TRIM('z' FROM 'ZZZZKHZZZZ') FROM DUAL;
SELECT TRIM(LEADING 'Z' FROM 'ZZZZKHZZZZ') FROM DUAL;
SELECT TRIM(TRAILING 'Z' FROM 'ZZZZKHZZZZ') FROM DUAL;
SELECT TRIM(BOTH 'Z' FROM 'ZZZZ123456ZZZZ') FROM DUAL;

--SUBSTR : 컬럼이나 문자열에서 지정한 위치로부터 지정한 문자열을 잘라서 리턴
--SUBSTR('문자열', 시작위치, 자를길이)

SELECT SUBSTR ('SHOWMETHEMONEY', 5, 2)FROM DUAL;
SELECT SUBSTR ('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR ('SHOWMETHEMONEY', -8,3) FROM DUAL;
SELECT SUBSTR ('쇼우 미 더 머니',2,5) FROM DUAL;

SELECT EMP_NAME, SUBSTR (EMP_NO,8,1) VAL, EMP_NO
FROM EMPLOYEE;


--LOWER/UPPER/INITCAP : 대소문자를 변경해주는 함수
--LOWER( 문자열|컬럼 ) : 소문자로 변경해주는 함수 

SELECT  
    LOWER('Welcome To My World') VAL
FROM DUAL;

----UPPER( 문자열|컬럼 ) : 대문자로 변경해주는 함수 

SELECT  
    UPPER('Welcome To My World') VAL
FROM DUAL;

----INITCAP : 앞글자만 대문자로 변경해주는 함수

SELECT  
    INITCAP('Welcome to my world') VAL
FROM DUAL;


--CONCAT : 문자열 혹은 컬럼 두개를 입력받아 하나로 합친 후 리턴

SELECT
    CONCAT('가나다라','ABC') VAL
FROM DUAL;
SELECT
    '가나다라'||'ABC' VAL
FROM DUAL;

--REPLACE : 컬럼 혹은 문자열을 입력받아 변경하고자 하는 문자열을 변경할 문자열로 바꾼 후 리턴
SELECT
    REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') VAL
FROM DUAL;

--1. EMPLYEE 테이블에서 직원들의 주민번호를 조회하여
-- 사원명, 생년, 생월, 생일 을 각각 분리하여 조회
-- 단 컬럼의 별칭은 생년, 생월, 생일로 한다.
---SUBSTR('문자열',시작위치,자를 길이
SELECT
    EMP_NAME "사원명",
    SUBSTR(EMP_NO,1,2) "생년",
    SUBSTR(EMP_NO,3,2) "생월",
    SUBSTR(EMP_NO,5,2) "생일"
FROM EMPLOYEE;
    
--2. 여직원들의 모든 컬럼 정보를 조회
SELECT
    *
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = 2;

--3. 직원들의 입사일을 입사년도, 입사월, 입사날짜를 분리하여 조회
-- 단 컬럼의 별칭은 입사년도, 입사월, 입사날짜

SELECT
    EMP_NAME,
    SUBSTR(HIRE_DATE,1,2) 입사년도,
    SUBSTR(HIRE_DATE,4,2) 입사월,
    SUBSTR(HIRE_DATE,7,2) 입사날짜
FROM EMPLOYEE;


--SUBSTRB : 바이트 단위로 추출하는 함수
SELECT
    SUBSTR('ORACLE',3,2),
    SUBSTRB('ORACLE',3,2)
FROM DUAL;

SELECT
    SUBSTR('오라클',2,2),
    SUBSTRB('오라클',4,6)
FROM DUAL;


--함수 중첩 사용 가능 : 함수 안에서 함수를 사용할 수 있음
--EMPLOYEE 테이블에서 사원명, 주민번호 조회
--단, 주민번호는 생년 월일만 보이게 하고, '-' 다음 값은 '*' 로 바꿔서 출력 하라

SELECT
    EMP_NAME,
    RPAD(SUBSTR(EMP_NO,1,7),14,'*') 주민번호
FROM EMPLOYEE;    

--숫자 처리 함수 : ABS, MOD, ROUND, FLOOR, TRUNC, CEIL
-- ABS(숫자 | 숫자로 된 컬럼명) : 절대값 구하는 함수

SELECT 
    ABS(-10) COL1,
    ABS(10) COL2
FROM DUAL;

--MOD (숫자 | 숫자로 된 컬럼명, 숫자 | 숫자로 된 컬러명)
-- 두 수를 나누어 나머지를 구하는 함수 (인자 2개)
-- 처음 인자는 나누어지는 수, 두번째 인자는 나눌 수

SELECT
    MOD(10,5) COL1,
    MOD(10,3) COL2,
    MOD(10,-3) COL3,
    MOD(-10,3) COL4,
    MOD (-10,-3) COL5
FROM DUAL;
--넘버 값에 마이너스가오면 결과가 마이너스가 나옴


--ROUND(숫자 | 숫자로 된 컬럼명, [위치])
-- 반올림해서 리턴하는 함수

SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;


SELECT ROUND(123.456), 
 ROUND(123.456, 0), 
 ROUND(123.456, 1), 
 ROUND(123.456, 2), 
 ROUND(123.456, -2) 
FROM DUAL;

--FLOOR(숫자 | 숫자로 된 컬럼명)
--내림처리하는 함수 (인자로 전달받은 숫자 혹은 컬럼의 소수점 자리수를 버리는 함수)

SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(123.6789) FROM DUAL;

--TRUNC(숫자 | 숫자로 된 컬럼명 , [위치])
--내림처리 (절삭) 함수 , (인자로 전달받은 숫자 혹은 컬럼의 지정한 위치 이후의 소수점 자리 수를 버리는 함수

SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.678) FROM DUAL;
SELECT TRUNC(123.456,1) FROM DUAL;
SELECT TRUNC(123.456,2) FROM DUAL;
SELECT TRUNC(123.456,-1) FROM DUAL;
SELECT TRUNC(123.456,-2) FROM DUAL;

--CEIL함수 (숫자 | 숫자로 된 컬럼명)
--올림처리 함수(소수점 기준으로 올림처리)
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(123.678) FROM DUAL;


--날짜함수 : SYSDATE, MONTHS_BETWEEN, ADD_MONTH, NEXT_DAY, LAST_DAY, EXTRACT
-- SYSDATE : 시스템에 저장되어 있는 날짜를 반환해주는 함수
SELECT
    SYSDATE
FROM DUAL;

--MONTHS_BETWEEN(날짜, 날짜)
-- 두 날짜의 개월 수 차이를 숫자로 리턴하는 함수

SELECT
    EMP_NAME,
    HIRE_DATE,
    CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) COL
FROM EMPLOYEE;



-- ADD_MONTHS(날짜, 숫자)
-- 날짜에 숫자만큼 개월 수를 더해서 리턴해주는 함수

SELECT
    ADD_MONTHS(SYSDATE, 1) COL1,
    ADD_MONTHS(SYSDATE, 2) COL2
FROM DUAL;

--EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사 후 6개월이 되는 날짜를 조회

SELECT
    EMP_NAME,
    HIRE_DATE,
    ADD_MONTHS(HIRE_DATE,6) COL1
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 근무년수가 20년 이상인 직원조회

SELECT
    HIRE_DATE,
    ADD_MONTHS(HIRE_DATE,240) VAL
FROM EMPLOYEE
--WHERE ADD_MONTHS (HIRE_DATE,240) <= SYSDATE;
WHERE MONTHS_BETWEEN (SYSDATE, HIRE_DATE) >= 240;

-- NEXT_DAY(기준날짜, 요일( 문자 | 숫자 )
--기준날짜에서 구하려는 요일에 가장 가까운 날짜 리턴
-- 일요일부터 1로 시작~ 토요일까지 7
SELECT SYSDATE, NEXT_DAY(SYSDATE,'목요일') NDAY FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,5) NDAY FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'목') NDAY FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'FRIDAY') NDAY FROM DUAL; --NLS LANGUAGE가 한국어로 설정되어 있어서 오류발생
ALTER SESSION SET NLS_LANGUAGE = KOREAN; --NLS LANGUAGE 변경법
ALTER SESSION SET NLS_DATE_FORMAT = 'RR-MM-DD'; --날짜의 포맷을 변경할 수 있음

SELECT *
FROM NLS_SESSION_PARAMETERS
WHERE PARAMETER IN ('NLS_LANGUAGE', 'NLS_DATE_FORMAT', 'NLS_DATE_LANGUAGE');



--LAST_DAY(날짜) : 해당월의 마지막 날짜를 구하여 리턴
SELECT SYSDATE, LAST_DAY(SYSDATE) LDAY FROM DUAL;

--EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사월의 마지막 날, 입사한 월부터의 근무 일수 조회

 SELECT
    EMP_NAME,
    HIRE_DATE,
    LAST_DAY(HIRE_DATE) LDAY,
    CEIL(SYSDATE - HIRE_DATE) COL1,
    CEIL(ABS(HIRE_DATE - SYSDATE)) COL2
FROM EMPLOYEE;

--입사한 월의 근무 일수

SELECT
    HIRE_DATE,
    LAST_DAY(HIRE_DATE),
    LAST_DAY(HIRE_DATE) - HIRE_DATE+1
FROM EMPLOYEE;

--EXTRACT : 년, 월, 일 정보를 추출하여 리턴하는 함수
--EXTRACT (YEAR FROM 날짜) : 년도만 추출
--EXTRACT (MONTH FROM 날짜) : 월만 추출
--EXTRACT (DAY FROM 날짜) : 날짜만 추출

SELECT
    EXTRACT (YEAR FROM SYSDATE) 년도,
    EXTRACT (MONTH FROM SYSDATE) 월,
    EXTRACT (DAY FROM SYSDATE) 일
FROM DAUL;

--EMPLOYEE 테이블에서 사원이름, 입사년, 입사월, 입사일 조회

SELECT
    EMP_NAME 사원이름, ---1
    EXTRACT(YEAR FROM HIRE_DATE) 년, ---2
    EXTRACT(MONTH FROM HIRE_DATE) 월, ---3
    EXTRACT(DAY FROM HIRE_DATE) 일 ---4
FROM EMPLOYEE
--ORDER BY EMP_NAME DESC -- 내림차순 기본은 오름차순
--ORDER BY 사원이름
--ORDER BY 1
ORDER BY 2, 3;
--EMPLOYEE테이블에서 사원이름, 입사일, 근무년수를 조회(단, 근무년수는 현재년도 - 입사년도 로 조회)
SELECT
    EMP_NAME,
    HIRE_DATE,
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) COL1
FROM EMPLOYEE;

--EMPLOYEE테이블에서 사원이름, 입사일, 근무년수를 조회(MONTHS_BETWEEN 으로 근무년수 조회)
SELECT
    EMP_NAME,
    HIRE_DATE,
    CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) COL1
FROM EMPLOYEE;


--형변환 함수
-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터로 변환
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변환

/*
Format		 예시			설명
,(comma)	9,999		콤마 형식으로 변환
.(period)	99.99		소수점 형식으로 변환
0		09999		왼쪽에 0을 삽입
$		$9999		$ 통화로 표시
L		L9999		Local 통화로 표시(한국의 경우 \)
9:자릿수를 나타내며 ,자릿수가 많지않아도 0으로채우지않는다
0:자릿수를나타내며, 자릿수가 많지 않을 경우 0으로 채워준다.
EEEE 과학 지수 표기법 
*/
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '99999') FROM DUAL;
SELECT TO_CHAR(1234, '00000') FROM DUAL;
SELECT TO_CHAR(1234, 'L99999') FROM DUAL;
SELECT TO_CHAR(1234, '$99,999') FROM DUAL;
SELECT TO_CHAR(1234, '00,000') FROM DUAL;
SELECT TO_CHAR(1234, '9.9EEEE') FROM DUAL;
SELECT TO_CHAR(1234, '999') FROM DUAL;

--EMPLOYEE테이블에서 사원명, 급여를 조회
-- 급여는 \9,000,000형식

SELECT
    EMP_NAME,
    TO_CHAR(SALARY, 'L99,999,999') 
FROM EMPLOYEE;


--날짜 데이터 포맷 적용
SELECT TO_CHAR(SYSDATE,'PM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'MON DY,YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY-fmMM-DD DAY') FROM DUAL;  --fm을 붙이면 0을 제거
SELECT TO_CHAR(TO_DATE('980630','RRMMDD'),'YYYY-fmMM-DD') FROM DUAL; -- 월앞에 0제거하고 싶을때 fm사용
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YEAR,Q')||'분기' FROM DUAL;

SELECT
    EMP_NAME,
    TO_CHAR(HIRE_DATE,'YYYY-MM-DD')입사일
FROM EMPLOYEE;
SELECT
    EMP_NAME,
    TO_CHAR(SYSDATE,'YYYY-MM--DD HH24:MI:SS')
FROM EMPLOYEE;

SELECT CURRENT_TIMESTAMP
FROM DUAL;

SELECT 
    TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') VAL,
    TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS') VLA2
FROM DUAL;

--오늘 날짜에 대해 년도 4자리, 2자리
--년도 이름으로 출력

SELECT 
    TO_CHAR(SYSDATE, 'YYYY'),
    TO_CHAR(SYSDATE, 'RRRR'),
    TO_CHAR(SYSDATE,'YY'),
    TO_CHAR(SYSDATE,'RR'),
    TO_CHAR(SYSDATE,'YEAR')
FROM DUAL;
/*
RR과 YY의 차이
    RR은 두 자리 년도를 네자리로 바꿀 때 바꿀 년도가 50년 미만인 경우 2000년대로 적용
    50년 이상이면 1900년대로 적용
    
    TO_DATE 시 Y를 적용하면 2000년도 적용
*/
SELECT
    TO_CHAR(TO_DATE('980630','YYMMDD'),'YYYY-MM-DD') VAL
FROM DUAL;

SELECT
    TO_CHAR(TO_DATE('980630','RRMMDD'),'YYYY-MM-DD') VAL2
FROM DUAL;

--오늘 날짜에서 월만 출력
SELECT
    TO_CHAR(SYSDATE,'MM'),
    TO_CHAR(SYSDATE,'MONTH'),
    TO_CHAR(SYSDATE,'MON'),
    TO_CHAR(SYSDATE,'RM')  --로마문자표기
FROM DUAL;

--오늘 날짜에서 일만 출력
SELECT
    TO_CHAR(SYSDATE, '"1년기준 "DDD"일째"'),
    TO_CHAR(SYSDATE, '"달기준 "DD"일째"'),
    TO_CHAR(SYSDATE, '"주기준 "D"일째"')
FROM DUAL;

--오늘 날짜에서 분기와 요일 출력 처리


SELECT
    TO_CHAR(SYSDATE, 'Q"분기"'),
    TO_CHAR(SYSDATE,'DAY'),
    TO_CHAR(SYSDATE,'DY')
FROM DUAL;

-- EMPLOYEE 테이블에서 이름, 입사일 조회 (입사일포맷 : '2018년 6월 15일 (수)') 형식으로 출력 처리하시오
SELECT
    EMP_NAME
    , TO_CHAR(HIRE_DATE, 'RRRR"년" fmMM"월" DD"일" "("DY")"') VAL
FROM EMPLOYEE;

-- TO_DATE: 문자형 데이터를 날짜형 데이터로 변환하여 리턴
-- TO_DATE(문자형 데이터, [포맷])
-- TO_DATE(숫자, [포맷])
SELECT
    TO_DATE('20100101', 'YYYYMMDD')
FROM DUAL;

SELECT
    TO_CHAR(TO_DATE('20100101', 'YYYYMMDD'), 'YYYY , MON') VAL
FROM DUAL;

SELECT
    TO_CHAR(TO_DATE('041030 143000', 'YYMMDD HH24MISS'), 'DD-MON-YY HH:MI:SS PM') VAL
FROM DUAL;

-- EMPLOYEE 테이블에서 2000년 이후에 입사한 사원의
-- 사번, 이름, 입사일을 조회하시오
SELECT
    EMP_ID
    , EMP_NAME
    , HIRE_DATE
FROM EMPLOYEE
--WHERE HIRE_DATE >= '20000101';
--WHERE TO_CHAR(HIRE_DATE, 'RRRRMMDD') >= '20000101';
WHERE HIRE_DATE >= TO_DATE(20000101, 'YYMMDD');
-- 자동적으로 형변환을 해주고 있음


-- TO_NUMBER(문자데이터, [포맷]) : 문자데이터를 숫자로 리턴
SELECT TO_NUMBER('123456789') VAL FROM DUAL;
SELECT TO_NUMBER('1,000,000', '9,999,999') - TO_NUMBER('550,000', '999,999') VAL FROM DUAL;

SELECT '123' + '456' FROM DUAL; -- 숫자로된 문자열도 자동형변환 해주고 있음
SELECT '123a' + '456' FROM DUAL; -- 문자가 들어가있으면 자동형변환 안됨, 오류


SELECT *
FROM EMPLOYEE
--WHERE MOD(EMP_ID, 2) = 1; -- 이것도 자동형변환된거
WHERE MOD(TO_NUMBER(EMP_ID), 2) = 1;


-- NULL처리 함수
-- NVL(컬럼명, 컬럼값이 NULL일 때 바꿀 값)
SELECT 
    EMP_NAME
    , BONUS
    , NVL(BONUS, 0) B
FROM EMPLOYEE;

SELECT
    EMP_NAME
    , PHONE
    , NVL(PHONE, '-') PHONE2
FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값1, 바꿀값2)
-- 해당 컬럼이 값이 있으면 바꿀값1로 변경
-- 해당 컬럼이 값이 NULL 일 경우 바꿀값2로 변경
SELECT
    EMP_NAME
    , BONUS
    , NVL2(BONUS, 0.7, 0.5) VAL
FROM EMPLOYEE;

SELECT
    EMP_NAME
    , PHONE
    , NVL2(PHONE, 'Y', 'N') PHONE2
FROM EMPLOYEE;


-- 선택함수
-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2, ..., [DEFAULT])
SELECT
    EMP_NO
    , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') VAL -- default 설정안하면 NULL로 들어감
FROM EMPLOYEE; 

-- 마지막 인자에 조건값 없이 선택값을 작성하게되면
-- 아무것도 해당되지 않는 경우 마지막에 작성한 선택값이 무조건 선택된다.
SELECT
    EMP_NO
    , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '여') VAL
FROM EMPLOYEE;
-- DB2에선 사용안됨


-- CASE 문
/*
CASE
    WHEN 조건식 THEN 결과값
    WHEN 조건식 THEN 결과값
    ELSE 결과값
END
*/

-- 직원의 급여를 인상하고자 한다
-- 직급코드가 J7인 직원은 급여의 10%를 인상하고
-- 직급코드가 J6인 직원은 급여의 15%를 인상하고
-- 직급코드가 J5인 직원은 급여의 20%를 인상한다.
-- 그 외 직급의 직원은 5%만 인상한다.
-- 직원 테이블에서 직원명, 직급코드, 급여, 인상급여(위 조건)을
-- 조회하세요

SELECT * FROM EMPLOYEE;
SELECT * FROM JOB;

-- DECODE
SELECT
    EMP_NAME
    , JOB_CODE
    , SALARY
    , DECODE(JOB_CODE
            , 'J7', SALARY * 1.1
            , 'J6', SALARY * 1.15
            , 'J5', SALARY * 1.2
            , SALARY * 1.05) 인상급여
FROM EMPLOYEE;

-- CASE WHEN
SELECT
    EMP_NAME
    , JOB_CODE
    , SALARY
    , CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1
           WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
           WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
           ELSE SALARY * 1.05
      END 인상급여
FROM EMPLOYEE;

-- 사번, 사원명, 급여을 EMPLOYEE 테이블에서 조회하고
-- 급여가 500만원 초과이면 '고급'
-- 급여가 300~500만원이면 '중급
-- 그 미만은 초급으로 출력하고 별칭은 '구분'이라고 한다.

SELECT
    EMP_ID
    , EMP_NAME
    , SALARY
    , CASE WHEN SALARY > 5000000 THEN '고급'
--           WHEN SALARY >= 3000000 THEN '중급'
           WHEN SALARY BETWEEN 3000000 AND 5000000 THEN '중급'
           ELSE '초급'
      END 구분
FROM EMPLOYEE;


-- 그룹함수 : SUB, AVG, MAX, MIN, COUNT

-- SUM(숫자가 기록된 컬럼명) : 합계를 구하여 리턴
SELECT
    SUM(SALARY) COl
FROM EMPLOYEE;
--GROUP BY DEPT_CODE;
-- GROUP BY 안쓰면 전체를 하나의 그룹으로 봄

-- AVG(숫자가 기록된 컬럼명) : 평균을 구하여 리턴
SELECT
    AVG(SALARY) COL
FROM EMPLOYEE;

-- MIN(컬럼명) : 컬럼에서 가장 작은 값 리턴 (자료형 ANY TYPE)
SELECT
    MIN(SALARY) COL
    , MIN(EMAIL) COL2
    , MIN(HIRE_DATE) COL3
FROM EMPLOYEE;

-- MAX(컬럼명) : 컬럼에서 가장 큰 값 리턴 (자료형 ANY TYPE)
SELECT
    MAX(SALARY) COL
    , MAX(EMAIL) COL2
    , MAX(HIRE_DATE) COL3
FROM EMPLOYEE;


SELECT
    AVG(BONUS) COL /* 기본 평균 */
    , AVG(DISTINCT BONUS) COL2 /* 중복제거 평균 */
    , AVG(NVL(BONUS, 0)) COL3 /* NULL 포함된 평균값 */
FROM EMPLOYEE;

--COUNT(* |컬럼명): 행의갯수를 헤아려서 리턴
--COUNT([DISTINCT] 컬러명):중복을 제거한 행 갯수 리턴 
--COUNT(*) :NULL 을 포함한 전체 갯수 리턴 
--COUNT(컬럼명): NULL 을 제외한 실제값이 기록된 행의 갯수 리턴

SELECT * FROM EMPLOYEE;
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

SELECT
    COUNT(*) COL1
    , COUNT(DEPT_CODE) COL2  -- NULL을 제외한 값이 기록된 행의 갯수
    , COUNT(DISTINCT DEPT_CODE) COL3 -- 중복없이 뽑은거
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 부서코드가 D5인 직원의 
-- 보너스 포함 연봉 합 계산
SELECT
    SUM((SALARY + (SALARY * NVL(BONUS, 0))) * 12) TOT
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- EMPLOYEE 테이블에서 전 사원의 보너스 평균을 소수 둘째 자리까지 반올림하여 구하기 (NULL 포함)
-- 처음부터 할 때 안나오면 하나씩 하는게 좋음
-- NVL(BOUNS, 0)
-- AVG(NVL(BONUS, 0))
-- ROUND(AVG(NVL(BONUS, 0)), 2)
-- 이런 순서로

SELECT
    ROUND(AVG(NVL(BONUS, 0)), 2)
FROM EMPLOYEE;

