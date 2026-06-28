CREATE TABLE IF NOT EXISTS workspace.s_sch.customer (
    customerID        BIGINT,
    first_name        STRING,
    last_name         STRING,
    email_address            STRING,
    phone_number      STRING,
    address           STRING,
    city              STRING,
    state             STRING,
    country           STRING,
    continent         STRING,
    postal_zip_code   BIGINT,
    gender            STRING,

    -- Audit columns
    _ingestion_ts     TIMESTAMP,
    _job_run_id     STRING,
    _source_table     STRING
)
USING DELTA;