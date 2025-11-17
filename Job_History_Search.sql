DROP TABLE IF EXISTS #ZZ;

SELECT sysjobhistory.server,
         sysjobs.name
         AS
         job_name,
         CASE sysjobhistory.run_status
           WHEN 0 THEN 'Failed'
           WHEN 1 THEN 'Succeeded'
           ELSE '???'
         END
         AS
         run_status,
         Isnull(Substring(CONVERT(VARCHAR(8), run_date), 1, 4) + '-' +
                       Substring(CONVERT(VARCHAR
                                 (8), run_date), 5, 2) + '-' +
                Substring(CONVERT(VARCHAR(
                          8), run_date), 7, 2), '')
         AS
         [Run DATE],
         Isnull(Substring(CONVERT(VARCHAR(7), run_time+1000000), 2, 2) + ':'
                 +
                       Substring(CONVERT(VARCHAR(7), run_time+1000000), 4, 2
                        )
                +
                ':' +
                Substring(CONVERT(VARCHAR(7), run_time+1000000), 6, 2), '')
         AS
         [Run TIME],
         Isnull(Substring(CONVERT(VARCHAR(7), run_duration+1000000), 2, 2) +
                 ':' +
                       Substring(CONVERT(VARCHAR(7), run_duration+1000000),
                       4,
                       2)
                + ':' +
                Substring(CONVERT(VARCHAR(7), run_duration+1000000), 6, 2),
         ''
         ) AS
         [Duration],
		 run_duration,
         sysjobhistory.step_id,
         sysjobhistory.step_name,
         sysjobhistory.MESSAGE
INTO #ZZ
  FROM   msdb.dbo.sysjobhistory
         INNER JOIN msdb.dbo.sysjobs
           ON msdb.dbo.sysjobhistory.job_id = msdb.dbo.sysjobs.job_id
  ORDER  BY instance_id DESC

DROP TABLE IF EXISTS #final;

WITH cte AS
(
SELECT CONVERT(DATETIME, [Run DATE] + ' ' + [Run TIME] ) JobStepStartTime
, (Substring(CONVERT(VARCHAR(7), run_duration+1000000), 2, 2)*60)*60 ---HOURS TO SECONDS
	+(Substring(CONVERT(VARCHAR(7), run_duration+1000000),4,2)*60) --MINUTES TO SECONDS
	+(Substring(CONVERT(VARCHAR(7), run_duration+1000000), 6, 2)) --SCONDS
	AS DurationSeconds
,* FROM #ZZ
)
SELECT server	
, job_name	
, run_status	
, JobStepStartTime
, dateadd(SECOND,DurationSeconds,JobStepStartTime) JobStepEndTime
, DurationSeconds
, Duration	
, step_id	
, step_name	
, MESSAGE
INTO #final
FROM cte
WHERE [Run DATE]='2024-06-10'
AND job_name='SSIS_BHDW_Tables_Dimensions_fact_Load_4'



SELECT a.step_name
, a.JobStepStartTime
, a.JobStepEndTime
, b.*
FROM #final a
LEFT JOIN #final b ON 
a.JobStepStartTime BETWEEN b.JobStepStartTime  and b.JobStepEndTime
or a.JobStepEndTime between b.JobStepStartTime  and b.JobStepEndTime
where a.job_name='SSIS_BHDW_Tables_Dimensions_fact_Load_4'
and a.step_name='Fact_Load_4 Recreate Indexes on BHDW Tables'
