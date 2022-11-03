CREATE OR REPLACE TABLE {bq_dataset}.asset_structure_snapshot_{date_iso}
AS (
SELECT
    CURRENT_DATE() AS date,
    A.*
FROM {bq_dataset}.asset_structure AS A
);
