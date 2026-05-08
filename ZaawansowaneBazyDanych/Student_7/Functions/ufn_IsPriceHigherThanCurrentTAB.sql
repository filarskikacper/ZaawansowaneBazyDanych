CREATE FUNCTION Student_7.ufn_IsPriceHigherThanCurrentTAB (
@Products NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN (
SELECT
	CAST(JSON_VALUE(J.value, '$.ProductID') AS INT) AS ProductID,
	CAST(JSON_VALUE(J.value, '$.ListPrice') AS MONEY) AS ListPrice,
	Student_7.ufn_IsPriceHigherThanCurrent(J.value) AS IsHigher
FROM OPENJSON(@Products) AS J
)