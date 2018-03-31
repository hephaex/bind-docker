# bind docker

## Get start & Installiation
 On Dockerhub, https://hub.docker.com/hephaex/bind pre-builded the images of bind.
> $ docker pull hephaex/bind

Alternatively way, you shall be build the image do yourself.

> $ docker build -t [you docker hub ID]/bind github.com/hephaex/bind-docker

## Quick start

the BIND preserve its state across container shutdown and startup, you should mount a volume at /data. this example use "/var/docker/shard/bind".

> $ mkdir -p /var/docker/shared/bind
> $ chcon -Rt svirt_sandbox_file_t /var/docker/shared/bind~

```
docker run --name bind -it --rm \
  --publish 53:53/tcp \
  --publish 53:53/udp \
  --publish 10000:10000/tcp \
  --volume /var/docker/shared/bind:/data \
  hephaex/bind \
  -h Persistence
```
