use UNIVER;


--1-- 
set nocount on
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
	drop table TAB;           
declare @c int, @flag char = 'c'; -- ���� �->r, ������� �� ����

SET IMPLICIT_TRANSACTIONS ON -- ��� ����� ������� ����������
	create table TAB(K int );                   
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print '���-�� ����� � TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  -- �������� 
		else rollback;     -- �����                           
SET IMPLICIT_TRANSACTIONS OFF -- ��������� ����� ������������
if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print '������� TAB ����';  
else print '������� TAB ���'

--2-- 
USE UNIVER;
begin try        
	begin tran                 -- ������  ����� ����������
		insert FACULTY values ('��', '��������� ������ ����');
	    insert FACULTY values ('���', '��������� print-����������');
	commit tran;               -- �������� ����������
end try

begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then '������������ '	--������� 1-�� ���������
		else '����������� ������: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ��.����������� ��.>0,  ����� �� ��������� 	  
end catch;
 
DELETE FACULTY WHERE FACULTY = '��';
DELETE FACULTY WHERE FACULTY = '���';

select * from FACULTY;

--3-- 
declare @point varchar(32);

begin try
	begin tran                           
		set @point = 'p1'; 
		save tran @point;  -- ����������� ����� p1
		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values
		                      (20,'���������', '1997-08-02', NULL, NULL),
							  (20,'����������', '1997-08-06', NULL, NULL),
							  (20,'���������', '1997-08-01', NULL, NULL),
							  (20,'�����', '1997-08-03', NULL, NULL);    
		set @point = 'p2'; 
		save tran @point; -- ����������� ����� p2
		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values
							  (20, '��������� �������', '1997-08-02', NULL, NULL); 
	commit tran;                                              
end try

begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%STUDENT_PK%', error_message()) > 0 then '������������ ��������' 
		else '����������� ������: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- ���� ���������� �� ���������
	begin
	   print '����������� �����: '+ @point;
	   rollback tran @point; -- ����� � ��������� �����.�����
	   commit tran; -- �������� ���������, ������ �� �����.����� 
	end;     
end catch;

select * from STUDENT where IDGROUP=20; 
delete STUDENT where IDGROUP=20; 



--4--
--A--
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
	select @@SPID, 'insert FACULTY' '���������', *
		from FACULTY WHERE FACULTY = '��';
	select @@SPID, 'update PULPIT' '���������', *
		from PULPIT WHERE FACULTY = '��';
	commit;

-----t2---------
--B--

begin transaction
	select @@SPID
	insert FACULTY VALUES
		('��3','�������������� ����������');
	update PULPIT set FACULTY = '��' WHERE PULPIT = '����'

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
where FACULTY = '��'; 

-----t1-------
-----t2-------

select 'update PULPIT' '���������', count(*) 
from PULPIT where FACULTY = '��'; --�������� ��������������� ������
commit;
------B----

begin transaction

------t1-----

update PULPIT set FACULTY = '��' where PULPIT = '����';
commit;

------t2------

--6--
set transaction isolation level  REPEATABLE READ 
begin transaction 
select PULPIT from PULPIT where FACULTY = '��';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
select  case
when PULPIT = '��' then 'insert  PULPIT'  else ' ' 
end '���������', PULPIT from PULPIT  where FACULTY = '��';
commit; 
	--- B ---	
begin transaction 	  
	-------------------------- t1 --------------------
insert PULPIT values ('�����', '��������������� �����������',  '����');
commit; 
select * from PULPIT
	-------------------------- t2 --------------------

--7--
-- A ---
set transaction isolation level SERIALIZABLE 
begin transaction 

insert PULPIT values ('��', '������������ �������',  '��');
commit; 
update PULPIT set PULPIT = '��' where FACULTY = '��';
select PULPIT from PULPIT where FACULTY = '��';
	-------------------------- t1 -----------------
select PULPIT from PULPIT where FACULTY = '��';
	-------------------------- t2 ------------------ 
commit; 	

	--- B ---	
