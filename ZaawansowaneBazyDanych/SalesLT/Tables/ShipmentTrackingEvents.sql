CREATE TABLE [SalesLT].[ShipmentTrackingEvents] (
    [EventID]      BIGINT        NULL,
    [SalesOrderID] INT           NOT NULL,
    [EventDate]    DATETIME      NOT NULL,
    [Location]     VARCHAR (100) NULL,
    [Status]       VARCHAR (50)  NULL,
    [Notes]        VARCHAR (200) NULL,
    CONSTRAINT [PK_ShipmentTrackingEvents] PRIMARY KEY CLUSTERED ([SalesOrderID] ASC, [EventDate] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_ShipmentTrackingEvents_Status]
    ON [SalesLT].[ShipmentTrackingEvents]([Status] ASC)
    INCLUDE([SalesOrderID], [EventDate], [Location], [Notes]);

