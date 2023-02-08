### Generate self-signed certificate and key for up to 10 years
```
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /repos/infra/nginx/conf.d/ssl/dea.key -out /repos/infra/nginx/conf.d/ssl/dea.crt
```
* Don't forget to change paths in `conf.d/*.conf` except `conf.d/default.conf`
