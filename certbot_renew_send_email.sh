#!/bin/bash

FILE_CERTBOT_RENEW_LOG=/tmp/certbot_renew.log
SUBJECT_EXTEND=""

# --- Parse options ---
while getopts "e:" opt; do
  case $opt in
    e)
      SUBJECT_EXTEND="${OPTARG} - "
      ;;
    *)
      echo "Usage: $0 [-e EXTENDED_SUBJECT]"
      exit 1
      ;;
  esac
done

# --- Log handling ---
if [ ! -f "${FILE_CERTBOT_RENEW_LOG}" ]; then
    FILE_CERTBOT_RENEW_LOG=/dev/null
fi

# --- Email sending ---
if (( CERTBOT_ENABLE_RENEW_SEND_EMAIL == 1 )); then
(
  echo "Subject: ${SUBJECT_EXTEND}Certbot renew - hostname:$(hostname)"
  echo
  cat "${FILE_CERTBOT_RENEW_LOG}"
) | msmtp "${CERTBOT_EMAIL_TO_ADDRESS}"

else
  echo "CERTBOT_ENABLE_RENEW_SEND_EMAIL=${CERTBOT_ENABLE_RENEW_SEND_EMAIL}"
fi
