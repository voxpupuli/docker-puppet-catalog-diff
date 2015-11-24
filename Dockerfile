FROM camptocamp/puppet-agent:1.2.7-1wheezy

MAINTAINER raphael.pinson@camptocamp.com

ADD scripts/catalog_diff /usr/local/bin/catalog_diff

RUN puppet module install zack/catalog_diff

VOLUME /reports
