CREATE TABLE [SalesLT].[PriceLog] (
    [LogID]             INT      IDENTITY (1, 1) NOT NULL,
    [ProductID]         INT      NOT NULL,
    [OldPrice]          MONEY    NULL,
    [AttemptedNewPrice] MONEY    NULL,
    [AttemptDate]       DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);

