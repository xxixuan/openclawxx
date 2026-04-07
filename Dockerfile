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
# The official base image already installs apt packages via
# OPENCLAW_DOCKER_APT_PACKAGES build-arg — we just pass our packages through.
# No extra RUN layer needed.

FROM ghcr.io/openclaw/openclaw:latest

ARG OPENCLAW_DOCKER_APT_PACKAGES="tmux ffmpeg jq"

# The base image has a conditional RUN that only executes if this arg is non-empty:
#   RUN if [ -n "$OPENCLAW_DOCKER_APT_PACKAGES" ]; then apt-get update ...; fi
# So tmux/ffmpeg/jq get installed by the inherited RUN, no duplication needed.
