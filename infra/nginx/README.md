### Generate self-signed certificate and key for up to 10 years

##### Generate certificate for \*.domain
`cd /repos/infra/nginx/conf.d/ssl/`

 - Step 1 : Create the CA Private Key
```
openssl genrsa -des3 -out CAPrivate.key 2048
```
 - Step 2: Generate the CA Root certificate
```
openssl req -x509 -new -nodes -key CAPrivate.key -sha256 -days 3650 -out CAPrivate.pem
```
 - Step 3 : Create a Private Key
```
openssl genrsa -out MyPrivate.key 2048
```
 - Step 4 : Generate the CSR
```
openssl req -new -key MyPrivate.key -extensions v3_ca -out MyRequest.csr
```
 - Step 5: Create extensions file to specify subjectAltName
Create an extensions file named: `openssl.ss.cnf`. File Contents of openssl.ss.cnf (replace "\*.dea" with your domain):
```
basicConstraints=CA:FALSE
subjectAltName=DNS:*.dea
extendedKeyUsage=serverAuth
```
 - Step 6: Generate the Certificate using the CSR
```
openssl x509 -req -in MyRequest.csr -CA CAPrivate.pem -CAkey CAPrivate.key -CAcreateserial -extfile openssl.ss.cnf -out MyCert.crt -days 3650 -sha256
```
 - Step 7: Install the Certificate / Private Key on your Web Server / Application
```
cp MyCert.crt dea.crt
cp MyPrivate.key dea.key
```

* Don't forget to change paths in `conf.d/*.conf` except `conf.d/default.conf`
