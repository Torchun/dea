# dea
DevOps tools for local development 

### Add IP routes to router's DNS records, or add domain names to `/etc/hosts` @ client OS (laptop?), e.g.:
```
192.168.1.45	dea
192.168.1.45	nexus.dea
192.168.1.45	gitlab.dea
192.168.1.45	prometheus.dea
192.168.1.45	node-exporter.dea
192.168.1.45	cadvisor.dea
192.168.1.45	grafana.dea
192.168.1.45	postgres.dea
192.168.1.45	pgadmin.dea
192.168.1.45	minio.dea
192.168.1.45	minio-metrics.dea
192.168.1.45	jupyter.dea
192.168.1.45	carto.dea

```

### Create nessessary directories @ server, in same directory as `docker-compose.yaml` will be placed:
```
mkdir -p ./nginx/conf.d

mkdir -p ./gitlab/config
mkdir -p ./gitlab/logs
mkdir -p ./gitlab/data

mkdir -p ./nexus/data # ensure "chown -R 200:200 ./nexus/data"
chown -R 200:200 ./nexus/data

mkdir -p ./prometheus/data
# copy alerts.yml and prometheus.yml to ./prometheus before changing ownership
chown -R 65534:65534 ./prometheus

mkdir -p ./grafana/data
mkdir -p ./grafana/provisioning/datasources/
mkdir -p ./grafana/dashboards
chown -R 472:0 ./grafana/data
chown -R 472:0 ./grafana/provisioning
chown -R 472:0 ./grafana/dashboards
chown -R 472:0 ./grafana/dashboard.yaml

mkdir -p ./postgres/data
mkdir -p ./postgres/exporter
mkdir -p ./postgres/init

mkdir -p ./pgadmin
chown -R 5050:0 ./pgadmin

mkdir -p ./minio

mkdir -p ./jupyter/notebooks
chown -R 1000:100 ./jupyter

mkdir -p ./carto/12/main
chmod 750 ./carto/12
chmod 750 ./carto/12/main # fill with data as instructed below
chown -R 103:105 ./carto
```

### CartoDB data
```
docker create --name cartodb_pgdata sverhoeven/cartodb
# Change to directory to save the Postgresql data dir (cartodb_pgdata) of the CartoDB image
docker cp cartodb_pgdata:/var/lib/postgresql $PWD/cartodb_pgdata
docker rm -f cartodb_pgdata
```
