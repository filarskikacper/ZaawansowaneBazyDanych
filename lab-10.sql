-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

CREATE OR ALTER PROCEDURE [236817].[AddCustomer]
	@FirstName dbo.Name,
	@LastName [K7_surname].Nazwisko,
	@EmailAddress NVARCHAR(50),
	@Phone dbo.Phone
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @NameExists BIT
    SELECT @NameExists = dbo.isLastNameUnique(@LastName)

    IF @NameExists = 0
    BEGIN
        RETURN
    END

	INSERT INTO [236817].[Customer](FirstName, LastName, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate)
	VALUES (@FirstName, @LastName, @EmailAddress, @Phone, 'LNoK27abGQo48gGue3EBV/UrlYSToV0/s87dCRV7uJk=', 'YTNH5Rw=', NEWID(), GETDATE())
END;
GO

-- =============================================
-- Zadanie 2
-- =============================================

CREATE OR ALTER PROCEDURE [236817].[FindCustomers]
    @CustomerID INT = NULL,
    @FirstName dbo.Name = NULL,
    @LastName [K7_surname].Nazwisko = NULL,
    @EmailAddress NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [CustomerID]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,[CompanyName]
      ,[SalesPerson]
      ,[EmailAddress]
      ,[Phone]
      ,[PasswordHash]
      ,[PasswordSalt]
      ,[rowguid]
      ,[ModifiedDate]
      ,[SysStartTime]
      ,[SysEndTime]
    FROM [236817].[Customer]
    WHERE 
        (@CustomerID IS NULL OR CustomerID = @CustomerID)
        AND (@FirstName IS NULL OR FirstName = @FirstName)
        AND (@LastName IS NULL OR LastName = @LastName)
        AND (@EmailAddress IS NULL OR EmailAddress = @EmailAddress)
END;
GO

-- =============================================
-- Zadanie 3
-- =============================================

-- To zadanie jest niemożliwe do zrobienia, bo zmienna tabelaryczna nie może być jako output w procedurze, parametr tabelaryczny ogólnie może być, ale tylko z klauzulą READONLY

-- =============================================
-- Zadanie 4
-- =============================================

CREATE OR ALTER FUNCTION dbo.isLastNameUnique (
    @LastName NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @SelectOutput NVARCHAR(50) = NULL

    SELECT @SelectOutput = LastName
    FROM [236817].[Customer]
    WHERE LastName = @LastName

    IF @SelectOutput IS NULL
    BEGIN
        RETURN 1
    END
    RETURN 0
END;
GO

-- =============================================
-- Zadanie 5
-- =============================================

CREATE OR ALTER PROCEDURE dbo.UpdateCustomer
    @CustomerID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS ( 
    SELECT 1 FROM [236817].[Customer]
    WHERE CustomerID = @CustomerID
    )
    BEGIN
        RAISERROR ('Dany rekord nie istnieje', 16, 1)
        RETURN
    END

    UPDATE [236817].[Customer]
    SET FirstName = @FirstName,
    LastName = @LastName,
    ModifiedDate = GETDATE()
    WHERE CustomerID = @CustomerID
END;
GO

-- =============================================
-- Zadanie 6
-- =============================================

CREATE TABLE SalesLT.ProductInventory (
    ProductID INT,
    Amount INT
);
GO

CREATE OR ALTER PROCEDURE dbo.AddNewProduct
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
GO

-- =============================================
-- Zadanie 7
-- =============================================

-- To zadanie jest niemożliwe do zrobienia, bo zmienna tabelaryczna nie jest w obrębie procedury, więc w środku niej nie istnieje