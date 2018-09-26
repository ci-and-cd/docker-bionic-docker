
FROM cirepo/nix:2.1.1-bionic


ARG IMAGE_ARG_APT_MIRROR
ARG IMAGE_ARG_FILESERVER

ARG IMAGE_ARG_DOCKERCE_VERSION
ARG IMAGE_ARG_DOCKERCOMPOSE_VERSION
ARG IMAGE_ARG_DOCKERMACHINE_VERSION


USER root


COPY --chown=root:root docker /data


## install docker, docker-machine, docker-compose
# Select docker version both supported by rancher and kubernetes
# see: https://docs.rancher.com/rancher/v1.6/en/hosts/#supported-docker-versions
# see: https://github.com/gitlawr/install-docker
# 1.12
#apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
#   && echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | tee /etc/apt/sources.list.d/docker.list \
#   && apt-get update \
#   && apt-cache madison docker-engine \
#   && apt-get -yq install docker-engine=1.12.6-0~ubuntu-xenial
#curl -sSL https://github.com/gitlawr/install-docker/blob/master/1.12.6.sh?raw=true | sh
#
# 17.03
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
#   && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
#   && apt-get update \
#   && apt-cache madison docker-ce \
#   && apt-get -yq --allow-unauthenticated install docker-ce=17.03.1~ce-0~ubuntu-xenial
#curl -sSL https://github.com/gitlawr/install-docker/blob/1.0/17.03.1.sh?raw=true | sh
#
#STABLE (NOT YET AVAILABLE!), please check availabilty before using:
#echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/docker.list
#echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic edge' >> /etc/apt/sources.list.d/docker.list
#echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic nightly' >> /etc/apt/sources.list.d/docker.list
# or
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge"
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) nightly"
# then
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# or
#${ARIA2C_DOWNLOAD} -d /tmp -o docker_ubuntu_gpg https://download.docker.com/linux/ubuntu/gpg && apt-key add /tmp/docker_ubuntu_gpg
RUN set -ex \
    && sed -i "s/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/${IMAGE_ARG_APT_MIRROR:-archive.ubuntu.com}\/ubuntu\//g" /etc/apt/sources.list \
    && groupadd -f docker \
    && apt-key add /data/docker_ubuntu_gpg && rm -f /data/docker_ubuntu_gpg \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge" \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) nightly" \
    && apt-get -y update \
    && apt-cache madison docker-ce \
    && apt-get -yq install docker-ce=${IMAGE_ARG_DOCKERCE_VERSION:-18.06.1~ce~3-0}~ubuntu \
    && apt-get -q -y autoremove \
    && apt-get -q -y clean && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin \
    && if [ ! -f /data/docker-compose-Linux-x86_64 ]; then ${ARIA2C_DOWNLOAD} -d /data -o docker-compose-Linux-x86_64 ${IMAGE_ARG_FILESERVER:-https://github.com}/docker/compose/releases/download/${IMAGE_ARG_DOCKERCOMPOSE_VERSION:-1.21.2}/docker-compose-Linux-x86_64; fi \
    && mv /data/docker-compose-Linux-x86_64 /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && if [ ! -f /data/docker-machine-Linux-x86_64 ]; then ${ARIA2C_DOWNLOAD} -d /data -o docker-machine-Linux-x86_64 ${IMAGE_ARG_FILESERVER:-https://github.com}/docker/machine/releases/download/v${IMAGE_ARG_DOCKERMACHINE_VERSION:-0.14.0}/docker-machine-Linux-x86_64; fi \
    && mv /data/docker-machine-Linux-x86_64 /usr/local/bin/docker-machine \
    && chmod +x /usr/local/bin/docker-machine
