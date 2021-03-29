#!/usr/bin/env bash

/usr/local/bin/websocketd \
  --port=80 \
  --binary \
  --header-ws="Sec-WebSocket-Protocol: binary" \
  --origin=y2k.jarv.is,jarv.is,y2k.jakejarvis.workers.dev \
  -- \
  docker run \
    --cpus 1 \
    --memory 200m \
    --network none \
    --log-driver none \
    --rm -i \
    registry.digitalocean.com/jakejarvis/y2k:latest

# to spawn QEMU processes natively on the host machine instead of via
# individual Docker containers:
# /root/y2k/container/bin/boot.rb /root/y2k/container/hdd /usr/bin/qemu-system-i386
