/*
블럭단위 주석
*/
#라인단위 주석1
--라인단위 주석2


SELECT * FROM ts_test;

DESC member;
DESC board;


#모델1방식(JSP) + MariaDB를 이용한 게시판
#회원테이블(부모)
create table member(
    id VARCHAR(30) not null,
    pass VARCHAR(30) not null,
    name varchar(member30) not null,
    regidate datetime default CURRENT_TIMESTAMP, /* 현재시간을 디폴트로 사용 
		 														datatime : 날짜와 시간을 동시에 표현 할 수 있는 자료형
			 													*/
    primary key (id)
);
#게시판테이블(자식)
/*
	AUTO_INCREMENT : 오라클의 시퀀스를 대체 할 수 있는 속성으로
		지정된 컬럼은 자동으로 값이 증가하게 된다. 단 자동증가로
		지정되면 데이터를 임의로 삽입 할 수 없게된다.
*/
create table board(
    num int not NULL AUTO_INCREMENT,
    title varchar(100) not null,
    content text not null,
    posrdate datetime default CURRENT_TIMESTAMP,
    id varchar(10) not null,
    visitcount MEDIUMINT NOT NULL DEFAULT 0,
    primary key(num)
);

#회원테이블과 게시판테이블의 참조 제약조건
ALTER TABLE board ADD CONSTRAINT fk_board_member
	FOREIGN KEY (id) REFERENCES member (id);

#더미데이터 삽입
INSERT INTO member (id, pass, name)
	VALUES ('kosmo', '1234', '코스모61기');
#member테이블과 외래키 제약조건이 있으므로 board테이블에 먼저 삽입 할
#경우 에러가 발생된다.
INSERT INTO board (title, content, id)
	VALUES ('제목입니다1', '내용입니다1', 'kosmo');
INSERT INTO board (title, content, id)
	VALUES ('제목입니다2', '내용입니다2', 'kosmo');
INSERT INTO board (title, content, id)
	VALUES ('제목입니다3', '내용입니다3', 'kosmo');
INSERT INTO board (title, content, id)
	VALUES ('제목입니다4', '내용입니다4', 'kosmo');
INSERT INTO board (title, content, id)
	VALUES ('제목입니다5', '내용입니다5', 'kosmo');
	
#데이터 타입의 종류
#숫자형
CREATE TABLE tb_int(
	idx INT PRIMARY KEY AUTO_INCREMENT,
	
	num1 TINYINT UNSIGNED NOT NULL,
	num2 SMALLINT NOT NULL,
	num3 MEDIUMINT DEFAULT '100',
	num4 BIGINT,
	
	fnum1 FLOAT(10, 5) NOT NULL,
	fnum2 DOUBLE(20, 10)
	
);
	
SHOW VARIABLES LIKE 'c%';#인코딩 확인?

INSERT INTO tb_int (num1, num2, num3, num4, fnum1, fnum2)
	VALUES (100, 12345, 1234567, 1234567890, 12345.12345, 1234567890.1234567891);    
SELECT * FROM tb_int;
/* 자동증가 컬럼에 임의의 값을 삽입 할 수 있으나 사용하지 않는것이 좋다 */
INSERT INTO tb_int (idx, num1, num2, num3, num4, fnum1, fnum2)
	VALUES (2, 100, 12345, 1234567, 1234567890, 12345.12345, 1234567890.1234567891);  
# 빈값은 삽입 할 수 없다. 오류발생됨
INSERT INTO tb_int (idx, num1, num2, num3, num4, fnum1, fnum2)
	VALUES ('', 100, 12345, 1234567, 1234567890, 12345.12345, 1234567890.1234567891); 
	
#날짜형
CREATE TABLE tb_date(
	idx INT PRIMARY KEY AUTO_INCREMENT,
	
	date1 DATE NOT NULL,
	date2 DATETIME DEFAULT CURRENT_TIMESTAMP
);
/*
	날짜타입의 컬럼에 현재날짜를 입력 할 때 오라클은 sysdate를
	사용하지만 MySQL은 now()함수를 사용한다.
*/
INSERT INTO tb_date (date1, date2)
	VALUES ('2020-05-27', NOW());
