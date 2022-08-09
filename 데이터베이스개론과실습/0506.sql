-- 0506



-- SQL 함수 > 내장 함수, 사용자정의 함수

-- SQL 내장 함수
-- SQL 내장 함수는 사수나 속성 이름을 입력값으로 받아 단일 값을 결과로 반환한다.
-- 모든 내장 함수는 최초에 선언될 때 유효한 입력값을 받아야한다.


-- 질의 4-1 -78과 +78의 절댓값
select 
    abs(-78) as "-78 절댓값", 
    abs(+78) as "78 절댓값"
from dual;
-- dual : Dual 테이블은 실제로 존재하는 테이블이 아니라 오라클에서 일시적인 연산 작업에 사용하기 위해 만든 가상의 테이블



-- 질의 4-2 4.875 소수 첫째 자리까지 반올림한 값
select round(4.875, 1) from dual;



-- **************************************************                    
-- 질의 4-3 고객별 평균 주문 금액을 백 원 단위로 반올림한 값
-- 백원 단위로 반올림은 어떻게 하지? > - 사용
select * from customer;
select * from orders;

select 
    name,
    round(avg(saleprice), -2)
from customer c
    inner join orders o
        on c.custid = o.custid
            group by name;

select 
    custid as "고객번호", 
    round(sum(saleprice)/count(*), -2) as "평균금액"
from orders 
    group by custid;



-- **************************************************
-- 질의 4-4 도서 제목에 '야구'가 포함된 도서를 '농구'로 변경한 후 도서목록 보이기
select bookname from book;
select replace(bookname, '야구', '농구') from book;



-- 질의 4-5 '굿스포츠'에서 출판한 도서의 제목과 제목의 글자수, 바이트 수
-- 공백도 하나의 문자로 간주
select 
    bookname as "제목",
    length(bookname) as "글자 수",
    lengthB(bookname) as "바이트 수"
from book 
    where publisher = '굿스포츠';



-- 질의 4-6 마당서점의 고객 중에서 같은 성을 가진 사람이 몇명이나 되는지 성별 인원수
select * from customer;
select 
    substr(name, 1, 1), 
    count(*) 
from customer 
    group by substr(name, 1,1);



-- **************************************************
-- 날짜, 시간 함수> java에서도 그렇게 뭔지 모르게 헷갈림
-- To_Date('2020-0914', 'yyyy-mm-dd'); 문자형 데이터를 DATE형으로 반환
-- To_Char(To_Date('2020-0914', 'yyyy-mm-dd'), 'yyyymmdd'); DATE형 데이터를 문자형으로 반환
-- add_months(date, 숫자); 날짜에 지정한 달을 더해 DATE형으로 반환
-- last_day(date) 날짜에 달의 마지막 날을 DATE형으로 반환
-- sysdate DBMS 시스템상의 당일 날짜를 DATE형으로 반환하는 인자가 없는 함수



select 
    to_date('2020-07-01', 'yyyy-mm-dd')+5 as "Before",
    to_date('2020-07-01', 'yyyy-mm-dd')-5 as "After"
from dual;



-- 질의 4-7 마당서점은 주문일로부터 10일 후 매출을 확정한다. 각 주문의 확정일자
select * from orders;
select
    custid as "고객번호",
    orderdate as "주문일자",
    to_date(orderdate, 'yyyy-mm-dd') + 10 as "매출 확정",
    orderdate + 10 as "매출 확정" -- 이미 date형이어서 굳이 바꿀 필요 없었음;
from orders;



-- **************************************************
/*

    datetime 주요 인자 > 이것도 잘 기억 안남

    d : 1 ~ 7 (월요일이 1)
    day : 월요일 ~ 일요일
    dy : 월 ~ 일
    dd : 1 ~ 31 (1달 중 날짜)
    ddd : 1 ~ 365 (1년 중 날짜)
    hh, hh12 : 12시간
    hh24 : 24시간
    mi : 1 ~ 60 (분)
    mm : 1 ~ 12 (월 순서)
    ss : 1~ 60 (초)
    mon : jan ~ dec
    month : january ~ december
    yyyy : 4자리 연도
    yyyy.yy.y : 4자리 연도의 마지막 3,2,1 자리

*/



