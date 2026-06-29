MERGE INTO workspace.cfg_sch.master_control AS target
USING (
    SELECT 
        col1 AS workflowId,
        col2 AS layer,
        col3 AS sourceTable,
        col4 AS targetTable,
        col5 AS loadType,
        col6 AS archive,
        col7 AS mergeKeys,
        col8 AS colMapping
    FROM VALUES
    (
        'f51e7d02-795f-4d59-bef9-ce62282f39ee',
        'BRONZE',
        '/Volumes/workspace/cfg_sch/ingestion/customer/',
        'workspace.b_sch.customer',
        'APPEND',
        true,
        NULL,
        '{
          "archivePath": "/Volumes/workspace/cfg_sch/ingestion/customer/archive/",
          "columns": [
            {"sourceCol":"customerID","targetCol":"customerID"},
            {"sourceCol":"first_name","targetCol":"first_name"},
            {"sourceCol":"last_name","targetCol":"last_name"},
            {"sourceCol":"email_address","targetCol":"email_address"},
            {"sourceCol":"phone_number","targetCol":"phone_number"},
            {"sourceCol":"address","targetCol":"address"},
            {"sourceCol":"city","targetCol":"city"},
            {"sourceCol":"state","targetCol":"state"},
            {"sourceCol":"country","targetCol":"country"},
            {"sourceCol":"continent","targetCol":"continent"},
            {"sourceCol":"postal_zip_code","targetCol":"postal_zip_code"},
            {"sourceCol":"gender","targetCol":"gender"}
          ]
        }'
    ),
    (
        'f51e7d02-795f-4d59-bef9-ce62282f39ee',
        'SILVER',
        'workspace.b_sch.customer',
        'workspace.s_sch.customer',
        'MERGE',
        false,
        ARRAY('customerID'),
        '{
          "columns": [
            {"sourceCol":"customerID","targetCol":"customerID","dtype":"bigint"},
            {"sourceCol":"first_name","targetCol":"first_name","dtype":"string"},
            {"sourceCol":"last_name","targetCol":"last_name","dtype":"string"},
            {"sourceCol":"email_address","targetCol":"email_address","dtype":"string"},
            {"sourceCol":"phone_number","targetCol":"phone_number","dtype":"string"},
            {"sourceCol":"address","targetCol":"address","dtype":"string"},
            {"sourceCol":"city","targetCol":"city","dtype":"string"},
            {"sourceCol":"state","targetCol":"state","dtype":"string"},
            {"sourceCol":"country","targetCol":"country","dtype":"string"},
            {"sourceCol":"continent","targetCol":"continent","dtype":"string"},
            {"sourceCol":"postal_zip_code","targetCol":"postal_zip_code","dtype":"bigint"},
            {"sourceCol":"gender","targetCol":"gender","dtype":"string"}
          ],
          "nullValidation": ["customerID", "email_address"],
          "dedupList": ["customerID"]
        }'
    ),
    (
        'f51e7d02-795f-4d59-bef9-ce62282f39ee',
        'GOLD',
        'workspace.s_sch.customer',
        'workspace.g_sch.customer',
        'OVERWRITE',
        false,
        NULL,
        '{
          "sourceQuery": "SELECT customerID,first_name,last_name,email_address,country,continent FROM workspace.s_sch.customer"
        }'
    )
) AS source
ON target.workflowId = source.workflowId
AND target.layer = source.layer

WHEN MATCHED THEN
UPDATE SET
    target.sourceTable = source.sourceTable,
    target.targetTable = source.targetTable,
    target.loadType = source.loadType,
    target.archive = source.archive,
    target.mergeKeys = source.mergeKeys,
    target.colMapping = source.colMapping

WHEN NOT MATCHED THEN
INSERT (
    workflowId,
    layer,
    sourceTable,
    targetTable,
    loadType,
    archive,
    mergeKeys,
    colMapping
)
VALUES (
    source.workflowId,
    source.layer,
    source.sourceTable,
    source.targetTable,
    source.loadType,
    source.archive,
    source.mergeKeys,
    source.colMapping
)