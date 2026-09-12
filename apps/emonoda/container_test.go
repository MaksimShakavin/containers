package main

import (
	"testing"

	helpers "github.com/MaksimShakavin/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/maksimshakavin/emonoda:rolling")

	// emonoda is a CLI toolset; assert its console_scripts are installed on PATH.
	helpers.RequireFileExists(t, image, "/usr/local/bin/emupdate")

	// Importing the package exercises the compiled Cython bencoder extension and
	// the CLI app modules. emonoda's own `--help` exits non-zero, so this import
	// check is the reliable "the install actually works" smoke test.
	helpers.RequireCommandSucceeds(t, image, nil, "python", "-c",
		"from emonoda.thirdparty import bencoder; from emonoda.apps import emupdate")
}
