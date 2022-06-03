use SALES
CREATE table GOODS
(Name_of_product nvarchar(50) primary key,
Price real unique not null,
Quantity int
);