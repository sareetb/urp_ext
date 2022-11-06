import os
import subprocess
from flask import Flask, request

app = Flask(__name__)

@app.route("/", methods=["POST"])
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

    subprocess.check_call(["./run-docker.sh", "google_ads_queries/*/*.sql", "bq_queries", "/google-ads.yaml"])

    return ("", 204)
@app.route("/test", methods=["POST"])
def test():    
    return "yo yo yo"

if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=int(os.environ.get("PORT", 8080)))