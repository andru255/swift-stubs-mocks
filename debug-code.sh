#!/bin/sh


# example:
# ./debug-with-lldb.sh lldb .build/debug/app
# gets a prompt, so:
# (lldb) breakpoint set -f main.swift -l 5
# write: r //to run the program again

# source:
# https://medium.com/engineering-housing/developing-and-debugging-swift-packages-using-swift-package-manager-a7e4a1c65528

docker run -ti --privileged \
           --rm -e DEV_UID=$(id -u) -e DEV_GID=$(id -g) \
           -v /etc/ssl/certs:/etc/ssl/certs:ro \
           -v $(pwd):/usr/local/app andru255/docker-swift:4.0 $*
