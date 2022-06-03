use SALES;
select isnull (Orders.Product_name, '**')[Product], GOODS.Quantity
From GOODS Left Outer JOIN Orders
On GOODS.Name_of_product=Orders.Product_name
