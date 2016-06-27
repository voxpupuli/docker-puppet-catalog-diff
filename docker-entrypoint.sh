#!/bin/bash

set -o errexit

DIR=/docker-entrypoint.d

if [[ -d "$DIR" ]]
then
  /bin/run-parts --verbose --regex '\.sh$' "$DIR"
fi

function pipeEnvironmentVariables() {
  local environmentfile="/etc/profile.d/jobber.sh"
  cat > ${environmentfile} <<_EOF_
#!/bin/sh
_EOF_
  sh -c export >> ${environmentfile}
}

if [ "$1" = 'jobberd' ]; then
  pipeEnvironmentVariables
  exec /usr/local/libexec/jobberd
fi

exec "$@"
