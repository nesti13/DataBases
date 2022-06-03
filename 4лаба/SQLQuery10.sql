use SALES;
Select GOODS.Name_of_product, GOODS.Price, Orders.Selling_price
From Orders Cross Join GOODS
where Orders.Product_name=GOODS.Name_of_product