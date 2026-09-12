#!/usr/bin/env sh

# qbit-torrent-files-cleaner is a one-shot CLI. The image has no default
# long-running process; the caller (e.g. a Kubernetes CronJob) passes the
# command and args, most commonly:
#   qbit-torrent-files-cleaner --config /config/config.yaml
if [ "$#" -eq 0 ]; then
    exec qbit-torrent-files-cleaner --help
fi

exec "$@"
