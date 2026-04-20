CREATE VIEW [236817_order]
AS
SELECT TOP (100) ProductID, Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice;