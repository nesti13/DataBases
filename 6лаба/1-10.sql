use UNIVER;
--1--
select max(AUDITORIUM_CAPACITY) [Максимальная вместимость],
       min(AUDITORIUM_CAPACITY) [Минимальная вместимость],
       avg(AUDITORIUM_CAPACITY) [Средняя вместимость],
	   sum(AUDITORIUM_CAPACITY) [Суммарная вместимость],
	   count(*) [Количество аудиторий]

from AUDITORIUM

--2--
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [Наименование типа аудитории],
       max(AUDITORIUM_CAPACITY) [Максимальная вместимость],
       min(AUDITORIUM_CAPACITY) [Минимальная вместимость],
       avg(AUDITORIUM_CAPACITY) [Средняя вместимость],
	   sum(AUDITORIUM_CAPACITY) [Суммарная вместимость],
	   count(*) [Количество аудиторий] 
from AUDITORIUM inner join AUDITORIUM_TYPE on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE
Group by AUDITORIUM_TYPENAME


--3--
select *
from (select case when note between 4 and 5 then '4-5'
                  when note between 6 and 7 then '6-7'
				  when note between 8 and 9 then '8-9'
				  else '10'
				  end [Оценки], COUNT(*) [Количество]  
from PROGRESS group by case
                  when note between 4 and 5 then '4-5'
                  when note between 6 and 7 then '6-7'
				  when note between 8 and 9 then '8-9'
				  else '10' end) as T
order by case [Оценки]
     when '4-5' then 3
     when '6-7' then 2
	 when '8-9' then 1
	 else 0 
	 end

--4--
use UNIVER;
select FACULTY.FACULTY [Факультет],
       GROUPS.PROFESSION [Специальность],
	   case 
	       when GROUPS.YEAR_FIRST = 2010 then '4'
		   when GROUPS.YEAR_FIRST = 2011 then '3'
		   when GROUPS.YEAR_FIRST = 2012 then '2'
		   when GROUPS.YEAR_FIRST = 2013 then '1'
	   end[Курс],
	   round(avg(cast(PROGRESS.NOTE as float(4))),2) [Средняя оценка]
From FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
             inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
             inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
order by [Средняя оценка] desc

--4.1--
use UNIVER;
select FACULTY.FACULTY [Факультет],
       GROUPS.PROFESSION [Специальность],
	   case 
	       when GROUPS.YEAR_FIRST = 2010 then '4'
		   when GROUPS.YEAR_FIRST = 2011 then '3'
		   when GROUPS.YEAR_FIRST = 2012 then '2'
		   when GROUPS.YEAR_FIRST = 2013 then '1'
	   end[Курс],
	   round(avg(cast(PROGRESS.NOTE as float(4))),2) [Средняя оценка]
From FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
             inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
             inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
			 where PROGRESS.SUBJECT in ('ОАиП','КГ')
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
order by [Средняя оценка] desc

--5--
use UNIVER;
select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   round(avg(cast(PROGRESS.NOTE as float(4))), 2) [Средняя оценка]
	   from FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
	                      join STUDENT  on GROUPS.IDGROUP=STUDENT.IDGROUP
						  join PROGRESS on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
	     
       where FACULTY.FACULTY ='ИДиП'
       group by FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT 

--5.1--
 use UNIVER;
select  GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   round(avg(cast(PROGRESS.NOTE as float(4))), 2) [Средняя оценка]
	   from FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
	                      join STUDENT  on GROUPS.IDGROUP=STUDENT.IDGROUP
						  join PROGRESS on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
	     
       where FACULTY.FACULTY ='ИДиП'
       group by ROLLUP(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT) 
	   
--6--
use UNIVER;
select 
       GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   round(avg(cast(PROGRESS.NOTE as float(4))), 2) [Средняя оценка]
	   from FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
	                      join STUDENT  on GROUPS.IDGROUP=STUDENT.IDGROUP
						  join PROGRESS on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
       where FACULTY.FACULTY ='ИДиП'
       group by CUBE(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT) 

--7--
use UNIVER;
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
values  ('СУБД', 1054, '2013-12-01', 8),
        ('КГ', 1058, '2012-10-02', 7),
		('ОАиП', 1067, '2010-11-01', 6),
		('СУБД', 1081, '2011-12-01', 9),
		('КГ', 1085, '2013-10-02', 8),
		('ОАиП', 1073, '2012-11-01', 5) 

--7--
use UNIVER;
select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   avg(PROGRESS.NOTE) [Средняя оценка]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT    
where GROUPS.FACULTY='ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

union

  select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   avg(PROGRESS.NOTE) [Средняя оценка]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT  
 where GROUPS.FACULTY='ХТиТ'                                         
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--7.1--
use UNIVER;
select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   avg(PROGRESS.NOTE) [Средняя оценка]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT    
where GROUPS.FACULTY='ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

union all

  select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   avg(PROGRESS.NOTE) [Средняя оценка]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT  
 where GROUPS.FACULTY='ХТиТ'                                         
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT	

--8--
use UNIVER;
select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   avg(PROGRESS.NOTE) [Средняя оценка]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT    
where GROUPS.FACULTY='ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

intersect

  select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   avg(PROGRESS.NOTE) [Средняя оценка]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT  
 where GROUPS.FACULTY='ХТиТ'                                         
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT	

--9--
use UNIVER;
select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   avg(PROGRESS.NOTE) [Средняя оценка]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT    
where GROUPS.FACULTY='ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

except

  select GROUPS.PROFESSION [Специальность],
       PROGRESS.SUBJECT [Дисциплина],
	   avg(PROGRESS.NOTE) [Средняя оценка]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT  
 where GROUPS.FACULTY='ХТиТ'                                         
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--10--
use UNIVER;
select * from PROGRESS

select PROGRESS.SUBJECT,
	   Progress.Note,
	   count(Progress.IDSTUDENT)[Количество студентов]
	   from progress
	   group by PROGRESS.SUBJECT, PROGRESS.NOTE
	   having PROGRESS.NOTE in(8,9)






 

       
       

