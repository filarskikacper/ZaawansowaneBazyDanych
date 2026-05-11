CREATE   PROCEDURE dbo.UpdateCustomer
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