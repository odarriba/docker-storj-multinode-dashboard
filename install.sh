#!/bin/sh

set -e

apk add --update --no-cache unzip curl

# Detect architecture
ARCH=""
case $(uname -m) in
  x86_64)
    ARCH="amd64"
    ;;
  armv7l)
    ARCH="arm"
    ;;
  aarch64)
    ARCH="arm64"
    ;;
  *)
    echo "Unknown arch: `uname -m`"
    exit 1
esac

# Download & extract binaries
curl -LO https://github.com/storj/storj/releases/download/v${STORJ_VERSION}/multinode_linux_${ARCH}.zip
curl -LO https://github.com/storj/storj/releases/download/v${STORJ_VERSION}/identity_linux_${ARCH}.zip
unzip multinode_linux_${ARCH}.zip && rm multinode_linux_${ARCH}.zip
unzip identity_linux_${ARCH}.zip && rm identity_linux_${ARCH}.zip

# Move binaries and set executable flag
mv multinode /usr/local/bin/
mv identity /usr/local/bin/
chmod +x /usr/local/bin/multinode
chmod +x /usr/local/bin/identity

apk del curl unzip
