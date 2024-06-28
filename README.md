# nginx-certbot

## Getting started

### Build
```
docker build -t nginx-certbot .
```

### Run container
Run container in _daemon_ mode (see below for _ENVIRONMENTS_ details):
```sh
docker run -d --restart always -p80:80 -p443:443 --name nginx-certbot -e CERTBOT_EMAIL_FROM_ADDRESS=valentino.lauciani@ingv.it -e HOST_SMTP=ssmail.rm.ingv.it -e CERTBOT_ENABLE_RENEW=1 -e CERTBOT_CA_HOST=https://acme.sectigo.com/v2/OV -v $(pwd)/volumes/etc/letsencrypt:/etc/letsencrypt nginx-certbot
```

_ONLY FIRST TIME_ you need to register ACME account into the _nginx-certbot_ running container:
```sh
docker exec -it nginx-certbot certbot register --server https://acme.sectigo.com/v2/OV --email <email> --eab-kid <eab-kid> --eab-hmac-key <eab-hmac-key>
```

Get certificate, install it and _automatically_ restart _Nginx_ (the `server_name` into _nginx_ configuration, must be the same used in `--domain`):
```sh
docker exec -it nginx-certbot certbot --nginx --non-interactive --server https://acme.sectigo.com/v2/OV -v --cert-name <cert_name> --domain <domain>
```

### Environment variable
With _environment_ variables you can set:
1. `CERTBOT_ENABLE_RENEW=1` (default `0`): execute every 12h
2. `CERTBOT_ENABLE_RENEW_SEND_EMAIL=1` (default `0`): used to send en e-mail on each renew
3. `HOST_SMTP=smtp.test.com` (default _not set_): It is used to set SMTP host to send an email at each _renew_; Works only on port `25`.
4. `CERTBOT_EMAIL_FROM_ADDRESS=mario.rossi@test.it` (default _not set_): Set the sender
5. `CERTBOT_CA_HOST=https://acme.sectigo.com/v2/OV` (default `https://acme.sectigo.com/v2/OV`): Set CA Remote server

### _Manual_ operations

#### renew certificate
```
docker exec -it nginx-certbot certbot renew --server https://acme.sectigo.com/v2/OV -v
```

#### revoke certificate
```
docker exec -it nginx-certbot certbot revoke --server https://acme.sectigo.com/v2/OV -v --cert-name <cert_name>
```

#### delete certificate
```
docker exec -it nginx-certbot certbot delete --server https://acme.sectigo.com/v2/OV -v --cert-name <cert_name>
```
