--1--
create view [Преподаватель]
as select TEACHER [код],
TEACHER_NAME [имя преподавателя],
GENDER [пол],
PULPIT [код кафедры] 
from TEACHER
--2--
create view [количество кафедр]
as select FACULTY.FACULTY [факультет],
(select count(*) from PULPIT where FACULTY.FACULTY=PULPIT.FACULTY) [количество кафедр]
from FACULTY
--3--
create view [Аудитории]
as select AUDITORIUM [код],
AUDITORIUM_NAME [наименование аудитории]
from AUDITORIUM 
where AUDITORIUM_TYPE like 'ЛК%';
go 
insert AUDITORIUM values (102-1, 'ЛК', 150, 102-1)

--select * from AUDITORIUM--
--4--
create view [Лекционные_аудитории]
as select AUDITORIUM [код],
AUDITORIUM_NAME [наименование аудитории]
from AUDITORIUM 
where AUDITORIUM_TYPE like 'ЛК%' with check option;
go 
insert AUDITORIUM values (115, 'ЛК', 90, 115)
--5--
create view [Дисциплины]
as select top 30 SUBJECT [код],
SUBJECT_NAME [наименовнаиее_дисциплины],
PULPIT [код кафедры]
from SUBJECT
order by SUBJECT_NAME;
--6--
alter view [количество кафедр] with schemabinding
as select f.FACULTY [факультет],
count (p.PULPIT) [Количество кафедр] from dbo.PULPIT p join dbo.FACULTY f
on p.FACULTY=f.FACULTY
group by f.FACULTY
