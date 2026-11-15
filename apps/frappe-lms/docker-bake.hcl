target "docker-metadata-action" {}

variable "APP" {
  default = "frappe-lms"
}

# Frappe major line, not a semver: version-16 + lms main are moving branches.
# Drives the calver + rolling tags; bump when the fleet moves to the next major.
variable "VERSION" {
  default = "version-16"
}

# Primary app; used for the image source label.
variable "SOURCE" {
  default = "https://github.com/frappe/lms"
}

# Pinned so builds are reproducible; Renovate bumps it as upstream main advances.
variable "FRAPPE_DOCKER_REF" {
  # renovate: datasource=git-refs depName=https://github.com/frappe/frappe_docker branch=main
  default = "0ad1a1152f93b1285104bcd0a8059e036dc5bd3d"
}

# Base framework comes from here, not apps.json: bench init pulls it and the
# branch selects the frappe/build + frappe/base parent images.
variable "FRAPPE_PATH" {
  default = "https://github.com/frappe/frappe"
}

variable "FRAPPE_BRANCH" {
  default = "version-16"
}

# Bump to force a fresh bench init when the pinned ref would reuse a cached layer
# but the moving app branches have advanced.
variable "CACHE_BUST" {
  default = ""
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  # Context is the pinned frappe_docker repo so the layered Containerfile and its
  # resources/ are in scope. apps.json rides in as a secret because the current
  # Containerfile reads --mount=type=secret,id=apps_json, not a build-arg.
  context    = "https://github.com/frappe/frappe_docker.git#${FRAPPE_DOCKER_REF}"
  dockerfile = "images/layered/Containerfile"
  args = {
    FRAPPE_PATH         = "${FRAPPE_PATH}"
    FRAPPE_BRANCH       = "${FRAPPE_BRANCH}"
    FRAPPE_IMAGE_PREFIX = "frappe"
    CACHE_BUST          = "${CACHE_BUST}"
  }
  secret = ["id=apps_json,src=apps.json"]
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output   = ["type=docker"]
  tags     = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
