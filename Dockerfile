FROM camptocamp/puppet-agent:1.3.0-1jessie

MAINTAINER raphael.pinson@camptocamp.com

RUN apt-get update \
  && apt-get install -y puppetdb-termini cron git \
                        bundler s3cmd \
                        libaugeas-dev libreadline-dev pkg-config \
  && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/acidprime/puppet-catalog-diff.git /etc/puppetlabs/code/environments/production/modules/catalog_diff

VOLUME /reports

COPY scripts/catalog_diff /usr/local/bin/
COPY ./docker-entrypoint.sh /
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
COPY ./known_hosts /etc/ssh/ssh_known_hosts

ENTRYPOINT [ "/docker-entrypoint.sh", "cron" ]
CMD [ "-f" ]
