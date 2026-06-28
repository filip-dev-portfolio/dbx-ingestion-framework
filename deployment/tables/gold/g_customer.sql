CREATE TABLE IF NOT EXISTS workspace.g_sch.customer (
    customerID        BIGINT,
    first_name        STRING,
    last_name         STRING,
    email_address     STRING,
    country           STRING,
    continent         STRING,
    -- Audit columns
    _updated_ts  TIMESTAMP
)
USING DELTA;