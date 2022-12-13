#!/usr/bin/env bash

docker run \
  -d \
  --name "solar-logger" \
  --restart unless-stopped \
  --mount type=bind,source=/usr/local/share/solar-logger,target=/app/db \
  solar-logger
