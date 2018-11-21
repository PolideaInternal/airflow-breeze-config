#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
set -euo pipefail

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#################### Directories #######################################################
export AIRFLOW_BREEZE_KEYS_DIR="${MY_DIR}/keys"

echo "TEST" | gcloud kms encrypt --plaintext-file=- --ciphertext-file=- \
     --location=global --keyring=airflow --key=airflow_crypto_key >/dev/null || \
     (echo "ERROR! You should have KMS Encrypt/Decrypt Role assigned in Google Cloud Platform. Exiting!" && exit 1)

cd "${AIRFLOW_BREEZE_KEYS_DIR}"
FILES=$(ls *.enc 2>/dev/null || true)
echo "Decrypting all files '${FILES}'"
for FILE in ${FILES}
do
  gcloud kms decrypt --plaintext-file "$(basename "${FILE}" .enc)" --ciphertext-file "${FILE}" \
     --location=global --keyring=airflow --key=airflow_crypto_key \
        && echo Decrypted "${FILE}"
done
chmod -v og-rw ./*
