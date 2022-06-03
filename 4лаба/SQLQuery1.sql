use SALES;
SELECT GOODS.Name_of_product, GOODS.Price, Orders.Selling_price
From Orders Inner Join GOODS
On Orders.[Product_name]=GOODS.Name_of_product
