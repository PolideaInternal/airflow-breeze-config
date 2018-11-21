# Airflow Breeze Config

This repository is intended to be used by https://github.com/PolideaInternal/airflow-system-tests.
It is responsible for configuring Apache Airflow Breeze environment to run system tests in Google Cloud environment in automated way.

For safety reasons it should be stored in Cloud Source Repositories within Google Cloud project where tests are being run.


## Configuring Apache Airflow Breeze environment for system tests

Setting up the environment consists of:

 - `init.sh` file - this script is intended bo executed during staring Airflow Breeze environment. 
   It should set up environment variables and execute additional commands if necessary.
 - providing Google Cloud service account keys - system tests requires several json files with authorization keys.


## Preparing repository for automated Apache Airflow system tests

### 1. Create Service Accounts

The [`github.com/apache/tests/providers/google/cloud/utils/gcp_authenticator.py`](https://github.com/apache/airflow/blob/master/tests/providers/google/cloud/utils/gcp_authenticator.py)
file consists names of JSON files with service accounts keys required by GCP system tests:

```python
GCP_AI_KEY = 'gcp_ai.json'
GCP_AUTOML_KEY = 'gcp_automl.json'
GCP_BIGQUERY_KEY = 'gcp_bigquery.json'
GCP_BIGTABLE_KEY = 'gcp_bigtable.json'
GCP_CLOUD_BUILD_KEY = 'gcp_cloud_build.json'
GCP_CLOUDSQL_KEY = 'gcp_cloudsql.json'
GCP_COMPUTE_KEY = 'gcp_compute.json'
GCP_COMPUTE_SSH_KEY = 'gcp_compute_ssh.json'
GCP_DATACATALOG_KEY = 'gcp_datacatalog.json'
GCP_DATAFLOW_KEY = 'gcp_dataflow.json'
GCP_DATAFUSION_KEY = 'gcp_datafusion.json'
GCP_DATAPROC_KEY = 'gcp_dataproc.json'
GCP_DATASTORE_KEY = 'gcp_datastore.json'
GCP_DLP_KEY = 'gcp_dlp.json'
GCP_FUNCTION_KEY = 'gcp_function.json'
GCP_GCS_KEY = 'gcp_gcs.json'
GCP_GCS_TRANSFER_KEY = 'gcp_gcs_transfer.json'
GCP_GKE_KEY = "gcp_gke.json"
GCP_KMS_KEY = "gcp_kms.json"
GCP_LIFE_SCIENCES_KEY = 'gcp_life_sciences.json'
GCP_MEMORYSTORE = 'gcp_memorystore.json'
GCP_PUBSUB_KEY = "gcp_pubsub.json"
GCP_SECRET_MANAGER_KEY = 'gcp_secret_manager.json'
GCP_SPANNER_KEY = 'gcp_spanner.json'
GCP_STACKDRIVER = 'gcp_stackdriver.json'
GCP_TASKS_KEY = 'gcp_tasks.json'
GCP_WORKFLOWS_KEY = "gcp_workflows.json"
GMP_KEY = 'gmp.json'
G_FIREBASE_KEY = 'g_firebase.json'
GCP_AWS_KEY = 'gcp_aws.json'
```

1. Create service accounts (See [`Creating and managing service accounts`](https://cloud.google.com/iam/docs/creating-managing-service-accounts))
2. Create service accounts keys and store them in `./keys` directory (See[Creating and managing service account keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys))
3. Encrypt them by executing `encrypt_all_files`
4. Commit encrypted keys to the repository
   
### 2. Customize `init.sh` and `configure_gcs.sh` if needed

Script `configure_gcs.sh` is executed before starting Breeze environment. It decrypts service account keys and modifies `init.sh`.

Script `init.sh` is being executed during starting Breeze environment.

###  3. Push repository into Cloud Source Repositories

Add google remote:
```
git remote add google \
https://source.developers.google.com/p/[PROJECT_NAME]/r/airflow-breeze-config
```

Push code to google remote:
```
git push --all google
```

See: [Cloud Source Repositories - Pushing code from an existing repository](https://cloud.google.com/source-repositories/docs/pushing-code-from-a-repository)
