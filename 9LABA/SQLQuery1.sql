--1--
use UNIVER;
exec SP_HELPINDEX 'AUDITORIUM_TYPE'
exec SP_HELPINDEX 'AUDITORIUM'
exec SP_HELPINDEX 'FACULTY'
exec SP_HELPINDEX 'GROUPS'
exec SP_HELPINDEX 'PROFESSION'
exec SP_HELPINDEX 'PROGRESS'
exec SP_HELPINDEX 'PULPIT'
exec SP_HELPINDEX 'STUDENT'
exec SP_HELPINDEX 'SUBJECT'
exec SP_HELPINDEX 'TEACHER'

create table #temp_table
(	some_ind int, 
	some_field varchar(20)
)
SET nocount on;		--не вывод сообщения о вводе строк
DECLARE @i int = 0;
while @i < 1000
	begin
		insert #temp_table(some_ind, some_field)
			values(FLOOR(RAND()*10000), REPLICATE('STRING',3));
		SET @i = @i + 1; 
	end

select * from #temp_table where some_ind between 1500 and 5000 order by some_ind 
	checkpoint;				--фиксация БД
	DBCC DROPCLEANBUFFERS;	--очистить буферный кэш
CREATE clustered index #temp_table_cl on #temp_table(some_ind asc)
drop table #temp_table

--2--
create table #temp_table_1
(
	some_ind int, 
	some_field varchar(20),
	cc int identity(1,1)	
)
SET nocount on;
DECLARE @j int = 0;
while @j < 1000
begin
	insert #temp_table_1(some_ind, some_field)
		values(FLOOR(RAND()*10000), 'str' + cast(@j as nvarchar(1000)) );
	SET @j = @j + 1; 
end

select * from #temp_table_1 where cc >500 and some_ind between 1500 and 5000 

SELECT count(*)[количество строк] from #temp_table_1;
SELECT * from #temp_table_1
CREATE index #temp_table_1_nonclu on #temp_table_1(some_ind, CC)
--drop table #temp_table_1--

--3--
create table #temp_table_2
(
	some_ind int, 
	some_field varchar(20),
	cc int identity(1,1)
)
SET nocount on;
DECLARE @k int = 0;
while @k < 1000
begin
	insert #temp_table_2(some_ind, some_field)
		values(FLOOR(RAND()*30000), REPLICATE('julia',3) );
	SET @k = @k + 1; 
end

select * from #temp_table_2 where cc >500 and some_ind between 1500 and 5000 
CREATE index #temp_table_2_nonclu_2 on #temp_table_2(some_ind) INCLUDE(cc)
select CC from #temp_table_2 where some_ind > 1500
--drop table #temp_table_2

--4--
SELECT some_ind from  #temp_table_2 where some_ind between 5000 and 19999; 
SELECT some_ind from  #temp_table_2 where some_ind>15000 and  some_ind < 20000  
SELECT some_ind from  #temp_table_2 where some_ind=17000

 CREATE  index #temp_table_WHERE on #temp_table_2(some_ind) where (some_ind>=15000 and 
 some_ind  < 20000);
 drop index #temp_table_WHERE on #temp_table_2

 --5--

CREATE index #temp_table_2_ind  on #temp_table_2(some_ind);
SELECT	name [Индекс],
		avg_fragmentation_in_percent [Фрагментация(%)] 
	FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), 
  OBJECT_ID(N'#temp_table_2'), NULL, NULL, NULL) AS ss
  JOIN sys.indexes AS ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
  where name is not null;

INSERT top(10000) #temp_table_2(some_ind, some_field) select some_ind, some_field from #temp_table_2;

ALTER index #temp_table_2_ind on #temp_table_2 reorganize; 
ALTER index #temp_table_2_ind  on #temp_table_2 rebuild with (online = off);

drop index #temp_table_2_ind on #temp_table_2

--6--
CREATE index #temp_table_3_ind1  on #temp_table_2(some_ind)with (fillfactor = 65);

