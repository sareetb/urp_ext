import os
import subprocess
import yaml
from flask import Flask, request

app = Flask(__name__)

@app.route("/", methods=["GET"])
def up():
    return ("server up", 200)

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

@app.route("/get-dashboard-url", methods=["GET"])
def get_dashboard_url():
    with open("config.yaml", 'r') as f:
        config_data = yaml.load(f, Loader=yaml.FullLoader)
        dashboard_data = config_data.get('dashboard')
    
    dashboard_url = dashboard_data.get('url')
    if dashboard_url:
        return (dashboard_url, 200)
    
    else:
        return ("Dashboard URL doesn't exist", 400)


if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=int(os.environ.get("PORT", 8080)))