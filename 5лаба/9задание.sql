use SALES;
select Orders.Product_name, Orders.Date_of_delivery, GOODS.Price
from Orders, GOODS
where Orders.Product_name=GOODS.Name_of_product
and
Customer in (select Company_Name From Customer
where (The_Address Like 'Grodno%'))

use SALES;
select Orders.Product_name, Orders.Date_of_delivery, GOODS.Price
from Orders Inner join GOODS
on Orders.Product_name=GOODS.Name_of_product
where Customer in (select Company_Name From Customer
where (The_Address Like 'Grodno%'))

use SALES;
select Orders.Product_name, Orders.Date_of_delivery, GOODS.Price
from Orders Inner join GOODS
on Orders.Product_name=GOODS.Name_of_product
inner join Customer
on Customer.Company_Name=Orders.Customer
where (The_Address Like 'Grodno%')

use SALES;
select Product_name, Selling_price
from Orders a
where Customer = (select top(1) Customer from Orders aa
where aa.Product_name=a.Product_name
order by Selling_price desc)

use SALES;
select Name_of_product from GOODS
where not exists (select * from Orders
where Orders.Product_name=GOODS.Name_of_product)

use SALES;
select top 1
(select avg(Selling_price) from Orders
where Product_name like 'sofa%')[Sofa],
(select avg(Selling_price) from Orders
where Product_name like 'chair%')[Chair]
from Orders

use SALES;
select Product_name, Selling_price from Orders
where Selling_price>=all(select Selling_price from orders
where Product_name like 'c%')

use SALES;
select Product_name, Selling_price from Orders
where Selling_price>any(select Selling_price from orders
where Product_name like 'c%')