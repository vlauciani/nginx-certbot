FROM nginx:1.25.4

LABEL maintainer="Valentino Lauciani <valentino.lauciani@ingv.it>"

ENV CERTBOT_ENABLE_RENEW=0
ENV CERTBOT_EMAIL_FROM_ADDRESS=
ENV CERTBOT_EMAIL_TO_ADDRESS=
ENV CERTBOT_ENABLE_RENEW_SEND_EMAIL=0
ENV CERTBOT_CA_HOST=
ENV HOST_SMTP=

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    certbot \
    vim \
    cron \
    procps \
    msmtp \
    python3-certbot-apache \
    python3-certbot-nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set bashrc
RUN echo "alias ll='ls -l'" >> ~/.bashrc

#
COPY entrypoint-wrapper.sh /
COPY certbot_renew_send_email.sh /
COPY certbot_renew.sh /
RUN chmod +x /entrypoint-wrapper.sh /certbot_renew_send_email.sh /certbot_renew.sh

# Crontab for Renew
COPY certbot_cron /etc/cron.d/certbot

# Set new Entrypoint
ENTRYPOINT ["/entrypoint-wrapper.sh"]

# Have to reset CMD since it gets cleared when we set ENTRYPOINT
CMD ["nginx", "-g", "daemon off;"]
