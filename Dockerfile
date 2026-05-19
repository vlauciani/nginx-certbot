#FROM nginx:1.25.4
FROM nginx:1.31.0

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
    logrotate \
    iputils-ping \
    procps \
    msmtp \
    python3-certbot-apache \
    python3-certbot-nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set bashrc
RUN echo "alias ll='ls -l'" >> ~/.bashrc

# Set .vimrc
# Force Vim to write changes in place instead of replacing the file inode (atomic save).
# This is critical when editing files mounted into the container via Docker bind mounts:
# without this setting, Vim may create a new file and rename it, breaking the bind mount
# and causing changes not to propagate correctly between the host and the container.
RUN echo "set backupcopy=yes" >> ~/.vimrc

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
