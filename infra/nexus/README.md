### Add certs to access `nexus.dea` with docker
```
sudo mkdir -p /etc/docker/certs.d/nexus.dea
cd /etc/docker/certs.d/
keytool -printcert -sslserver nexus.dea -rfc | sudo tee nexus.dea/ca.crt
sudo ln -s /etc/docker/certs.d/nexus.dea nexus.dea:443
```
##### Configure nexus
 - create new blob "File"
 - create repository, e.g. proxy to dockerhub
 - create role to access docker repositories, e.g. "docker-admin"
 - create user and assign a role
 - enable realms for docker and default role

##### Now try to pull image:
```
docker login nexus.dea
docker pull nexus.dea/hub.docker.com/busybox
```

##### To be able to export metrics:
 - create role to read metrics only, e.g. `metrics-viewer` with privileges of `nx-metrics-all`
 - create user to be used by prometheus, e.g. `prometheus`
 - update credentials in `prometheus/prometheus.yml`:
```
  - job_name: 'nexus'
    basic_auth:
      username: 'prometheus'
      password: 'prometheus'
    static_configs:
      - targets:
          - "localhost:42002/service/metrics/prometheus"
```
