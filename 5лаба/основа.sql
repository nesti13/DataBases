use UNIVER;
select FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME, PROFESSION.PROFESSION_NAME
from FACULTY, PULPIT, PROFESSION
where PULPIT.FACULTY = FACULTY.FACULTY and FACULTY.FACULTY=PROFESSION.FACULTY
and PROFESSION.PROFESSION_NAME in (select PROFESSION.PROFESSION_NAME
from PROFESSION where(PROFESSION.PROFESSION_NAME like '%����������%'
or PROFESSION.PROFESSION_NAME like '%����������%'))

use UNIVER;
select FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME, PROFESSION.PROFESSION_NAME
from FACULTY inner join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY, PROFESSION
where PULPIT.FACULTY = FACULTY.FACULTY and FACULTY.FACULTY=PROFESSION.FACULTY
and PROFESSION.PROFESSION_NAME in (select PROFESSION.PROFESSION_NAME
from PROFESSION where(PROFESSION.PROFESSION_NAME like '%����������%'
or PROFESSION.PROFESSION_NAME like '%����������%'))

use UNIVER;
select FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME, PROFESSION.PROFESSION_NAME
from FACULTY inner join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY inner join PROFESSION on PROFESSION.FACULTY=FACULTY.FACULTY
where (PROFESSION.PROFESSION_NAME like '%����������%' or PROFESSION.PROFESSION_NAME like '%����������%')

use UNIVER;
select a.AUDITORIUM_NAME [�������� ���������], a.AUDITORIUM_CAPACITY [�����������], a.AUDITORIUM_TYPE [���]
from AUDITORIUM as a
where AUDITORIUM_CAPACITY = (select top(1) aa.AUDITORIUM_CAPACITY
from AUDITORIUM as aa
where a.AUDITORIUM_TYPE=aa.AUDITORIUM_TYPE
order by AUDITORIUM_CAPACITY desc)

use UNIVER;
select FACULTY.FACULTY [���������]
from FACULTY
where not exists (select * from PULPIT where FACULTY.FACULTY=PULPIT.FACULTY)

use UNIVER;
select (select avg(PROGRESS.NOTE) from PROGRESS
where PROGRESS.SUBJECT like '����')[����],
(select avg(PROGRESS.NOTE) from PROGRESS
where PROGRESS.SUBJECT like '����')[����],
(select avg(PROGRESS.NOTE) from PROGRESS
where PROGRESS.SUBJECT like '��')[��]

use UNIVER;
select a.IDSTUDENT, a.NOTE
from PROGRESS as a
where a.NOTE >= all (select aa.NOTE from PROGRESS as aa where a.IDSTUDENT!=aa.IDSTUDENT)

use UNIVER;
select a.IDSTUDENT, a.NOTE
from PROGRESS as a
where a.NOTE > any (select aa.NOTE from PROGRESS as aa where a.IDSTUDENT!=aa.IDSTUDENT)