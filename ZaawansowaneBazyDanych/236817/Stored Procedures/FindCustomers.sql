CREATE   PROCEDURE [236817].[FindCustomers]
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