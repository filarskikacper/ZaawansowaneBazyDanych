CREATE   PROCEDURE [236817].[AddCustomer]
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