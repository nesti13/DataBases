use SALES;
select* 
from Orders full outer join GOODS 
on GOODS.Name_of_product=Orders.Product_name
where Orders.Order_number is not null