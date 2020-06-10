#!/usr/bin/env bash

set -euxo pipefail

# what a mess. https://stackoverflow.com/a/53183593
YOU_ARE_HERE="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# container will be useless unless we bundle the actual OS
test -f "$YOU_ARE_HERE"/hdd/hdd.img

# this image is private on Docker Hub, make sure we're logged in
docker login

docker build -t jakejarvis/y2k:latest --no-cache "$YOU_ARE_HERE"
docker push jakejarvis/y2k:latest
