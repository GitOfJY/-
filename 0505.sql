-- 0505


DROP TABLE Orders cascade constraints purge;
DROP TABLE Book cascade constraints purge;
DROP TABLE Customer cascade constraints purge;
DROP TABLE Imported_Book cascade constraints purge;

CREATE TABLE Book (
bookid NUMBER(2) PRIMARY KEY,
bookname VARCHAR2(40),
publisher VARCHAR2(40),
price NUMBER(8)
);

CREATE TABLE Customer (
custid NUMBER(2) PRIMARY KEY,
name VARCHAR2(40),
address VARCHAR2(50),
phone VARCHAR2(20)
);

CREATE TABLE Orders (
orderid NUMBER(2) PRIMARY KEY,
custid NUMBER(2) REFERENCES Customer(custid),
bookid NUMBER(2) REFERENCES Book(bookid),
saleprice NUMBER(8),
orderdate DATE
);

/* Book, Customer, Orders 데이터 생성 */
INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000);
INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000);
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000);
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000);
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000);
INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000);
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000);
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000);
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500);
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001');
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '000-7000-0001');
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전', NULL);

INSERT INTO Orders VALUES (1, 1, 1, 6000, TO_DATE('2020-07-01','yyyy-mm-dd'));
INSERT INTO Orders VALUES (2, 1, 3, 21000, TO_DATE('2020-07-03','yyyy-mm-dd'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, TO_DATE('2020-07-03','yyyy-mm-dd'));
INSERT INTO Orders VALUES (4, 3, 6, 6000, TO_DATE('2020-07-04','yyyy-mm-dd'));
INSERT INTO Orders VALUES (5, 4, 7, 20000, TO_DATE('2020-07-05','yyyy-mm-dd'));
INSERT INTO Orders VALUES (6, 1, 2, 12000, TO_DATE('2020-07-07','yyyy-mm-dd'));
INSERT INTO Orders VALUES (7, 4, 8, 13000, TO_DATE('2020-07-07','yyyy-mm-dd'));
INSERT INTO Orders VALUES (8, 3, 10, 12000, TO_DATE('2020-07-08','yyyy-mm-dd'));
INSERT INTO Orders VALUES (9, 2, 10, 7000, TO_DATE('2020-07-09','yyyy-mm-dd'));
INSERT INTO Orders VALUES (10, 3, 8, 13000, TO_DATE('2020-07-10','yyyy-mm-dd'));

CREATE TABLE Imported_Book (
bookid NUMBER,
bookname VARCHAR(40),
publisher VARCHAR(40),
price NUMBER(8)
);

INSERT INTO Imported_Book VALUES(21, 'Zen Golf', 'Pearson', 12000);
INSERT INTO Imported_Book VALUES(22, 'Soccer Skills', 'Human Kinetics', 15000);

COMMIT;



--질의 3-15 고객이 주문한 총판매액
select*from orders;
select sum(saleprice) as "총 판매액" from orders;



-- 질의 3-16 2번 김연아 고객이 주문한 도서의 총 판매액
select sum(saleprice) as "총 판매액" from orders where custid = '2';



-- 질의 3-17 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가
select 
    sum(saleprice),
    avg(saleprice),
    max(saleprice),
    min(saleprice)
from orders;



-- 질의 3-18 마당서점의 도서 판매 건수
select count(*) from orders;



-- 질의 3-19 고객별로 주문한 도서의 총수량과 총판매액
select
    count(*),
    sum(saleprice)
from orders 
    group by custid;
    


-- **************************************************                    
-- 질의 3-20 가격이 8000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총수량을 구하시오. 단 2권 이상 구매한 고객만
-- 8000원 이상 도서를 구매한 고객 > 총수량 > 2권 이상
select * from orders;
select count(*) from orders group by custid;
select count(*) from orders where saleprice > 8000 group by custid;

select custid, count(*) from orders where saleprice >= 8000 group by custid having count(*) >= 2;
-- having에 대해 공부 필요
-- 반드시 group by절과 같이 작성, 검색조건에는 집계함수가 와야한다.
-- 실행 순서 헷갈림 : from > where > (group by > having > select) > order by



-- 질의 3-21 고객과 고객의 주문에 관한 데이터를 모두
select * from orders;
select * from customer;

select * from customer c inner join orders o on c.custid = o.custid;
select * from Customer, Orders where Customer.custid=Orders.custid;
select * from Customer c, Orders o where c.custid = o.custid;
-- **************************************************  
-- from 다음에 테이블 2개가 동시에 와서 조인이 가능하군



-- 질의 3-22 고객과 고객의 주문에 관한 데이터를 고객별로 정렬
select * from Customer c, Orders o where c.custid = o.custid order by c.name;
select * from Customer, Orders where Customer.custid = Orders.custid order by Customer.custid;



-- **************************************************
-- 동등조인 > 동등조건에 의하여 테이블을 조인하는 것, 조인이라고 하면 대부분 동등조인
-- (equi join, inner join)
-- 동등조건? 양쪽 테이블에서 등호(=) 연결 연산자를 사용하여 조건 값이 정확하게 일치할 때만 행을 가져옴



-- 질의 3-23 고객의 이름과 고객이 주문한 도서의 판매가격 
select 
    c.name as "이름",
    o.saleprice as "도서의 판매가격"
from customer c 
    inner join orders o 
        on c.custid = o.custid;



-- **************************************************
-- 내가 짠 query가 틀린 이유가 뭐지
-- 질의 3-24 고객별로 주문한 모든 도서의 총판매액을 구하고 고객별로 정렬
select 
    c.name,
    sum(o.saleprice)
from customer c 
    inner join orders o 
        on c.custid = o.custid
            group by c.custid
                order by c.custid;
                
select 
    name,
    sum(saleprice)
from customer, orders
    where customer.custid = orders.custid
        group by customer.name
            order by customer.name;



-- 질의 3-25 고객의 이름과 고객이 주문한 도서의 이름
select 
    c.name as "고객이름",
    b.bookname as "주문한 도서"
from customer c 
    inner join orders o 
        on c.custid = o.custid
            inner join book b
                on o.bookid = b.bookid;
                
select Customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid;



-- 질의 3-26 가격이 20000원인 도서를 주문한 고객의 이름과 도서의 이름
select 
    c.name,
    b.bookname
from customer c
    inner join orders o
        on c.custid = o.custid
            inner join book b
                on o.bookid = b.bookid
                    where o.saleprice = 20000;
                    
select
    Customer.name,
    book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid and orders.saleprice = 20000;



-- 질의 3-27 도서를 구매하지 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 판매가격
select 
    c.name,
    o.saleprice
from customer c
    left outer join orders o
        on c.custid = o.custid;
        
select Customer.name, saleprice
from Customer left outer join orders
on Customer.custid = Orders.custid;



-- 질의 3-28 가장 비싼 도서의 이름
select max(price) from book;
select bookname from book where price = (select max(price) from book); 
-- **************************************************
-- subquery > 부속질의 > 질의가 중첩되어있다.



-- 질의 3-29 도서를 구매한 적이 있는 고객의 이름
select * from orders;
select distinct custid from orders;
select * from customer;
select name from customer where custid in (select distinct custid from orders);



-- 질의 3-30 대한미디어에서 출판한 도서를 구매한 고객의 이름
select * from orders;
select * from book;
select bookid from book where publisher = '대한미디어';
select custid from orders where bookid in(select bookid from book where publisher = '대한미디어');
select name from customer where custid = (select custid from orders where bookid in(select bookid from book where publisher = '대한미디어'));



-- 질의 3-31 출판사별로 출판사의 평균 도서 가격보다 비싼 도서 
select * from orders;
select * from book;
select publisher,round(avg(price)) as "평균가격" from book group by publisher; --출판사별로 출판사의 평균 도서
select round(avg(price)) from book group by publisher;

select 
    b.bookname
from book b 
    inner join (select publisher,round(avg(price)) as "평균가격" from book group by publisher) a 
        on b.publisher = a.publisher
            where b.price > a."평균가격";
            
select b1.bookname
from book b1
where b1.price > (select avg(b2.price) from book b2 where b2.publisher = b1.publisher);
-- **************************************************
-- 투플 변수 : 테이블의 별칭 붙여 사용하는 것 
/*
부속질의 : select문에 나오는 결과 속성을 from절의 테이블에서만 얻을 수 있다.
조인    : 조인한 모든 테이블에서 결과 속성을 얻을 수 있다. 
> 조인은 부속질의가 할 수 있는 모든 것을 할 수 있다.
> 힌 개의 테이블에서만 결과를 얻는 여러 테이블 질의는 조인보다 부속질의로 작성하는 것이 더 편하다.
*/



-- **************************************************
-- 질의 3-32 도서를 주문하지 않은 고객의 이름
select 
    c.name
from customer c
    left outer join orders o
        on c.custid = o.custid
            where o.orderdate is null;
-- **************************************************
-- null 일 때 is 사용하는거 까먹음

select name
from customer
minus
select name
from customer
where custid in (select custid from orders);

-- **************************************************
-- 집합 연산 > 완전 까먹고 있었다. 수업 내용 다시 복습하기
-- 집합 연산 > 테이블은 투플이 집합이므로 테이블 간의 집합연산을 이용하여 합집합(union)/차집합(minus)/교집합(intersect)



-- 질의 3-33 주문이 있는 고객의 이름과 주소 
select 
    name as "이름",
    address as "주소"
from customer
    where custid in (select custid from orders);
    
select 
    c.name as "이름",
    c.address as "주소"
from customer c
    left outer join orders o
        on c.custid = o.custid
            where o.orderdate is not null;
-- **************************************************
-- 이렇게 풀이했을 때 distinct() 사용 안되는 이유? group by도 안되고 중복 없애는 방법은 없나?

select name,address
from customer cs
where exists (select * from orders od where cs.custid=od.custid);
-- **************************************************
-- exists 모름 > 배운적 없는 것 같으니 찾아보기
-- exists는 상관 부속질의문 형식, 조건에 맞는 투플이 존재하면 결과에 포함시킨다.
-- not exists는 부속질의문의 모든 행이 조건에 만족하지 않을 때만 참이다.



-- 질의 3-34 다음과 같은 속성을 가진 NewBook 테이블 생성
-- bookid(도서번호) - number
-- bookname(도서이름) - varchar2(20)
-- publisher(출판사) - varchar2(20)
-- price(가격) - number
create table NewBook (
    bookid number,
    bookname varchar2(20),
    publisher varchar2(20),
    price number
);



-- 질의 3-35 다음과 같은 속성을 가진 NewCustomer 테이블 생성
-- custid(고객번호) - number, 기본키
-- name(이름) - varchar2(40)
-- address(주소) - varchar2(40)
-- phone(번호) - varchar(30)

create table NewCustomer (
    custid number primary key,
    name varchar2(40),
    address varchar2(40),
    phone varchar2(30)
);



-- 질의 3-36 다음과 같은 속성을 가진 NewOrders 테이블 생성
-- orderid(주문번호) - number, 기본키
-- custid(고객번호) - number, not null 제약조건, 외래키(NewCostomer.custid, 연쇄삭제)
-- bookid(도서번호) - number, not null 제약조건
-- saleprice(판매가격) - number
-- orderdate(판매일자) - date

create table NewOrders (
    orderid number,
    custid number not null,
    bookid number not null,
    saleprice number,
    orderdate date,
    
    primary key(orderid),
    foreign key(custid) references newcustomer(custid) on delete cascade
);

-- **************************************************
-- 외래키랑 날짜 헷갈림 > 수업중에 했던 regdate랑 뭐지
-- on delete cascade 기억 안남
-- 외래키 제약조건 명시 주의점 > 반드시 참조되는 테이블이 존재해야 하며 참조되는 테이블의 기본키여야한다.
-- 외래키 지정 시 on delete 옵션은 참조되는 테이블의 투플이 삭제될 때 취할 수 있는 동작을 지정한다.
-- cascade > 참조되는 테이블의 투플이 삭제되면 참조하는 테이블의 투플이 연쇄삭제
-- set null 옵션은 null 값으로 바꾸며 no action 옵션은 기본값으로 어떠한 동작도 취하지 않는다.
-- 아직 DDL이 너무 어색함, 자주 보기



-- **************************************************
-- 질의 3-37 newbook 테이블에 varchar2(13)의 자료형을 가진 isbn 속성을 추가
ALTER TABLE newBook
    add isbn varchar2(13);

select * from newBook;
desc newBook;



-- **************************************************
-- 질의 3-38 newbook 테이블의 isbn 속성의 데이터 타입을 number형으로 변경
ALTER TABLE newBook modify isbn number;



-- **************************************************
-- 질의 3-39 newbook 테이블의 isbn 속성 삭제
ALTER TABLE newBook drop column isbn;



-- **************************************************
-- 질의 3-40 newbook 테이블의 bookid 속성에 not null 제약조건을 적용
ALTER TABLE newBook modify bookid NUMBER not null;



-- **************************************************
-- 질의 3-41 newbook 테이블의 bookid 속성을 기본키로 변경
ALTER TABLE newBook ADD primary key(bookid);



-- 질의 3-42 newbook 테이블을 삭제
DROP TABLE newBook;



-- 질의 3-43 newcustomer 테이블을 삭제, 삭제가 거절된다면 원인을 파악하고 관련된 테이블을 같이 삭제
DROP TABLE newCustomer;
--ORA-02449: unique/primary keys in table referenced by foreign keys
-- 삭제하려는 테이블의 기본키를 다른 테이블에서 참조하고 있다면 삭제가 거절된다. > 참조하고 있는 테이블부터 삭제

desc newCustomer;

DROP TABLE newOrders;
DROP TABLE newCustomer;



-- **************************************************
-- 질의 3-44 book 테이블에 새로운 도서 '스포츠 의학'을 삽입, 한솔의학서적에서 출간했으며 가격은 90000원
-- insert into 테이블이름[(속성리스트)] values (값리스트);
-- 새로운 투플 삽입할 때 속성의 이름 생략 가능하다. 대신 데이터의 입력 순서는 속성의 순서와 일치해야한다.
-- 데이터는 항상 속성의 순서대로 입력하지 않아도 된다. 대신 속성의 이름과 데이터 순서를 바꾸면 된다.
-- 몇 개의 속성만 입력해야 한다면 속성만 명시하면 된다. null 사용 없이 그냥 안 쓰면 됨
desc book;
select * from book;
insert into book(bookid, bookname, publisher, price) values (11, '스포츠 의학', '한솔의학서적', 90000);



-- 질의 3-45 book 테이블에 새로운 도서 '스포츠 의학'을 삽입, 스포츠 의학은 한솔의학서적에서 출간했으며 가격은 미정
insert into book(bookid, bookname, publisher, price) values(12, '스포츠 의학', '한솔의학서적', null);
insert into book(bookname, publisher, bookid) values ('스포츠 의학', '한솔의학서적', 13);



-- **************************************************
-- 질의 3-46 수입도서 목록(imported_book)을 book테이블에 모두 삽입
select * from imported_book;
insert into Book(bookid, bookname, price, publisher) 
select bookid, bookname, price, publisher 
from imported_book;

select * from book;



-- **************************************************
-- update 테이블이름 set 속성이름=값 where 조건;
-- 질의 3-47 customer 테이블에서 고개번호가 5인 고객의 주소를 '대한민국 부산'으로 변경
update customer set address='대한민국 부산' where custid = 5;



-- 질의 3-48 customer 테이블에서 박세리 고객의 주소를 김연아 고객의 주소로 변경
select * from customer;
select address from customer where name = '김연아';
update customer set address = (select address from customer where name = '김연아') where name = '박세리';



-- **************************************************
-- delete from 테이블이름 where 조건;
-- drop문은 ddl문으로 테이블 구조를 삭제한다. 당연히 데이터도 같이 삭제한다.
-- delete문은 dml문으로 테이블 구조는 그대로 두고 데이터만 삭제한다.
-- 질의 3-49 customer 테이블에서 고객번호가 5이 고객을 삭제한 후 결과 확인
delete from customer where custid = 5;
select * from customer;



-- 질의 3-50 모든 고객 삭제
delete from customer;


/*
    
    commit 과 rollback
    
    insert, delete, update 문의 결과는 최종적으로 commit문을 만나지 않으면 실제로 데이터 베이스에 반영되지 않는다.
    일시적으로 반영된 데이터 복원 > rollback
    commit 반영 후 rollback 작업을 수행해도 삭제된 데이터 복원 불가능
    
*/













































