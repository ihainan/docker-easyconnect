#!/bin/bash
set -e

MIRROR_URL="${MIRROR_URL:-http://mirrors.ustc.edu.cn/debian/}"
VPN_URL="https://atrustcdn.sangfor.com/standard/linux/2.5.16.20/uos/amd64/aTrustInstaller_amd64.deb"
VPN_TYPE="ATRUST"

echo "==> Step 1: build base image"
docker image build \
  --build-arg VPN_URL="$VPN_URL" \
  --build-arg VPN_TYPE="$VPN_TYPE" \
  --build-arg MIRROR_URL="$MIRROR_URL" \
  ${http_proxy:+--build-arg http_proxy="$http_proxy"} \
  ${https_proxy:+--build-arg https_proxy="$https_proxy"} \
  -f Dockerfile.build \
  -t hagb/docker-easyconnect:build \
  .

echo "==> Step 2: build aTrust image with Chromium"
docker image build \
  --build-arg VPN_URL="$VPN_URL" \
  --build-arg VPN_TYPE="$VPN_TYPE" \
  --build-arg CHROMIUM=1 \
  --build-arg MIRROR_URL="$MIRROR_URL" \
  ${http_proxy:+--build-arg http_proxy="$http_proxy"} \
  ${https_proxy:+--build-arg https_proxy="$https_proxy"} \
  -f Dockerfile \
  -t hagb/docker-atrust:chromium \
  .

echo "==> Done"
