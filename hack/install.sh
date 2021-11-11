#!/bin/bash
set -eux -o pipefail

export DOWNLOADS=/tmp/dl
export BIN=${BIN:-/usr/local/bin}

mkdir -p $DOWNLOADS

ARCHITECTURE=""
HOST_OS="linux"
case $(uname -m) in
    x86_64)                     ARCHITECTURE="amd64" ;;
    arm64)                      ARCHITECTURE="arm64"; HOST_OS="darwin";;
    arm|armv7l|armv8l|aarch64)  dpkg --print-architecture | grep -q "arm64" && ARCHITECTURE="arm64" || ARCHITECTURE="arm" ;;
esac

if [ -z "$ARCHITECTURE" ]; then
      echo "Could not detect the architecture of the system"
      exit 1
fi

for product in $*; do
  ARCHITECTURE=$ARCHITECTURE HOST_OS=$HOST_OS "$(dirname $0)/installers/install-${product}.sh"
done
