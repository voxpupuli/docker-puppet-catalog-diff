FROM camptocamp/puppet-agent:1.2.7-1wheezy

MAINTAINER raphael.pinson@camptocamp.com

ADD scripts/catalog_diff /usr/local/bin/catalog_diff

RUN puppet module install zack/catalog_diff
RUN apt-get update \
  && apt-get install -y cron \
  && rm -rf /var/lib/apt/lists/*

VOLUME /reports

CMD ["cron", "-f"]
