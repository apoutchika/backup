#!/bin/bash

S3_CMD=""

if [[ ! -z ${S3_ACCESS_KEY+x} && ! -z ${S3_SECRET_KEY+x} && ! -z ${S3_PATH+x} ]]; then 
  cat <<EOF > /root/.s3cfg
[default]
host_base = ${S3_HOST_BASE}
host_bucket = ${S3_HOST_BUCKET}
bucket_location = ${S3_REGION}
use_https = ${S3_USE_HTTPS}
access_key = ${S3_ACCESS_KEY}
secret_key = ${S3_SECRET_KEY}
EOF
  S3_CMD="s3cmd sync ${S3_OPS} /data/backup/ ${S3_PATH}"
fi
