-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

CREATE SCHEMA K7_surname AUTHORIZATION dbo;
GO

CREATE TYPE K7_surname.Nazwisko FROM VARCHAR(50) NOT NULL;
GO

ALTER TABLE [236817].Customer
ALTER COLUMN LastName K7_surname.Nazwisko;
GO

-- =============================================
-- Zadanie 2
-- =============================================

DECLARE @ProductInfo NVARCHAR(MAX) = N'[
    {"ProductID": 680, "NewPrice": 1350.00},
    {"ProductID": 706, "NewPrice": 1450.00},
    {"ProductID": 707, "NewPrice": 30.00},
    {"ProductID": 708, "NewPrice": 25.00},
    {"ProductID": 711, "NewPrice": 40.00}
]';

CREATE VIEW SalesLT.vProductPriceCompare 
AS
SELECT p.ProductID, p.Name, p.ListPrice, j.NewPrice, (j.NewPrice - p.ListPrice) AS Roznica
FROM SalesLT.Product AS p
JOIN OPENJSON(@ProductInfo) j ON p.ProductID = j.ProductID;

-- Nie można zrobić tego zadania, bo widoki nie obsługują zmiennych lokalnych, wyskakuje błąd Must declare the scalar variable "@ProductInfo".


-- =============================================
-- Zadanie 3
-- =============================================

CREATE VIEW [236817_order]
AS
SELECT TOP (100) ProductID, Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice;
GO

-- =============================================
-- Zadanie 4
-- =============================================

-- Widok sortujący zamówienia na podstawie wartości, żeby najdroższe miały najwyższy priorytet

CREATE VIEW Student_7.MyLogicView
AS
SELECT TOP 100 SalesOrderID, OrderDate, CustomerID, TotalDue
FROM SalesLT.SalesOrderHeader
ORDER BY TotalDue DESC;
GO

SELECT * FROM Student_7.MyLogicView;
GO

-- =============================================
-- Zadanie 5
-- =============================================

CREATE VIEW Student_7.TaxView
AS
SELECT SalesOrderID, OrderDate, TotalDue, ROUND(TotalDue*0.23, 2) AS VAT, (TotalDue + ROUND(TotalDue*0.23, 2)) AS BRUTTO
FROM Student_7.MyLogicView;
GO

SELECT * FROM Student_7.TaxView;
GO