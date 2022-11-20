import os
import subprocess
import yaml
import urllib.parse
from flask import Flask, request, redirect

_DATASOURCES_DICT = {
    "ds216": ("approval_statuses", "BQ UAC Disapproval"),
    "ds217": ("creative_excellence", "BQ UAC Hygiene"),
    "ds218": ("change_history", "BQ UAC Final Change History"),
    "ds221": ("cannibalization", "BQ UAC Cannibalization"),
    "ds277": ("geo_performance", "BQ UAC Geo Performance"),
    "ds220": ("performance_grouping", "BQ UAC Performance Grouping Changes"),
    "ds219": ("ad_group_network_split", "BQ UAC Network Splits"),
    "ds215": ("asset_performance", "BQ UAC Assets")

}

_REPORT_ID = "f6f81c6c-2da2-4bcc-98ff-58838c8cbba8"
_REPORT_NAME = "New Report"
_DATASET_ID = "urp_target"
_BASE_URL = "https://datastudio.google.com/reporting/create?"
_CONFIG_FILE_PATH = "./config.yaml"


app = Flask(__name__)

@app.route("/", methods=["GET"])
def home():
    """Create a Looker dashboard creation link with the Linking API, and return a button
    that redirects to it."""
    
    with open(_CONFIG_FILE_PATH, 'r') as f:
        config_data = yaml.load(f, Loader=yaml.FullLoader)
        gaarf_data = config_data.get('gaarf')
        bq_data = gaarf_data.get('bq')

    project_id = bq_data.get('project')

    dashboard_url = create_url(_REPORT_NAME, _REPORT_ID, project_id, _DATASET_ID, _DATASOURCES_DICT)
    return f"""<!DOCTYPE html>
                <html>
                    <head>
                        <title>Title of the document</title>
                    </head>
                    <body>
                        <button onclick="window.location.href='{dashboard_url}';">
                            Create Dashboard
                        </button>
                    </body>
                </html>"""


@app.route("/run-urp", methods=["POST"])
def index():
    envelope = request.get_json()
    if not envelope:
        msg = "no Pub/Sub message received"
        print(f"error: {msg}")
        return f"Bad Request: {msg}", 400

    if not isinstance(envelope, dict) or "message" not in envelope:
        msg = "invalid Pub/Sub message format"
        print(f"error: {msg}")
        return f"Bad Request: {msg}", 400

    pubsub_message = envelope["message"]
    print(pubsub_message)
    
    print("Pub/Sub request recieved. Running URP")

    subprocess.check_call(["./run-docker.sh", "google_ads_queries/*/*.sql", "bq_queries", "/google-ads.yaml"])

    return ("", 204)


def create_url(report_name, report_id, project_id, dataset_id, _DATASOURCES_DICT):
    url = _BASE_URL
    for ds_num, ds_data in _DATASOURCES_DICT.items():
        url += create_datasource(project_id, dataset_id, ds_num, ds_data[0], ds_data[1])

    return url[:-1]  # remove last ""&""


def create_datasource(project_id, dataset_id, ds_num, table_id, datasource_name):
    url_safe_name = urllib.parse.quote(datasource_name)

    return (f'ds.{ds_num}.connector=bigQuery'
          f'&ds.{ds_num}.datasourceName={url_safe_name}'
          f'&ds.{ds_num}.projectId={project_id}'
          f'&ds.{ds_num}.type=TABLE'
          f'&ds.{ds_num}.datasetId={dataset_id}'
          f'&ds.{ds_num}.tableId={table_id}&')

    
if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=int(os.environ.get("PORT", 8080)))