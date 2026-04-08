CREATE TABLE [SalesLT].[ProductAttribute] (
    [ProductAttributeID] INT                                          IDENTITY (1, 1) NOT NULL,
    [ProductID]          INT                                          NOT NULL,
    [Attributes]         XML(CONTENT [dbo].[ProductAttributesSchema]) NOT NULL,
    PRIMARY KEY CLUSTERED ([ProductAttributeID] ASC),
    FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);

