#!/usr/bin/env bash
set -Eeuo pipefail

APP="${1:?}"
CONFIG="${2:?}"

if yq --exit-status '.schemaVersion' "./apps/${APP}/${CONFIG}" &>/dev/null; then
    gh release download --repo GoogleContainerTools/container-structure-test --pattern "*-linux-$(dpkg --print-architecture)" --output /usr/local/bin/container-structure-test
    chmod +x /usr/local/bin/container-structure-test
else
    # Goss 0.4.10 ships archives using GoReleaser's architecture names.
    GOSS_VERSION="0.4.10"
    case "$(dpkg --print-architecture)" in
        amd64) GOSS_ARCH=x86_64 ;;
        arm64) GOSS_ARCH=arm64 ;;
        *) echo "Unsupported Goss architecture" >&2; exit 1 ;;
    esac
    gh release download "v${GOSS_VERSION}" --repo goss-org/goss \
        --pattern "goss_${GOSS_VERSION}_linux_${GOSS_ARCH}.tar.gz" --output - \
        | tar -xz -C /usr/local/bin goss
    chmod +x /usr/local/bin/goss
    gh release download "v${GOSS_VERSION}" --repo goss-org/goss --pattern "dgoss" --output /usr/local/bin/dgoss
    chmod +x /usr/local/bin/dgoss
fi
