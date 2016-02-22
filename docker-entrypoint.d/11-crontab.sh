#!/bin/bash

if test -n "$CRON_SCRIPT"; then
  echo "${CRON_SCRIPT}" > /usr/local/bin/catalog_diff_cron
  echo "0 2 * * * root /usr/local/bin/catalog_diff_cron" > /etc/cron.d/catalog_diff
fi
