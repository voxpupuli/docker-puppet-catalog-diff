FROM debian:jessie

MAINTAINER raphael.pinson@camptocamp.com

# Install puppet
ENV RELEASE=jessie

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

ENV PUPPET_AGENT_VERSION 1.3.4-1${RELEASE}

ENV PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

RUN apt-get update \
  && apt-get install -y curl locales-all \
  && curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-${RELEASE}.deb \
  && dpkg -i puppetlabs-release-pc1-${RELEASE}.deb \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install -y --force-yes git \
    puppet-agent=$PUPPET_AGENT_VERSION \
  && rm -rf /var/lib/apt/lists/*

# Configure Puppet
RUN puppet config set certname catalog_diff --section main

# Install requirements for catalog-diff and friends
RUN apt-get update \
  && apt-get install -y puppetdb-termini cron git \
                        bundler s3cmd \
                        libaugeas-dev libreadline-dev pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Install catalog-diff module
RUN git clone https://github.com/acidprime/puppet-catalog-diff.git /etc/puppetlabs/code/environments/production/modules/catalog_diff

VOLUME /data

COPY scripts/catalog_diff /usr/local/bin/
COPY ./docker-entrypoint.sh /
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
COPY ./known_hosts /etc/ssh/ssh_known_hosts

ENTRYPOINT [ "/docker-entrypoint.sh", "cron" ]
CMD [ "-f" ]
