CREATE TABLE membership (
	memberlv TINYINT DEFAULT 1,
	name VARCHAR(30) NOT NULL,
	id VARCHAR(30) NOT NULL, 
	pass VARCHAR(30) NOT NULL, 
	phone VARCHAR(20),
	cellphone VARCHAR(20) NOT NULL,
	email VARCHAR(40) NOT NULL,
	address VARCHAR(300) NOT NULL,
	regdate DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (5, '관리자', 'admin', '1234', '01047398061', '01047398061', 'songjiwoong1020@gmail.com', '.');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원1', 'dummy1', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원2', 'dummy2', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원3', 'dummy3', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원4', 'dummy4', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원5', 'dummy5', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원6', 'dummy6', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원7', 'dummy7', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원8', 'dummy8', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원9', 'dummy9', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원10', 'dummy10', '1234', '-', '-', '-', '-');
INSERT INTO membership (memberlv, NAME, id, pass, phone, cellphone, email, address)
	VALUES (1, '더미회원11', 'dummy11', '1234', '-', '-', '-', '-');


SELECT * FROM membership;

# 회원 테이블 생성 후 관리자를 넣어봄


CREATE TABLE multi_board (
    idx INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    postdate DATETIME DEFAULT CURRENT_TIMESTAMP,
    id varchar(10) NOT NULL,
    visitcount MEDIUMINT NOT NULL DEFAULT 0,
	 bname VARCHAR(30) NOT NULL,
	 ofile VARCHAR(100) NOT NULL,
	 sfile VARCHAR(30) NOT NULL,
    primary key(idx)
);

ALTER TABLE multi_board ADD CONSTRAINT fk_board_member
	FOREIGN KEY (id) REFERENCES membership (id);
	
INSERT INTO multi_board (title, content, id, bname)
	VALUES ('공지더미1', '더미내용1', 'admin', 'notice');
INSERT INTO multi_board (title, content, id, bname)
	VALUES ('공지더미2', '더미내용2', 'admin', 'notice');
INSERT INTO multi_board (title, content, id, bname)
	VALUES ('공지더미3', '더미내용3', 'admin', 'notice');
INSERT INTO multi_board (title, content, id, bname)
	VALUES ('자유게시판더미1', '더미내용1', 'admin', 'freeboard');
INSERT INTO multi_board (title, content, id, bname)
	VALUES ('자유게시판더미2', '더미내용2', 'admin', 'freeboard');
INSERT INTO multi_board (title, content, id, bname)
	VALUES ('자유게시판더미3', '더미내용3', 'admin', 'freeboard');