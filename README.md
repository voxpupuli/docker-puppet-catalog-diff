Puppet Catalog Diff Docker image
=================================

[![Docker Pulls](https://img.shields.io/docker/pulls/camptocamp/puppet-catalog-diff.svg)](https://hub.docker.com/r/camptocamp/puppet-catalog-diff/)
[![Build Status](https://img.shields.io/travis/camptocamp/docker-puppet-catalog-diff/master.svg)](https://travis-ci.org/camptocamp/docker-puppet-catalog-diff)
[![By Camptocamp](https://img.shields.io/badge/by-camptocamp-fb7047.svg)](http://www.camptocamp.com)


# Usage

```shell
docker run -ti camptocamp/puppet-catalog-diff puppet catalog diff --help
```


## `catalog_diff` wrapper

The image comes with a `catalog_diff` wrapper taking environment variables.

```shell
$ docker run -ti -e "MASTER1=puppet.dev" \  # defaults to "puppet"
                 -e "MASTER2=puppet.prod" \ # defaults to $MASTER1
                 -e "ENV1=dev" \            # defaults to "production"
                 -e "ENV2=production" \     # defaults to $ENV1
                 -e "THREADS=6" \           # defaults to 1
                 -e "COMPRESS=yes" \        # optional
                 -e "SYNC=yes" \            # optional
                 -e "USE_PUPPETDB=yes" \
                 --link puppetdb \
                 camptocamp/puppet-catalog-diff catalog_diff
```

## Using jobber

This image is based on [jobber](https://hub.docker.com/r/blacklabelops/jobber/~/dockerfile/) for executing tasks.

This means you can pass environment variables to create cron jobs. For example:

```shell
$ docker run -ti -e ENV2=dev \
                 -e JOB_NAME1=prod_dev_report \
                 -e JOB_COMMAND1="REPORT=/data/my_report.json catalog_diff" \
                 camptocamp/puppet-catalog-diff
```

## Report compression

If `COMPRESS=yes` is passed to the `catalog_diff` script, the report will be compressed using `gzip`.

## S3 synchronization

This image comes with s3cmd installed. If you pass `SYNC=yes` to the `catalog_diff` command, it will send the generated report to S3. The following environment variables are recognized:

* Standard AWS environment variables for access and secret keys
* `S3_BUCKET`
* `S3_DIR`

## Certificates

The `puppet catalog` command uses the standard Puppet certificates in the container. No certificate is included in the container, so Puppet will create one when you run it.

For this reason, it is recommended to mount a certificate signed by your CA in the container when starting it.

Be sure to set the container hostname to the same as the certificate.


## Reports

When using the `catalog_diff` wrapper, generated JSON reports are stored in `/data`. It is recommended to mount a volume there to retrieve the reports.

