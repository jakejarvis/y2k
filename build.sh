#!/usr/bin/env bash

set -euxo pipefail

# what a mess. https://stackoverflow.com/a/53183593
YOU_ARE_HERE="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# container will be useless unless we bundle the actual OS
test -f "$YOU_ARE_HERE"/container/hdd/hdd.img

# this image is private on DigitalOcean, make sure we're logged in
doctl registry login

docker build -t registry.digitalocean.com/jakejarvis/y2k:latest --squash --no-cache "$YOU_ARE_HERE"
docker push registry.digitalocean.com/jakejarvis/y2k:latest

# on DigitalOcean, old tags need to be purged manually:
#   doctl registry garbage-collection start --force --include-untagged-manifests
#   doctl registry garbage-collection get-active
