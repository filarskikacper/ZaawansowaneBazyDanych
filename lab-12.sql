-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

-- w bazie master
CREATE LOGIN [236817] WITH PASSWORD = 'WislawEkstraklasie67!';
GO

-- w bazie sql-adb-s236817-dev-pl
CREATE USER [236817] FOR LOGIN [236817];
GO

-- sprawdzanie uprawnień
EXECUTE AS USER = '236817';

SELECT * FROM fn_my_permissions(NULL, 'SERVER');
GO
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
GO

REVERT;
GO

-- =============================================
-- Zadanie 2
-- =============================================

GRANT CONTROL ON SCHEMA::SalesLT TO [236817];
GO

-- sprawdzanie uprawnień
EXECUTE AS USER = '236817';

SELECT * FROM fn_my_permissions(NULL, 'SERVER');
GO
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
GO
SELECT * FROM fn_my_permissions('SalesLT', 'SCHEMA');
GO

REVERT;
GO

-- =============================================
-- Zadanie 3
-- =============================================

REVOKE CONTROL ON SCHEMA::SalesLT FROM [236817];
GO

GRANT SELECT ON SalesLT.Product TO [236817];
GO

GRANT SELECT (FirstName), UPDATE (FirstName) ON [236817].Customer TO [236817];
GO

-- sprawdzanie uprawnień
EXECUTE AS USER = '236817';

SELECT * FROM fn_my_permissions(NULL, 'SERVER');
GO
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
GO
SELECT * FROM fn_my_permissions('SalesLT', 'SCHEMA');
GO
SELECT * FROM fn_my_permissions('[236817].Customer', 'OBJECT');
GO
SELECT * FROM fn_my_permissions('SalesLT.Product', 'OBJECT');
GO

REVERT;
GO