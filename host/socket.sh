#!/usr/bin/env bash

REPO_DIR=/root/y2k
IMAGE_NAME=y2k:latest

$REPO_DIR/host/websocketd \
  --port=80 \
  --binary \
  --header-ws="Sec-WebSocket-Protocol: binary" \
  --origin=y2k.app,www.y2k.app,y2k.pages.dev \
  -- \
  docker run \
    --cpus 1 \
    --memory 128m \
    --network none \
    --log-driver none \
    --rm -i \
    $IMAGE_NAME

# to spawn QEMU processes natively on the host machine instead of via
# individual Docker containers:
# /root/y2k/container/bin/boot.rb /root/y2k/container/hdd /usr/bin/qemu-system-i386
