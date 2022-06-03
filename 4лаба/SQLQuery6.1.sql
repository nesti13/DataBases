use UNIVER;
select FACULTY.FACULTY_NAME[факультет], PULPIT.PULPIT[Кафедра], PROFESSION.PROFESSION_NAME[специальность], SUBJECT.SUBJECT[Дисциплина], STUDENT.NAME[Имя студента],
case
when(Progress.NOTE=6) then 'six'
when(Progress.NOTE=7) then 'seven'
when(Progress.NOTE=8) then 'eight'
end[Оценка]
from ((((((FACULTY
inner join PULPIT on FACULTY.FACULTY=PULPIT.FACULTY)
inner join SUBJECT on PULPIT.PULPIT=SUBJECT.PULPIT)
inner join PROGRESS on SUBJECT.SUBJECT=PROGRESS.SUBJECT)
inner join STUDENT on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT)
inner join GROUPS on STUDENT.IDGROUP=GROUPS.IDGROUP)
inner join PROFESSION on GROUPS.PROFESSION=PROFESSION.PROFESSION)
where PROGRESS.NOTE between 6 and 8
order by (
case
when (Progress.NOTE=6) then 3
when (Progress.NOTE=6) then 2
else 1
end)