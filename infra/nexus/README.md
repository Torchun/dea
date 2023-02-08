### Add certs to access `nexus.dea` with docker
```
sudo mkdir -p /etc/docker/certs.d/nexus.dea
cd /etc/docker/certs.d/
keytool -printcert -sslserver nexus.dea -rfc | sudo tee nexus.dea/ca.crt
sudo ln -s /etc/docker/certs.d/nexus.dea nexus.dea:443
```
And now try to pull image:
```
docker login nexus.dea
docker pull nexus.dea/hub.docker.com/busybox
```
