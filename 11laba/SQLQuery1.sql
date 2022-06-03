use UNIVER;


--1-- 
set nocount on
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
	drop table TAB;           
declare @c int, @flag char = 'c'; -- если с->r, таблица не сохр

SET IMPLICIT_TRANSACTIONS ON -- вкл режим неявной транзакции
	create table TAB(K int );                   
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print 'кол-во строк в TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  -- фиксация 
		else rollback;     -- откат                           
SET IMPLICIT_TRANSACTIONS OFF -- действует режим автофиксации
if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print 'таблица TAB есть';  
else print 'таблицы TAB нет'

--2-- 
USE UNIVER;
begin try        
	begin tran                 -- начало  явной транзакции
		insert FACULTY values ('ДФ', 'Факультет других наук');
	    insert FACULTY values ('ПиМ', 'Факультет print-технологий');
	commit tran;               -- фиксация транзакции
end try

begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then 'дублирование '	--позиция 1-го вхождения
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ур.вложенности тр.>0,  транз не завершена 	  
end catch;
 
DELETE FACULTY WHERE FACULTY = 'ДФ';
DELETE FACULTY WHERE FACULTY = 'ПиМ';

select * from FACULTY;

--3-- 
declare @point varchar(32);

begin try
	begin tran                           
		set @point = 'p1'; 
		save tran @point;  -- контрольная точка p1
		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values
		                      (20,'Екатерина', '1997-08-02', NULL, NULL),
							  (20,'Александра', '1997-08-06', NULL, NULL),
							  (20,'Елизавета', '1997-08-01', NULL, NULL),
							  (20,'Ольга', '1997-08-03', NULL, NULL);    
		set @point = 'p2'; 
		save tran @point; -- контрольная точка p2
		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values
							  (20, 'Особенный Студент', '1997-08-02', NULL, NULL); 
	commit tran;                                              
end try

begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%STUDENT_PK%', error_message()) > 0 then 'дублирование студента' 
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- если транзакция не завершена
	begin
	   print 'контрольная точка: '+ @point;
	   rollback tran @point; -- откат к последней контр.точке
	   commit tran; -- фиксация изменений, выполн до контр.точки 
	end;     
end catch;

select * from STUDENT where IDGROUP=20; 
delete STUDENT where IDGROUP=20; 



--4--
--A--
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
	select @@SPID, 'insert FACULTY' 'результат', *
		from FACULTY WHERE FACULTY = 'ИТ';
	select @@SPID, 'update PULPIT' 'результат', *
		from PULPIT WHERE FACULTY = 'ИТ';
	commit;

-----t2---------
--B--

begin transaction
	select @@SPID
	insert FACULTY VALUES
		('ИТ3','Информационных технологий');
	update PULPIT set FACULTY = 'ИТ' WHERE PULPIT = 'ИСиТ'

-----t1----------
-----t2----------

ROLLBACK;
SELECT * FROM FACULTY;
SELECT * FROM PULPIT;

--5--
-----A--------
SELECT * from PULPIT;
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT
where FACULTY = 'ИТ'; 

-----t1-------
-----t2-------

select 'update PULPIT' 'результат', count(*) 
from PULPIT where FACULTY = 'ИТ'; --работает неповторяющееся чтение
commit;
------B----

begin transaction

------t1-----

update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ИСиТ';
commit;

------t2------

--6--
set transaction isolation level  REPEATABLE READ 
begin transaction 
select PULPIT from PULPIT where FACULTY = 'ИТ';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
select  case
when PULPIT = 'ЛВ' then 'insert  PULPIT'  else ' ' 
end 'результат', PULPIT from PULPIT  where FACULTY = 'ИТ';
commit; 
	--- B ---	
begin transaction 	  
	-------------------------- t1 --------------------
insert PULPIT values ('пратв', 'Полиграфических производств',  'ИДИП');
commit; 
select * from PULPIT
	-------------------------- t2 --------------------

--7--
-- A ---
set transaction isolation level SERIALIZABLE 
begin transaction 

insert PULPIT values ('КГ', 'Компьютерная графика',  'ИТ');
commit; 
update PULPIT set PULPIT = 'КГ' where FACULTY = 'ИТ';
select PULPIT from PULPIT where FACULTY = 'ИТ';
	-------------------------- t1 -----------------
select PULPIT from PULPIT where FACULTY = 'ИТ';
	-------------------------- t2 ------------------ 
commit; 	

	--- B ---	
begin transaction 	   
insert PULPIT values ('КБ', 'компьютерная безопсность',  'ИТ');
update PULPIT set PULPIT = 'КБ' where FACULTY = 'ИТ';
select PULPIT from PULPIT where FACULTY = 'ИТ';
          -------------------------- t1 --------------------
commit; 
select PULPIT from PULPIT where FACULTY = 'ИТ';
      -------------------------- t2 --------------------
	  select * from PULPIT

--8--
select (select count(*) from dbo.PULPIT where FACULTY = 'ИДиП') 'Кафедры ИДИПа', 
(select count(*) from FACULTY where FACULTY.FACULTY = 'ИДиП') 'ИДИП'; 

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='Кафедра ИДиПа' where PULPIT.FACULTY = 'ИДиП';
	commit;
