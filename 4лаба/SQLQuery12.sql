use SALES;
select Orders.Date_of_delivery, Orders.Customer, Orders.Order_number
from Orders full outer join GOODS
on GOODS.Name_of_product=Orders.Product_name
where Orders.Order_number is not null