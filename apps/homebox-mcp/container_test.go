package main

import (
	"testing"

	helpers "github.com/MaksimShakavin/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/maksimshakavin/homebox-mcp:rolling")

	// Console entry point must be installed on PATH.
	helpers.RequireFileExists(t, image, "/usr/local/bin/homebox-mcp")

	// Import rather than run the server, which would block reading stdio; this
	// still proves the install and that the musl pillow/pillow-heif wheels load.
	helpers.RequireCommandSucceeds(t, image, nil, "python", "-c",
		"import homebox_mcp, httpx, mcp, PIL, pillow_heif")
}
