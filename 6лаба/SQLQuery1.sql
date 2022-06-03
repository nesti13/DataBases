use UNIVER;
Select max(AUDITORIUM_CAPACITY) [������������ �����������],
min(AUDITORIUM_CAPACITY) [����������� �����������],
AVG(AUDITORIUM_CAPACITY) [������� ����������],
sum(AUDITORIUM_CAPACITY) [��������� ����������� ���� ���������],
count(AUDITORIUM) [����� ���-�� ���������]
from AUDITORIUM

use UNIVER;
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [�������� ���� ���������],
max(AUDITORIUM_CAPACITY) [������������ �����������],
min(AUDITORIUM_CAPACITY) [����������� �����������],
AVG(AUDITORIUM_CAPACITY) [������� ����������],
sum(AUDITORIUM_CAPACITY) [��������� ����������� ���� ���������],
count(AUDITORIUM) [����� ���-�� ���������]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE
group by AUDITORIUM_TYPENAME

use UNIVER;
select *
from (select case when NOTE between 4 and 5 then '4-5'
when NOTE between 6 and 7 then '6-7'
when NOTE between 8 and 9 then '8-9'
else '10'
end [������], count(*) [����������]
from PROGRESS group by case when NOTE between 4 and 5 then '4-5'
when NOTE between 6 and 7 then '6-7'
when NOTE between 8 and 9 then '8-9'
else '10' end) as T
order by case [������]
when '4-5' then 3
when '6-7' then 2
when '8-9' then 1
else 0
end

use UNIVER;
select FACULTY.FACULTY [���������],
GROUPS.PROFESSION [�������������],
case
when GROUPS.YEAR_FIRST = 2010 then '4'
when GROUPS.YEAR_FIRST = 2011 then '3'
when GROUPS.YEAR_FIRST = 2012 then '2'
when GROUPS.YEAR_FIRST = 2013 then '1'
end [����],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
from FACULTY inner join GROUPS ON FACULTY.FACULTY=GROUPS.FACULTY
inner join STUDENT ON GROUPS.IDGROUP=STUDENT.IDGROUP
inner join PROGRESS ON STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
order by [������� ������] desc

use UNIVER;
select FACULTY.FACULTY [���������],
GROUPS.PROFESSION [�������������],
case
when GROUPS.YEAR_FIRST = 2010 then '4'
when GROUPS.YEAR_FIRST = 2011 then '3'
when GROUPS.YEAR_FIRST = 2012 then '2'
when GROUPS.YEAR_FIRST = 2013 then '1'
end [����],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
from FACULTY inner join GROUPS ON FACULTY.FACULTY=GROUPS.FACULTY
inner join STUDENT ON GROUPS.IDGROUP=STUDENT.IDGROUP
inner join PROGRESS ON STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
order by [������� ������] desc
