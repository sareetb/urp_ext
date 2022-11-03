FROM python:3.8
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD google_ads_queries/ google_ads_queries/
ADD bq_queries/ bq_queries/
ADD scripts/ .
ADD google-ads.yaml .
ADD config.yaml
RUN chmod a+x run-docker.sh
ENTRYPOINT ["./run-docker.sh"]
CMD ["google_ads_queries/*/*.sql", "bq_queries", "google-ads.yaml"]
