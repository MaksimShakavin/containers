target "docker-metadata-action" {}

variable "APP" {
  default = "emonoda"
}

variable "VERSION" {
  // renovate: datasource=git-refs depName=https://github.com/MaksimShakavin/emonoda branch=feature/qbittorrent-preserve-category
  default = "913b2ddba78d8398bf00d23b963796a0713e5c0b"
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
