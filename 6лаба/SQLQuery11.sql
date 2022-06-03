use SALES;
select min(Selling_price) [Минимальная цена],
max(Selling_price) [Max price],
count(*) [Goods quantity],
sum(Selling_price) [Заказы на общую сумму]
from Orders

use Sales;
SELECT Product_name,  
          max(Selling_price)  [Максимальная цена],  
          count(*)  [Количество заказанных товаров]
    From  Orders  Inner Join  GOODS 
              On  Orders.Product_name = GOODS.Name_of_product  
               And  GOODS.Quantity > 5   Group by Product_name  

use SALES;
select *
From(select case when Selling_price between 1 and 50 then 'price<50'
when Selling_price between 50 and 100 then 'price from 50 to 100'
else 'price > 100'
end [limits], count (*) [quantity]
from Orders group by case
when Selling_price between 1 and 50 then 'price<50'
when Selling_price between 50 and 100 then 'price from 50 to 100'
else 'price > 100'
end) as T
order by case [limits]
when 'price<50' then 3
when 'price from 50 to 100' then 2
when 'price > 100' then 1
else 0
end

use SALES;
select g.Product_name,
s.Company_name,
f.Price,
round(avg(cast(g.Selling_price as float(4))), 2)
from GOODS f inner join Orders g 
on f.Name_of_product = g.Product_name
inner join Customer s
on g.Customer = s.Company_Name
where f.Price > 15
group by g.Product_name,
s.Company_Name,
f.Price

use SALES;
select Product_name, Selling_price, sum(Quantity)
Quantity
from Orders
where Product_name in ('table', 'chair')
group by Product_name, Selling_price;

use SALES;
select Product_name, Selling_price, sum(Quantity)
Quantity
from Orders
where Product_name in ('table', 'chair')
group by rollup (Product_name, Selling_price);

use SALES;
select Product_name, sum(Quantity) Quantity
from Orders where Customer='ABA'
group by Product_name
union 
select Product_name, sum(Quantity) Quantity
from Orders where Customer='IBA'
group by Product_name

use SALES;
select p1.Product_name, p1.Selling_price,
(select count(*) from Orders p2 
where p2.Product_name=p1.Product_name
and p2.Selling_price=p1.Selling_price) [Quantity]
from Orders p1
group by p1.Product_name, p1.Selling_price
having Selling_price < 20 or Selling_price > 30