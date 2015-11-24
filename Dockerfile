FROM camptocamp/puppet-agent:1.2.7-1wheezy

MAINTAINER raphael.pinson@camptocamp.com

RUN puppet module install zack/catalog_diff


