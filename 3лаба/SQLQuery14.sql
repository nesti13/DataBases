use SALES;
SELECT Distinct Top(2) Product_name, Selling_price FROM Orders Order by Selling_price Desc;