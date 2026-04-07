# syntax=docker/dockerfile:1.7
#
# Dockerfile — extends the official pre-built OpenClaw image
#
# Uses ghcr.io/openclaw/openclaw as base (pre-built, avoids build:docker
# regressions in openclaw/openclaw#61211 and openclaw/openclaw#61066).
# All runtime files are owned by the 'node' user as set by the base image.
#
# Build:
#   docker build -f Dockerfile -t openclawxx:local .
#
# Add more packages:
#   docker build -f Dockerfile \
#     --build-arg EXTRA_APT_PACKAGES="python3 wget" \
#     -t openclawxx:local .

FROM ghcr.io/openclaw/openclaw:latest

# The base image already has 'node' user configured and WORKDIR /app set.
# apt-get runs as root during build (USER directive only affects runtime).
# Installed binaries get 755 permissions — node user can read and execute.

ARG EXTRA_APT_PACKAGES=""

RUN --mount=type=cache,id=openclaw-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=openclaw-apt-lists,target=/var/lib/apt/lists,sharing=locked \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tmux \
        ffmpeg \
        jq \
        ${EXTRA_APT_PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
