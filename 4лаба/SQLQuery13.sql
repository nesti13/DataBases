use SALES;
select GOODS.Name_of_product, GOODS.Quantity, GOODS.Price
from Orders full outer join GOODS 
on GOODS.Name_of_product=Orders.Product_name
where GOODS.Name_of_product is not null