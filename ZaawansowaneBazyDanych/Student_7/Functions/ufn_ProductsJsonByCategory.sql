CREATE   FUNCTION Student_7.ufn_ProductsJsonByCategory(
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