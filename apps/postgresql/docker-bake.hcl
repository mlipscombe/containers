target "docker-metadata-action" {}

variable "APP" {
  default = "postgresql"
}

variable "VERSION" {
  // renovate: datasource=docker depName=ghcr.io/cloudnative-pg/postgresql versioning=loose
  default = "19beta2-system-trixie"
}

variable "POSTGRES_VERSION" {
  default = VERSION
}

variable "POSTGRES_MAJOR" {
  default = index(split(".", VERSION), 0)
}

variable "PG_TEXTSEARCH_VERSION" {
  // renovate: datasource=github-releases depName=timescale/pg_textsearch
  default = "1.3.0"
}

variable "SOURCE" {
  default = "https://github.com/cloudnative-pg/postgres-containers"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    POSTGRES_VERSION      = "${POSTGRES_VERSION}"
    PG_MAJOR             = "${POSTGRES_MAJOR}"
    PG_TEXTSEARCH_VERSION = "${PG_TEXTSEARCH_VERSION}"
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
