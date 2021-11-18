#!/usr/bin/env bash

set -euxo pipefail

# what a mess. https://stackoverflow.com/a/53183593
YOU_ARE_HERE="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# container will be useless unless we bundle the actual OS
test -f "$YOU_ARE_HERE"/container/hdd/hdd.img

# build the container & tag it locally
docker build -t y2k:latest --squash --no-cache "$YOU_ARE_HERE"
