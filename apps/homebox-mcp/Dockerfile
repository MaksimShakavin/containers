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

# homebox-mcp is a stdio MCP server, not a /config app: config is injected via
# env vars (HOMEBOX_URL/HOMEBOX_TOKEN/...) by the ToolHive MCPServer manifest,
# and the pod mounts an emptyDir at /tmp. Point HOME and every cache at that
# writable /tmp so the image is readOnlyRootFilesystem-friendly.
ENV \
    HOME="/tmp" \
    UV_CACHE_DIR="/tmp/uv" \
    XDG_CACHE_HOME="/tmp/.cache"

USER root
WORKDIR /app

# Every dependency (pillow, pillow-heif, pydantic-core via mcp) ships a
# musllinux cp314 wheel, so the install needs no C/Rust toolchain. Pin the
# package version to VERSION (== the image tag); no PyPI fetch at runtime.
RUN \
    apk add --no-cache \
        catatonit \
    && pip install --no-cache-dir uv \
    && uv pip install "homebox-mcp==${VERSION}" \
    && rm -rf /root/.cache /tmp/*

USER nobody:nogroup
# CWD is the default output dir for QR labels (HOMEBOX_LABEL_DIR, overridable);
# /tmp is the writable emptyDir, so default label writes land somewhere writable.
WORKDIR /tmp

# Run the stdio MCP server directly (console script homebox_mcp:main). catatonit
# is PID 1 for signal forwarding / zombie reaping and is transparent to stdio;
# the server reads MCP over stdin/stdout, needs no TTY and takes no required args.
ENTRYPOINT ["/usr/bin/catatonit", "--", "homebox-mcp"]