SELECT * FROM tb_date;
/*
	시간변환함수 date_format(컬럼명, '서식')
*/
SELECT DATE_FORMAT(date2, '%Y-%m-%d') FROM tb_date;
SELECT DATE_FORMAT(date2, '%H:%i:%s') FROM tb_date;

#특수형
CREATE TABLE tb_spec(
	idx INT AUTO_INCREMENT,
	
	spec1 ENUM('M', 'W', 'T'),
	spec2 SET('A', 'B', 'C', 'D'),
	
	PRIMARY KEY (idx)
);

INSERT INTO tb_spec (spec1, spec2)
	VALUES ('W', 'A,B,D');
SELECT * FROM tb_spec;

#spec1은 디폴트가 설정되었으므로 자동입력
INSERT INTO tb_spec (spec2)
	VALUES ('A,B,C');
#설정되지 않은 값으로 입력시 오류 발생
INSERT INTO tb_spec (spec1, spec2)
	VALUES ('A', 'A,B,E');
	
	
/*
Model1 방식의 게시판을 MariaDB로 컨버팅
*/
-- 전체 레코드 수 조회
SELECT COUNT(*) FROM board;
SELECT COUNT(*) FROM board WHERE title LIKE '%다1%';

-- 페이지처리를 위한 쿼리문 (오라클과 다름)
SELECT * FROM board ORDER BY num DESC;
-- 한 페이지에 2개의 게시물이 출력된다고 가정했을때
/*
	페이지처리를 위해 게시물의 범위를 정할때 Oracle은 rownum의
	속성을 사용하지만 MariaDB는 limit를 사용한다.
	방법 : limit 시작인덱스, 가져올 레코드갯수
*/
-- 1페이지 레코드 셋
SELECT * FROM board ORDER BY num DESC LIMIT 0, 2;
-- 2페이지 레코드 셋
SELECT * FROM board ORDER BY num DESC LIMIT 2, 2;
-- 3페이지 레코드 셋
SELECT * FROM board ORDER BY num DESC LIMIT 4, 2;

-- 컬럼이름 잘못만듬
ALTER TABLE board
CHANGE posrdate postdate datetime default CURRENT_TIMESTAMP;
SELECT * FROM board;
-- ㅜㅜ 

-- 상세보기처리 - 조회수 업데이트 => 기존 오라클 쿼리와 동일
UPDATE board SET visitcount = visitcount + 1 WHERE num = 2;
SELECT * FROM board WHERE num=2;

-- 회원테이블과 게시판 테이블 내부조인을 통한 조회
#표준방식 => 기존 오라클 쿼리와 동일
SELECT b.*, M.name FROM member M INNER JOIN board B ON M.id = B.id WHERE num = 2;
#간단방식
SELECT b.*, M.name FROM member M, board B WHERE M.id = B.id AND num=2;

-- 게시물 수정하기 => 기존 오라클 쿼리와 동일
UPDATE board SET title='수정해볼까요?', content='수정' WHERE num=2;

-- 게시물 삭제하기 => 기존 오라클 쿼리와 동일
DELETE FROM board WHERE num=2;


/*
기존의 게시판을 멀티게시판으로 변경
	자유게시판 : freeboard
	공지사항 : notice
	질문과답변 : qna
	FQA : faq
하나의 테이블로 여러개의 게시판을 제작하는 경우 게시판의 구분을 위해
flag(플레그)가 필요하다.
*/
-- 공지사항 게시판에 글쓰기
INSERT INTO board (title, content, id, bname)
	VALUES ('여긴 공지사항', '내용없음', 'kosmo', 'notice');
INSERT INTO board (title, content, id, bname)
	VALUES ('공지더미1', '공지내용1', 'kosmo', 'notice');
INSERT INTO board (title, content, id, bname)
	VALUES ('공지더미2', '공지내용2', 'kosmo', 'notice');
INSERT INTO board (title, content, id, bname)
	VALUES ('공지더미3', '공지내용3', 'kosmo', 'notice');
INSERT INTO board (title, content, id, bname)
	VALUES ('공지더미4', '공지내용4', 'kosmo', 'notice');
	
	
-- 자유게시판 리스트 보기
SELECT * FROM board WHERE bname='freeboard';
-- 공지사항 리스트 보기
SELECT * FROM board WHERE bname='notice';

SELECT * FROM board;