begin transaction 	   
insert PULPIT values ('��', '������������ �����������',  '��');
update PULPIT set PULPIT = '��' where FACULTY = '��';
select PULPIT from PULPIT where FACULTY = '��';
          -------------------------- t1 --------------------
commit; 
select PULPIT from PULPIT where FACULTY = '��';
      -------------------------- t2 --------------------
	  select * from PULPIT

--8--
select (select count(*) from dbo.PULPIT where FACULTY = '����') '������� �����', 
(select count(*) from FACULTY where FACULTY.FACULTY = '����') '����'; 

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='������� �����' where PULPIT.FACULTY = '����';
	commit;
if @@TRANCOUNT > 0 rollback;

--9--
use UNIVER;


--1-- 
set nocount on
	if  exists (select * from  SYS.OBJECTS        -- ������� X ����?
	            where OBJECT_ID= object_id(N'DBO.X') )	            
	drop table X;           
	declare @cc int, @flagg char = 'c';           -- commit ��� rollback?
	SET IMPLICIT_TRANSACTIONS  ON   -- �����. ����� ������� ����������
	CREATE table X(K int );                         -- ������ ���������� 
		INSERT X values (1),(2),(3);
		set @cc = (select count(*) from X);
		print '���������� ����� � ������� X: ' + cast( @cc as varchar(2));
		if @flagg = 'c'  commit;                   -- ���������� ����������: �������� 
	          else   rollback;                                 -- ���������� ����������: �����  
      SET IMPLICIT_TRANSACTIONS  OFF   -- ������. ����� ������� ����������
	
	if  exists (select * from  SYS.OBJECTS       -- ������� X ����?
	            where OBJECT_ID= object_id(N'DBO.X') )
	print '������� X ����';  
      else print '������� X ���'

--2-- 
use SALES;
begin try        
	begin tran                 -- ������  ����� ����������
		--delete GOODS where Name_of_product = 'Chair';
		insert GOODS values ('Tables', 153, 201);
	    insert GOODS values ('TVs', 35, 12);
	commit tran;               -- �������� ����������
end try
begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%Name_of_product_PK%', error_message()) > 0 then '������������ '	--������� 1-�� ���������
		else '����������� ������: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ��.����������� ��.>0,  ����� �� ��������� 	  
end catch;

select * from GOODS;

--3-- 
declare @point2 varchar(32);

begin try
	begin tran                           
		set @point2 = 'p1'; 
		save tran @point2;  -- ����������� ����� p1
		insert GOODS values ('chairss', 15, 20);    
		set @point2 = 'p2'; 
		save tran @point2; -- ����������� ����� p2
		insert GOODS values ('tvss', 22, 50);    
	commit tran;                                              
end try

begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%PK_GOODS%', error_message()) > 0 then '������������ ��������' 
		else '����������� ������: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- ���� ���������� �� ���������
	begin
	   print '����������� �����: '+ @point2;
	   rollback tran @point2; -- ����� � ��������� �����.�����
	   commit tran; -- �������� ���������, ������ �� �����.����� 
	end;     
end catch;




--4--
use SALES;
--A--
set transaction isolation level READ UNCOMMITTED 
	begin transaction 
	-------------------------- t1 ------------------
	select @@SPID, 'insert ������' '���������', * from GOODS where Name_of_product = 'Sofa';
	select @@SPID, 'update ������'  '���������',  Product_name, 
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
	select  'update ������'  '���������', count(*)
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
          when Customer = 'IBA' then 'insert  ������'  else ' ' 
end '���������', Customer from Orders  where Product_name = 'Chair';
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
select (select count(*) from dbo.Orders where Customer = 'ABA') '������', 
(select count(*) from Customer where  Company_Name = 'ABA') '���������'; 

begin tran
insert Customer values ('IBAA', 'Minsk', 10234);
	begin tran
	update Orders set Product_name = 'Chair' where Customer = 'IBA';
	commit;
if @@TRANCOUNT > 0 rollback;

