#!/bin/sh

docker run --privileged \
           --rm -e DEV_UID=$(id -u) -e DEV_GID=$(id -g) \
           -v /etc/ssl/certs:/etc/ssl/certs:ro \
           -v $(pwd):/usr/local/app andru255/docker-swift $*