-- 질의 4-8 마당서점이 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 보이시오
--          단 주문일은 'yyyy-mm-dd 요일' 형태로 표시
select * from orders;
select
    orderid as "주문번호",
    to_char(orderdate, 'yyyy-mm-dd day') as "주문일",
    custid as "고객번호",
    bookid as "도서번호"
from orders
    where orderdate = to_date('2020-07-07', 'yyyy-mm-dd');



-- 질의 4-9 DBMS 서버에 설정된 현재 날짜와 시간, 요일을 확인
select
    sysdate,
    to_char(sysdate, 'yyyy/mm/dd dy hh24:mi:ss') as "sysdate_1"
from dual;



-- **************************************************
-- null 값이란 아직 지정되지 않은 값
-- null 값은 '0', 빈문자, 공백 등과 다른 특별한 값
-- null + 숫자 > null
-- 집계 함수를 계산할 때 null이 포함된 행은 집계에서 빠진다.
-- 집계 함수에 적용되는 행이 하나도 없으면, sum/avg 결과는 null, count 결과는 0



-- **************************************************
-- nvl 함수 > 수업시간에 했었는지 모르겠음
-- nvl(속성, 값) > null값을 다른 값으로 대치하여 연산하거나 다른 값으로 출력
-- 질의 4-10 이름, 전화번호가 포함된 고객목록을 보이시오. 단, 전화번호가 없는 고객은 '연락처 없음'으로 표시
select * from customer;
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전', NULL);
commit;

select
    name as "이름",
    nvl(phone, '연락처 없음') as "연락처"
from customer;



-- 질의 4-11 고객목록에서 고개번호, 이름, 전화번호를 앞의 두 명만 보이시오
-- **************************************************
-- rownum > 보여주는 순서는 규칙이 없고 오라클이 저장해 둔 순서대로 보여준다.
-- where문은 order문보다 먼저 실행됨을 조심하기 > 정렬 먼저 하고 싶을 땐 subquery 이용
select * from customer;
select rownum, custid, name, phone from customer where rownum < 3;



-- **************************************************
-- 조인? 부속질의?
-- 두 테이블을 연관시킬 때 조인을 선택할지 부속질의를 선택할지는 데이터의 형태와 양에 따라 달라진다.
-- 일반적으로 데이터가 대량일 경우 데이터를 모두 합쳐서 연산하는 조인보다 필요한 데이터만 찾아서 공급해주는 부속질의가 좋다.

-- select 부속질의 / from 부속질의 / where 부속질의
-- 스칼라 부속질의  /   인라인 뷰   /    중첩질의(보통의 부속질의)
-- 스칼라 부속질의 : select절에서 사용되며 단일 값을 반환하기 때문에 스칼라 부속질의
-- 인라인 뷰 : from절에서 결과를 뷰 형태로 반환하기 때문에 인라인 뷰

-- 부속질의가 주 질의의 값을 참조하는가?
-- 상관 부속질의 : 주 질의의 특정 열 값을 부속질의가 상속받아 부속질의의 질의에 사용하는 형태
-- 비상관 부속질의(일반 부속질의) : 독립된 질의를 수행해서 결과값을 가져오는 형태



-- 질의 4-12 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 보이시오
select avg(saleprice) from orders;
select 
    orderid,
    saleprice
from orders
    where saleprice <= (select avg(saleprice) from orders);



-- 질의 4-13 각 고객의 평균 주문금액보다 큰 주문 내역에 대해서 주문번호, 고객번호, 금액을 보이시오
select 
    orderid,
    saleprice
from orders
    where saleprice > (select avg(saleprice) from orders);



-- 질의 4-14 '대한민국'에 거주하는 고객에게 판매한 도서의 총판매액을 구하시오
select
    sum(saleprice)
from customer c
    inner join orders o
        on c.custid = o.custid
            where substr(address, 1, 4) = '대한민국';
 
 select
    sum(saleprice) as "total"
from orders
    where custid in (select custid from customer where address like '%대한민국%');
    -- **************************************************
    -- like 까먹었었다!
