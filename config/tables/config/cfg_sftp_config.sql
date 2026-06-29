CREATE TABLE IF NOT EXISTS workspace.cfg_sch.sftp_config (
    config_id BIGINT,
    enabled BOOLEAN,
    host STRING,
    port BIGINT,
    username STRING,
    secret_scope STRING,
    secret_key STRING,
    remote_path STRING,
    filename_pattern STRING,
    archive_action STRING,
    archive_path STRING,
    volume_path STRING,
    overwrite BOOLEAN,
    max_files BIGINT
)
USING DELTA;
