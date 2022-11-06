COLOR='\033[0;36m'
echo -n -e "${COLOR}This is the Service Url: ${SERVICE_URL}"
gcloud scheduler jobs create pubsub daily-data-refresh --schedule="0 4 * * *" --topic=urp-schedules --message-body="{"trigger":true}" --time-zone="Israel"
gcloud iam service-accounts create urp-ext-service-account --display-name "urp-ext-service"
gcloud run services add-iam-policy-binding urp \
   --member=serviceAccount:urp-ext-service-account@fit-sanctum-353111.iam.gserviceaccount.com \
   --role=roles/run.invoker
gcloud pubsub topics create urp-schedules
gcloud projects add-iam-policy-binding fit-sanctum-353111 \
     --member=serviceAccount:service-683864013084@gcp-sa-pubsub.iam.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator
gcloud alpha bq datasets create urp
