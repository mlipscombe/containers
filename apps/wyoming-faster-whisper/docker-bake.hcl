target "docker-metadata-action" {}

variable "APP" {
  default = "wyoming-faster-whisper"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=rhasspy/wyoming-faster-whisper
  default = "v3.0.2"
}

variable "SOURCE" {
  default = "https://github.com/rhasspy/wyoming-faster-whisper"
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
