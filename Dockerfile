FROM debian:jessie

MAINTAINER raphael.pinson@camptocamp.com

# Install puppet
ENV RELEASE jessie

ENV \
  LANGUAGE=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  LANG=en_US.UTF-8 \

  PUPPET_AGENT_VERSION=1.5.2-1${RELEASE} \
  PUPPETDB_VERSION=4.1.0-1puppetlabs1 \

  PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

RUN apt-get update \
  && apt-get install -y curl locales-all \
  && curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-${RELEASE}.deb \
  && dpkg -i puppetlabs-release-pc1-${RELEASE}.deb \
  && rm -rf /var/lib/apt/lists/*

RUN echo $PUPPETDB_VERSION | grep -q SNAPSHOT && curl https://nightlies.puppetlabs.com/puppetdb/$(echo ${PUPPETDB_VERSION}|sed -E 's/([^-]*)-.*SNAPSHOT(.*)puppetlabs1/\1.SNAPSHOT\2/')/repo_configs/deb/pl-puppetdb-$(echo ${PUPPETDB_VERSION}|sed -E 's/([^-]*)-.*SNAPSHOT(.*)puppetlabs1/\1.SNAPSHOT\2/')-${RELEASE}.list > /etc/apt/sources.list.d/pl-puppetdb-$(echo ${PUPPETDB_VERSION}|sed -E 's/([^-]*)-.*SNAPSHOT(.*)puppetlabs1/\1.SNAPSHOT\2/')-${RELEASE}.list || true

RUN apt-get update \
  && apt-get install -y --force-yes git \
    puppet-agent=$PUPPET_AGENT_VERSION \
    puppetdb-termini=$PUPPETDB_VERSION \
    s3cmd \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

# Configure Puppet
RUN puppet config set certname catalog_diff --section main

# Install catalog-diff module
RUN git clone https://github.com/raphink/puppet-catalog-diff.git /etc/puppetlabs/code/environments/production/modules/catalog_diff

# github_pki
ENV GOPATH=/go
RUN apt-get update && apt-get install -y golang-go git make \
  && go get github.com/dshearer/jobber \
  && useradd jobber_client \
  && make -C /go/src/github.com/dshearer/jobber install \
  && apt-get autoremove -y golang-go git \
  && rm -rf /var/lib/apt/lists/*

VOLUME /data

RUN chsh -s /bin/bash

COPY scripts/catalog_diff /usr/local/bin/
COPY scripts/generate_reportlist.py /
COPY ./docker-entrypoint.sh /
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
COPY ./known_hosts /etc/ssh/ssh_known_hosts

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "jobberd" ]
