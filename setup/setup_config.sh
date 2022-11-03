#!/bin/bash

echo "Setting Project ID: ${GOOGLE_CLOUD_PROJECT}"
gcloud config set project ${GOOGLE_CLOUD_PROJECT}

echo "Editing google-ads.yaml file..."
sed -i 's/MCC-ID/'${MCC_ID}'/' google-ads.yaml
sed -i 's/YOUR-CLIENT-ID/'${OAUTH_CLIENT_ID}'/' google-ads.yaml
sed -i 's/YOUR-CLIENT-SECRET/'${OAUTH_CLIENT_SECRET}'/' google-ads.yaml
sed -i 's/YOUR-REFRESH-TOKEN/'${REFRESH_TOKEN}'/' google-ads.yaml
sed -i 's/DEVELOPER-TOKEN/'${DEVELOPER_TOKEN}'/' google-ads.yaml

echo "Editing config.yaml file..."
sed -i 's/YOUR-BQ-PROJECT/'${GOOGLE_CLOUD_PROJECT}'/g' config.yaml
sed -i 's/MCC-ID/'${MCC_ID}'/g' config.yaml
