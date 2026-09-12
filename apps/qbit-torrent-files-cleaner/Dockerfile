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

# The package versions itself via setuptools-scm from git tags; pretend the tag
# so the build doesn't depend on git history depth. git is needed to fetch the
# source; build-base covers any sdist-only runtime dep (e.g. PyYAML on musl).
RUN \
    apk add --no-cache --virtual=build-dependencies \
        build-base \
        git \
    && apk add --no-cache \
        catatonit \
    && pip install --no-cache-dir uv \
    && SETUPTOOLS_SCM_PRETEND_VERSION="${VERSION#v}" \
        uv pip install "qbit-torrent-files-cleaner @ git+https://github.com/MaksimShakavin/qbit-torrent-files-cleaner@${VERSION}" \
    && mkdir -p /config && chown nobody:nogroup -R /config \
    && apk del --purge build-dependencies \
    && rm -rf /root/.cache /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config

VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
