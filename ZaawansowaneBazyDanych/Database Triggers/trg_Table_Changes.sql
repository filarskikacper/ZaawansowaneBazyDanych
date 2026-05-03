
CREATE TRIGGER trg_Table_Changes
ON DATABASE
FOR ALTER_TABLE, DROP_TABLE, CREATE_TABLE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @data XML = EVENTDATA();
    
    INSERT INTO dbo.DatabaseAuditLog (LoginName, EventType, ObjectName, TSQLCommand)
    VALUES (
        @data.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(100)'),
        @data.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
        @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)'),
        @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
        );
END;