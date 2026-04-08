-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

-- https://github.com/filarskikacper/ZaawansowaneBazyDanych

-- =============================================
-- Zadanie 2
-- =============================================

ALTER TABLE [236817].[Customer]
ADD
SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL DEFAULT SYSUTCDATETIME(),
SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
GO

ALTER TABLE [236817].[Customer]
SET
(SYSTEM_VERSIONING = ON (HISTORY_TABLE = [236817].[CustomerHistory]))
GO

-- =============================================
-- Zadanie 3
-- =============================================

UPDATE [236817].[Customer]
SET FirstName = FirstName + 'AAA'
WHERE CustomerID IN (SELECT TOP 10 CustomerID FROM [236817].[Customer] ORDER BY CustomerID ASC)
GO

UPDATE [236817].[Customer]
SET FirstName = FirstName + 'BBB'
WHERE CustomerID IN (SELECT TOP 10 CustomerID FROM [236817].[Customer] ORDER BY CustomerID ASC)
GO

UPDATE [236817].[Customer]
SET FirstName = FirstName + 'CCC'
WHERE CustomerID IN (SELECT TOP 10 CustomerID FROM [236817].[Customer] ORDER BY CustomerID ASC)
GO

INSERT INTO [236817].[Customer] 
(NameStyle, FirstName, LastName, EmailAddress, PasswordHash, PasswordSalt, rowguid, ModifiedDate)
VALUES 
(0, 'Adam', 'Kowalski', 'adam.k@example.com', 'L/RxeMACnEh1', '1Kj=', NEWID(), GETDATE()),
(0, 'Ewa', 'Kaczmarek', 'ewa.k@example.com', 'L/RxeMACnEh2', '2Kj=', NEWID(), GETDATE()),
(0, 'Piotr', 'Krawczyk', 'piotr.k@example.com', 'L/RxeMACnEh3', '3Kj=', NEWID(), GETDATE()),
(0, 'Anna', 'Kruk', 'anna.k@example.com', 'L/RxeMACnEh4', '4Kj=', NEWID(), GETDATE()),
(0, 'Michał', 'Kwiatkowski', 'michal.k@example.com', 'L/RxeMACnEh5', '5Kj=', NEWID(), GETDATE());
GO

-- =============================================
-- Zadanie 4
-- =============================================

-- Zmodyfikowałem wcześniej wszystkie 10 rekordów, także wyświetlam 40 (10 rekordów po 4 wersje)

SELECT TOP 40 *FROM [236817].[Customer] FOR SYSTEM_TIME ALL
ORDER BY CustomerID, SysStartTime DESC
GO

-- =============================================
-- Zadanie 5
-- =============================================

SELECT MIN(SysStartTime)
FROM [236817].[Customer]
GO

SELECT *
FROM [236817].[Customer]
FOR SYSTEM_TIME AS OF '2026-04-08 10:40:13'
GO

-- =============================================
-- Zadanie 6
-- =============================================

CREATE XML SCHEMA COLLECTION ProductAttributesSchema AS N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Attributes">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Weight" type="xs:decimal" minOccurs="0" />
        <xs:element name="Color" type="xs:string" minOccurs="0" />
        <xs:element name="Material" type="xs:string" minOccurs="0" />
        <xs:element name="Name" type="xs:string" minOccurs="0" />
        <xs:element name="WarrantyMonths" type="xs:integer" minOccurs="0" />
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'
GO

CREATE TABLE [SalesLT].[ProductAttribute](
    ProductAttributeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Attributes XML(ProductAttributesSchema) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES [SalesLT].[Product](ProductID)
)
GO

-- =============================================
-- Zadanie 7
-- =============================================

INSERT INTO [SalesLT].[ProductAttribute] (ProductID, Attributes)
VALUES 
(
    680,
    N'<Attributes>
        <Weight>1016.04</Weight>
        <Color>Black</Color>
        <Material>Aluminum</Material>
        <Name>HL Road Frame</Name>
        <WarrantyMonths>12</WarrantyMonths>
    </Attributes>'
),
(
    706,
    N'<Attributes>
        <Weight>1016.04</Weight>
        <Color>Red</Color>
        <Material>Aluminum</Material>
        <Name>HL Road Frame</Name>
        <WarrantyMonths>12</WarrantyMonths>
    </Attributes>'
),
(
    707,
    N'<Attributes>
        <Weight>0</Weight>
        <Color>Red</Color>
        <Material>Aluminum</Material>
        <Name>Sport-100 Helmet</Name>
        <WarrantyMonths>12</WarrantyMonths>
    </Attributes>'
),
(
    708,
    N'<Attributes>
        <Weight>0</Weight>
        <Color>Black</Color>
        <Material>Aluminum</Material>
        <Name>Sport-100 Helmet</Name>
        <WarrantyMonths>12</WarrantyMonths>
    </Attributes>'
),
(
    709,
    N'<Attributes>
        <Weight>0</Weight>
        <Color>WHITE</Color>
        <Material>Cotton</Material>
        <Name>Mountain Bike Socks</Name>
        <WarrantyMonths>12</WarrantyMonths>
    </Attributes>'
)

-- =============================================
-- Zadanie 8
-- =============================================

UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('
    replace value of (/Attributes/Color)[1]
    with concat("K", (/Attributes/Color)[1])
')
WHERE Attributes.exist('/Attributes/Color') = 1
GO

UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('
    replace value of (/Attributes/Material)[1]
    with concat("K", (/Attributes/Material)[1])
')
WHERE Attributes.exist('/Attributes/Material') = 1
GO

UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('
    replace value of (/Attributes/Name)[1]
    with concat("K", (/Attributes/Name)[1])
')
WHERE Attributes.exist('/Attributes/Name') = 1
GO

SELECT ProductID, Attributes
FROM [SalesLT].[ProductAttribute]
GO

-- =============================================
-- Zadanie 9
-- =============================================

DECLARE @ProductJSON NVARCHAR(MAX) = N'{
    "Weight": 1016.04,
    "Color": "Black",
    "Material": "Aluminum",
    "Name": "HL Road Frame",
    "WarrantyMonths": 12
}'

SET @ProductJSON = JSON_MODIFY(@ProductJSON, '$.WarrantyMonths', 236817)

SELECT @ProductJSON
GO