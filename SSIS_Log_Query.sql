
SELECT TOP 10 * FROM internal.operations OP (NOLOCK) WHERE object_name='BH_SSIS'
ORDER BY Operation_id DESC

SELECT TOP 20 * FROM SSISDB.[internal].[executions] EX
INNER JOIN SSISDB.internal.operations OP (NOLOCK) ON EX.execution_id=OP.operation_id
WHERE project_name='BH_SSIS'
AND package_name='Fact_Calculated_Charge.dtsx'
ORDER BY execution_id DESC



SELECT EX.execution_id
	, EX.folder_name
	, EX.project_name
	, EX.package_name
	, ET.executable_name
	, ES.execution_path
	, OP.start_time AS PackageStartTime
	, Es.start_time
	, ES.end_time
	, (DATEDIFF(SECOND,ES.start_time,ES.end_time)/60.00) ExecTimeInMin
	, OP.end_time AS PackageEndTime
	, ES.execution_duration
FROM [internal].[executions] EX (NOLOCK)
LEFT JOIN internal.operations OP (NOLOCK) ON OP.operation_id=EX.execution_id
LEFT JOIN [internal].[executable_statistics] ES (NOLOCK) ON ES.execution_id=EX.execution_id
JOIN internal.executables ET (NOLOCK) ON ET.executable_id=ES.executable_id
WHERE EX.execution_id=519657
ORDER BY ES.statistics_id DESC





SELECT OP.operation_id
	, OP.object_name
	, OP.status
	, OP.start_time
	, OP.end_time
	, OPM.message_type
	, OPM.message_time
	, OPM.message
	, OP.process_id
	, OPM.operation_message_id
	, EM.execution_path
FROM internal.operations OP (NOLOCK)
LEFT JOIN internal.operation_messages OPM (NOLOCK) ON OP.operation_id=opm.operation_id
LEFT JOIN [internal].[event_messages] EM (NOLOCK) ON EM.operation_id=OP.operation_id AND OPM.operation_message_id=EM.event_message_id
WHERE OP.operation_id=519657
AND (OPM.message like '%The processing time was%'
		OR OPM.message like '%Elapsed time%')
--AND OPM.message_type=120 --error
ORDER BY OPM.message_time DESC

SELECT * FROM internal.operations OP (NOLOCK)
WHERE OP.operation_id=519657

SELECT * FROM [internal].[event_messages]
WHERE operation_id=519657




SELECT TOP 1 * FROM BHDW.[dbo].[bh_ssis_audit]
WHERE dw_ssis_package_nm='Fact_Calculated_Charge'
ORDER BY ID DESC


SELECT execution_path
, message_time	
, CASE WHEN SearchFlag=1 THEN CONVERT(varchar, DATEADD(ms, ( CONVERT(numeric,Duration) % 86400 ) * 1000, 0), 114)
	ELSE CONVERT(varchar,Duration) END AS [Duration]
, [message]	
, PackageStartTime
, PackageEndTime
FROM (
SELECT OP.start_time as PackageStartTime
	, EM.execution_path
	, OPM.message_time
	, CASE WHEN OPM.message LIKE '%The processing time was%' THEN 
		SUBSTRING(OPM.message,CHARINDEX('The processing time was',OPM.message)+24,CHARINDEX(' seconds',OPM.message)-(CHARINDEX('The processing time was',OPM.message)+24))
	 WHEN OPM.message LIKE '%Elapsed time%' THEN  
	 SUBSTRING(OPM.message,CHARINDEX('Elapsed time',OPM.message)+14,12)
	 END Duration
	, CASE WHEN  OPM.message like '%The processing time was%' THEN 1 WHEN OPM.message like '%Elapsed time%' THEN 2 END SearchFlag
	, OPM.message
	, OP.end_time as PackageEndTime
FROM SSISDB.internal.operations OP (NOLOCK)
LEFT JOIN SSISDB.internal.operation_messages OPM (NOLOCK) ON OP.operation_id=opm.operation_id
LEFT JOIN SSISDB.[internal].[event_messages] EM (NOLOCK) ON EM.operation_id=OP.operation_id AND OPM.operation_message_id=EM.event_message_id
WHERE OP.operation_id=519204 ---519657
AND (OPM.message like '%The processing time was%'
		OR OPM.message like '%Elapsed time%')
--AND OPM.message_type=120 --error
) x
ORDER BY message_time DESC






SELECT TOP 10 * FROM [internal].[operation_os_sys_info]
where operation_id=521054
--SELECT top 10 * FROM internal.operations (NOLOCK)
--where operation_id=521089

--SELECT * FROM internal.executables 
--where executable_id=130984


SELECT * FROM [internal].[execution_parameter_values]
WHERE execution_id=520932

SELECT * FROM [internal].[event_messages]
WHERE operation_id=520932
SELECT * FROM [catalog].[event_messages]
WHERE operation_id=520932
SELECT * FROM [internal].[event_message_context]
WHERE operation_id=520932




SELECT     opmsg.[operation_message_id] as [event_message_id],
           opmsg.[operation_id], 
           opmsg.[message_time],
           opmsg.[message_type],
           opmsg.[message_source_type],  
           opmsg.[message], 
           opmsg.[extended_info_id],
           eventmsg.[package_name],
           eventmsg.[event_name],
           
           message_source_name = 
                      CASE 
                        WHEN (opmsg.message_source_type = 10) THEN 'ISServerExec' 
                        WHEN (opmsg.message_source_type = 20) THEN 'Transact-SQL stored procedure'
                        ELSE eventmsg.message_source_name
                    END,
           eventmsg.[message_source_id],
           eventmsg.[subcomponent_name],
           eventmsg.[package_path],
           eventmsg.[execution_path],
           eventmsg.[threadID],
           eventmsg.[message_code]
FROM       [internal].[operation_messages] opmsg 
		LEFT JOIN [internal].[event_messages] eventmsg
           ON opmsg.[operation_message_id] = eventmsg.[event_message_id]
WHERE      opmsg.[operation_id] =520932

--in (SELECT [id] FROM [internal].[current_user_readable_operations])
--AND opmsg.[operation_id]=520932
