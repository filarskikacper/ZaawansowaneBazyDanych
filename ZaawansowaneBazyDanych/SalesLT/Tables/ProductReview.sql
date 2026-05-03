CREATE TABLE [SalesLT].[ProductReview] (
    [ReviewID]  INT            IDENTITY (1, 1) NOT NULL,
    [ProductID] INT            NOT NULL,
    [Rating]    INT            NULL,
    [Review]    NVARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([ReviewID] ASC),
    CHECK ([Rating]>=(1) AND [Rating]<=(5)),
    FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);

