use UNIVER;

--1--
DECLARE Subs CURSOR
	for SELECT SUBJECT from dbo.SUBJECT
	where SUBJECT.PULPIT='ИСиТ'; 

DECLARE @sub char(4),
		@str char(100)=' '; 
OPEN Subs;  
	fetch  Subs into @sub;    
	print   'Дисциплины на кафедре ИСиТ:';   
	while @@fetch_status = 0                                   
	begin 
		set @str = rtrim(@sub)+', '+@str; -- удаляет все завершающие пробелы        
		fetch  Subs into @sub; 
	end;   
    print @str;        
CLOSE  Subs;
deallocate Subs; 

--2--
DECLARE Puls CURSOR LOCAL
	for SELECT PULPIT, FACULTY from PULPIT;
DECLARE @pul nvarchar(10),
		@fac nvarchar(4);      
OPEN Puls; 	  
	fetch  Puls into @pul, @fac; 	
    print rtrim(@pul)+' (local) на факультете  '+ @fac;


DECLARE Puls CURSOR GLOBAL
	for SELECT PULPIT, FACULTY from PULPIT;
DECLARE @pul1 nvarchar(10),
		@fac1 nvarchar(4);      
OPEN Puls;	  
	fetch  Puls into @pul1, @fac1; 	
    print rtrim(@pul1)+' (global) на факультете  '+ @fac1;
 
CLOSE Puls;
deallocate Puls;

--3--
DECLARE Studs CURSOR Local STATIC
	for SELECT NAME from STUDENT
	where IDGROUP = 3;		
		   
OPEN Studs;
print 'Кол-во строк : '+cast(@@CURSOR_ROWS as varchar(5)); 

DECLARE @name char(50);  
UPDATE STUDENT set IDGROUP=24 where IDGROUP=3;  
fetch  Studs into @name;     
while @@fetch_status = 0                                    
begin 
   print @name + ' ';      
   fetch Studs into @name; 
end;      
CLOSE  Studs;


UPDATE STUDENT set IDGROUP=3 where IDGROUP=24;
DEALLOCATE Studs 

--4--
DECLARE  @t int, @rn char(50);  

DECLARE ScrollCur CURSOR LOCAL DYNAMIC SCROLL for 
		SELECT row_number() over (order by NAME), NAME from STUDENT where IDGROUP = 6 
OPEN ScrollCur;
	fetch FIRST from ScrollCur into  @t, @rn;                 
		print 'первая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);
	fetch NEXT from ScrollCur into  @t, @rn;                 
		print 'следующая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);      
	fetch LAST from  ScrollCur into @t, @rn;       
		print 'последняя строка: ' +  cast(@t as varchar(3))+ ' '+rtrim(@rn);   
	fetch PRIOR from ScrollCur into  @t, @rn;         --пред от текущей  
		print 'предпоследняя строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch ABSOLUTE 2 from ScrollCur into  @t, @rn;    -- от начала             
		print 'вторая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch RELATIVE 1 from ScrollCur into  @t, @rn;    -- от текущей          
		print 'третья строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);         
CLOSE ScrollCur;

--5--
INSERT FACULTY(FACULTY,FACULTY_NAME) VALUES (N'FIT',N'Факультет IT'); 

DECLARE cur CURSOR LOCAL SCROLL DYNAMIC
	for select f.FACULTY from FACULTY f 
	FOR UPDATE; 

DECLARE @s nvarchar(5); 
OPEN cur 
	fetch FIRST from cur into @s; 
	update FACULTY set FACULTY = N'myFIT' where current of cur; 
	fetch FIRST from cur into @s; 
	delete FACULTY where current of cur; 
GO 



--6--
DECLARE @name3 nvarchar(20), @n int;  

DECLARE Cur01 CURSOR  for 
SELECT NAME, NOTE from PROGRESS join STUDENT 
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5

OPEN Cur01;  
    fetch  Cur1 into @name3, @n;  
	while @@fetch_status = 0
	begin 		
		delete PROGRESS where CURRENT OF Cur01;	
		fetch  Cur01 into @name3, @n;  
	end
CLOSE Cur01;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5
insert into PROGRESS (SUBJECT,IDSTUDENT,PDATE, NOTE)
    values 
           ('ОАиП', 1005,  '01.10.2013',4),
           ('СУБД', 1017,  '01.12.2013',4),
		   ('КГ',   1018,  '06.5.2013',4),
           ('ОХ',   1065,  '01.1.2013',4),
           ('ОХ',   1069,  '01.1.2013',4),
           ('ЭТ',   1058,  '01.1.2013',4)

-- увелиичть оценку на единицу
DECLARE @name4 char(20), @n3 int;  

DECLARE Cur2 CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT=1000
OPEN Cur2;  
    fetch  Cur2 into @name4, @n3; 
    UPDATE PROGRESS set NOTE=NOTE+1 where CURRENT OF Cur2;
CLOSE Cur2;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where PROGRESS.IDSTUDENT=1000

--7--
--1--
DECLARE @tv char(20), @t char(300)='';
declare zktovar cursor for select Product_name from Orders; 

OPEN zktovar;  
	fetch  zktovar into @tv;    
	print   'Заказанные товары:';   
	while @@fetch_status = 0                                   
	begin 
		set @t = rtrim(@tv)+', '+@t; -- удаляет все завершающие пробелы        
		fetch  zktovar into @tv; 
	end;   
    print @t;        
