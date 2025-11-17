SELECT scm.name TableSchema
, tn.[name] AS [Table name]
, ix.[name] AS [Index name]
, SUM(sz.[used_page_count]) * 8 AS [Index size (KB)]
, (SUM(sz.[used_page_count]) * 8)/1024.0/1024.0 AS [Index size (GB)]
FROM sys.dm_db_partition_stats AS sz
INNER JOIN sys.indexes AS ix ON sz.[object_id] = ix.[object_id] 
AND sz.[index_id] = ix.[index_id]
INNER JOIN sys.tables tn ON tn.OBJECT_ID = ix.object_id
INNER JOIN sys.schemas scm on tn.schema_id=scm.schema_id
WHERE tn.OBJECT_ID=object_id('dbo.Reservation_Fulfillment_History_Dim')
GROUP BY scm.name,tn.[name], ix.[name]
ORDER BY tn.[name]
