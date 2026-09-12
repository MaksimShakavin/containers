<div align="center">

## Containers

_A personal collection of container images_

</div>

<div align="center">

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/MaksimShakavin/containers/release.yaml?style=for-the-badge&label=Release)

</div>

Personal container images, published to this repository's GitHub Packages. Start by [browsing the packages page](https://github.com/MaksimShakavin?tab=packages&repo_name=containers).

This repository is a trimmed-down fork of [home-operations/containers](https://github.com/home-operations/containers), reusing its build pipeline, Renovate flow, and `testcontainers-go` testing approach for my own apps.

## Mission Statement

The goal is to provide [semantically versioned](https://semver.org/), [rootless](https://rootlesscontaine.rs/), and [multi-architecture](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/) containers.

Following the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle): logging to stdout, [one process per container](https://testdriven.io/tips/59de3279-4a2d-4556-9cd0-b444249ed31e/), avoiding tools like [s6-overlay](https://github.com/just-containers/s6-overlay), and building on top of [Alpine](https://hub.docker.com/_/alpine) or [Ubuntu](https://hub.docker.com/_/ubuntu).

## Features

### Tag Immutability

Images here do not use immutable tags in the traditional sense. Instead, pin to the `sha256` digest of the image. While less visually appealing, it ensures functionality and immutability.

| Container                                               | Immutable |
| ------------------------------------------------------- | --------- |
| `ghcr.io/maksimshakavin/emonoda:rolling`                | ❌        |
| `ghcr.io/maksimshakavin/emonoda:2.1.40`                 | ❌        |
| `ghcr.io/maksimshakavin/emonoda:rolling@sha256:8053...` | ✅        |
| `ghcr.io/maksimshakavin/emonoda:2.1.40@sha256:8053...`  | ✅        |

_When pinning to the `sha256` digest, [Renovate](https://github.com/renovatebot/renovate) can update containers based on digest or version changes._

### Rootless

By default the majority of these containers run as a non-root user (`65534:65534`); you can change the user/group via your configuration.

### Configuration Volume

For applications requiring persistent configuration data, the configuration volume is hardcoded to `/config` within the container. In most cases, this path cannot be changed.

### Verify Image Signature

These images are signed using the [attest-build-provenance](https://github.com/actions/attest-build-provenance) action.

To verify that an image was built by this repository's CI:

```sh
gh attestation verify --repo MaksimShakavin/containers oci://ghcr.io/maksimshakavin/${APP}:${TAG}
```

or by using [cosign](https://github.com/sigstore/cosign):

```sh
cosign verify-attestation --new-bundle-format --type slsaprovenance1 \
    --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
    --certificate-identity-regexp "^https://github.com/MaksimShakavin/containers/.github/workflows/app-builder.yaml@refs/heads/main" \
    ghcr.io/maksimshakavin/${APP}:${TAG}
```

## Local Development

Tooling is provisioned with [mise](https://mise.jdx.dev) (the same config CI uses),
optionally auto-activated via [direnv](https://direnv.net/):

```sh
mise install           # install pinned tools (go, hadolint, ...)
direnv allow           # optional: auto-activate the env via .envrc (use mise)
mise tasks             # list available tasks
mise run local-build <app>   # build an app image and run its test locally (requires Docker)
```

## Credits

Forked from and inspired by [home-operations/containers](https://github.com/home-operations/containers), the home-ops community, [hotio.dev](https://hotio.dev/), and [linuxserver.io](https://www.linuxserver.io/).
