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