-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

BEGIN TRAN;

UPDATE SalesLT.Product
SET ListPrice = ListPrice + 5
WHERE ProductID = 680;

WAITFOR DELAY '00:00:30';

UPDATE SalesLT.SalesOrderDetail
SET UnitPrice = UnitPrice + 1
WHERE ProductID = 680;

COMMIT;

BEGIN TRAN;

UPDATE SalesLT.SalesOrderDetail
SET UnitPrice = UnitPrice + 1
WHERE ProductID = 680;

WAITFOR DELAY '00:00:30';

UPDATE SalesLT.Product
SET ListPrice = ListPrice + 5
WHERE ProductID = 680;

COMMIT;
GO

-- Gdy wykonamy ten kod w dwóch równoległych sesjach to tabela stanie się niedostępna, ponieważ obie sesje będą próbowały zablokować te same wiersze.
-- Będą czekać na siebie nawzajem i żadna z nich nie będzie mogła kontynuować, co prowadzi do deadlocka.

-- =============================================
-- Zadanie 2
-- =============================================

BEGIN TRAN;

INSERT INTO [236817].Customer (FirstName, LastName, PasswordHash, PasswordSalt, CompanyName, EmailAddress, Phone)
    VALUES 
    ('Test', 'Testowy1', 'hash1', 'salt1', 'Firma1', 'lol1@lol.com', '111-111-111'),
    ('Test', 'Testowy2', 'hash2', 'salt2', 'Firma2', 'lol2@lol.com', '222-222-222'),
    ('Test', 'Testowy3', 'hash3', 'salt3', 'Firma3', 'lol3@lol.com', '333-333-333'),
    ('Test', 'Testowy4', 'hash4', 'salt4', 'Firma4', 'lol4@lol.com', '444-444-444'),
    ('Test', 'Testowy5', 'hash5', 'salt5', 'Firma5', 'lol5@lol.com', '555-555-555'),
    ('Test', 'Testowy6', 'hash6', 'salt6', 'Firma6', 'lol6@lol.com', '666-666-666'),
    ('Test', 'Testowy7', 'hash7', 'salt7', 'Firma7', 'lol7@lol.com', '777-777-777'),
    ('Test', 'Testowy8', 'hash8', 'salt8', 'Firma8', 'lol8@lol.com', '888-888-888'),
    ('Test', 'Testowy9', 'hash9', 'salt9', 'Firma9', 'lol9@lol.com', '999-999-999'),
    ('Test', 'Testowy10', 'hash10', 'salt10', 'Firma10', 'lol10@lol.com', '000-000-000');

UPDATE TOP (10) SalesLT.Product
SET ListPrice = ListPrice + 1

TRUNCATE TABLE SalesLT.SalesOrderDetail;

SELECT 'Customer', COUNT(*) AS Licznik 
FROM [236817].Customer
WHERE LastName LIKE 'Testowy%';
SELECT 'SalesOrderDetail', COUNT(*) AS Licznik 
FROM SalesLT.SalesOrderDetail;

ROLLBACK TRAN;
GO

SELECT 'Customer', COUNT(*) AS Licznik 
FROM [236817].Customer 
WHERE LastName LIKE 'Testowy%';
SELECT 'SalesOrderDetail', COUNT(*) AS Licznik 
FROM SalesLT.SalesOrderDetail;
GO

-- =============================================
-- Zadanie 3
-- =============================================

BEGIN TRAN;

INSERT INTO [236817].Customer (FirstName, LastName, PasswordHash, PasswordSalt, CompanyName, EmailAddress, Phone)
    VALUES 
    ('Test', 'Testowy1', 'hash1', 'salt1', 'Firma1', 'lol1@lol.com', '111-111-111'),
    ('Test', 'Testowy2', 'hash2', 'salt2', 'Firma2', 'lol2@lol.com', '222-222-222'),
    ('Test', 'Testowy3', 'hash3', 'salt3', 'Firma3', 'lol3@lol.com', '333-333-333'),
    ('Test', 'Testowy4', 'hash4', 'salt4', 'Firma4', 'lol4@lol.com', '444-444-444'),
    ('Test', 'Testowy5', 'hash5', 'salt5', 'Firma5', 'lol5@lol.com', '555-555-555'),
    ('Test', 'Testowy6', 'hash6', 'salt6', 'Firma6', 'lol6@lol.com', '666-666-666'),
    ('Test', 'Testowy7', 'hash7', 'salt7', 'Firma7', 'lol7@lol.com', '777-777-777'),
    ('Test', 'Testowy8', 'hash8', 'salt8', 'Firma8', 'lol8@lol.com', '888-888-888'),
    ('Test', 'Testowy9', 'hash9', 'salt9', 'Firma9', 'lol9@lol.com', '999-999-999'),
    ('Test', 'Testowy10', 'hash10', 'salt10', 'Firma10', 'lol10@lol.com', '000-000-000');

UPDATE TOP (10) SalesLT.Product
SET ListPrice = ListPrice + 1

TRUNCATE TABLE SalesLT.SalesOrderDetail;

SELECT 'Customer', COUNT(*) AS Licznik 
FROM [236817].Customer
WHERE LastName LIKE 'Testowy%';
SELECT TOP (10) ListPrice
FROM SalesLT.Product
SELECT 'SalesOrderDetail', COUNT(*) AS Licznik 
FROM SalesLT.SalesOrderDetail;

WAITFOR DELAY '00:05:00';

ROLLBACK TRAN;
GO

-- Sesja 2, dzięki NOLOCK można odczytać dane
SELECT 'Customer', COUNT(*) AS Licznik 
FROM [236817].Customer WITH (NOLOCK)
WHERE LastName LIKE 'Testowy%';

SELECT TOP 10 ListPrice
FROM SalesLT.Product WITH (NOLOCK);

SELECT 'SalesOrderDetail', COUNT(*) AS Licznik 
FROM SalesLT.SalesOrderDetail WITH (NOLOCK);

-- =============================================
-- Zadanie 4
-- =============================================

BEGIN TRY 
SELECT TOP 1 ListPrice/0 
FROM SalesLT.Product
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

-- =============================================
-- Zadanie 5 & 6
-- =============================================

-- Usunięcie zamówienia klienta z systemu

-- Wykonujemy operacje:
-- 1. Sprawdzenia czy podane zamówienie istnieje,
-- 2. usunięcia wszystkich powiązanych pozycji z SalesOrderDetail,
-- 3. usunięcia wszystkich powiązanych pozycji z SalesOrderHeader.

-- Możliwe błędy i obsługa:
-- 1. Podanie ID zamówienia, którego nie ma w bazie (THROW),
-- 2. błędy systemowe podczas usuwania danych (CATCH i ROLLBACK).

DECLARE @ZamowienieID INT = 717741; 

BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @ZamowienieID)
        THROW 50001, 'Zamówienie o podanym ID nie istnieje', 1;
    BEGIN TRAN;
        DELETE FROM SalesLT.SalesOrderDetail 
        WHERE SalesOrderID = @ZamowienieID;
        DELETE FROM SalesLT.SalesOrderHeader 
        WHERE SalesOrderID = @ZamowienieID;
    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRAN;
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;