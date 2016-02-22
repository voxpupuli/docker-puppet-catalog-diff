#!/bin/bash

if test -n S3_ACCESS_KEY; then
  cat << EOF > /root/.s3cfg
[default]
access_key = ${S3_ACCESS_KEY}
secret_key = ${S3_SECRET_KEY}
EOF
fi