select custid from customer where address like '%대한민국%';



-- **************************************************
-- ALL 모든, SOME(ANY) 어떤(최소한 하나라도)
-- scalar_expression {비교연산자} {ALL|SOME|ANY} (부속질의)
-- ex) 금액 > some(select 단가 from 상품) : 금액이 상품 테이블에 있는 어떠한 단가보다 큰 경우 참



-- 질의 4-15 3번 고객이 주문한 도서의 최고 금액보다 더 비싼 도서를 구입한 주문의 주문번호와 금액
select
    custid,
    saleprice
from orders
    where saleprice > (select max(saleprice) from orders where custid = '3');
    
select * from orders;
select max(saleprice) from orders where custid = '3';

select
    custid,
    saleprice
from orders
    where saleprice > ALL (select saleprice from orders where custid = '3');
-- ALL을 사용하니까 max 사용할 필요가 없구나



-- **************************************************
-- where [not] EXISTS (부속질의)
-- exists 연산자는 다른 연산자와 달리 왼쪽에 스칼라값이나 열을 명시하지 않는다.
-- 반드시 부속질의에 주 질의의 열이름이 제공되어야한다. ???



-- 질의 4-16 exists 연산자를 사용하여 '대한민국'에 거주하는 고객에게 판매한 도서의 총판매액
select
    sum(saleprice)
from orders o
    inner join customer c
        on o.custid = c.custid
            where exists (select * from customer where address like '%대한민국%');
-- 118000   
-- **************************************************
-- 이 쿼리에서 틀린점이 뭐지?,,,

select
    sum(saleprice)
from orders o
    inner join customer c
        on o.custid = c.custid
            where c.custid in (select custid from customer where address like '%대한민국%');
-- 46000

select
    sum(saleprice)
from orders od
    where EXISTS (select * from customer cs where address like '%대한민국%' and cs.custid = od.custid);
-- 46000



-- 질의 4-17 마당서점의 고객별 판매액
select
    c.name,
    sum(saleprice)
from customer c
    inner join orders o
        on c.custid = o.custid
            group by c.name;

select 
    (select
        name
     from customer c
        where c.custid = o.custid) "name",
    sum(saleprice) "total"
from orders o
    group by o.custid;



-- 스칼라 부속질의는 select문과 함께 update문에서도 사용이 가능하다.
ALTER TABLE Orders ADD bookname varchar2(40);

UPDATE
    orders
SET
    bookname='피겨 교본'
where bookid = 1;

select * from orders;
select * from book;



-- **************************************************
-- 질의 4-18 orders 테이블에 각 주문에 맞는 도서이름을 입력
UPDATE
    orders
SET
    bookname = (select bookname from book where book.bookid=orders.bookid);


select * from orders;
select * from book;



-- 질의 4-19 고객번호가 2 이하인 고객의 판매액을 보이시오(고객이름과 고객별 판매액 출력)
select * from customer order by custid;
select rownum, a.* from (select * from customer order by custid) a where rownum <= 2;


select
    c.custid,
    sum(saleprice)
from customer c
    inner join orders o
        on c.custid = o.custid
            group by c.custid;

select
    a.*
from (select
    c.custid,
    sum(saleprice)
from customer c
    inner join orders o
        on c.custid = o.custid
            group by c.custid) a
                where rownum <= 2;
-- 고객이름...

            
select
    distinct(custid)
from customer
    order by custid;


select custid from (select
    distinct(custid)
from customer
    order by custid) where rownum <=2;
            
            
select
    c.custid,
    sum(saleprice)
from customer c
    inner join orders o
        on c.custid = o.custid
            where c.custid in (select custid from (select distinct(custid) from customer order by custid) where rownum <=2)
             group by c.custid;
-- 고객이름...


select 
    name,
    sum(saleprice)
from customer c
    inner join orders o
        on c.custid = o.custid
            where c.custid <= 2
                group by name;
-- 괜히 rownum 사용하려고 해서 복잡하게 고민했었음


select
    cs.name,
    sum(od.saleprice)
from (select custid, name from customer where custid <=2) cs, orders od
where cs.custid=od.custid
group by cs.name;



