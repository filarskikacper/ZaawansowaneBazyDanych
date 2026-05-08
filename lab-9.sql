-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

--SELECT * FROM [dbo].[236817_order]

ALTER FUNCTION SalesLT.BestRecord (
	@ProductID INT = 952,
	@Name NVARCHAR(50) = 'Chain',
	@ListPrice MONEY = 2
	)

RETURNS INT
AS
BEGIN
	DECLARE @Result INT

	SELECT TOP 1 @Result = ProductID
	FROM [dbo].[236817_order]
	WHERE Name = @Name AND ListPrice > @ListPrice AND ProductID = @ProductID

	RETURN @Result
END;
GO

-- Widok już był posortowany, więc używać ORDER BY

SELECT SalesLT.BestRecord(952, 'Chain', 2);
GO


-- =============================================
-- Zadanie 2
-- =============================================

SELECT TOP 25 ProductID, Name, ListPrice
INTO ##TopProducts
FROM SalesLT.Product
ORDER BY ListPrice;

CREATE FUNCTION Student_7.ufn_CalcAdjustedPrices()
RETURNS @Summary TABLE 
(
    ProductID INT,
    ListPrice MONEY
)
AS
BEGIN
UPDATE ##TopProducts
SET ListPrice = (ListPrice - (ListPrice * 0.07))
END;
GO

-- Tego zadania nie da się zrobić, bo nie można użyć tabeli tymczasowej w funkcji

-- =============================================
-- Zadanie 3
-- =============================================

CREATE FUNCTION Student_7.ufn_ProductsJsonByCategory(
@CategoryName NVARCHAR(50)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE	@Product NVARCHAR(MAX)
	SET @Product = (
	SELECT pc.ProductCategoryID, p.Name
	FROM SalesLT.ProductCategory pc
	JOIN SalesLT.Product p ON pc.ProductCategoryID = p.ProductCategoryID
	WHERE pc.Name = @CategoryName
	FOR JSON PATH
	)
	RETURN @Product
END;
GO

-- =============================================
-- Zadanie 4
-- =============================================

CREATE FUNCTION Student_7.ufn_IsPriceHigherThanCurrent (
@Product NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
	DECLARE @ProductID INT
	DECLARE @JsonPrice MONEY
	DECLARE @ListPrice MONEY
	DECLARE @Result BIT

	SET @ProductID = CAST(JSON_VALUE(@Product, '$.ProductID') AS INT)
	SET @JsonPrice = CAST(JSON_VALUE(@Product, '$.ListPrice') AS MONEY)

	SELECT @ListPrice = ListPrice
	FROM SalesLT.Product
	WHERE ProductID = @ProductID
	
	IF @JsonPrice > @ListPrice
		SET @Result = 1
	ELSE
		SET @Result = 0
	RETURN @Result
END;
GO

-- Przy równej cenie Result będzie równy 0

-- =============================================
-- Zadanie 5
-- =============================================

CREATE FUNCTION Student_7.ufn_IsPriceHigherThanCurrentTAB (
@Products NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN (
SELECT
	CAST(JSON_VALUE(J.value, '$.ProductID') AS INT) AS ProductID,
	CAST(JSON_VALUE(J.value, '$.ListPrice') AS MONEY) AS ListPrice,
	Student_7.ufn_IsPriceHigherThanCurrent(J.value) AS IsHigher
FROM OPENJSON(@Products) AS J
)
GO

-- =============================================
-- Zadanie 6
-- =============================================

-- iTVF
-- Pobieranie listy przesyłek dla danego klienta na podstawie jednej zmiennej CustomerID

CREATE FUNCTION Student_7.GetShipments (
@CustomerID INT
)
RETURNS TABLE
AS
RETURN (
	SELECT ShipmentID, Destination, Status, WeightKG, Price
	FROM [236817].[Shipments]
	WHERE CustomerID = @CustomerID
);
GO

-- mTVF
-- Flagowanie samochodów, które są aktualnie w naprawie z floty firmy na podstawie tabeli z naprawami

CREATE FUNCTION Student_7.CarFlags()
RETURNS @Report TABLE (
CarID INT,
CarName NVARCHAR(50),
Status NVARCHAR(20)
)
AS
BEGIN
	INSERT INTO @Report (CarID, CarName, Status)
	SELECT
		CarID,
		CarName,
		'Operational'
	FROM [236817].[Cars]

	UPDATE @Report
	SET Status = 'In repair'
	WHERE CarID IN (
		SELECT CarID
		FROM [236817].[RepairLogs]
		WHERE IsFixed = 0
		)

	RETURN
END;
GO

-- Widok
-- Widok sortujący zamówienia na podstawie wartości, żeby najdroższe miały najwyższy priorytet

CREATE VIEW Student_7.OrderSortView
AS
SELECT TOP 100 SalesOrderID, OrderDate, CustomerID, TotalDue
FROM [236817].[Orders]
ORDER BY TotalDue DESC;
GO

-- Funkcja skalarna
-- Obliczanie rabatu dla klienta w zależności od ilości posiadanych punktów w programie lojalnościowym

CREATE FUNCTION Student_7.ufn_CalculateDiscount (
@LoyaltyPoints INT
)
RETURNS DECIMAL(3,2)
AS
BEGIN
	DECLARE @Discount DECIMAL(3,2) = 0.00

	IF @LoyaltyPoints > 3000
		SET @Discount = 0.20
	ELSE IF @LoyaltyPoints > 2000
		SET @Discount = 0.15
	ELSE IF @LoyaltyPoints > 1000
		Set @Discount = 0.10

	RETURN @Discount
END;
GO


-- =============================================
-- Zadanie 7
-- =============================================
CREATE FUNCTION dbo.fn_GetCustomerCreditRisk (
@CustomerID INT
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @Orders TABLE (
	Price MONEY,
	DaysLate INT
	)

	INSERT INTO @Orders (Price, DaysLate)
	SELECT
		TotalDue,
		DATEDIFF(DAY, DueDate, ISNULL(ShipDate, GETDATE()))
	FROM SalesLT.SalesOrderHeader
	WHERE CustomerID = @CustomerID

	DECLARE @TotalPrice MONEY
	DECLARE @LateOrdersCount INT
	DECLARE @Risk NVARCHAR(10)

	SELECT
		@TotalPrice = SUM(Price),
		@LateOrdersCount = SUM(CASE WHEN DaysLate > 3 THEN 1 ELSE 0 END)
	FROM @Orders

	IF @TotalPrice > 100000 AND @LateOrdersCount >= 2
		SET @Risk = 'HIGH'
	ELSE IF @TotalPrice > 50000
		SET @Risk = 'MEDIUM'
	ELSE
		SET @Risk = 'LOW'
	
	RETURN @Risk
END;
GO
