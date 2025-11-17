/******************************************
	Index Usage Stats
*******************************************/

SELECT	OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
			 I.[NAME] AS [INDEX NAME], 
			 i.type_desc,
			 USER_SEEKS, 
			 USER_SCANS, 
			 USER_LOOKUPS, 
			 USER_UPDATES 
	FROM     SYS.DM_DB_INDEX_USAGE_STATS AS S 
			 INNER JOIN SYS.INDEXES AS I 
			   ON I.[OBJECT_ID] = S.[OBJECT_ID] 
				  AND I.INDEX_ID = S.INDEX_ID 
	WHERE    OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1 
AND S.[OBJECT_ID]=OBJECT_ID('dbo.Reservation_Fulfillment_History_Dim')
