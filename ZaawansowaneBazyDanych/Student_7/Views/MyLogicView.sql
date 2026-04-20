CREATE VIEW Student_7.MyLogicView
AS
SELECT TOP 100 SalesOrderID, OrderDate, CustomerID, TotalDue
FROM SalesLT.SalesOrderHeader
ORDER BY TotalDue DESC;