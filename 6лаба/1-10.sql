use UNIVER;
--1--
select max(AUDITORIUM_CAPACITY) [������������ �����������],
       min(AUDITORIUM_CAPACITY) [����������� �����������],
       avg(AUDITORIUM_CAPACITY) [������� �����������],
	   sum(AUDITORIUM_CAPACITY) [��������� �����������],
	   count(*) [���������� ���������]

from AUDITORIUM

--2--
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [������������ ���� ���������],
       max(AUDITORIUM_CAPACITY) [������������ �����������],
       min(AUDITORIUM_CAPACITY) [����������� �����������],
       avg(AUDITORIUM_CAPACITY) [������� �����������],
	   sum(AUDITORIUM_CAPACITY) [��������� �����������],
	   count(*) [���������� ���������] 
from AUDITORIUM inner join AUDITORIUM_TYPE on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE
Group by AUDITORIUM_TYPENAME


--3--
select *
from (select case when note between 4 and 5 then '4-5'
                  when note between 6 and 7 then '6-7'
				  when note between 8 and 9 then '8-9'
				  else '10'
				  end [������], COUNT(*) [����������]  
from PROGRESS group by case
                  when note between 4 and 5 then '4-5'
                  when note between 6 and 7 then '6-7'
				  when note between 8 and 9 then '8-9'
				  else '10' end) as T
order by case [������]
     when '4-5' then 3
     when '6-7' then 2
	 when '8-9' then 1
	 else 0 
	 end

--4--
use UNIVER;
select FACULTY.FACULTY [���������],
       GROUPS.PROFESSION [�������������],
	   case 
	       when GROUPS.YEAR_FIRST = 2010 then '4'
		   when GROUPS.YEAR_FIRST = 2011 then '3'
		   when GROUPS.YEAR_FIRST = 2012 then '2'
		   when GROUPS.YEAR_FIRST = 2013 then '1'
	   end[����],
	   round(avg(cast(PROGRESS.NOTE as float(4))),2) [������� ������]
From FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
             inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
             inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
order by [������� ������] desc

--4.1--
use UNIVER;
select FACULTY.FACULTY [���������],
       GROUPS.PROFESSION [�������������],
	   case 
	       when GROUPS.YEAR_FIRST = 2010 then '4'
		   when GROUPS.YEAR_FIRST = 2011 then '3'
		   when GROUPS.YEAR_FIRST = 2012 then '2'
		   when GROUPS.YEAR_FIRST = 2013 then '1'
	   end[����],
	   round(avg(cast(PROGRESS.NOTE as float(4))),2) [������� ������]
From FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
             inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
             inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
			 where PROGRESS.SUBJECT in ('����','��')
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
order by [������� ������] desc

--5--
use UNIVER;
select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   round(avg(cast(PROGRESS.NOTE as float(4))), 2) [������� ������]
	   from FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
	                      join STUDENT  on GROUPS.IDGROUP=STUDENT.IDGROUP
						  join PROGRESS on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
	     
       where FACULTY.FACULTY ='����'
       group by FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT 

--5.1--
 use UNIVER;
select  GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   round(avg(cast(PROGRESS.NOTE as float(4))), 2) [������� ������]
	   from FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
	                      join STUDENT  on GROUPS.IDGROUP=STUDENT.IDGROUP
						  join PROGRESS on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
	     
       where FACULTY.FACULTY ='����'
       group by ROLLUP(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT) 
	   
--6--
use UNIVER;
select 
       GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   round(avg(cast(PROGRESS.NOTE as float(4))), 2) [������� ������]
	   from FACULTY inner join GROUPS on FACULTY.FACULTY=GROUPS.FACULTY
	                      join STUDENT  on GROUPS.IDGROUP=STUDENT.IDGROUP
						  join PROGRESS on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
       where FACULTY.FACULTY ='����'
       group by CUBE(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT) 

--7--
use UNIVER;
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
values  ('����', 1054, '2013-12-01', 8),
        ('��', 1058, '2012-10-02', 7),
		('����', 1067, '2010-11-01', 6),
		('����', 1081, '2011-12-01', 9),
		('��', 1085, '2013-10-02', 8),
		('����', 1073, '2012-11-01', 5) 

--7--
use UNIVER;
select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   avg(PROGRESS.NOTE) [������� ������]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT    
where GROUPS.FACULTY='���'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

union

  select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   avg(PROGRESS.NOTE) [������� ������]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT  
 where GROUPS.FACULTY='����'                                         
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--7.1--
use UNIVER;
select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   avg(PROGRESS.NOTE) [������� ������]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT    
where GROUPS.FACULTY='���'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

union all

  select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   avg(PROGRESS.NOTE) [������� ������]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT  
 where GROUPS.FACULTY='����'                                         
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT	

--8--
use UNIVER;
select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   avg(PROGRESS.NOTE) [������� ������]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT    
where GROUPS.FACULTY='���'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

intersect

  select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   avg(PROGRESS.NOTE) [������� ������]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT  
 where GROUPS.FACULTY='����'                                         
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT	

--9--
use UNIVER;
select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   avg(PROGRESS.NOTE) [������� ������]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT    
where GROUPS.FACULTY='���'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

except

  select GROUPS.PROFESSION [�������������],
       PROGRESS.SUBJECT [����������],
	   avg(PROGRESS.NOTE) [������� ������]
	   from  GROUPS inner join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
	                inner join PROGRESS on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT  
 where GROUPS.FACULTY='����'                                         
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--10--
use UNIVER;
select * from PROGRESS

select PROGRESS.SUBJECT,
	   Progress.Note,
	   count(Progress.IDSTUDENT)[���������� ���������]
	   from progress
	   group by PROGRESS.SUBJECT, PROGRESS.NOTE
	   having PROGRESS.NOTE in(8,9)






 

       
       

