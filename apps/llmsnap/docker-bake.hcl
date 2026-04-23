target "docker-metadata-action" {}

variable "APP" {
  default = "llmsnap"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=napmany/llmsnap
  default = "v0.0.5"
}

variable "VERSION_CLEAN" {
  default = trimprefix(VERSION, "v")
}

variable "SOURCE" {
  default = "https://github.com/napmany/llmsnap"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION_CLEAN}"
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
    "linux/amd64"
  ]
}
