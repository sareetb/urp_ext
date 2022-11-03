-- Snapshot for a given day for bid and budget
CREATE OR REPLACE TABLE {bq_dataset}.bid_budgets_{date_iso}
AS (
SELECT
    CURRENT_DATE() AS day,
    A.*
FROM {bq_dataset}.bid_budget AS A
);
