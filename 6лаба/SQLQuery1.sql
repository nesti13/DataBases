use UNIVER;
Select max(AUDITORIUM_CAPACITY) [Максимальная вместимость],
min(AUDITORIUM_CAPACITY) [Минимальная вместимость],
AVG(AUDITORIUM_CAPACITY) [Средняя вместимоть],
sum(AUDITORIUM_CAPACITY) [Суммарная вместимость всех аудиторий],
count(AUDITORIUM) [общее кол-во аудиторий]
from AUDITORIUM

use UNIVER;
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [Название типа аудитории],
max(AUDITORIUM_CAPACITY) [Максимальная вместимость],
min(AUDITORIUM_CAPACITY) [Минимальная вместимость],
AVG(AUDITORIUM_CAPACITY) [Средняя вместимоть],
sum(AUDITORIUM_CAPACITY) [Суммарная вместимость всех аудиторий],
count(AUDITORIUM) [общее кол-во аудиторий]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE
group by AUDITORIUM_TYPENAME

use UNIVER;
select *
from (select case when NOTE between 4 and 5 then '4-5'
when NOTE between 6 and 7 then '6-7'
when NOTE between 8 and 9 then '8-9'
else '10'
end [Оценки], count(*) [Количество]
from PROGRESS group by case when NOTE between 4 and 5 then '4-5'
when NOTE between 6 and 7 then '6-7'
when NOTE between 8 and 9 then '8-9'
else '10' end) as T
order by case [оценки]
when '4-5' then 3
when '6-7' then 2
when '8-9' then 1
else 0
end

use UNIVER;
select FACULTY.FACULTY [факультет],
GROUPS.PROFESSION [специальность],
case
when GROUPS.YEAR_FIRST = 2010 then '4'
when GROUPS.YEAR_FIRST = 2011 then '3'
when GROUPS.YEAR_FIRST = 2012 then '2'
when GROUPS.YEAR_FIRST = 2013 then '1'
end [курс],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
from FACULTY inner join GROUPS ON FACULTY.FACULTY=GROUPS.FACULTY
inner join STUDENT ON GROUPS.IDGROUP=STUDENT.IDGROUP
inner join PROGRESS ON STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
order by [средняя оценка] desc

use UNIVER;
select FACULTY.FACULTY [факультет],
GROUPS.PROFESSION [специальность],
case
when GROUPS.YEAR_FIRST = 2010 then '4'
when GROUPS.YEAR_FIRST = 2011 then '3'
when GROUPS.YEAR_FIRST = 2012 then '2'
when GROUPS.YEAR_FIRST = 2013 then '1'
end [курс],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
from FACULTY inner join GROUPS ON FACULTY.FACULTY=GROUPS.FACULTY
inner join STUDENT ON GROUPS.IDGROUP=STUDENT.IDGROUP
inner join PROGRESS ON STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
order by [средняя оценка] desc