INSERT top(50)percent into #temp_table_2(some_ind, some_field) select some_ind, some_field  from #temp_table_2; 
use tempdb
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация(%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'#temp_table_2'), NULL, NULL, NULL) ss
       JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
       where name is not null;

drop index #temp_table_3_ind1 on #temp_table_2


--7.1--
use SALES;
exec SP_HELPINDEX 'Customer'
exec SP_HELPINDEX 'GOODS'
exec SP_HELPINDEX 'Orders'

create table #temp_table
(	some_ind int, 
	some_field varchar(20)
)
SET nocount on;		--не вывод сообщения о вводе строк
DECLARE @ii int = 0;
while @ii < 1000
	begin
		insert #temp_table(some_ind, some_field)
			values(FLOOR(RAND()*10000), REPLICATE('STRING',3));
		SET @ii = @ii + 1; 
	end

select * from #temp_table where some_ind between 1500 and 5000 order by some_ind 
	checkpoint;				--фиксация БД
	DBCC DROPCLEANBUFFERS;	--очистить буферный кэш
CREATE clustered index #temp_table_cl on #temp_table(some_ind asc)
drop table #temp_table

--2.1--
create table #temp_table_11
(
	some_ind int, 
	some_field varchar(20),
	cc int identity(1,1)	
)
SET nocount on;
DECLARE @jj int = 0;
while @jj < 1000
begin
	insert #temp_table_11(some_ind, some_field)
		values(FLOOR(RAND()*10000), 'str' + cast(@jj as nvarchar(1000)) );
	SET @jj = @jj + 1; 
end

select * from #temp_table_11 where cc >500 and some_ind between 1500 and 5000 

SELECT count(*)[количество строк] from #temp_table_11;
SELECT * from #temp_table_11
CREATE index #temp_table_11_nonclu on #temp_table_11(some_ind, CC)
--drop table #temp_table_11--

--3.1--
create table #temp_table_22
(
	some_ind int, 
	some_field varchar(20),
	cc int identity(1,1)
)
SET nocount on;
DECLARE @kk int = 0;
while @kk < 1000
begin
	insert #temp_table_22(some_ind, some_field)
		values(FLOOR(RAND()*30000), REPLICATE('julia',3) );
	SET @kk = @kk + 1; 
end

select * from #temp_table_22 where cc >500 and some_ind between 1500 and 5000 
CREATE index #temp_table_2_nonclu_22 on #temp_table_22(some_ind) INCLUDE(cc)
select CC from #temp_table_22 where some_ind > 1500
--drop table #temp_table_2

--4.1--
SELECT some_ind from  #temp_table_22 where some_ind between 5000 and 19999; 
SELECT some_ind from  #temp_table_22 where some_ind>15000 and  some_ind < 20000  
SELECT some_ind from  #temp_table_22 where some_ind=17000

 CREATE  index #temp_table_WHERE2 on #temp_table_22(some_ind) where (some_ind>=15000 and 
 some_ind  < 20000);
 drop index #temp_table_WHERE2 on #temp_table_22

 --5.1--

CREATE index #temp_table_22_ind  on #temp_table_22(some_ind);
SELECT	name [Индекс],
		avg_fragmentation_in_percent [Фрагментация(%)] 
	FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), 
  OBJECT_ID(N'#temp_table_22'), NULL, NULL, NULL) AS ss
  JOIN sys.indexes AS ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
  where name is not null;

INSERT top(10000) #temp_table_2(some_ind, some_field) select some_ind, some_field from #temp_table_2;

ALTER index #temp_table_22_ind on #temp_table_22 reorganize; 
ALTER index #temp_table_22_ind  on #temp_table_22 rebuild with (online = off);

drop index #temp_table_22_ind on #temp_table_22

--6.1--
CREATE index #temp_table_33_ind1  on #temp_table_2(some_ind)with (fillfactor = 65);

INSERT top(50)percent into #temp_table_2(some_ind, some_field) select some_ind, some_field  from #temp_table_2; 
use tempdb
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация(%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'#temp_table_2'), NULL, NULL, NULL) ss
       JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
       where name is not null;

drop index #temp_table_3_ind1 on #temp_table_2