use UNIVER
go
--1--
select PULPIT.FACULTY[факультет/@код], 
	TEACHER.PULPIT[факультет/кафедра/@код], 
    TEACHER.TEACHER_NAME[факультет/кафедра/преподаватель/@код]
	    from TEACHER inner join PULPIT
		    on TEACHER.PULPIT = PULPIT.PULPIT
			   where TEACHER.PULPIT = 'ИСиТ' for xml path, root('Список_преподавателей_кафедры_ИСиТ');

--2--
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
	   AUDITORIUM.AUDITORIUM_TYPE,
	   AUDITORIUM.AUDITORIUM_CAPACITY 
		from AUDITORIUM inner join AUDITORIUM_TYPE 
			on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
Order by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME for xml AUTO,
root('Список_аудиторий'), elements;

--3--
use UNIVER
go
declare @h int = 0,
	@x varchar(2000)='<?xml version="1.0" encoding="windows-1251" ?>
	<дисциплины>
					   	<дисциплина код="КГиГ" название="Компьютерная геометрия и графика" кафедра="ИСиТ" />
						 <дисциплина код="ОЗИ" название="Основы защиты информации" кафедра="ИСиТ" />
						 <дисциплина код="МПп" название="Математическое программирование п" кафедра="ИСиТ" />
	</дисциплины>';
	   exec sp_xml_preparedocument @h output, @x;
insert SUBJECT select[код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина',0)
    with([код] char(10), [название] varchar(100), [кафедра] char(20));
	select * from SUBJECT
delete from SUBJECT where SUBJECT.SUBJECT='КГиГ' or SUBJECT.SUBJECT='ОЗИ' or SUBJECT.SUBJECT='МПп'

--4--
insert into STUDENT(IDGROUP, NAME, BDAY, INFO)
	values(22, 'Колядко Я.Д.', '01.08.2003',
	'<студент>
		<паспорт серия="МС" номер="2899090" дата="02.11.2017" />
		<телефон>+375298413284</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Копыль</город>
			<улица>Энгельса</улица>
			<дом>74</дом>
			<квартира>1</квартира>
		</адрес>
	</студент>');
select * from STUDENT where NAME = 'Колядко Я.Д.';
update STUDENT set INFO = '<студент>
			<паспорт серия="МС" номер="2899090" дата="02.11.2017" />
			<телефон>+375298413284</телефон>
			<адрес>
			<страна>Беларусь</страна>
			<город>Копыль</город>
			<улица>Энгельса</улица>
			<дом>74</дом>
			<квартира>2</квартира>
		</адрес>
	</студент>' where NAME='Колядко Я.Д.'
select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
	INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта],
	INFO.query('/студент/адрес')[Адрес]
		from  STUDENT
			where NAME = 'Колядко Я.Д.';

--5--
go
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

--alter table STUDENT alter column INFO xml(Student);
--drop XML SCHEMA COLLECTION Student;
select Name, INFO from STUDENT where NAME='Колядко Я.Д.'
