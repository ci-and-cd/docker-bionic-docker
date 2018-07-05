# docker-bionic-docker

Docker for multi-stage docker image build.

Dockerfile [ci-and-cd/docker-bionic-docker on Github](https://github.com/ci-and-cd/docker-bionic-docker)

[cirepo/bionic-docker on Docker Hub](https://hub.docker.com/r/cirepo/bionic-docker/)

## Use this image as a “stage” in multi-stage builds

```dockerfile
FROM alpine:3.7
COPY --from=cirepo/bionic-docker:18.05.0~ce~3-0 /data/root /
```
