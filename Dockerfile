FROM puppet/puppet-agent

RUN apt-get update \
  && apt-get install -y --force-yes git puppetdb-termini \
  && rm -rf /var/lib/apt/lists/*

# Install catalog-diff module
RUN git clone https://github.com/camptocamp/puppet-catalog-diff.git /etc/puppetlabs/code/environments/production/modules/catalog_diff
