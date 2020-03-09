#!/bin/bash

S3_CMD=""

if [[ ! -z ${BACKUP_S3_ACCESS_KEY+x} && ! -z ${BACKUP_S3_SECRET_KEY+x} && ! -z ${BACKUP_S3_PATH+x} ]]; then 
  cat <<EOF > /root/.s3cfg
[default]
host_base = ${BACKUP_S3_HOST_BASE}
host_bucket = ${BACKUP_S3_HOST_BUCKET}
bucket_location = ${BACKUP_S3_REGION}
use_https = ${BACKUP_S3_USE_HTTPS}
access_key = ${BACKUP_S3_ACCESS_KEY}
secret_key = ${BACKUP_S3_SECRET_KEY}
EOF
  S3_CMD="s3cmd sync ${S3_OPS} /data/backup/ ${BACKUP_S3_PATH}"
fi
