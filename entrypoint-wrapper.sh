#!/bin/bash

#
echo "defaults
tls off
logfile ~/.msmtp.log

account default
host ${HOST_SMTP}
port 25
auth off
from ${CERTBOT_EMAIL_FROM_ADDRESS}

" > /etc/msmtprc
chmod 600 /etc/msmtprc

# Export env variables, used from crontab script
env > /opt/env_vars.sh
sed -i 's/^/export /' /opt/env_vars.sh

#
cron && /docker-entrypoint.sh "$@"
