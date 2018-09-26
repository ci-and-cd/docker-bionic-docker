# docker-bionic-docker

Docker for multi-stage docker image build.

Dockerfile [ci-and-cd/docker-bionic-docker on Github](https://github.com/ci-and-cd/docker-bionic-docker)

[cirepo/docker on Docker Hub](https://hub.docker.com/r/cirepo/docker/)

## Use this image as a “stage” in multi-stage builds

```dockerfile

FROM ubuntu:18.04
COPY --from=cirepo/docker:18.06.1-bionic /data/root /

```
