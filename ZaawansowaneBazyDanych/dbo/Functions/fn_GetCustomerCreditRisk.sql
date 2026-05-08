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