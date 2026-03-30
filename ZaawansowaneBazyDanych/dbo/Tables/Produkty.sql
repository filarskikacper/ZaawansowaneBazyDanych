CREATE TABLE [dbo].[Produkty] (
    [ProductID] INT          IDENTITY (1, 1) NOT NULL,
    [Name]      [dbo].[Name] NOT NULL,
    [ListPrice] MONEY        NOT NULL
);

