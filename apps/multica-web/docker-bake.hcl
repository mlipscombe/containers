target "docker-metadata-action" {}

variable "APP" {
  default = "multica-web"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=multica-ai/multica
  default = "v0.3.11"
}

variable "SOURCE" {
  default = "https://github.com/multica-ai/multica"
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
