use UNIVER;
select * from PULPIT at full outer join TEACHER aa
on aa.PULPIT=at.PULPIT

use UNIVER;
select * from TEACHER at full outer join PULPIT aa
on aa.PULPIT=at.PULPIT

use UNIVER;
select * from PULPIT left outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT

use UNIVER;
select * from PULPIT right outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT

use UNIVER;
select * from PULPIT full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT

use UNIVER;
select * from PULPIT inner join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT

use UNIVER;
select PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME from PULPIT
full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
where TEACHER.TEACHER is null

use UNIVER;
select TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT, TEACHER.GENDER from PULPIT
full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
where TEACHER.TEACHER is not null

use UNIVER;
select * from PULPIT full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT