--1--
create view [�������������]
as select TEACHER [���],
TEACHER_NAME [��� �������������],
GENDER [���],
PULPIT [��� �������] 
from TEACHER
--2--
create view [���������� ������]
as select FACULTY.FACULTY [���������],
(select count(*) from PULPIT where FACULTY.FACULTY=PULPIT.FACULTY) [���������� ������]
from FACULTY
--3--
create view [���������]
as select AUDITORIUM [���],
AUDITORIUM_NAME [������������ ���������]
from AUDITORIUM 
where AUDITORIUM_TYPE like '��%';
go 
insert AUDITORIUM values (102-1, '��', 150, 102-1)

--select * from AUDITORIUM--
--4--
create view [����������_���������]
as select AUDITORIUM [���],
AUDITORIUM_NAME [������������ ���������]
from AUDITORIUM 
where AUDITORIUM_TYPE like '��%' with check option;
go 
insert AUDITORIUM values (115, '��', 90, 115)
--5--
create view [����������]
as select top 30 SUBJECT [���],
SUBJECT_NAME [�������������_����������],
PULPIT [��� �������]
from SUBJECT
order by SUBJECT_NAME;
--6--
alter view [���������� ������] with schemabinding
as select f.FACULTY [���������],
count (p.PULPIT) [���������� ������] from dbo.PULPIT p join dbo.FACULTY f
on p.FACULTY=f.FACULTY
group by f.FACULTY
