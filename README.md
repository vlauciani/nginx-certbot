# nginx-certbot

## Getting started

### Build
```
docker build -t nginx-certbot .
```

### Run container
```
docker run -it --rm -p80:80 -p443:443 --name nginx-certbot -v $(pwd)/volumes/etc/letsencrypt:/etc/letsencrypt nginx-certbot
```

(_only first time_) Register account:
```
root@8d7396aa7e00:/# certbot register --server https://acme.sectigo.com/v2/OV --email <email> --eab-kid <eab-kid> --eab-hmac-key <eab-hmac-key>
```

Get certificate and _automatically_ restart _Nginx_:
```
root@8d7396aa7e00:/# certbot --nginx --non-interactive --server https://acme.sectigo.com/v2/OV -v  --domain <domain>
```

## Environment variable
With _environment_ variables you can set:
1. `CERTBOT_ENABLE_RENEW=1` (default `0`): execute every 12h
2. `CERTBOT_ENABLE_RENEW_SEND_EMAIL=1` (default `0`): used to send en e-mail on each renew
3. `HOST_SMTP=smtp.test.com` (default _not set_): It is used to set SMTP host to send an email at each _renew_
4. `CERTBOT_EMAIL_FROM_ADDRESS=valentino.lauciani@ingv.it` (default _not set_): Set the sender
5. `CERTBOT_CA_HOST=https://acme.sectigo.com/v2/OV` (default `https://acme.sectigo.com/v2/OV`): Set CA Remote server

## Example:
```
docker build -t nginx-certbot .

docker run -it --rm -p80:80 -p443:443 --name nginx-certbot -e CERTBOT_EMAIL_FROM_ADDRESS=valentino.lauciani@ingv.it -e HOST_SMTP=ssmail.rm.ingv.it -e CERTBOT_ENABLE_RENEW=1 -e CERTBOT_CA_HOST=https://acme.sectigo.com/v2/OV -v $(pwd)/volumes/etc/letsencrypt:/etc/letsencrypt nginx-certbot
```