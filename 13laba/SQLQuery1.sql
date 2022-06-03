use UNIVER;
--1--
go
create function COUNT_STUDENTS(@faculty nvarchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (
SELECT count(IDSTUDENT) from STUDENT join GROUPS
    on STUDENT.IDGROUP = GROUPS.IDGROUP
	join FACULTY
	    on GROUPS.FACULTY = FACULTY.FACULTY
		    where FACULTY.FACULTY = @faculty);
return @rc;
end; 
go
declare @n int = dbo.COUNT_STUDENTS('ИДиП');
print 'Количество студентов: ' + cast(@n as varchar(4));

--2--
go
create function FSUBJECTS(@p varchar(20)) returns varchar(300)
as begin
declare @sb varchar(10), @s varchar(100) = '';
declare sbj cursor local static
    for select distinct SUBJECT from SUBJECT 
	    where PULPIT like @p;
open sbj;
fetch sbj into @sb;
while @@FETCH_STATUS = 0
begin
	set @s = @s + RTRIM(@sb) + ', ';
	fetch sbj into @sb;
end;
return @s
end;

go 
select distinct PULPIT, dbo.FSUBJECTS(PULPIT)[Дисциплины] from SUBJECT;

--3--
go
create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY left outer join PULPIT
  on FACULTY.FACULTY = PULPIT.FACULTY
   where FACULTY.FACULTY = ISNULL(@f, FACULTY.FACULTY) and --первое значение, не равное null
    PULPIT.PULPIT = ISNULL(@p, PULPIT.PULPIT);

go
select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL('ИДиП', null);
select * from dbo.FFACPUL(null, 'ИСиТ');
select * from dbo.FFACPUL('ИДиП', 'ИСиТ');

--4--
go
create function FCTEACHER(@p varchar(20)) returns int
as begin
declare @rc int = (select count(TEACHER) from TEACHER where PULPIT = ISNULL(@p, PULPIT));
return @rc;
end;

go 
select PULPIT, dbo.FCTEACHER(PULPIT)[Количество преподавателей] from TEACHER;
select dbo.FCTEACHER(null)[Общее количество преподавателей];

--5--
--1--
use SALES
go
create function COUNT_Zakazy(@f varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(Order_number) from Orders z join Customer zk
on z.Customer = zk.Company_Name
where Company_Name = @f);
return @rc;
end;
go
declare @f int = dbo.COUNT_Zakazy('IBA');
print 'Количество заказов= ' + cast(@f as varchar(4));

--2--
go
create FUNCTION FZakazy(@tz char(20)) returns char(300) 
as
begin  
declare @tv char(20);  
declare @t varchar(300) = 'Заказанные товары: ';  
declare ZkTovar CURSOR LOCAL 
for select Product_name from Orders 
where Customer = @tz;
open ZkTovar;	  
fetch  ZkTovar into @tv;   	 
while @@fetch_status = 0                                     
begin 
set @t = @t + ', ' + rtrim(@tv);         
FETCH  ZkTovar into @tv; 
end;    
return @t;
end;  
go
select Company_Name,  dbo.FZakazy (Company_Name)  from Customer;

--3--
go 
create function FTovCena(@f varchar(50), @p real) returns table
as return
select f.Name_of_product, f.Price, p.Selling_price
from GOODS f left outer join Orders p
on f.Name_of_product = p.Product_name
where f.Name_of_product=isnull(@f, f.Name_of_product)
and
p.Selling_price = isnull(@p, p.Selling_price);

select * from dbo.FTovCena(NULL, NULL);
select * from dbo.FTovCena('Chair', NULL);
select * from dbo.FTovCena(NULL, 400);
select * from dbo.FTovCena('Table', 340);

--4--
go
create function FKolTov(@p varchar(50)) returns int
as
begin
declare @rc int=(select count(*) from Orders
where Customer=isnull(@p, Customer));
return @rc;
end;
go 
select Customer, dbo.FKolTov(Customer) [Количсетво заказов] from Orders
select dbo.FKolTov(null) [всего заказов]
