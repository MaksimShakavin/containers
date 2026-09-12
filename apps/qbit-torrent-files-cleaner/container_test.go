package main

import (
	"testing"

	helpers "github.com/MaksimShakavin/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/maksimshakavin/qbit-torrent-files-cleaner:rolling")

	// The console entry point should be installed on PATH.
	helpers.RequireFileExists(t, image, "/usr/local/bin/qbit-torrent-files-cleaner")

	// `--version` exercises the entry point (imports the package, prints the
	// setuptools-scm version) and exits 0, so it's a reliable install smoke test.
	helpers.RequireCommandSucceeds(t, image, nil, "qbit-torrent-files-cleaner", "--version")
}
