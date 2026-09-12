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

ENV HOME="/config"

USER root
WORKDIR /app

# emonoda ships a Cython extension (emonoda/thirdparty/bencoder.pyx) and has no
# pyproject.toml, so Cython + a C toolchain must be present at build time.
RUN \
    apk add --no-cache --virtual=build-dependencies \
        build-base \
        git \
    && apk add --no-cache \
        catatonit \
    && pip install --no-cache-dir uv \
    && uv pip install Cython setuptools \
    && uv pip install --no-build-isolation "emonoda @ git+https://github.com/MaksimShakavin/emonoda@${VERSION}" \
    && mkdir -p /config && chown nobody:nogroup -R /config \
    && apk del --purge build-dependencies \
    && rm -rf /root/.cache /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config

VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
