# openclawxx

OpenClaw custom image — extends official base with extra APT packages.

## Base Image
- **Upstream**: [openclaw/openclaw](https://github.com/openclaw/openclaw)
- **Latest Tag**: v2026.4.11
- **Last Synced**: 2026-04-13

## Included Packages
```
tmux ffmpeg jq
```

## Dockerfile

```
FROM ghcr.io/openclaw/openclaw:latest
ARG EXTRA_APT_PACKAGES=""
RUN apt-get update && apt-get install -y tmux ffmpeg jq ${EXTRA_APT_PACKAGES}
```

## Auto-Build
上游发布新 tag → 自动更新本仓库 → 触发阿里云 ACR 构建
