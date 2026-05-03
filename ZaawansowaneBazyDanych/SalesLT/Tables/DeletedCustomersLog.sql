CREATE TABLE [SalesLT].[DeletedCustomersLog] (
    [LogID]               INT            IDENTITY (1, 1) NOT NULL,
    [CustomerID]          INT            NOT NULL,
    [FirstName]           NVARCHAR (50)  NULL,
    [LastName]            NVARCHAR (50)  NULL,
    [CompanyName]         NVARCHAR (128) NULL,
    [AttemptedDeleteDate] DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);

