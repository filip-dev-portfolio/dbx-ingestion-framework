CREATE TABLE IF NOT EXISTS workspace.cfg_sch.master_control (
    workflowId STRING,
    layer STRING,
    sourceTable STRING,
    targetTable STRING,
    loadType STRING,
    archive BOOLEAN,
    mergeKeys ARRAY<STRING>,
    colMapping STRING
)
USING DELTA;