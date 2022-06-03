use SALES;
SELECT Orders.Product_name, GOODS.Price, Orders.Selling_price
From Orders Inner Join GOODS
On Orders.Product_name=GOODS.Name_of_product And
Orders.Product_name Like '%ch%'
