# syntax=docker/dockerfile:1.7
#
# Dockerfile — extends the official pre-built OpenClaw image
#
# Uses ghcr.io/openclaw/openclaw as base (pre-built, no pnpm build:docker
# required). Sidesteps build:docker regressions in openclaw/openclaw#61211
# and openclaw/openclaw#61066.
#
# Build:
#   docker build -f Dockerfile -t openclawxx:local .
#
# Add more packages:
#   docker build -f Dockerfile \
#     --build-arg EXTRA_APT_PACKAGES="python3 wget" \
#     -t openclawxx:local .

FROM ghcr.io/openclaw/openclaw:latest

ARG EXTRA_APT_PACKAGES=""

USER root
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

USER node
