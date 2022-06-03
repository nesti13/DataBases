use SALES;
select isnull (Orders.Product_name, '**')[Product], GOODS.Quantity
From Orders Right Outer JOIN GOODS
On Orders.Product_name=GOODS.Name_of_product
