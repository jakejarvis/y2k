#!/usr/bin/env bash

/usr/bin/websocketd \
  --port=80 \
  --binary \
  --header-ws="Sec-WebSocket-Protocol: binary" \
  --origin=y2k.land,www.y2k.land,y2k.jakejarvis.workers.dev \
  -- \
  docker run \
    --cpus 1 \
    --memory 200m \
    --network none \
    --log-driver none \
    --rm -i \
    jakejarvis/y2k:latest

# NOTE: if not using Docker, the command is:
# /root/y2k/backend/bin/boot.rb /root/y2k/backend/hdd /usr/bin/qemu-system-i386
