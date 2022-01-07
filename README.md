# Spring
sql문
sql 아이디 scottdb
비밀번호 tiger

```
create table tbl_board(
BNO Integer primary key auto_increment,
TITLE varchar(35),
CONTENT varchar(400),
WRITER varchar(20),
REGDATE datetime default current_timestamp,
UPDATEDATE datetime default current_timestamp
);

DESC TBL_BOARD;
DROP TABLE TBL_BOARD;
SELECT * FROM TBL_BOARD;

select count(*) from tbl_board;

select * from tbl_board limit 0,3; -- 0부터 3개 보여줘라 이런뜻..

insert into  tbl_board(title,content,writer) values ('명탐정은 노잼','명탐정 영화 노잼','미란이');

create table tbl_reply(
rno Integer primary key auto_increment,
bno int,
reply varchar(2000),
replyer varchar(40),
replyDate datetime default current_timestamp,
updateDate datetime default current_timestamp,
foreign key (bno) references tbl_board (bno) -- on update cascade
);
drop table tbl_reply;
desc tbl_reply;
select version();
select * from tbl_reply;

create index idx_reply on tbl_reply(bno desc, rno asc);
explain select * from tbl_reply where bno=1;

create table tbl_sample1(col1 varchar(500));
create table tbl_sample2(col2 varchar(50));

drop table tbl_sample1;
select * from tbl_sample2;

alter table tbl_board add (replycnt Integer default 0);

-- 댓글 지금까지 작성된 갯수 update
update tbl_board tb set replycnt=(select count(rno) from tbl_reply tr where tb.bno=tr.bno);
-- tb.bno랑 tr.bno가 같은거 중에서 tbl_reply 테이블에서 rno의 갯수를 tbl_board 의 replycnt로 update 쫘라락 해라 라는 뜻
select * from tbl_board;
select * from tbl_attach;
delete from tbl_board;

-- 첨부파일을 보관하는 tbl_attach
create table tbl_attach(
uuid varchar(200) not null,
uploadPath varchar(300) not null,
fileName varchar(200) not null,
fileType char(1) default 'I',
bno Integer
);
desc tbl_attach;
alter table tbl_attach add constraint pk_attach primary key(uuid); -- 제약조건의 이름 : pk_attach 를 추가하는데 uuid를 primary key로 설정해라
alter table tbl_attach add constraint fk_board_attach foreign key(bno) references tbl_board(bno);
```
