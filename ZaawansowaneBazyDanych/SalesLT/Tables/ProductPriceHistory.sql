CREATE TABLE [SalesLT].[ProductPriceHistory] (
    [HistoryID]    INT      IDENTITY (1, 1) NOT NULL,
    [ProductID]    INT      NOT NULL,
    [OldListPrice] MONEY    NULL,
    [NewListPrice] MONEY    NULL,
    [ChangeDate]   DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([HistoryID] ASC)
);

