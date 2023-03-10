#!/usr/bin/env bash
OLD_DOMAIN='.dea' # like ['nexus.dea', 'gitlab.dea']
OLD_IP='192.168.1.45'
NEW_DOMAIN='.dev' # e.g. ['nexus.dev', 'gitlab.dev']
NEW_IP='192.168.1.70'

### Change IP
TREE=$(grep -rlF $OLD_IP | grep -v `basename $0` | grep -v '.git/')
for j in $TREE
do
  sed -i "s|${OLD_IP}|${NEW_IP}|g" $j
done
###

### Change domain
TREE=$(grep -rlF $OLD_DOMAIN | grep -v `basename $0` | grep -v '.git/')
for j in $TREE
do
  sed -i "s|${OLD_DOMAIN}|${NEW_DOMAIN}|g" $j
done
###

### Generate certs
cd infra/nginx/conf.d/ssl/
openssl genrsa -des3 -out CAPrivate.key 2048
openssl req -x509 -new -nodes -key CAPrivate.key -sha256 -days 3650 -out CAPrivate.pem
openssl genrsa -out MyPrivate.key 2048
openssl req -new -key MyPrivate.key -extensions v3_ca -out MyRequest.csr

cat <<EOF > openssl.ss.cnf
basicConstraints=CA:FALSE
subjectAltName=DNS:*${NEW_DOMAIN}
extendedKeyUsage=serverAuth
EOF

openssl x509 -req -in MyRequest.csr -CA CAPrivate.pem -CAkey CAPrivate.key -CAcreateserial -extfile openssl.ss.cnf -out MyCert.crt -days 3650 -sha256
cp MyCert.crt ${NEW_DOMAIN:1}.crt # ${NEW_DOMAIN:1} means start string from symbol 1 (not 0) == skipping first symbol
cp MyPrivate.key ${NEW_DOMAIN:1}.key

cd -
###

### Fix permissions
cd ./infra
sudo chown -R 200:200 ./nexus/data

sudo chown -R 65534:65534 ./prometheus

sudo chown -R 472:0 ./grafana/data
sudo chown -R 472:0 ./grafana/provisioning
sudo chown -R 472:0 ./grafana/dashboards
sudo chown -R 472:0 ./grafana/dashboard.yaml

sudo chown -R 5050:0 ./pgadmin
cd -
###

echo "Fixed."
exit 0
