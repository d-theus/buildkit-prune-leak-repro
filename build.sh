#!/bin/sh

echo; echo "build"

IMAGE=reg:5000/bk-prune-test
HASH=$(dd if=/dev/urandom count=10 2>/dev/null | sha1sum | awk '{print $1}')

buildkitd &
until buildctl debug workers >/dev/null 2>&1; do sleep 1s; done

cd /code

buildctl du

buildctl \
  build \
  --frontend dockerfile.v0 \
  --local context=. \
  --local dockerfile=.

pkill buildkitd
