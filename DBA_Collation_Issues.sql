with cte
as
(
 
select table_name,COLUMN_NAME
From information_schema.COLUMNS where COLLATION_NAME ='Latin1_General_CI_AI'
),final
as
 
(
select table_name,COLUMN_NAME
From information_schema.COLUMNS where COLLATION_NAME ='SQL_Latin1_General_CP1_CI_AS'
)
 
select t.column_name,tt.column_name,t.table_name,tt.table_name  from cte t
inner join final tt on t.COLUMN_NAME=tt.COLUMN_NAME
