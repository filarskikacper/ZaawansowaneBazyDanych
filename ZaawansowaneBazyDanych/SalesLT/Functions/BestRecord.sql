-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

--SELECT * FROM [dbo].[236817_order]

CREATE FUNCTION SalesLT.BestRecord (
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