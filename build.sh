#!/usr/bin/env bash
# Build & push defyma/s2i-ubi8-php74-pdooci-libreoffice
# Pakai: ./build.sh [BASE_TAG] [LO_VER]   (default: 1792860909 25.8.7)
set -euo pipefail
cd "$(dirname "$0")"
BASE_TAG="${1:-1792860909}"
LO_VER="${2:-25.8.7}"
IMAGE=defyma/s2i-ubi8-php74-pdooci-libreoffice
docker build --platform linux/amd64 \
  --build-arg BASE_TAG="$BASE_TAG" --build-arg LO_VER="$LO_VER" \
  -t "$IMAGE:$BASE_TAG" -t "$IMAGE:latest" .
docker run --rm --platform linux/amd64 --entrypoint sh "$IMAGE:$BASE_TAG" -c \
  'php -m | grep -E "^(oci8|PDO_OCI)$" && libreoffice7.3 --version'
if [ "${NO_PUSH:-0}" != "1" ]; then
  docker push "$IMAGE:$BASE_TAG"
  docker push "$IMAGE:latest"
fi
