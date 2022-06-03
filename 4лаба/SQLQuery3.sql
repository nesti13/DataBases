use SALES;
SELECT GOODS.Name_of_product, GOODS.Price, Orders.Selling_price
From Orders, GOODS
Where Orders.Product_name=GOODS.Name_of_product
