target "docker-metadata-action" {}

variable "APP" {
  default = "moodle-php-apache"
}

variable "VERSION" {
  default = "8.4.27"
}

variable "PHP_SOURCE_SHA256" {
  default = "dcf93923b0e38e0d5252b25b796520b5a47761a08b3488b6d0b5d1115764d3f0"
}

variable "SOURCE" {
  default = "https://github.com/moodlehq/moodle-php-apache"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION           = "${VERSION}"
    PHP_SOURCE_SHA256 = "${PHP_SOURCE_SHA256}"
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
  platforms = ["linux/amd64", "linux/arm64"]
}
