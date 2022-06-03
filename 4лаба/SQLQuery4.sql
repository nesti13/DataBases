use SALES;
SELECT T1.Name_of_product, T1.Price, T2.Selling_price
From Orders As T2, GOODS As T1
Where T2.Product_name=T1.Name_of_product
