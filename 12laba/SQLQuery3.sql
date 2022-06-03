--1
create procedure PSUBJECT2 
as 
begin 
declare @K int= (select count(*) from SUBJECT);
select* from SUBJECT;
return @K;
end;

declare @C int=0;
EXEC @C=PSUBJECT2;
print 'кол-во товаров='+cast (@C as varchar(3));

--2
alter procedure PSUBJECT1 @p varchar(20), @c int output
as begin
declare @K int= (select count(*) from SUBJECT);
print 'параметры "р='+@p+',@c='+ cast(@c as varchar(4));
select* from SUBJECT where  SUBJECT = @p;
set @c=@@rowcount;
return @K;
end;

DECLARE @k1 int, @k2 nvarchar(2);
EXEC @k1 = PSUBJECT1 @p = 'СУБД', @c = @k2 output;
print 'Количество предметов: ' + @k2;
go

--3

alter procedure PSUBJECT @p varchar(20)
as begin
declare @K int= (select count(*) from SUBJECT);
select * from SUBJECT where SUBJECT=@p;
end;

create table #SUBJECT
(
Subject nvarchar(max),
Subject_name nvarchar(max),
Pulpit nvarchar(max)
)

INSERT #SUBJECT exec PSUBJECT @p='СУБД';

select* from #SUBJECT

--4
create procedure PAUDITORIUM_INSERT
@a char(20), @n varchar(50), @c int =0,@t char(10)
as begin
try
insert into AUDITORIUM( AUDITORIUM, AUDITORIUM_NAME,AUDITORIUM_CAPACITY,AUDITORIUM_TYPE)
values (@a,@n,@c,@t)
return 1
end try
begin catch
print 'номер ошибки:'+cast(error_number() as varchar(6));
print 'Номер ошибки: ' + cast(error_number() as varchar(6));
print 'Сообщение: ' + error_message();
print 'Уровень: ' + cast(error_severity() as varchar(6));
print 'Метка: ' + cast(error_state() as varchar(8));
print 'Номер строки: ' + cast(error_line() as varchar(8));
if error_procedure() is not null   
print 'Имя процедуры: ' + error_procedure();
return -1;
end catch;

DECLARE @rc int;  
EXEC @rc = PAUDITORIUM_INSERT @a = '433-3', @n = 'ЛК', @c = 100, @t = '420-3'; 
print 'Код ошибки: ' + cast(@rc as varchar(3));
go

--5
create procedure SUBJECT_REPORT @p char(10)
as 
declare @rc int =0;
begin try
declare @tv char(20), @t char(100)='';
declare SUBJECTs cursor for
select SUBJECT from SUBJECT where PULPIT=@p;
if not exists (select SUBJECT from SUBJECT where PULPIT=@p)
raiserror('ошибка', 11,1);
else
open SUBJECTs;
fetch SUBJECTs into @tv;
while @@FETCH_STATUS=0
begin
set @t=rtrim(@tv)+ ','+ @t;
set @rc =@rc+1;
fetch SUBJECTs into @tv;
end;
print @t;
close SUBJECTs;
return @rc;
end try
begin catch
print 'error'
if ERROR_PROCEDURE()is not null
print 'name procedure:'+error_procedure();
return @rc;
end catch;

declare @rc1 int;
exec @rc1=SUBJECT_REPORT @p='ИСиТ';
print 'количество товаров='+cast(@rc1 as varchar(3));

--6
CREATE procedure PAUDITORIUM_INSERTX
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10),
		@tn varchar(50)	--доп., для ввода в AUD_TYPEAUD_TYPENAME
as begin
DECLARE @rc int = 1;
begin try
	set transaction isolation level serializable;          
	begin tran
	INSERT into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
				values(@n, @tn);
	EXEC @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
	commit tran;
	return @rc;
end try
begin catch
	print 'Номер ошибки: ' + cast(error_number() as varchar(6));
	print 'Сообщение: ' + error_message();
	print 'Уровень: ' + cast(error_severity() as varchar(6));
	print 'Метка: ' + cast(error_state() as varchar(8));
	print 'Номер строки: ' + cast(error_line() as varchar(8));
	if error_procedure() is not  null   
	print 'Имя процедуры: ' + error_procedure(); 
	if @@trancount > 0 rollback tran ; 
	return -1;
end catch;
end;


DECLARE @k3 int;  
EXEC @k3 = PAUDITORIUM_INSERTX '622-3', @n = 'КГ', @c = 85, @t = '622-3', @tn = 'Комп. гласс'; 
print 'Код ошибки: ' + cast(@k3 as varchar(3));

delete AUDITORIUM where AUDITORIUM='622-3';  
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE='КГ';
go

drop procedure PAUDITORIUM_INSERTX;