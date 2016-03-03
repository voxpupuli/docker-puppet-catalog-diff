FROM blacklabelops/jobber:latest

MAINTAINER raphael.pinson@camptocamp.com

# Install puppet
ENV RELEASE=jessie

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

ENV PUPPET_AGENT_VERSION 1.3.4-1${RELEASE}

ENV PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

RUN rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

RUN yum install -y puppet-agent puppetdb-termini s3cmd

RUN gem install bundler

# Configure Puppet
RUN puppet config set certname catalog_diff --section main

# Install catalog-diff module
RUN git clone https://github.com/acidprime/puppet-catalog-diff.git /etc/puppetlabs/code/environments/production/modules/catalog_diff

VOLUME /data

COPY scripts/catalog_diff /usr/local/bin/
COPY scripts/generate_reportlist.py /
COPY ./docker-entrypoint.sh /
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
COPY ./known_hosts /etc/ssh/ssh_known_hosts

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/opt/jobber/docker-entrypoint.sh", "jobberd" ]
