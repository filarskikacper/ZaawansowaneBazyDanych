CREATE VIEW Student_7.TaxView
AS
SELECT SalesOrderID, OrderDate, TotalDue, ROUND(TotalDue*0.23, 2) AS VAT, (TotalDue + ROUND(TotalDue*0.23, 2)) AS BRUTTO
FROM Student_7.MyLogicView;