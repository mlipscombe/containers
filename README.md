<!---
NOTE: AUTO-GENERATED FILE
to edit this file, instead edit its template at: ./scripts/templates/README.md.j2
-->
<div align="center">


## Containers

_An opinionated collection of container images_

_Forked from [onedr0p/containers](https://github.com/onedr0p/containers)_

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/mlipscombe/containers?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/mlipscombe/containers?style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/mlipscombe/containers/release-scheduled.yaml?style=for-the-badge&label=Scheduled%20Release)

</div>

Welcome to my container images, if looking for a container start by [browsing the GitHub Packages page for this repo's packages](https://github.com/mlipscombe?tab=packages&repo_name=containers).

## Mission statement

The goal of this project is to support [semantically versioned](https://semver.org/), [rootless](https://rootlesscontaine.rs/), and [multiple architecture](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/) containers for various applications.

It also adheres to a [KISS principle](https://en.wikipedia.org/wiki/KISS_principle), logging to stdout, [one process per container](https://testdriven.io/tips/59de3279-4a2d-4556-9cd0-b444249ed31e/), no [s6-overlay](https://github.com/just-containers/s6-overlay) and all images are built on top of [Alpine](https://hub.docker.com/_/alpine) or [Ubuntu](https://hub.docker.com/_/ubuntu).

## Tag immutability

The containers built here do not use immutable tags, as least not in the more common way you have seen from [linuxserver.io](https://fleet.linuxserver.io/) or [Bitnami](https://bitnami.com/stacks/containers).

We do take a similar approach but instead of appending a `-ls69` or `-r420` prefix to the tag we instead insist on pinning to the sha256 digest of the image, while this is not as pretty it is just as functional in making the images immutable.

| Container                                          | Immutable |
|----------------------------------------------------|-----------|
| `ghcr.io/mlipscombe/sonarr:rolling`                   | ❌         |
| `ghcr.io/mlipscombe/sonarr:3.0.8.1507`                | ❌         |
| `ghcr.io/mlipscombe/sonarr:rolling@sha256:8053...`    | ✅         |
| `ghcr.io/mlipscombe/sonarr:3.0.8.1507@sha256:8053...` | ✅         |

_If pinning an image to the sha256 digest, tools like [Renovate](https://github.com/renovatebot/renovate) support updating the container on a digest or application version change._

## Rootless

To run these containers as non-root make sure you update your configuration to the user and group you want.

### Docker compose

```yaml
networks:
  sonarr:
    name: sonarr
    external: true
services:
  sonarr:
    image: ghcr.io/mlipscombe/sonarr:3.0.8.1507
    container_name: sonarr
    user: 65534:65534
    # ...
```

### Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sonarr
# ...
spec:
  # ...
  template:
    # ...
    spec:
      # ...
      securityContext:
        runAsUser: 65534
        runAsGroup: 65534
        fsGroup: 65534
        fsGroupChangePolicy: OnRootMismatch
# ...
```

## Passing arguments to a application

Some applications do not support defining configuration via environment variables and instead only allow certain config to be set in the command line arguments for the app. To circumvent this, for applications that have an `entrypoint.sh` read below.

1. First read the Kubernetes docs on [defining command and arguments for a Container](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/).
2. Look up the documentation for the application and find a argument you would like to set.
3. Set the extra arguments in the `args` section like below.

    ```yaml
    args:
      - --port
      - "8080"
    ```

## Configuration volume

For applications that need to have persistent configuration data the config volume is hardcoded to `/config` inside the container. This is not able to be changed in most cases.

## Available Images

Each Image will be built with a `rolling` tag, along with tags specific to it's version. Available Images Below

Container | Channel | Image
--- | --- | ---
[actions-runner](https://github.com/mlipscombe/containers/pkgs/container/actions-runner) | stable | ghcr.io/mlipscombe/actions-runner
[bazarr](https://github.com/mlipscombe/containers/pkgs/container/bazarr) | stable | ghcr.io/mlipscombe/bazarr
[home-assistant](https://github.com/mlipscombe/containers/pkgs/container/home-assistant) | stable | ghcr.io/mlipscombe/home-assistant
[jbops](https://github.com/mlipscombe/containers/pkgs/container/jbops) | stable | ghcr.io/mlipscombe/jbops
[lidarr](https://github.com/mlipscombe/containers/pkgs/container/lidarr) | master | ghcr.io/mlipscombe/lidarr
[lidarr-develop](https://github.com/mlipscombe/containers/pkgs/container/lidarr-develop) | develop | ghcr.io/mlipscombe/lidarr-develop
[lidarr-nightly](https://github.com/mlipscombe/containers/pkgs/container/lidarr-nightly) | nightly | ghcr.io/mlipscombe/lidarr-nightly
[plex](https://github.com/mlipscombe/containers/pkgs/container/plex) | stable | ghcr.io/mlipscombe/plex
[postgres-init](https://github.com/mlipscombe/containers/pkgs/container/postgres-init) | stable | ghcr.io/mlipscombe/postgres-init
[prowlarr](https://github.com/mlipscombe/containers/pkgs/container/prowlarr) | master | ghcr.io/mlipscombe/prowlarr
[prowlarr-develop](https://github.com/mlipscombe/containers/pkgs/container/prowlarr-develop) | develop | ghcr.io/mlipscombe/prowlarr-develop
[prowlarr-nightly](https://github.com/mlipscombe/containers/pkgs/container/prowlarr-nightly) | nightly | ghcr.io/mlipscombe/prowlarr-nightly
[qbittorrent](https://github.com/mlipscombe/containers/pkgs/container/qbittorrent) | stable | ghcr.io/mlipscombe/qbittorrent
[radarr](https://github.com/mlipscombe/containers/pkgs/container/radarr) | master | ghcr.io/mlipscombe/radarr
[radarr-develop](https://github.com/mlipscombe/containers/pkgs/container/radarr-develop) | develop | ghcr.io/mlipscombe/radarr-develop
[radarr-nightly](https://github.com/mlipscombe/containers/pkgs/container/radarr-nightly) | nightly | ghcr.io/mlipscombe/radarr-nightly
[readarr-develop](https://github.com/mlipscombe/containers/pkgs/container/readarr-develop) | develop | ghcr.io/mlipscombe/readarr-develop
[readarr-nightly](https://github.com/mlipscombe/containers/pkgs/container/readarr-nightly) | nightly | ghcr.io/mlipscombe/readarr-nightly
[redlib](https://github.com/mlipscombe/containers/pkgs/container/redlib) | stable | ghcr.io/mlipscombe/redlib
[rtl_433](https://github.com/mlipscombe/containers/pkgs/container/rtl_433) | stable | ghcr.io/mlipscombe/rtl_433
[rtl_433_mqtt_hass](https://github.com/mlipscombe/containers/pkgs/container/rtl_433_mqtt_hass) | stable | ghcr.io/mlipscombe/rtl_433_mqtt_hass
[sabnzbd](https://github.com/mlipscombe/containers/pkgs/container/sabnzbd) | stable | ghcr.io/mlipscombe/sabnzbd
[sonarr](https://github.com/mlipscombe/containers/pkgs/container/sonarr) | main | ghcr.io/mlipscombe/sonarr
[sonarr-develop](https://github.com/mlipscombe/containers/pkgs/container/sonarr-develop) | develop | ghcr.io/mlipscombe/sonarr-develop
[tacticalrmm](https://github.com/mlipscombe/containers/pkgs/container/tacticalrmm) | stable | ghcr.io/mlipscombe/tacticalrmm
[tacticalrmm-frontend](https://github.com/mlipscombe/containers/pkgs/container/tacticalrmm-frontend) | stable | ghcr.io/mlipscombe/tacticalrmm-frontend
[tautulli](https://github.com/mlipscombe/containers/pkgs/container/tautulli) | master | ghcr.io/mlipscombe/tautulli
[volsync](https://github.com/mlipscombe/containers/pkgs/container/volsync) | stable | ghcr.io/mlipscombe/volsync
[wyoming-faster-whisper](https://github.com/mlipscombe/containers/pkgs/container/wyoming-faster-whisper) | stable | ghcr.io/mlipscombe/wyoming-faster-whisper


## Deprecations

Containers here can be **deprecated** at any point, this could be for any reason described below.

1. The upstream application is **no longer actively developed**
2. The upstream application has an **official upstream container** that follows closely to the mission statement described here
3. The upstream application has been **replaced with a better alternative**
4. The **maintenance burden** of keeping the container here **is too bothersome**

**Note**: Deprecated containers will remained published to this repo for 6 months after which they will be pruned.

## Credits

A lot of inspiration and ideas are thanks to the hard work of [hotio.dev](https://hotio.dev/) and [linuxserver.io](https://www.linuxserver.io/) contributors.