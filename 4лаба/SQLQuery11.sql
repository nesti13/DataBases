use SALES;
Select GOODS.Name_of_product, Orders.Order_number as Quantity, Orders.Selling_price
from GOODS FULL OUTER JOIN Orders
on GOODS.Quantity = Orders.Order_number