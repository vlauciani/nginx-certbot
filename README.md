[![License](https://img.shields.io/github/license/vlauciani/nginx-certbot.svg)](https://github.com/vlauciani/nginx-certbot/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/vlauciani/nginx-certbot.svg)](https://github.com/vlauciani/nginx-certbot/issues)

[![Docker build](https://img.shields.io/badge/docker%20build-from%20CI-yellow)](https://hub.docker.com/r/vlauciani/nginx-certbot)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/vlauciani/nginx-certbot?sort=semver)
![Docker Pulls](https://img.shields.io/docker/pulls/vlauciani/nginx-certbot)

[![CI](https://github.com/vlauciani/nginx-certbot/actions/workflows/docker-image.yml/badge.svg)](https://github.com/vlauciani/nginx-certbot/actions)
[![GitHub](https://img.shields.io/static/v1?label=GitHub&message=Link%20to%20repository&color=blueviolet)](https://github.com/vlauciani/nginx-certbot)


# nginx-certbot

## Getting started

### Run container
Run container in _daemon_ mode (see below for _ENVIRONMENTS_ details):
```sh
docker run -d \
    --restart always \
    -p80:80 \
    -p443:443 \
    --name nginx-certbot \
    -e CERTBOT_EMAIL_FROM_ADDRESS=mario.rossi@test.it \
    -e CERTBOT_EMAIL_TO_ADDRESS=mario.bianchi@test.it \
    -e HOST_SMTP=smtp.example.com \
    -e CERTBOT_ENABLE_RENEW=1 \
    -e CERTBOT_CA_HOST=https://acme-v02.harica.gr/acme/... \
    -v $(pwd)/volumes/etc/letsencrypt:/etc/letsencrypt \
    vlauciani/nginx-certbot
```

_ONLY FIRST TIME_ you need to register ACME account into the _nginx-certbot_ running container:
```sh
docker exec -it nginx-certbot certbot register --server https://acme-v02.harica.gr/acme/... --email <email> --eab-kid <eab-kid> --eab-hmac-key <eab-hmac-key>
```

Get the certificate, install it, and _automatically_ restart _Nginx_ (the `server_name` in the _Nginx_ configuration must match the domain specified with `--domain` option):
```sh
docker exec -it nginx-certbot certbot --nginx --non-interactive --server https://acme-v02.harica.gr/acme/... -v --cert-name <cert_name> --domain <domain>
```

### Environment variable
With _environment_ variables you can set:
1. `CERTBOT_ENABLE_RENEW=1` (default `0`): execute every 12h
2. `CERTBOT_ENABLE_RENEW_SEND_EMAIL=1` (default `0`): used to send en e-mail on each renew
3. `HOST_SMTP=smtp.example.com` (default _not set_): It is used to set SMTP host to send an email at each _renew_; Works only on port `25`.
4. `CERTBOT_EMAIL_FROM_ADDRESS=mario.rossi@test.it` (default _not set_): Set the sender
5. `CERTBOT_EMAIL_TO_ADDRESS=mario.bianchi@test.it` (default _not set_): Set the receiver
6. `CERTBOT_CA_HOST=https://acme-v02.harica.gr/acme/...` (default _not set_): Set CA Remote server

### _Manual_ operations

#### renew certificate
```sh
docker exec -it nginx-certbot certbot renew --server https://acme-v02.harica.gr/acme/... -v
```

#### revoke certificate
```sh
docker exec -it nginx-certbot certbot revoke --server https://acme-v02.harica.gr/acme/... -v --cert-name <cert_name>
```

#### delete certificate
```sh
docker exec -it nginx-certbot certbot delete --server https://acme-v02.harica.gr/acme/... -v --cert-name <cert_name>
```

### Build docker images by _yourself_
Instead of using the _pre_-built docker image, you can build the Docker image by _yourself_:
```sh
docker build -t vlauciani/nginx-certbot .
```

### Use in `docker compose`
Example:
```sh
services:
  nginx: 
    image: vlauciani/nginx-certbot:latest
    restart: always
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./letsencrypt:/etc/letsencrypt
    ports:
      - 443:443
    environment:
      - CERTBOT_ENABLE_RENEW=1
      - CERTBOT_ENABLE_RENEW_SEND_EMAIL=1
      - HOST_SMTP=ssmail.rm.ingv.it
      - CERTBOT_EMAIL_FROM_ADDRESS=mario.rossi@test.it
      - CERTBOT_EMAIL_TO_ADDRESS=mario.bianchi@test.it
      - CERTBOT_CA_HOST=https://acme-v02.harica.gr/acme/...
```

## Contribute
Thanks to your contributions!

Here is a list of users who already contributed to this repository: \
<a href="https://github.com/vlauciani/nginx-certbot/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=vlauciani/nginx-certbot" />
</a>
