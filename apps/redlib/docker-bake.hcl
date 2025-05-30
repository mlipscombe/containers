target "docker-metadata-action" {}

variable "APP" {
  default = "redlib"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=redlib-org/redlib
  default = "0.36.0"
}

variable "SOURCE" {
  default = "https://github.com/redlib-org/redlib"
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
