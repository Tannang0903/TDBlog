CREATE DATABASE TDBlog;
USE TDBlog;

CREATE TABLE ROLE
(
	ID NVARCHAR(16) PRIMARY KEY,
    NAME NVARCHAR(30)
);

CREATE TABLE USER
(
	ID NVARCHAR(16) PRIMARY KEY,
    NAME NVARCHAR(30),
    USERNAME NVARCHAR(30),
    PASSWORD NVARCHAR(50),
    AVATAR NVARCHAR(100),
    REGISTEREDAT TIMESTAMP,
    ROLEID NVARCHAR(16)
);

CREATE TABLE POST
(
	ID NVARCHAR(16) PRIMARY KEY,
    NAME NVARCHAR(256),
    CONTENT NVARCHAR(10000),
    IMAGE NVARCHAR(100),
    VIEW INT,
    TIME INT,
    CREATEDAT TIMESTAMP,
    UPDATEDAT TIMESTAMP,
    AUTHORID NVARCHAR(16),
    TAGID NVARCHAR(16)
);

CREATE TABLE STATEHISTORY
(
	ID NVARCHAR(16),
    STATE INT,
    AT TIMESTAMP,
    POSTID NVARCHAR(16)
);

CREATE TABLE TAG 
(
	ID NVARCHAR(16) PRIMARY KEY,
    NAME NVARCHAR(256)
);


ALTER TABLE USER
	ADD CONSTRAINT FK_USER_ROLE
    FOREIGN KEY (ROLEID)
    REFERENCES ROLE(ID);
ALTER TABLE POST
	ADD CONSTRAINT FK_POST_AUTHOR
    FOREIGN KEY (AUTHORID)
    REFERENCES USER(ID);
ALTER TABLE POST
	ADD CONSTRAINT FK_TAG_POST
    FOREIGN KEY (TAGID)
    REFERENCES TAG(ID);
ALTER TABLE STATEHISTORY
	ADD CONSTRAINT FK_STATE_POST
    FOREIGN KEY (POSTID)
    REFERENCES POST(ID);
    
INSERT INTO ROLE(ID, NAME)
VALUES('ROLE_01', 'ADMIN');
INSERT INTO ROLE(ID, NAME)
VALUES('ROLE_02', 'USER');

INSERT INTO TAG(ID, NAME)
VALUES('TAG_01', 'Khoa học - Công nghệ');
INSERT INTO TAG(ID, NAME)
VALUES('TAG_02', 'Sách');
INSERT INTO TAG(ID, NAME)
VALUES('TAG_03', 'Du lịch');
INSERT INTO TAG(ID, NAME)
VALUES('TAG_04', 'Đời sống hằng ngày');
INSERT INTO TAG(ID, NAME)
VALUES('TAG_05', 'Phát triển bản thân');
INSERT INTO TAG(ID, NAME)
VALUES('TAG_06', 'Quan điểm - Tranh luận');
INSERT INTO TAG(ID, NAME)
VALUES('TAG_07', 'Thể thao');

SELECT POST.*, STATEHISTORY.STATE AS 'STATE' FROM POST INNER JOIN STATEHISTORY
ON POST.ID = STATEHISTORY.POSTID
ORDER BY STATEHISTORY.AT DESC
LIMIT 1;

SELECT * FROM POST;

SET SQL_SAFE_UPDATES = 0;

-- Admin account
-- username: tdblog_admin
-- password: tdblog_admin
INSERT INTO USER(ID, NAME, USERNAME, PASSWORD, AVATAR, REGISTEREDAT, ROLEID)
VALUES('U_01', 'Le Quoc Ron', 'tdblog_admin', 'c53000668f9643f31fce6339834a5625', '/public/uploads/avatar_1.png','2022-11-27 11:15:00', 'ROLE_01');

SELECT STATEHISTORY.STATE, DATE(STATEHISTORY.AT) AS 'AT', COUNT(STATEHISTORY.POSTID) AS 'COUNT' FROM STATEHISTORY INNER JOIN
(
	SELECT POST.ID, MAX(STATEHISTORY.AT) AS 'LASTED' FROM STATEHISTORY 
	INNER JOIN POST
	ON STATEHISTORY.POSTID = POST.ID
	GROUP BY POST.ID, DATE(STATEHISTORY.AT)
) AS A
ON A.ID = STATEHISTORY.POSTID
WHERE STATEHISTORY.AT = A.LASTED AND DATE(STATEHISTORY.AT) BETWEEN '2022-08-08' AND '2022-11-29'
GROUP BY DATE(STATEHISTORY.AT), STATEHISTORY.STATE
ORDER BY STATEHISTORY.AT;