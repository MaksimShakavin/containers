package main

import (
	"testing"

	helpers "github.com/MaksimShakavin/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/maksimshakavin/frappe-lms:rolling")

	// The whole reason this image exists: every published ghcr.io/frappe/lms image
	// ships only the base frappe app, silently dropping lms + payments. This asserts
	// the apps were actually baked in. Two independent checks:
	//   1. apps/ holds the source trees bench init cloned (filesystem truth), and
	//   2. the packages are installed in the bench virtualenv (env/bin/python's pip);
	//      the system pip would miss them, so a bare `pip show lms` is not a valid test.
	// If bench init had silently skipped an app, one of these fails and the image is
	// never promoted past the sandbox build.
	helpers.RequireCommandSucceeds(t, image, nil, "bash", "-c", `
set -euo pipefail
cd /home/frappe/frappe-bench
echo "apps present:"
ls -1 apps
for app in frappe lms payments; do
    test -d "apps/${app}" || { echo "MISSING app dir: ${app}"; exit 1; }
done
./env/bin/python -m pip show frappe lms payments >/dev/null
`)
}
