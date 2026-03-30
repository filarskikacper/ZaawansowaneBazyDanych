CREATE TABLE [SalesLT].[ProductVendor] (
    [ProductID]       INT   NOT NULL,
    [VendorID]        INT   NOT NULL,
    [StandardPrice]   MONEY NOT NULL,
    [AverageLeadTime] INT   NOT NULL,
    CONSTRAINT [PK_ProductVendor] PRIMARY KEY CLUSTERED ([ProductID] ASC, [VendorID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_ProductVendor_VendorID]
    ON [SalesLT].[ProductVendor]([VendorID] ASC)
    INCLUDE([ProductID], [StandardPrice], [AverageLeadTime]);