if @@TRANCOUNT > 0 rollback;

--9--
use UNIVER;


--1-- 
set nocount on
	if  exists (select * from  SYS.OBJECTS        -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.X') )	            
	drop table X;           
	declare @cc int, @flagg char = 'c';           -- commit или rollback?
	SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
	CREATE table X(K int );                         -- начало транзакции 
		INSERT X values (1),(2),(3);
		set @cc = (select count(*) from X);
		print 'количество строк в таблице X: ' + cast( @cc as varchar(2));
		if @flagg = 'c'  commit;                   -- завершение транзакции: фиксация 
	          else   rollback;                                 -- завершение транзакции: откат  
      SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции
	
	if  exists (select * from  SYS.OBJECTS       -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.X') )
	print 'таблица X есть';  
      else print 'таблицы X нет'

--2-- 
use SALES;
begin try        
	begin tran                 -- начало  явной транзакции
		--delete GOODS where Name_of_product = 'Chair';
		insert GOODS values ('Tables', 153, 201);
	    insert GOODS values ('TVs', 35, 12);
	commit tran;               -- фиксация транзакции
end try
begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%Name_of_product_PK%', error_message()) > 0 then 'дублирование '	--позиция 1-го вхождения
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ур.вложенности тр.>0,  транз не завершена 	  
end catch;

select * from GOODS;

--3-- 
declare @point2 varchar(32);

begin try
	begin tran                           
		set @point2 = 'p1'; 
		save tran @point2;  -- контрольная точка p1
		insert GOODS values ('chairss', 15, 20);    
		set @point2 = 'p2'; 
		save tran @point2; -- контрольная точка p2
		insert GOODS values ('tvss', 22, 50);    
	commit tran;                                              
end try

begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%PK_GOODS%', error_message()) > 0 then 'дублирование студента' 
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- если транзакция не завершена
	begin
	   print 'контрольная точка: '+ @point2;
	   rollback tran @point2; -- откат к последней контр.точке
	   commit tran; -- фиксация изменений, выполн до контр.точки 
	end;     
end catch;




--4--
use SALES;
--A--
set transaction isolation level READ UNCOMMITTED 
	begin transaction 
	-------------------------- t1 ------------------
	select @@SPID, 'insert Товары' 'результат', * from GOODS where Name_of_product = 'Sofa';
	select @@SPID, 'update Заказы'  'результат',  Product_name, 
                      Selling_price from Orders where Product_name = 'Sofa';
	commit; 
	-------------------------- t2 -----------------
	--- B --	
	begin transaction 
	select @@SPID
	insert Goods values ('Sofass', 2, 80); 
	update Orders set Product_name  =  'NoteBooks' 
                           where Product_name = 'Chair' 
	-------------------------- t1 --------------------
	-------------------------- t2 --------------------
	rollback;
	select * from GOODS;

--5--
-----A--------
set transaction isolation level READ COMMITTED 
	begin transaction 
	select count(*) from Orders where Product_name = 'Chair';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  'update Заказы'  'результат', count(*)
	                           from Orders where Product_name = 'Chair';
	commit; 

	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
          update Orders set Product_name = 'Chair' 
                                       where Product_name = 'Table' 
          commit; 
	-------------------------- t2 --------------------	

--6--
set transaction isolation level  REPEATABLE READ 
	begin transaction 
	select Customer from Orders where Product_name = 'Chair';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  case
          when Customer = 'IBA' then 'insert  Заказы'  else ' ' 
end 'результат', Customer from Orders  where Product_name = 'Chair';
	commit; 

	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
          insert Orders values (12,  'Chair',  78,  10,  '01.12.2014',  'IBA');
          commit; 
	-------------------------- t2 --------------------

--7--
-- A ---
          set transaction isolation level SERIALIZABLE 
	begin transaction 
	delete Orders where Customer = 'ABA';  
          insert Orders values (9, 'Chair', 71,  8,  '01.12.2014', 'ABA');
          update Orders set Customer = 'ABA' where Product_name = 'Chair';
          select  Customer from Orders  where Product_name = 'Chair';
	-------------------------- t1 -----------------
	select  Customer from Orders  where Product_name = 'Chair';
	-------------------------- t2 ------------------ 
	commit; 	

	--- B ---	
	begin transaction 	  
	delete Orders where Customer = 'ABA';  
          insert Orders values (9, 'Chair', 71,  8,  '01.12.2014', 'ABA');
          update Orders set Customer = 'ABA' where Product_name = 'Chair';
          select  Customer from Orders  where Product_name = 'Chair';
          -------------------------- t1 --------------------
          commit; 
          select  Customer from Orders  where Product_name = 'Chair';
      -------------------------- t2 --------------------


--8--
select (select count(*) from dbo.Orders where Customer = 'ABA') 'Заказы', 
(select count(*) from Customer where  Company_Name = 'ABA') 'Заказчики'; 

begin tran
insert Customer values ('IBAA', 'Minsk', 10234);
	begin tran
	update Orders set Product_name = 'Chair' where Customer = 'IBA';
	commit;
if @@TRANCOUNT > 0 rollback;

