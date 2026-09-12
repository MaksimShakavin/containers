#!/usr/bin/env sh

# emonoda is a set of CLI tools (emupdate, emfile, emdiff, ...). The image has
# no default long-running process; the caller (e.g. a Kubernetes CronJob) passes
# the command and args, most commonly:
#   emupdate --config /app/config.yaml
if [ "$#" -eq 0 ]; then
    exec emupdate --help
fi

exec "$@"
