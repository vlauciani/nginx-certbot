#!/bin/bash
source /opt/env_vars.sh

echo "[$(date +'%Y-%m-%d %H:%M:%S')] - Start"

#
if [ ! -z ${CERTBOT_CA_HOST} ]; then
    SERVER="--server ${CERTBOT_CA_HOST}"
else
    SERVER=""
fi

#
if (( ${CERTBOT_ENABLE_RENEW} == 1 )); then
    certbot renew ${SERVER} -v --no-random-sleep-on-renew --deploy-hook "/certbot_renew_send_email.sh" > /tmp/certbot_renew.log
else 
    echo " CERTBOT_ENABLE_RENEW=${CERTBOT_ENABLE_RENEW}"
fi

echo "[$(date +'%Y-%m-%d %H:%M:%S')] - End"
