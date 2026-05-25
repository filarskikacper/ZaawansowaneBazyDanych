-- =============================================
-- Kacper
-- Filarski
-- 236817
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

SELECT DISTINCT
pc.Name AS CategoryName,
MIN(p.ListPrice) OVER(PARTITION BY p.ProductCategoryID) AS MinPrice,
MAX(p.ListPrice) OVER(PARTITION BY p.ProductCategoryID) AS MaxPrice,
COUNT(p.ProductID) OVER(PARTITION BY p.ProductCategoryID) AS ProductCount
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID;
GO

-- =============================================
-- Zadanie 2
-- =============================================

-- Tworzymy tabelę z pracownikami i tworzymy ranking według pensji, który dzięki PARTITION BY jest osobny dla każdego działu.

CREATE TABLE #Pracownicy (
    Dzial VARCHAR(50),
    Pracownik VARCHAR(50),
    Pensja DECIMAL(10, 2)
);

INSERT INTO #Pracownicy (Dzial, Pracownik, Pensja)
VALUES 
    ('IT', 'Kowalski', 12000.00),
    ('IT', 'Nowak', 15000.00),
    ('IT', 'Zieliński', 12000.00),
    ('HR', 'Nowicka', 8000.00),
    ('HR', 'Wiśniewski', 9500.00);

SELECT 
    Dzial,
    Pracownik,
    Pensja,
    DENSE_RANK() OVER (PARTITION BY Dzial ORDER BY Pensja DESC) AS MiejsceWDziale
FROM #Pracownicy;
GO

-- =============================================
-- Zadanie 3
-- =============================================

-- Tworzymy tabelę z produktami i przychodami w danym kwartale i dzięki pivotowi możemy stworzyć raport, gdzie podany jest produkt i przychody z niego w poszczególnych kwartałach.
CREATE TABLE #DanePionowe (
    Produkt VARCHAR(50),
    Kwartal VARCHAR(10),
    Przychody DECIMAL(10, 2)
);

INSERT INTO #DanePionowe VALUES 
    ('Buty', 'Q1', 1000.00), 
    ('Buty', 'Q2', 1500.00),
    ('Kurtki', 'Q1', 3000.00), 
    ('Kurtki', 'Q2', 800.00);

SELECT 
    Produkt, 
    [Q1], 
    [Q2]
FROM #DanePionowe
PIVOT (
    SUM(Przychody) 
    FOR Kwartal IN ([Q1], [Q2])
) AS TabelaPivot;
GO

-- Dostajemy dane od klienta z Excela, gdzie miesiące są w kolumnach, więc musimy użyć unpivota, żeby użyć ich w relacyjnej bazie danych.

CREATE TABLE #DanePoziome (
    Produkt VARCHAR(50),
    Styczen DECIMAL(10, 2),
    Luty DECIMAL(10, 2)
);

INSERT INTO #DanePoziome VALUES 
    ('Buty', 500.00, 600.00),
    ('Kurtki', 1200.00, 1800.00);

SELECT 
    Produkt, 
    Miesiac, 
    Sprzedaz
FROM #DanePoziome
UNPIVOT (
    Sprzedaz 
    FOR Miesiac IN (Styczen, Luty)
) AS TabelaUnpivot;
GO

-- =============================================
-- Zadanie 4
-- =============================================

-- Tworzymy dane dla sklepu i dzięki rollupowi liczymy sumy cząstkowe przychodów dla każdego regionu, kategorii i sumy końcowe.
CREATE TABLE #DaneSklepu (
    Region VARCHAR(50),
    Kategoria VARCHAR(50),
    Przychod DECIMAL(10, 2)
);


INSERT INTO #DaneSklepu (Region, Kategoria, Przychod)
VALUES 
    ('Europa', 'Elektronika', 15000.00),
    ('Europa', 'Odziez', 5000.00),
    ('Ameryka', 'Elektronika', 25000.00),
    ('Ameryka', 'Odziez', 12000.00);

SELECT Region, Kategoria, SUM(Przychod) AS CalkowityPrzychod
FROM #DaneSklepu
GROUP BY ROLLUP (Region, Kategoria);
GO
