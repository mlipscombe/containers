target "docker-metadata-action" {}

variable "APP" {
  default = "canvas-lms"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=instructure/canvas-lms versioning=loose
  default = "2026-01-28"
}

variable "SOURCE" {
  default = "https://github.com/instructure/canvas-lms"
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
