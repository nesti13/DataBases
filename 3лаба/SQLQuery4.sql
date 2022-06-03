use SALES
CREATE TABLE Orders
( Order_number int primary key,
  Product_name nvarchar(50) foreign key references dbo.GOODS(Name_of_product),
  Selling_price real,
  Quantity int,
  Date_of_delivery date,
  Customer nvarchar(20) foreign key references Customer(Company_Name)
);
