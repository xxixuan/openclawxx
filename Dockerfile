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
        libvulkan-dev \
        shaderc \
        ${EXTRA_APT_PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Pre-build node-llama-cpp Vulkan backend so cmake runs once at build time,
# not at every container startup. qmd query triggers the compilation and
# caches the binary in localBuilds/linux-x64-vulkan/.
USER node
RUN if command -v qmd >/dev/null 2>&1; then \
        echo "Warming up qmd (compiling llama.cpp backend)..." && \
        qmd query "warmup" -C 1 2>&1 || true; \
    else \
        echo "qmd not found in PATH, skipping warmup"; \
    fi

USER node
