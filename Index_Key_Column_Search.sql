/**********************************************
Index key colummns searching
***********************************************/

WITH CTE AS (
 SELECT 
 OBJECT_NAME(i.[object_id]) TableName ,
 i.index_id,
 i.[name] IndexName ,
 c.[name] ColumnName ,
 CASE WHEN ic.is_included_column=0 THEN c.[name] END keyColumnName ,
 CASE WHEN ic.is_included_column=1 THEN c.[name] END InclColumnName ,
 ic.is_included_column ,
 ic.index_column_id
FROM 
 sys.indexes i
 JOIN sys.index_columns ic ON ic.object_id = i.object_id and i.index_id = ic.index_id
 JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE OBJECT_NAME(i.Object_id)='Reservation_Care_Session_Dim'

)
SELECT e.TableName,e.IndexName,index_id
, STUFF(
		(
		SELECT ', '+ keyColumnName
		FROM CTE s
		WHERE s.TableName=e.TableName and s.IndexName = e.indexname
		FOR XML PATH('')
		),1,2,'') AS KeyColumns
, STUFF(
		(
		SELECT ', '+ InclColumnName
		FROM CTE s
		WHERE s.TableName=e.TableName and s.IndexName = e.indexname
		FOR XML PATH('')
		),1,2,'') AS IncludedColumns
FROM CTE e
GROUP BY e.TableName,e.IndexName,index_id
order by 3
