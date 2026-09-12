target "docker-metadata-action" {}

variable "APP" {
  default = "qbit-torrent-files-cleaner"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=MaksimShakavin/qbit-torrent-files-cleaner
  default = "v0.2.0"
}

variable "SOURCE" {
  default = "https://github.com/MaksimShakavin/qbit-torrent-files-cleaner"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
