-- Contains dynamics by asset performance grouping status.
CREATE OR REPLACE TABLE {target_dataset}.performance_grouping
AS (
    SELECT
        day,
        M.account_id,
        M.account_name,
        M.currency,
        M.campaign_id,
        M.campaign_name,
        M.campaign_status,
        ACS.campaign_sub_type,
        ACS.app_id,
        ACS.app_store,
        ACS.bidding_strategy,
        ACS.target_conversions,
        ACS.start_date AS start_date,
        M.ad_group_id,
        M.ad_group_name,
        M.ad_group_status,
        PerformanceGrouping.performance_label,
        geos,
        languages,
        COUNT(*) AS N
    FROM `{bq_dataset}.performance_grouping_statuses_*` AS PerformanceGrouping
    LEFT JOIN {bq_dataset}.account_campaign_ad_group_mapping AS M
      ON PerformanceGrouping.ad_group_id = M.ad_group_id
    LEFT JOIN `{bq_dataset}.AppCampaignSettingsView` AS ACS
      ON M.campaign_id = ACS.campaign_id
    LEFT JOIN `{bq_dataset}.GeoLanguageView` AS G
      ON M.campaign_id =  G.campaign_id
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
);
