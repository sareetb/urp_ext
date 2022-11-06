#!/bin/bash

echo "Setting Project ID: ${GOOGLE_CLOUD_PROJECT}"
gcloud config set project ${GOOGLE_CLOUD_PROJECT}

echo "Enabling Cloud Storage service..."
gcloud services enable storage-component.googleapis.com 

echo "Creating cloud storage bucket..."
gcloud alpha storage buckets create gs://${GOOGLE_CLOUD_PROJECT}-urp --project=${GOOGLE_CLOUD_PROJECT}

echo "Creating google-ads.yaml file..."
echo "
login_customer_id: ${MCC_ID}
client_id: ${OAUTH_CLIENT_ID}
client_secret: ${OAUTH_CLIENT_SECRET}
refresh_token: ${REFRESH_TOKEN}
developer_token: ${DEVELOPER_TOKEN}
use_proto_plus: true
" >> google-ads.yaml

echo "Editing config.yaml file..."
sed -i 's/YOUR-BQ-PROJECT/'${GOOGLE_CLOUD_PROJECT}'/g' config.yaml
sed -i 's/MCC-ID/'${MCC_ID}'/g' config.yaml

echo "Uploading google-ads.yaml file to cloud storage bucket..."
gcloud alpha storage cp ./google-ads.yaml gs://${GOOGLE_CLOUD_PROJECT}-urp

echo "Uploading config.yaml in cloud storage..."
gcloud alpha storage cp ./config.yaml gs://${GOOGLE_CLOUD_PROJECT}-urp

cat ./google-ads.yaml
cat ./config.yaml