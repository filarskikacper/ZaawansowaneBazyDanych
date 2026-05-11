CREATE   FUNCTION dbo.isLastNameUnique (
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