target "docker-metadata-action" {}

variable "APP" {
  default = "emonoda"
}

variable "VERSION" {
  // renovate: datasource=git-refs depName=https://github.com/MaksimShakavin/emonoda branch=feature/qbittorrent-preserve-category
  default = "557c52160b7fbba2d0153ea2b40e4b32c590c2f6"
}

variable "SOURCE" {
  default = "https://github.com/MaksimShakavin/emonoda"
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
