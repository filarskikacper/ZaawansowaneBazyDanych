
CREATE   PROCEDURE dbo.AddNewProduct
    @ProductName NVARCHAR(50),
    @Category NVARCHAR(50),
    @ListPrice MONEY,
    @Amount INT,
    @ProductNumber NVARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;

    IF @ListPrice <= 0
    BEGIN
        RAISERROR ('Cena musi być większa od zera', 16, 1)
        RETURN
    END
    IF @Amount < 0
    BEGIN
        RAISERROR ('Ilość nie może być ujemna', 16, 1)
        RETURN
    END

    BEGIN TRY
        BEGIN TRAN;
        DECLARE @CategoryID INT

        SELECT @CategoryID = ProductCategoryID
        FROM SalesLT.ProductCategory
        WHERE [Name] = @Category

        INSERT INTO [SalesLT].[Product]
           ([Name]
           ,[ProductCategoryID]
           ,[ProductNumber]
           ,[StandardCost]
           ,[ListPrice]
           ,[SellStartDate]
           ,[rowguid]
           ,[ModifiedDate])
        VALUES
            (
            @ProductName,
            @CategoryID,
            @ProductNumber,
            @ListPrice,
            @ListPrice,
            GETDATE(),
            NEWID(),
            GETDATE()
            )

        DECLARE @ProductID INT
        SET @ProductID = @@IDENTITY

        INSERT INTO SalesLT.ProductInventory (ProductID, Amount)
        VALUES (@ProductID, @Amount)

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;