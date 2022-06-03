use UNIVER;
--1--
DECLARE @c char ='a',
		@v varchar(4)='БГТУ',
		@d datetime,
		@t time,
		@i int,			--без иниц
		@s smallint,
		@ti tinyint,
		@n numeric(12,5);
SET @d=GETDATE();
SELECT @t='12:59:34.21';
SELECT @c c, @v v, @d d, @t t;
SELECT @s=345, @ti=1, @n=1234567.12345;
print 's='+cast(@s as varchar(10));
print 'ti='+cast(@ti as varchar(10));
print 'n='+cast(@n as varchar(13));

--2--
DECLARE @var1 int 
DECLARE @var2 int 
DECLARE @var3 int 
DECLARE @var4 int 
SELECT @var1 = SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM 
select @var1 'Общая вместимость аудиторий'
if @var1 > 200 
begin 
	select	@var2 = (select COUNT(*) from AUDITORIUM), 
			@var3 = (select AVG(AUDITORIUM_CAPACITY) FROM AUDITORIUM) 
	set		@var4 = (select COUNT(*) from AUDITORIUM where AUDITORIUM_CAPACITY < @var3) 
	select @var2 'Кол-во ауд.', @var3 'Средняя вмест',
			@var4 'Кол-во ауд.< AVR',			
			100*(cast(@var4 as float)/cast(@var2 as float)) '% ауд.< AVR'			
end 
else print 'Общая вместимость аудиторий' + @var1;

--3--
print '@@ROWCOUNT число обраб. строк ' + cast(@@ROWCOUNT as nvarchar(10));
print '@@VERSION версия SQL Server ' + cast(@@VERSION as nvarchar(10));
print '@@SPID системный иден. процесса ' + cast(@@SPID as nvarchar(10));
print '@@ERROR код последней ошибки ' + cast(@@ERROR as nvarchar(10));
print '@@SERVERNAME имя сервера ' + cast(@@SERVERNAME as nvarchar(10));
print '@@TRANCOUNT уровень вложенности транзакций ' + cast(@@TRANCOUNT as nvarchar(10));
print '@@FETCH_STATUS проверка рез-та счит. строк рез.набора ' + cast(@@FETCH_STATUS as nvarchar(10));
print '@@NESTLEVEL ур. влож-сти тек. процедуры ' + cast(@@NESTLEVEL as nvarchar(10));
		
--4--
declare @tt int=3, @x float=4, @z float;
if (@tt>@x) set @z=power(SIN(@tt),2);
if (@tt<@x) set @z=4*(@tt+@x);
if (@tt=@x) set @z=1-exp(@x-2);
select 'z='+cast(@z as varchar(10));

declare @ss varchar(100)=(select top 1 NAME from STUDENT)
select substring(@ss, 1, charindex(' ', @ss))
		+substring(@ss, charindex(' ', @ss)+1,1)+'.'
		+substring(@ss, charindex(' ', @ss, charindex(' ', @ss)+1)+1,1)+'.'

select NAME as 'Имя', 2022-YEAR(BDAY) as 'Возраст'		
	from STUDENT
	where MONTH(BDAY)=MONTH(getdate())+1;

DECLARE @group_number INT = 4;

SELECT TOP(1) DATENAME(WEEKDAY, PDATE) AS "WEEKDAY"
FROM PROGRESS
JOIN STUDENT ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
JOIN GROUPS ON STUDENT.IDGROUP = GROUPS.IDGROUP
WHERE GROUPS.IDGROUP = @group_number;

--5--
use SALES;
declare @xx int = (select count(*) from Orders);
if (select count(*) from Orders) > 20
begin
print 'Quantity > 20';
print 'Quantity=' + cast(@xx as varchar(10));
end;
begin
print 'Quantity < 20';
print 'Quantity=' + cast(@xx as varchar(10));
end;

--6--
use UNIVER;
declare @faculty_name nvarchar(10) = 'ХТиТ';
select case
when NOTE between 0 and 3 then 'very bad'
when NOTE between 4 and 6 then 'not bad'
when NOTE between 7 and 8 then 'good'
else 'very good'
end NOTE, count(*) [Кол-во]
from PROGRESS
join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
where FACULTY = @faculty_name
group by case
when NOTE between 0 and 3 then 'very bad'
when NOTE between 4 and 6 then 'not bad'
when NOTE between 7 and 8 then 'good'
else 'very good'
end

--7-- 
CREATE table #PEOPLE
(	age int,
	name varchar(50),
	fav_num int
);
SET nocount on;	--не вывод сообщения о вводе строк
declare @ii int=0;
while @ii<10
	begin
	insert #PEOPLE(age, name, fav_num)
			values (floor(24*RAND()), 'Julie', floor(100*RAND()));
	set @ii=@ii+1;
	end;
select * from #PEOPLE;
drop table #PEOPLE;

--8--
declare @ff int=1;
print @ff+1
print @ff+2
RETURN
print @ff+3

--9--
begin TRY
	update PROGRESS set NOTE='5'	
			where NOTE='6'
end TRY
begin CATCH
	print ERROR_NUMBER()	--код последней ошибки
	print ERROR_MESSAGE()	--сообщение об ошибке
	print ERROR_LINE()		--код последней ошибки
	print ERROR_PROCEDURE()	--имя процедуры или NULL
	print ERROR_SEVERITY()	--уровень серьезности ошибки
	print ERROR_STATE()		--метка ошибки
end CATCH
