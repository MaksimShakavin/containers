# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.14-alpine3.24
ARG VERSION

ENV \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true

# Keep every write on the emptyDir at /tmp so the rootfs can stay read-only.
ENV \
    HOME="/tmp" \
    UV_CACHE_DIR="/tmp/uv" \
    XDG_CACHE_HOME="/tmp/.cache"

USER root
WORKDIR /app

# Every dep ships a musllinux cp314 wheel, so no build toolchain is needed.
RUN \
    apk add --no-cache \
        catatonit \
    && pip install --no-cache-dir uv \
    && uv pip install "homebox-mcp==${VERSION}" \
    && rm -rf /root/.cache /tmp/*

USER nobody:nogroup
# QR labels default to the CWD (HOMEBOX_LABEL_DIR); keep it on the writable /tmp.
WORKDIR /tmp

# catatonit as PID 1 reaps zombies and forwards signals; it is stdio-transparent.
ENTRYPOINT ["/usr/bin/catatonit", "--", "homebox-mcp"]
