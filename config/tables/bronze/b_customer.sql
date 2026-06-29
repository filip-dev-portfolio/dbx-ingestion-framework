CREATE TABLE IF NOT EXISTS workspace.b_sch.customer (
    customerID        STRING,
    first_name        STRING,
    last_name         STRING,
    email_address            STRING,
    phone_number      STRING,
    address           STRING,
    city              STRING,
    state             STRING,
    country           STRING,
    continent         STRING,
    postal_zip_code   STRING,
    gender            STRING,

    -- Audit columns
    _ingestion_ts     STRING,
    _job_run_id     STRING,
    _source_table     STRING
)
USING DELTA;