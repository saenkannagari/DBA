SELECT ref.environment_name,ref.environment_folder_name,reference_id
, project_name=pj.name
, folder_name=f.name
,ref.reference_type
FROM SSISDB.[catalog].[environment_references] REF
INNER JOIN SSISDB.[catalog].[projects] PJ ON ref.PROJECT_ID=PJ.PROJECT_ID
INNER JOIN SSISDB.[catalog].[folders] F on PJ.FOLDER_ID=F.FOLDER_ID
WHERE EXISTS (SELECT TOP 1 1FROM SSISDB.[catalog].[object_parameters] PRM WHERE PRM.Project_id=REF.Project_Id
			AND object_name='BH_PureCloud_Load')


SELECT PRM.object_type
, PRM.Parameter_name
, PRM.object_name
, folder_name=f.name
, project_name=pj.name
, PRM.value_type
, Parameter_value=PRM.referenced_variable_name
FROM SSISDB.[catalog].[object_parameters] PRM 
INNER JOIN SSISDB.[catalog].[environment_references] REF ON PRM.Project_id=REF.Project_Id
INNER JOIN SSISDB.[catalog].[projects] PJ ON ref.PROJECT_ID=PJ.PROJECT_ID
INNER JOIN SSISDB.[catalog].[folders] F on PJ.FOLDER_ID=F.FOLDER_ID
WHERE object_name='BH_PureCloud_Load'
--AND f.name='BH_SSIS'
---AND value_type='R'
