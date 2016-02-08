FROM camptocamp/puppet-agent:1.3.0-1jessie

MAINTAINER raphael.pinson@camptocamp.com

ADD scripts/catalog_diff /usr/local/bin/catalog_diff
ADD ./entrypoint.sh /entrypoint.sh

RUN apt-get update \
  && apt-get install -y puppetdb-termini cron git \
  && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/acidprime/puppet-catalog-diff.git /etc/puppetlabs/code/environments/production/modules/catalog_diff

VOLUME /reports

ENTRYPOINT [ "/entrypoint.sh" ]