CLOSE  zktovar;

--2--
DECLARE Tovary CURSOR LOCAL                            
	             for SELECT Name_of_product, Price from GOODS;
DECLARE @tv char(20), @cena real;      
	OPEN Tovary;	  
	fetch  Tovary into @tv, @cena; 	
      print '1. '+@tv+cast(@cena as varchar(6));   
      go
 DECLARE @tv char(20), @cena real;     	
	fetch  Tovary into @tv, @cena; 	
      print '2. '+@tv+cast(@cena as varchar(6));  
  go   



DECLARE Tovary CURSOR GLOBAL                            
	             for SELECT Name_of_product, Price from GOODS;
DECLARE @tv char(20), @cena real;      
	OPEN Tovary;	  
	fetch  Tovary into @tv, @cena; 	
      print '1. '+@tv+cast(@cena as varchar(6));   
      go
 DECLARE @tv char(20), @cena real;     	
	fetch  Tovary into @tv, @cena; 	
      print '2. '+@tv+cast(@cena as varchar(6));  
	  close Tovary;
	  deallocate Tovary;
  go   


--3--
DECLARE @tid char(10), @tnm char(40), @tgn char(1);  
	DECLARE Zakaz CURSOR LOCAL STATIC                              
		 for SELECT Product_name, Selling_price, Quantity 
		       FROM dbo.Orders where Customer = 'IBA';				   
	open Zakaz;
	print   'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5)); 
    	UPDATE Orders set Quantity = 5 where Product_name = 'Chair';
	DELETE Orders where Product_name = 'Sofa';
	INSERT Orders (Order_number, Product_name, Selling_price,    
                                Quantity, Date_of_delivery, Customer) 
	                 values (18, 'Shkaf', 340, 1, '2014-08-02', 'IBM'); 
	FETCH  Zakaz into @tid, @tnm, @tgn;     
	while @@fetch_status = 0                                    
      begin 
          print @tid + ' '+ @tnm + ' '+ @tgn;      
          fetch Zakaz into @tid, @tnm, @tgn; 
       end;          
   CLOSE  Zakaz;


--4--
         DECLARE  @tc int, @rn char(50);  
         DECLARE Primer1 cursor local dynamic SCROLL                               
               for SELECT row_number() over (order by Product_name) N,
	                           Product_name FROM dbo.Orders 
                               where Customer = 'ABA' 
	OPEN Primer1;
	fetch FIRST from Primer1 into  @tc, @rn;                 
    print 'первая строка: ' + cast(@tc as varchar(3))+ ' ' + rtrim(@rn);
	FETCH  Primer1 into  @tc, @rn;                 
	print 'следующая строка        : ' + cast(@tc as varchar(3))+ rtrim(@rn);      
	FETCH  LAST from  Primer1 into @tc, @rn;       
	print 'последняя строка          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      
	fetch PRIOR from Primer1 into  @tc, @rn;         --пред от текущей  
	print 'предпоследняя строка: ' + cast(@tc as varchar(3))+ ' ' + rtrim(@rn); 
	fetch ABSOLUTE 2 from Primer1 into  @tc, @rn;    -- от начала             
	print 'вторая строка: ' + cast(@tc as varchar(3))+ ' ' + rtrim(@rn); 
	fetch RELATIVE 1 from Primer1 into  @tc, @rn;    -- от текущей          
	print 'третья строка: ' + cast(@tc as varchar(3))+ ' ' + rtrim(@rn); 
     CLOSE Primer1;

--5--
INSERT FACULTY(FACULTY,FACULTY_NAME) VALUES (N'FIT',N'Факультет IT'); 

DECLARE cur CURSOR LOCAL SCROLL DYNAMIC
	for select f.FACULTY from FACULTY f 
	FOR UPDATE; 

DECLARE @s nvarchar(5); 
OPEN cur 
	fetch FIRST from cur into @s; 
	update FACULTY set FACULTY = N'myFIT' where current of cur; 
	fetch FIRST from cur into @s; 
	delete FACULTY where current of cur; 
GO 



--6--
DECLARE @name3 nvarchar(20), @n int;  

DECLARE Cur01 CURSOR  for 
SELECT NAME, NOTE from PROGRESS join STUDENT 
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5

OPEN Cur01;  
    fetch  Cur1 into @name3, @n;  
	while @@fetch_status = 0
	begin 		
		delete PROGRESS where CURRENT OF Cur01;	
		fetch  Cur01 into @name3, @n;  
	end
CLOSE Cur01;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5
insert into PROGRESS (SUBJECT,IDSTUDENT,PDATE, NOTE)
    values 
           ('ОАиП', 1005,  '01.10.2013',4),
           ('СУБД', 1017,  '01.12.2013',4),
		   ('КГ',   1018,  '06.5.2013',4),
           ('ОХ',   1065,  '01.1.2013',4),
           ('ОХ',   1069,  '01.1.2013',4),
           ('ЭТ',   1058,  '01.1.2013',4)

-- увелиичть оценку на единицу
DECLARE @name4 char(20), @n3 int;  

DECLARE Cur2 CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT=1000
OPEN Cur2;  
    fetch  Cur2 into @name4, @n3; 
    UPDATE PROGRESS set NOTE=NOTE+1 where CURRENT OF Cur2;
CLOSE Cur2;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where PROGRESS.IDSTUDENT=1000
