#!/bin/bash

FILE_CERTBOT_RENEW_LOG=/tmp/certbot_renew.log

if [ ! -f ${FILE_CERTBOT_RENEW_LOG} ]; then
    FILE_CERTBOT_RENEW_LOG=/dev/null
fi

if (( ${CERTBOT_ENABLE_RENEW_SEND_EMAIL} == 1 )); then
(
  echo "Subject: Certbot renew - hostname:$(hostname)"
  echo
  cat /tmp/certbot_renew.log
) | msmtp ${CERTBOT_EMAIL_TO_ADDRESS}
else 
  echo " CERTBOT_ENABLE_RENEW_SEND_EMAIL=${CERTBOT_ENABLE_RENEW_SEND_EMAIL}"
fi
