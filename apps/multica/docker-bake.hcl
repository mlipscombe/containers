target "docker-metadata-action" {}

variable "APP" {
  default = "multica"
}

variable "WEB_APP" {
  default = "multica-web"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=multica-ai/multica
  default = "v0.4.4"
}

variable "SOURCE" {
  default = "https://github.com/multica-ai/multica"
}

group "default" {
  targets = ["image-local", "image-web-local"]
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

target "image-web" {
  inherits = ["docker-metadata-action"]
  dockerfile = "Dockerfile.web"
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

target "image-web-local" {
  inherits = ["image-web"]
  output = ["type=docker"]
  tags = ["${WEB_APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

target "image-web-all" {
  inherits = ["image-web"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
