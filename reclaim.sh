#!/bin/sh

echo; echo "reclaim"

buildkitd &
until buildctl debug workers >/dev/null 2>&1; do sleep 1s; done

buildctl \
  prune \
  --all

sleep 10s

pkill buildkitd

du -sh /var/lib/buildkit/*
