use SALES;
SELECT GOODS.Name_of_product, Orders.Date_of_delivery,
Case
When (Orders.Selling_price between 1 and 50) then 'price<50'
when (Orders.Selling_price between 50 and 100) then 'price from 50 to 100'
else 'price more than 100'
end [price limits]
From GOODS Inner Join Orders
On GOODS.Name_of_product=Orders.[Product_name]
Order by Orders.Product_name