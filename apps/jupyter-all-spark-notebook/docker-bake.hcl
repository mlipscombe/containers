target "docker-metadata-action" {}

variable "APP" {
  default = "jupyter-all-spark-notebook"
}

variable "VERSION" {
  // renovate: datasource=docker depName=quay.io/jupyter/all-spark-notebook
  default = "2025-06-02"
}

variable "SOURCE" {
  default = "https://github.com/jupyter/docker-stacks"
}

variable "NEEDS_DISK_SPACE" {
  default = "true"
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
