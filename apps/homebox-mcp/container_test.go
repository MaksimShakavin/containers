package main

import (
	"testing"

	helpers "github.com/MaksimShakavin/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/maksimshakavin/homebox-mcp:rolling")

	// The stdio MCP server's console entry point should be installed on PATH.
	helpers.RequireFileExists(t, image, "/usr/local/bin/homebox-mcp")

	// Importing the module exercises the full install, including the musl C
	// extensions (pillow, pillow-heif). It only warns (no sys.exit) when
	// HOMEBOX_TOKEN is unset and never touches stdin, so it exits 0 — unlike the
	// server itself, which blocks reading MCP over stdio.
	helpers.RequireCommandSucceeds(t, image, nil, "python", "-c",
		"import homebox_mcp, httpx, mcp, PIL, pillow_heif")
}
