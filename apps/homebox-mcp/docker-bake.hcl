target "docker-metadata-action" {}

variable "APP" {
  default = "homebox-mcp"
}

variable "VERSION" {
  // renovate: datasource=pypi depName=homebox-mcp
  default = "1.5.1"
}

variable "SOURCE" {
  default = "https://github.com/dgahagan/homebox-mcp"
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
