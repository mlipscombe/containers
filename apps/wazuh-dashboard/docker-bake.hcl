target "docker-metadata-action" {}

variable "APP" {
  default = "wazuh-dashboard"
}

variable "VERSION" {
  // renovate: datasource=docker depName=wazuh/wazuh-dashboard
  default = "4.12.0"
}

variable "SOURCE" {
  default = "https://github.com/wazuh/wazuh-dashboard"
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
    "linux/amd64"
  ]
}
