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
use_proto_plus: 'True'
" >> google-ads.yaml

echo "Writing google-ads.yaml file to cloud storage bucket..."
gcloud alpha storage cp ./google-ads.yaml gs://${GOOGLE_CLOUD_PROJECT}-urp

echo "Editing config.yaml file..."
sed -i 's/YOUR-BQ-PROJECT/'${GOOGLE_CLOUD_PROJECT}'/g' config.yaml.template
sed 's/MCC-ID/'${MCC_ID}'/g' config.yaml.template >> config.yaml

echo "Storing config.yaml in cloud storage..."
gcloud alpha storage cp ./config.yaml gs://${GOOGLE_CLOUD_PROJECT}-urp