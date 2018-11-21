#!/usr/bin/env bash
# Script to be run on Google Cloud Build to perform actions required before running
# Apache Airflow system tests in Breeze environment

# decrypt service account keys
./files/airflow-breeze-config/decrypt_all.sh
# add Google Cloud SDK installation to init.sh
cat <<EOT >> files/airflow-breeze-config/init.sh
rm /usr/bin/gcloud || true
rm /opt/airflow/scripts/in_container/run_cli_tool.sh || true
bash <(curl https://sdk.cloud.google.com/) --disable-prompts
export PATH="/root/google-cloud-sdk/bin/:$PATH"
EOT
cat files/airflow-breeze-config/init.sh
