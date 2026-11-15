# homebox-mcp

A stdio [MCP](https://modelcontextprotocol.io) server wrapping the
[Homebox](https://homebox.software) REST API (inventory Q&A, item intake,
attachments, QR labels).

- **Upstream**: <https://github.com/dgahagan/homebox-mcp>
- **Package**: [`homebox-mcp`](https://pypi.org/project/homebox-mcp/) on PyPI,
  baked in at build time at a pinned version (the image tag equals the package
  version). Renovate tracks the pin via the `docker-bake.hcl` annotation
  (`datasource=pypi depName=homebox-mcp`).

The image exists so the server can run under the
[ToolHive](https://github.com/stacklok/toolhive) Kubernetes operator as an
`MCPServer` with `transport: stdio`, which needs a real pullable image. The
`ENTRYPOINT` runs the server directly over stdin/stdout — no HTTP server, no
healthcheck, no exposed port (ToolHive provides the HTTP proxy itself).

## Runtime configuration

These are **not** baked into the image; inject them from the `MCPServer`
manifest:

| Variable              | Required | Description                                          |
| --------------------- | -------- | ---------------------------------------------------- |
| `HOMEBOX_URL`         | yes      | Base URL of the Homebox instance, no trailing slash. |
| `HOMEBOX_TOKEN`       | yes      | Homebox API key (`hb_…`).                            |
| `HOMEBOX_ALIAS_FIELD` | no       | Custom field used as an item alias for lookups.      |
| `HOMEBOX_LABEL_DIR`   | no       | QR-label output dir. Defaults to the CWD (`/tmp`).   |

## Runtime notes

- Runs as non-root (`nobody:nogroup`).
- `readOnlyRootFilesystem`-friendly: `HOME`, the uv/XDG caches, and the working
  directory all point at `/tmp`. Mount an `emptyDir` at `/tmp` for the writable
  scratch space the server (and QR-label output) needs.
