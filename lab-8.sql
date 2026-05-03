-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

CREATE TABLE SalesLT.ProductPriceHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    OldListPrice MONEY,
    NewListPrice MONEY,
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_Product_Price_Change
ON SalesLT.Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO SalesLT.ProductPriceHistory (ProductID, OldListPrice, NewListPrice)
    SELECT
        i.ProductID,
        d.ListPrice AS OldListPrice,
        i.ListPrice AS NewListPrice
        FROM INSERTED i
        JOIN DELETED d ON i.ProductID = d.ProductID
        WHERE ISNULL(d.ListPrice, -1) <> ISNULL(i.ListPrice, -1);
END
GO


-- =============================================
-- Zadanie 2
-- =============================================

CREATE TABLE SalesLT.DeletedCustomersLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    CompanyName NVARCHAR(128),
    AttemptedDeleteDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_Customer_Delete_Attempt
ON [236817].Customer
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO SalesLT.DeletedCustomersLog (CustomerID, FirstName, LastName, CompanyName)
    SELECT
        d.CustomerID,
        d.FirstName,
        d.LastName,
        d.CompanyName
    FROM DELETED d
    WHERE EXISTS (
        SELECT 1
        FROM SalesLT.SalesOrderHeader soh
        WHERE soh.CustomerID = d.CustomerID
    );

    DELETE c
    FROM [236817].Customer c
    JOIN DELETED d ON c.CustomerID = d.CustomerID
    WHERE NOT EXISTS (
        SELECT 1
        FROM SalesLT.SalesOrderHeader soh
        WHERE soh.CustomerID = d.CustomerID
    );
END
GO

-- Nie mogę stworzyć tego triggera, bo mam włączone wersjonowanie tabeli

-- =============================================
-- Zadanie 3
-- =============================================

UPDATE SalesLT.ProductCategory 
SET ParentProductCategoryID = 6
WHERE Name = 'Road Frames';

WITH RecCategory AS (
    SELECT
        ProductCategoryID,
        ParentProductCategoryID,
        Name,
        CAST(Name AS NVARCHAR(MAX)) AS CategoryPath
    FROM SalesLT.ProductCategory
    WHERE ParentProductCategoryID IS NULL
    
    UNION ALL

    SELECT
        pc.ProductCategoryID,
        pc.ParentProductCategoryID,
        pc.Name,
        CAST(rc.CategoryPath + ' -> ' + pc.Name AS NVARCHAR(MAX))
    FROM SalesLT.ProductCategory pc
    JOIN RecCategory rc ON pc.ParentProductCategoryID = rc.ProductCategoryID
)

SELECT CategoryPath
FROM RecCategory
WHERE CategoryPath LIKE 'Bikes%Frames';


-- =============================================
-- Zadanie 4
-- =============================================

CREATE TABLE SalesLT.PriceLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    OldPrice MONEY,
    AttemptedNewPrice MONEY,
    AttemptDate DATETIME DEFAULT GETDATE(),
);
GO

CREATE TRIGGER trg_Price_Attempt
ON SalesLT.Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(ListPrice)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN DELETED d ON i.ProductID = d.ProductID
            WHERE i.ListPrice > (d.ListPrice * 1.20)
            )
        BEGIN
            INSERT INTO SalesLT.PriceLog (ProductID, OldPrice, AttemptedNewPrice)
            SELECT
                i.ProductID,
                d.ListPrice,
                i.ListPrice
            FROM INSERTED i
            JOIN DELETED d ON i.ProductID = d.ProductID
            WHERE i.ListPrice > (d.ListPrice * 1.20);

            UPDATE p
            SET p.ListPrice = d.ListPrice
            FROM SalesLT.Product p
            JOIN DELETED d ON p.ProductID = d.ProductID
            JOIN INSERTED i ON p.ProductID = i.ProductID
            WHERE i.ListPrice > (d.ListPrice * 1.20);
        END
    END
END;
GO

-- =============================================
-- Zadanie 5
-- =============================================

CREATE TABLE dbo.DatabaseAuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EventDate DATETIME DEFAULT GETDATE(),
    LoginName NVARCHAR(100),
    EventType NVARCHAR(100),
    ObjectName NVARCHAR(100),
    TSQLCommand NVARCHAR(MAX)
);
GO

CREATE TRIGGER trg_Table_Changes
ON DATABASE
FOR ALTER_TABLE, DROP_TABLE, CREATE_TABLE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @data XML = EVENTDATA();
    
    INSERT INTO dbo.DatabaseAuditLog (LoginName, EventType, ObjectName, TSQLCommand)
    VALUES (
        @data.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(100)'),
        @data.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
        @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)'),
        @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
        );
END;
GO

-- =============================================
-- Zadanie 6
-- =============================================

CREATE TABLE SalesLT.ProductReview (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Review NVARCHAR(200),
    
    FOREIGN KEY (ProductID) 
    REFERENCES SalesLT.Product(ProductID)
);
GO

INSERT INTO SalesLT.ProductReview (ProductID, Rating, Review)
VALUES 
    (680, 5, 'Lol'),
    (680, 4, '4/5'),
    (706, 2, 'Meh'),
    (712, 5, 'Git');
GO

-- Chcę dostać produkty ze średnią oceną powyżej 3

WITH AvgRatings AS (
    SELECT ProductID, AVG(CAST(Rating as DECIMAL(3,2))) as AvgRating
    FROM SalesLT.ProductReview
    GROUP BY ProductID
)

SELECT p.Name, ar.AvgRating
FROM AvgRatings ar
JOIN SalesLT.Product p ON ar.ProductID = p.ProductID
WHERE ar.AvgRating > 3.0
ORDER BY ar.AvgRating;