CREATE TABLE IF NOT EXISTS workspace.cfg_sch.workflow_log (
    logId BIGINT GENERATED ALWAYS AS IDENTITY,
    errorType STRING,
    affectedCols STRING,
    workflowId STRING,
    jobRunId STRING,
    eventTimestamp TIMESTAMP
)
USING DELTA;