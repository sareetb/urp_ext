# App Reporting Pack
***
##### Centralized platform and dashboard for Google Ads App campaign data 

Crucial information on App campaigns is scattered across various places in Google Ads UI which makes it harder to get insights into how campaign and assets perform.
App Reporting Pack fetches all necessary data from Ads API and creates a centralized dashboard showing different aspects of App campaign's performance and settings. All data is stored in BigQuery tables that can be used for any other need the client might have.


## Deliverables

1. A centralized dashboard with deep app campaign and assets performance views
2. The following data tables in BigQuery that can be used independently:

* `asset_performance`
* `creative_excellence`
* `approval_statuses`
* `change_history`
* `performance_grouping_history`
* `ad_group_network_split`
* `geo_performance`
* `cannibalization`

## Prerequisites

1. [A Google Ads Developer token](https://developers.google.com/google-ads/api/docs/first-call/dev-token#:~:text=A%20developer%20token%20from%20Google,SETTINGS%20%3E%20SETUP%20%3E%20API%20Center.)

1. A new GCP project with billing account attached

1. Join this Google group [TODO]

## Setup

1. Create an [OAuth Consent Screen](https://console.cloud.google.com/apis/credentials/consent), make it of type "**External**"

1. Create an [OAuth Credentials](https://console.cloud.google.com/apis/credentials/oauthclient) - **Client ID**, **Client secret** and Google Ads enabled **Refresh Token**.
Follow instructions in [this video](https://www.youtube.com/watch?v=KFICa7Ngzng) OR:
    1. Set Application type to "**Web application**"
    1. Under Authorized redirect URIs, add a line with: https://developers.google.com/oauthplayground
    1. Save and take note of the **Client ID** and **Client Secret** presented to you
    1. Go to [OAuth2 Playground](https://developers.google.com/oauthplayground/#step1&scopes=https%3A//www.googleapis.com/auth/adwords&url=https%3A//&content_type=application/json&http_method=GET&useDefaultOauthCred=checked&oauthEndpointSelect=Google&oauthAuthEndpointValue=https%3A//accounts.google.com/o/oauth2/v2/auth&oauthTokenEndpointValue=https%3A//oauth2.googleapis.com/token&includeCredentials=unchecked&accessTokenType=bearer&autoRefreshToken=unchecked&accessType=offline&forceAprovalPrompt=checked&response_type=code) to generate a refresh token. This link is already pre-populated with the right scope.
    1. On the right side under settings, in "OAuth Client ID" add your client ID and under "OAuth Client secret" add your client secret
    1. Click "Authorize APIs and sign-in with a user that has access to your Google Ads account"
    1. Click "Exchange authorization code for tokens"
    1. Take not of the "Refresh Token"

1. Click the big blue button to deploy:

   [![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run?revision=sso)

1. Choose the Google Cloud Project you created for this tool

1. Select the region where you want to deploy

1. When prompted, paste in your client ID, client secre, refresh token, developer token and MCC ID

1. Wait for the deployment to finish. Once finished you will be given your ***URL***

1. Click on "Run URP" to manually run the queries and create tables for the first time. The queries are then scheduled to run daily automatically

1. Wait a few minutes and click "Create Dashboard". This will create your own private copy of the URP dashboard. Change your dashboard's name and save it's URL or bookmark it.


## Disclaimer
This is not an officially supported Google product.

Copyright 2022 Google LLC. This solution, including any related sample code or data, is made available on an “as is,” “as available,” and “with all faults” basis, solely for illustrative purposes, and without warranty or representation of any kind. This solution is experimental, unsupported and provided solely for your convenience. Your use of it is subject to your agreements with Google, as applicable, and may constitute a beta feature as defined under those agreements. To the extent that you make any data available to Google in connection with your use of the solution, you represent and warrant that you have all necessary and appropriate rights, consents and permissions to permit Google to use and process that data. By using any portion of this solution, you acknowledge, assume and accept all risks, known and unknown, associated with its usage, including with respect to your deployment of any portion of this solution in your systems, or usage in connection with your business, if at all.

