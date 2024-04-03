Use Mod06
GO
WAITFOR (
    RECEIVE 
        CASE
            WHEN validation = 'X' THEN CAST(message_body as XML)
            ELSE NULL
        END AS message_body 
        ,* 
    FROM [dbo].[Notify-Queue]
), TIMEOUT 10000
