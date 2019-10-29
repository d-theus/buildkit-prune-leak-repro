#!/bin/sh

docker kill registry &>/dev/null
docker run -d --rm --name reg registry:2

uname | grep -q Linux
SUDO=$(if [ $? -eq 0 ]; then echo "sudo"; else echo ""; fi)

function build
{
  docker run -it --rm --privileged \
             -v $(pwd)/build.sh:/build.sh \
             -v $(pwd)/ctx:/code \
             -v $(pwd)/.buildkit:/var/lib/buildkit \
             --entrypoint /build.sh \
             moby/buildkit:master
}

function reclaim
{
  docker run -it --rm --privileged \
             -v $(pwd)/reclaim.sh:/reclaim.sh \
             -v $(pwd)/.buildkit:/var/lib/buildkit \
             --entrypoint /reclaim.sh \
             moby/buildkit:master
}

$SUDO rm -rf .buildkit

set -e
build
echo "// random comment 1" >> ctx/index.js
build
echo "// random comment 2" >> ctx/index.js
build

reclaim

docker kill reg

