--1--
create view [Заказанные товары]
as select Product_name [Good],
Selling_price [Selling_price],
Date_of_delivery [Date]
from Orders;
--2--
create view [Сравнение цен]
as select zk.Product_name [Good],
tv.Price [First_price],
zk.Selling_price [Selling_price]
from Orders zk join GOODS tv
on zk.Product_name=tv.Name_of_product
--3--
create view expensive_goods (Good, Price, Quantity)
as select Name_of_product, Price, Quantity from GOODS
where Price > 10;
go
select * from expensive_goods
--4--
alter view expensive_goods (Good, Price, Quantity)
as select Name_of_product, Price, Quantity from GOODS
where Price > 10 with check option;
go
select * from expensive_goods
--5--
create view expensive_goods2 (Good, Price, Quantity)
as select top 2 Name_of_product, Price, Quantity from GOODS
order by Name_of_product;
--6--
alter view [Сравнение цен] with schemabinding
as select zk.Product_name [товар],
tv.Price [first_price],
zk.Selling_price [Selling_price]
from dbo.Orders zk join dbo.GOODS tv
on zk.Product_name=tv.Name_of_product