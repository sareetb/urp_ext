#!/bin/bash
ads_queries=$1
bq_queries=$2
ads_yaml=$3
echo ${GOOGLE_CLOUD_PROJECT}
echo $GOOGLE_CLOUD_PROJECT
storage_path=gs://${GOOGLE_CLOUD_PROJECT}-urp

gaarf $ads_queries -c=$storage_path/config.yaml --ads-config=$storage_path/$ads_yaml
python3 conv_lag_adjustment.py -c=config.yaml
gaarf-bq $bq_queries/views_and_functions/*.sql -c=config.yaml
gaarf-bq $bq_queries/snapshots/*.sql -c=config.yaml
gaarf-bq $bq_queries/*.sql -c=config.yaml
gaarf-bq $bq_queries/legacy_views/*.sql  -c=config.yaml

