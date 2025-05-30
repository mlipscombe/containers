target "docker-metadata-action" {}

variable "APP" {
  default = "rtl_433_mqtt_hass"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=merbanan/rtl_433
  default = "25.02"
}

variable "SOURCE" {
  default = "https://github.com/merbanan/rtl_433"
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
