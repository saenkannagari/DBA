SELECT 
  session_id
  ,requested_memory_kb
  ,(requested_memory_kb/1024.00)/1024.00 as requested_memory_GB
  ,granted_memory_kb
  ,(granted_memory_kb/1024.00)/1024.00
  ,used_memory_kb
  ,queue_id
  ,wait_order
  ,wait_time_ms
  ,is_next_candidate
  ,pool_id
  ,text
  ,query_plan
FROM sys.dm_exec_query_memory_grants
  CROSS APPLY sys.dm_exec_sql_text(sql_handle)
  CROSS APPLY sys.dm_exec_query_plan(plan_handle)




SELECT 
  pool_id
  ,total_memory_kb
  ,available_memory_kb
  ,granted_memory_kb
  ,used_memory_kb
  ,grantee_count, waiter_count 
  ,resource_semaphore_id
FROM sys.dm_exec_query_resource_semaphores rs



SELECT session_id, wait_type, wait_time, granted_query_memory, text
FROM sys.dm_exec_requests 
  CROSS APPLY sys.dm_exec_sql_text(sql_handle)
WHERE granted_query_memory > 0 
       OR wait_type = 'RESOURCE_SEMAPHORE'
