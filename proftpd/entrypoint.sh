#!/bin/bash
set -e
CONF_FILE="/etc/proftpd/ftpd.passwd"

# in case docker mounted this is a directory
# this fails as docker mounted dirs can't be delted
#if [ -d "$CONF_FILE" ]; then rmdir /etc/proftpd/ftpd.passwd ; fi
# in case the file doesn't exist
#touch $CONF_FILE

chown root $CONF_FILE
chmod 660  $CONF_FILE

exec "$@"
