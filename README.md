# dea
DevOps tools for local development 

### Add IP routes to router's DNS records, or add domain names to `/etc/hosts` @ client OS (laptop?), e.g.:
```
192.168.1.45	dea
192.168.1.45	nexus.dea
192.168.1.45	gitlab.dea
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
```
