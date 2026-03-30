CREATE TABLE [SalesLT].[CustomerReturn] (
    [ReturnID]     INT            IDENTITY (1, 1) NOT NULL,
    [SalesOrderID] INT            NOT NULL,
    [ProductID]    INT            NOT NULL,
    [ReturnDate]   DATETIME       DEFAULT (getdate()) NOT NULL,
    [ReturnReason] NVARCHAR (200) NOT NULL,
    [RefundAmount] MONEY          NOT NULL,
    [ResolveFlag]  BIT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_CustomerReturn] PRIMARY KEY CLUSTERED ([ReturnID] ASC),
    CONSTRAINT [FK_CustomerReturn_ProductID] FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID]),
    CONSTRAINT [FK_CustomerReturn_SalesOrder] FOREIGN KEY ([SalesOrderID]) REFERENCES [SalesLT].[SalesOrderHeader] ([SalesOrderID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CustomerReturn_SalesOrderID]
    ON [SalesLT].[CustomerReturn]([SalesOrderID] ASC)
    INCLUDE([ProductID], [ReturnDate], [RefundAmount], [ResolveFlag]);


GO
CREATE NONCLUSTERED INDEX [IX_CustomerReturn_ResolveFlag]
    ON [SalesLT].[CustomerReturn]([ReturnDate] ASC)
    INCLUDE([SalesOrderID], [ProductID], [RefundAmount]) WHERE ([ResolveFlag]=(0));

